//
//  BeerDTO+Mapping.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

extension BeerDTO {
    func toDomain(isFavorite: Bool) -> Beer {
        Beer(id: id, name: name, tagline: tagline, imageURL: imageURL, beerDescription: beerDTODescription, abv: abv, ibu: ibu, ebc: ebc, isFavorite: isFavorite)
    }
    
    func toEntity(_ entity: BeerEntity) -> BeerEntity {
        entity.name = name
        entity.id = Int64(id)
        entity.tagline = tagline
        entity.abv = abv ?? 0.0
        entity.ebc = ebc ?? 0.0
        entity.ibu = ibu ?? 0.0
        entity.firstBrewed = firstBrewed
        entity.beerDTODescription = beerDTODescription
        entity.attenuationLevel = attenuationLevel ?? 0.0
        return entity
    }
}
