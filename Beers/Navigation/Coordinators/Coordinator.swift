//
//  Coordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 05.08.21.
//

import Foundation

protocol Coordinator: AnyObject, Presentable {
    var router: RouterType { get }
    func start()
}
