//
//  BeerViewData+Mapping.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

extension Beer {
    func toViewData() -> BeerViewData {
        BeerViewData(id: id, name: name, tagline: tagline, beerDescription: beerDescription, imageURL: imageURL, abv: abv ?? 0.0, ibu: ibu ?? 0.0, ebc: ebc ?? 0.0, isFavorite: isFavorite)
    }
}
