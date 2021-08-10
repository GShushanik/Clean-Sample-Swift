//
//  PunkApi.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

enum PunkApi {
    
    struct NetworkConfigs {
        static let baseUrl = "https://api.punkapi.com/v2"
        static let beersUrlPath = "/beers"
        static let beerDetailsUrlPath = "/beers"
    }

    case beers(page: Int, count: Int)
    case beerDetails(id: Int)
    
    var baseURL: String {
        return NetworkConfigs.baseUrl
    }

    var path: String {
        switch self {
        case .beers: return NetworkConfigs.beersUrlPath
        case .beerDetails(let id): return NetworkConfigs.beerDetailsUrlPath + "/\(id)"
        }
    }

    var params: [URLQueryItem] {
        switch self {
        case let .beers(page, count):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(count)")
            ]
        default: return []
        }
    }
}
