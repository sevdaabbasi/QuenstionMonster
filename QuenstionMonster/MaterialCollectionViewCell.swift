//
//  MaterialCollectionViewCell.swift
//  QuenstionMonster
//
//  Created by Sevda Abbasi on 5.06.2024.
//

import UIKit

class MaterialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with material: Material) {
        nameLabel.text = material.name
        iconImageView.image = UIImage(named: material.type.icon)
    }
}
