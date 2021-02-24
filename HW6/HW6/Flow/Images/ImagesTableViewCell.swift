//
//  ImagesTableViewCell.swift
//  HW6
//
//  Created by Aliona Starunska on 21.02.2021.
//

import UIKit

class ImagesTableViewCell: UITableViewCell, ReusableCell, ConfigurableCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configure(with item: Photo) {
        if let data = item.imageData {
            photoImageView.image = UIImage(data: data)
        } else {
            photoImageView.image = nil
        }
        nameLabel.text = item.name
    }
}
