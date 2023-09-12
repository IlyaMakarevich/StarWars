//
//  StarWarsTests.swift
//  StarWarsTests
//
//  Created by Ilya Makarevich on 7.09.23.
//

import XCTest
import Combine
@testable import StarWars

final class StarWarsTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() throws {
        let expectation = self.expectation(description: "ApiCall")
        var error: Error?
        var resultName: String = ""
        
        let apiService = APIService()
        let searchUseCase = SearchUseCaseImp(apiService: apiService)
        searchUseCase.search(by: "Luke")
            .sink { items in
                resultName = items.people?.results.first?.name ?? ""
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 10)
        
        XCTAssertNil(error)
        XCTAssertEqual(resultName, "Luke Skywalker", "Name mismatch")
    }
    
    func testSavingToFavorites() throws {
        let persistanceUseCase = PersistanceUseCaseImpl()
        let favoriteCheckerUseCase = FavoriteCheckerUseCaseImpl()

        persistanceUseCase.saveCharacter(.init(name: "testName",
                                               gender: "testGender",
                                               shipsCount: 99))
        favoriteCheckerUseCase.fetchAllInfos()
        let result = favoriteCheckerUseCase.isCharacterFavorite(with: "testName")
        XCTAssertEqual(result, true, "Error saving to favorites")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
