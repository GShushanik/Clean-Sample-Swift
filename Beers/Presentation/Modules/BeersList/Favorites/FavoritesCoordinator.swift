//
//  FavoritesCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 10.08.21.
//

import UIKit

class FavoritesCoordinator: BaseBeersCoordinator {
    override func createViewController() -> BaseViewController? {
        let vc = diContainer.createFavoritesViewController()
        vc?.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 0)
        return vc
    }
}
