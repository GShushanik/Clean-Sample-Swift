//
//  BeerDTO.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

// MARK: - BeerDTO
struct BeerDTO: Codable {
    let id: Int
    let name: String?
    let tagline: String?
    let firstBrewed: String?
    let beerDTODescription: String?
    let imageURL: String?
    let abv: Double?
    let ibu: Double?
    let targetFg: Double?
    let targetOg: Double?
    let ebc: Double?
    let srm: Double?
    let ph: Double?
    let attenuationLevel: Double?
    let foodPairing: [String]?
    let brewersTips: String?
    let contributedBy: String?
    let volume: BoilVolume?
    let boilVolume: BoilVolume?
    let method: Method?
    let ingredients: Ingredients?

    enum CodingKeys: String, CodingKey {
        case id, name, tagline, abv, ebc, ph, srm, ibu, volume, method, ingredients
        case firstBrewed = "first_brewed"
        case beerDTODescription = "description"
        case imageURL = "image_url"
        case targetFg = "target_fg"
        case targetOg = "target_og"
        case attenuationLevel = "attenuation_level"
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
        case contributedBy = "contributed_by"
        case boilVolume = "boil_volume"
    }
}

// MARK: - BoilVolume
struct BoilVolume: Codable {
    let value: Int64?
    let unit: String?
}

// MARK: - Ingredients
struct Ingredients: Codable {
    let malt: [Malt]?
    let hops: [Hop]?
    let yeast: String?
}

// MARK: - Hop
struct Hop: Codable {
    let name: String?
    let amount: Amount?
    let add: String?
    let attribute: String?
}


// MARK: - Malt
struct Malt: Codable {
    let name: String?
    let amount: Amount?
}

struct Amount: Codable {
    let value: Double?
    let unit: String?
}

// MARK: - Method
struct Method: Codable {
    let mashTemp: [MashTemp]?
    let fermentation: Fermentation?

    enum CodingKeys: String, CodingKey {
        case mashTemp = "mash_temp"
        case fermentation
    }
}

// MARK: - Fermentation
struct Fermentation: Codable {
    let temp: BoilVolume?
}

// MARK: - MashTemp
struct MashTemp: Codable {
    let temp: BoilVolume?
    let duration: Int64?
}
