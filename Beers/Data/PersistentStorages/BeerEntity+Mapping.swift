//
//  BeerEntity+Mapping.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 08.08.21.
//

import Foundation

extension BeerEntity {
    func toDomain() -> Beer {
        Beer(id: Int(id), name: name, tagline: tagline, imageURL: imageURL, beerDescription: beerDTODescription, abv: abv, ibu: ibu, ebc: ebc, isFavorite: isFavorite)
    }
    
    func fillFromDTO(_ dto: BeerDTO) {
        name = dto.name
        id = Int64(dto.id)
        imageURL = dto.imageURL
        tagline = dto.tagline
        tagline = dto.tagline
        abv = dto.abv ?? 0.0
        ebc = dto.ebc ?? 0.0
        ibu = dto.ibu ?? 0.0
        firstBrewed = dto.firstBrewed
        beerDTODescription = dto.beerDTODescription
        attenuationLevel = dto.attenuationLevel ?? 0.0
    }
}
