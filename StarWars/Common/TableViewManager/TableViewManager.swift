//
//  TableViewManager.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import UIKit
import Combine

public final class TableViewManager: NSObject, TableViewManagerable {

    public var isEditable: Bool = true
    public var scrollHandler: ((CGFloat) -> Void)?
    public var sectionHandler: ((_ oldValue: [TableViewSectionModel]?, _ newValue: [TableViewSectionModel]?) -> Void)?
    public var endDraggingHandler: ((UnsafeMutablePointer<CGPoint>) -> Void)?
    public var swipeToDeleteHandler: ((IndexPath) -> Void)?

    private let tableView: UITableView

    private var cancellable = Set<AnyCancellable>()
    

    public var sections: [TableViewSectionModel]? {
        get {
            return _sections
        }
        set {
            let oldValue = _sections
            _sections = newValue
            tableView.reloadData()
            sectionHandler?(oldValue, newValue)

            guard _sections != nil,
                    !_waitInsertSection.isEmpty else { return }
            _waitInsertSection.forEach {
                insertSection(section: $0.section, at: $0.index)
            }
            _waitInsertSection = []
        }
    }

    private var _sections: [TableViewSectionModel]? {
        didSet {
            register()
        }
    }

    private var _waitInsertSection = [(section: TableViewSectionModel, index: Int)]()

    public var models: [TableViewCellModelable]? {
        didSet {
            register()
            tableView.reloadData()
        }
    }

    public func setTableHeader(view: UIView, viewModel: TableHeaderModelable?, completion: ((CGFloat) -> Void)? = nil) {
        guard let viewModel = viewModel else { return }
        viewModel.apply(view: view)
        tableView.tableHeaderView = view
        let headerHeight = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        completion?(headerHeight)
    }

    public init(tableView: UITableView) {
        self.tableView = tableView

        super.init()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.publisher(for: \.contentOffset)
            .map { _ in Void() }
            .merge(with: tableView.publisher(for: \.contentSize).map { _ in Void() })
            .sink { [weak self] in
                guard let self = self else { return }
                self.scrollHandler?(self.tableView.contentOffset.y)
            }
            .store(in: &cancellable)
    }

    // MARK: Public

    public func insertSection(section: TableViewSectionModel, at index: Int, with animation: UITableView.RowAnimation = .none) {
        guard _sections != nil else {
            _waitInsertSection.append((section, index))
            return
        }
        tableView.beginUpdates()
        _sections?.insert(section, at: index)
        tableView.insertSections([index], with: animation)
        tableView.endUpdates()
    }

    public func reloadSection(section: TableViewSectionModel, at index: Int, with animation: UITableView.RowAnimation) {
        guard sections?[safe: index] != nil else { return }
        _sections?[index] = section
        tableView.beginUpdates()
        self.tableView.reloadSections([index], with: animation)
        self.tableView.endUpdates()
    }

    public func reloadSectionNoAnimation(section: TableViewSectionModel, at index: Int) {
        guard sections?[safe: index] != nil else { return }
        _sections?[index] = section
        UIView.performWithoutAnimation {
            self.tableView.reloadSections([index], with: .none)
        }
    }

    public func deleteSection(at index: Int, with animation: UITableView.RowAnimation = .bottom) {
        guard sections?[safe: index] != nil else { return }
        tableView.beginUpdates()
        _sections?.remove(at: index)
        tableView.deleteSections([index], with: animation)
        tableView.endUpdates()
    }

    public func getHeightOfSection(index: Int) -> CGFloat {
        tableView.rectForRow(at: IndexPath(row: 0, section: index)).height
    }

    public func indexPath(for model: TableViewCellModelable) -> IndexPath? {
        var row: Int?
        var index: Int?
        sections?.enumerated().forEach({ (offset, section) in
            if let firstIndex = section.models.firstIndex(where: { $0.diffKey == model.diffKey }) {
                index = offset
                row = firstIndex
            }
        })

        if let row = row, let index = index {
            return IndexPath(row: row, section: index)
        }

        if let row = models?.firstIndex(where: { $0.diffKey == model.diffKey }) {
            return IndexPath(row: row, section: 0)
        }

        return nil
    }

    private func register() {
        guard let sections = sections else {
            models?.forEach({ registerCells(for: $0) })
            return
        }
        sections.forEach({ (section) in
            guard let method = section.headerModel?.registrationInfo else {
                section.models.forEach({ model in registerCells(for: model) })
                return
            }

            switch method {
            case let .fromClass(classType):
                tableView.register(classType, forHeaderFooterViewReuseIdentifier: String(describing: classType))
            case .fromNib:
                tableView.register(method.nib, forHeaderFooterViewReuseIdentifier: String(describing: method.nib))
            }

            section.models.forEach({ model in registerCells(for: model) })
        })
    }

    private func registerCells(for model: TableViewCellModelable) {
        let method = model.registrationInfo

        switch method {
        case let .fromClass(classType):
            tableView.register(classType, forCellReuseIdentifier: method.reuseIdentifier)
        case .fromNib:
            tableView.register(method.nib, forCellReuseIdentifier: method.reuseIdentifier)
        }
    }
}

extension TableViewManager: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sections?[safe: section] else {
            return models?.count ?? 0
        }
        return section.models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = sections?[safe: indexPath.section]?.models[safe: indexPath.row] ?? models?[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.registrationInfo.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        viewModel.apply(cell: cell)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = sections?[safe: section],
              let model = section.headerModel,
              let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: model.registrationInfo.reuseIdentifier)
        else {
            return nil
        }
        model.apply(view: view)
        return view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = sections?[safe: section] else {
            return CGFloat.leastNonzeroMagnitude
        }
        return section.headerModel?.headerHeight ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        endDraggingHandler?(targetContentOffset)
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            swipeToDeleteHandler?(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable
    }
}
