//
//  CategoryCollectionViewCell.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func setup(category: Category) {
        self.categoryLabel.text = category.categoryName
        self.imageView.image = UIImage(named: category.categoryImage!)
    }
}
