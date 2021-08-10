//
//  BeersCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import UIKit

class BeersCoordinator: BaseBeersCoordinator {
    override func createViewController() -> BaseViewController? {
        let vc = diContainer.createBeersViewController()
        vc?.tabBarItem = UITabBarItem(title: "Beers", image: UIImage(systemName: "list.dash"), tag: 0)
        return vc
    }
}
