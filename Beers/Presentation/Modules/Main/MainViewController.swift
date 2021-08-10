//
//  MainViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 06.08.21.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = .systemOrange
    }
}

extension MainViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
