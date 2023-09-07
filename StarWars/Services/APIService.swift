//
//  APIService.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation
import Alamofire
import Combine

enum SearchType {
    case character
    case starship
    case planet
}

enum Routes {
    static func getQuery(ofType: SearchType, text: String) -> String {
        let result: String
        switch ofType {
        case .character:
            result = "https://swapi.dev/api/people?search=" + text
        case .starship:
            result = "https://swapi.dev/api/starships?search=" + text
        case .planet:
            result = "https://swapi.dev/api/planets?search=" + text
        }
        return result.replacingOccurrences(of: " ", with: "%20")
    }
}

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol APIServiceProtocol {
    func searchCharacter(by text: String) -> AnyPublisher<DataResponse<InfoCharacters, NetworkError>, Never>
    func searchStarship(by text: String) -> AnyPublisher<DataResponse<InfoStarships, NetworkError>, Never>
    func searchPlanet(by text: String) -> AnyPublisher<DataResponse<InfoPlanets, NetworkError>, Never>
}

public final class APIService {
    static let shared: APIServiceProtocol = APIService()
    private init() { }
}

extension APIService: APIServiceProtocol {
    func searchCharacter(by text: String) -> AnyPublisher<DataResponse<InfoCharacters, NetworkError>, Never> {
        let resultQuery = Routes.getQuery(ofType: .character, text: text)
        let url = URL(string: resultQuery)!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: InfoCharacters.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchStarship(by text: String) -> AnyPublisher<DataResponse<InfoStarships, NetworkError>, Never> {
        let resultQuery = Routes.getQuery(ofType: .starship, text: text)
        let url = URL(string: resultQuery)!
        
        return AF.request(url,method: .get)
            .validate()
            .publishDecodable(type: InfoStarships.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchPlanet(by text: String) -> AnyPublisher<DataResponse<InfoPlanets, NetworkError>, Never> {
        let resultQuery = Routes.getQuery(ofType: .planet, text: text)
        let url = URL(string: resultQuery)!
        
        return AF.request(url,method: .get)
            .validate()
            .publishDecodable(type: InfoPlanets.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
