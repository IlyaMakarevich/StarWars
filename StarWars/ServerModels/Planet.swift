//
//  Planet.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation

struct InfoPlanets: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Planet]
}

struct Planet: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter
        case climate
        case gravity
        case terrain
        case surfaceWater = "surface_water"
        case population
        case residents
        case films
        case created
        case edited
        case url
    }
    
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: String
    let population: String
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
}
