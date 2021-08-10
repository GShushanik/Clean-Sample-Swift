//
//  AppCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 05.08.21.
//

import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {

    lazy var mainDiContainer: MainDIContainer = {
       MainDIContainer()
    }()
    
    lazy var beersDiContainer: BeersDIContainer = {
       BeersDIContainer()
    }()

    lazy var beerDetailsDiContainer: BeerDetailsDIContainer = {
        BeerDetailsDIContainer(dependency: beersDiContainer)
    }()

    override func start() {
        startHome()
    }
}

private extension AppCoordinator {
    func startHome() {
        let mainTabBarcoordinator = MainCoordinator(diContainer: createDiContainer(), router: router)
        addChild(mainTabBarcoordinator)
        mainTabBarcoordinator.start()
    }
    
    func createDiContainer() -> MainCoordinator.DiContainer {
        MainCoordinator.DiContainer(mainDiContainer: mainDiContainer, beersDiContainer: beersDiContainer, beerDetailsDiContainer: beerDetailsDiContainer)
    }
}
