//
//  BaseViewController.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import UIKit
import Combine

class BaseViewController: UIViewController {

    var viewModel: BaseViewModel?
    var cancellables = Set<AnyCancellable>()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.center = view.center
        activity.isHidden = true
        view.addSubview(activity)
        return activity
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bindViewModel()
    }

    func configureUI() {}
    func bindViewModel() {}
}

extension BaseViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}

extension BaseViewController {
    func showAlert(title: String?,
                   message: String?,
                   preferredStyle: UIAlertController.Style = .alert,
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: completion)
    }
}

// MARK: - Activity Indicator
extension BaseViewController {
    func startActivity() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
