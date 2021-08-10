//
//  UIImageView.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 09.08.21.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from urlString: String?) {
        let url = URL(string: urlString ?? "")
        let processor = DownsamplingImageProcessor(size: bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: "beer"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
