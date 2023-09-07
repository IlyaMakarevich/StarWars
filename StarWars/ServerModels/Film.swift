//
//  Film.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation

struct Film: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case openingCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case characters
        case planets
        case starships
        case vehicles
        case species
        case created
        case edited
        case url
    }
    
    let name: String
    let episodeId: Int
    let openingCrawl: String
    let director: String
    let producer: String
    let releaseDate: String
    let characters: [String]
    let planets: [String]
    let starships: [String]
    let vehicles: [String]
    let species: [String]
    let created: String
    let edited: String
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .title)
        self.episodeId = try container.decode(Int.self, forKey: .episodeId)
        self.openingCrawl = try container.decode(String.self, forKey: .openingCrawl)
        self.director = try container.decode(String.self, forKey: .director)
        self.producer = try container.decode(String.self, forKey: .producer)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.characters = try container.decode([String].self, forKey: .characters)
        self.planets = try container.decode([String].self, forKey: .planets)
        self.starships = try container.decode([String].self, forKey: .starships)
        self.vehicles = try container.decode([String].self, forKey: .vehicles)
        self.species = try container.decode([String].self, forKey: .species)
        self.created = try container.decode(String.self, forKey: .created)
        self.edited = try container.decode(String.self, forKey: .edited)
        self.url = try container.decode(String.self, forKey: .url)
    }
}

struct InfoFilms: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Film]
}
