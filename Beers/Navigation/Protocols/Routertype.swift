//
//  Routertype.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 05.08.21.
//

import UIKit

public protocol RouterType: AnyObject, Presentable {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
    func present(_ module: Presentable, animated: Bool)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule(animated: Bool)
}
