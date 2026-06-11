//
//  ApiNetwork.swift
//  SuperHeroes-Searcher
//
//  Created by Isa on 10/06/26.
//
import Foundation

class ApiNetwork {
    struct Wrapper: Codable {
        let response: String
        let results: [SuperHero]
    }
    
    struct SuperHero: Codable, Identifiable {
        let id: String
        let name: String
        let image: ImageSuperHero
        let powerstats: Powestats
    }
    
    struct ImageSuperHero: Codable {
        let url: String
    }
    
    struct SuperHeroComplete: Codable {
        let id: String
        let name: String
        let image: ImageSuperHero
        let biography: Biography
        let powerstats: Powestats

    }
    
    struct Powestats: Codable {
        let intelligence: String
        let strength: String
        let speed: String
        let durability: String
        let power: String
        let combat: String
    }
    
    struct Biography: Codable {
        let alignment: String
        let publisher: String
        let aliases: [String]
        let fullName: String
        
        enum CodingKeys: String, CodingKey {
            case fullName = "full-name"
            case alignment = "alignment"
            case publisher = "publisher"
            case aliases = "aliases"
        }
    }
    
    func getHerosByQuery(query: String) async throws -> Wrapper {
        let url = URL(string: "https://superheroapi.com/api/bb63b5b271c9376b99a39d8742f6dd05/search/\(query)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        return wrapper
    }
    
    func getHeroById(id: String) async throws -> SuperHeroComplete {
        let url = URL(string: "https://superheroapi.com/api/bb63b5b271c9376b99a39d8742f6dd05/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(SuperHeroComplete.self, from: data)
        
    }
}
