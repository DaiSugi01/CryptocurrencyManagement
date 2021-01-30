//
//  CurrencyTableViewCell.swift
//  Cryptocurrency Management
//
//  Created by Yuki Tsukada on 2021/01/30.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // customize the appearance of the cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView
        self.imageView?.frame = CGRect(x: 10, y: 0, width: self.frame.height, height: self.frame.height)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        // Costomize other elements
        self.textLabel?.frame = CGRect(x: self.frame.height + 20, y: 0, width: self.frame.width / 3, height: self.frame.height)
    }

}
