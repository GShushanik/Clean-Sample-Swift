//
//  MainCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import Foundation
import UIKit
import Combine

class MainCoordinator: BaseCoordinator {
    
    struct DiContainer {
        var mainDiContainer: MainDIContainer
        var beersDiContainer: BeersDIContainer
        var beerDetailsDiContainer: BeerDetailsDIContainer
    }

    var diContainer: DiContainer

    init(diContainer: DiContainer, router: RouterType) {
        self.diContainer = diContainer
        super.init(router: router)
    }

    override func start() {
        let mainVC = diContainer.mainDiContainer.createViewController()
        guard let beersVC = startBeersCoordinator(),
              let favoritesVC = startFavoritesCoordinator() else { return }
        mainVC.setViewControllers([beersVC, favoritesVC], animated: false)
        router.setRootModule(mainVC, hideBar: false)
    }

    func startBeersCoordinator() -> BaseViewController? {
        let beersCoordinator = BeersCoordinator(diContainer: diContainer.beersDiContainer, routerType: router)
        let vc = beersCoordinator.createViewController()
        guard let vm = vc?.viewModel as? BeersViewModel else { return nil }
        beersCoordinator.bindViewModel(vm)
        beersCoordinator
            .coordinatorOutput
            .sink { [weak self] output in
                self?.handleEvent(output)
            }
            .store(in: &cancellables)
        addChild(beersCoordinator)
        return vc
    }

    func startFavoritesCoordinator() -> BaseViewController? {
        let favoritesCoordinator = FavoritesCoordinator(diContainer: diContainer.beersDiContainer, routerType: router)
        let vc = favoritesCoordinator.createViewController()
        guard let vm = vc?.viewModel as? FavoritesViewModel else { return nil }
        favoritesCoordinator.bindViewModel(vm)
        favoritesCoordinator
            .coordinatorOutput
            .sink { [weak self] output in
                self?.handleEvent(output)
            }
            .store(in: &cancellables)
        addChild(favoritesCoordinator)
        return vc
    }

    func handleEvent(_ output: BaseBeersCoordinator.OutputEvent) {
        switch output {
        case .openDetails(let beer):
            startBeerDetails(beer)
        }
    }

    func startBeerDetails(_ beer: BeerViewData) {
        let beerDetailsVC = diContainer.beerDetailsDiContainer
        guard let vc = beerDetailsVC.createBeerDetailsViewController(beer: beer) else { return }
        router.push(vc, animated: true, completion: nil)
    }
}
