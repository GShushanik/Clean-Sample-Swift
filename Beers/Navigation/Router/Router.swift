//
//  Router.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 05.08.21.
//

import Foundation
import UIKit

final public class Router: NSObject, RouterType {
    private var completions: [UIViewController : () -> Void]
    public var rootViewController: UIViewController?
    public weak var navigationController: UINavigationController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.completions = [:]
        super.init()
        self.navigationController?.delegate = self
    }

    public func toPresentable() -> UIViewController {
        navigationController ?? UINavigationController()
    }

    public func present(_ module: Presentable, animated: Bool) {
        navigationController?.present(module.toPresentable(), animated: animated, completion: nil)
    }

    public func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }

    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toPresentable()
        if module.toPresentable() is UINavigationController {
            if let completion = completion {
                completions[controller] = completion
            }
        }
        navigationController?.pushViewController(controller, animated: animated)
    }

    public func popModule(animated: Bool = true) {
        if let controller = navigationController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    public func setRootModule(_ module: Presentable, hideBar: Bool) {
        let controller = module.toPresentable()
        navigationController?.setViewControllers([controller], animated: false)
        navigationController?.isNavigationBarHidden = hideBar
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController?.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    fileprivate func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

extension Router: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        runCompletion(for: poppedViewController)
    }
}
