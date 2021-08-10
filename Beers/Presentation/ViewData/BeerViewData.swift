//
//  BeerViewData.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

class BeerViewData: Hashable, Identifiable {
    var id: Int
    let name: String?
    let tagline: String?
    let beerDescription: String?
    let imageURL: String?
    let abv: Double
    let ibu: Double
    let ebc: Double
    var isFavorite: Bool

    init(id: Int, name: String?, tagline: String?, beerDescription: String?, imageURL: String?, abv: Double, ibu: Double, ebc: Double, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.beerDescription = beerDescription
        self.imageURL = imageURL
        self.abv = abv
        self.ibu = ibu
        self.ebc = ebc
        self.isFavorite = isFavorite
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: BeerViewData, rhs: BeerViewData) -> Bool {
        return lhs.id == rhs.id
    }
}
