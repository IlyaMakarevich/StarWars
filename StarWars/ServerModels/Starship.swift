//
//  Starship.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation

struct InfoStarships: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Starship]
}

struct Starship: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case model
        case manufacturer
        case costInCredits = "cost_in_credits"
        case length
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case crew
        case passengers
        case cargoCapacity = "cargo_capacity"
        case consumables
        case hyperdriveRating = "hyperdrive_rating"
        case MGLT
        case starshipClass = "starship_class"
        case pilots
        case films
        case created
        case edited
        case url
    }
    
    let name: String
    let model: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let maxAtmospheringSpeed: String
    let crew: String
    let passengers: String
    let cargoCapacity: String
    let consumables: String
    let hyperdriveRating: String
    let MGLT: String
    let starshipClass: String
    let pilots: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
}
