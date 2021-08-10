//
//  AppDIContainer.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import Foundation

class MainDIContainer {
    func createViewController() -> MainViewController {
        let tabBarViewController = R.storyboard.main.mainViewController()!
        return tabBarViewController
    }
}
