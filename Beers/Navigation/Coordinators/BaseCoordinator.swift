//
//  BaseCoordinator.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 05.08.21.
//

import UIKit
import Combine

class BaseCoordinator: NSObject, Coordinator {

    var router: RouterType
    var childCoordinators: [BaseCoordinator] = []
    var cancellables = Set<AnyCancellable>()

    init(router: RouterType) {
        self.router = router
    }

    func start() {}

    func toPresentable() -> UIViewController {
        router.toPresentable()
    }
}

extension BaseCoordinator {
    public func addChild(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: BaseCoordinator?) {
        if let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
    }
}
