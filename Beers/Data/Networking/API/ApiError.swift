//
//  ApiError.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case genericError
    
    public var errorDescription: String? {
        switch self {
        case .genericError:
            return "Something went wrong. Please try again!"
        }
    }
}
