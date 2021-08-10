//
//  BeerTableViewCell.swift
//  Beers
//
//  Created by Shushanik Gevorgyan on 07.08.21.
//

import UIKit
import Kingfisher

class BeerTableViewCell: UITableViewCell {

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        taglineLabel.font = UIFont.systemFont(ofSize: 12)
        taglineLabel.textColor = .gray
    }
}

extension BeerTableViewCell {
    func bind(to data: BeerViewData) {
        beerImageView.setImage(from: data.imageURL)
        titleLabel.text = data.name
        taglineLabel.text = "abv: \(data.abv) ibu: \(data.ibu) ebc: \(data.ebc)"
    }
}
