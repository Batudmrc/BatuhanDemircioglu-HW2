//
//  ArticesCollectionViewCell.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit

class ArticlesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    static let identifier = String(describing: ArticlesCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setup(article: ArticleResult) {
        self.title.text = article.title
        self.abstractLabel.text = article.abstract
        // URL image data converted into image
        if let multimedia = article.multimedia, !multimedia.isEmpty {
            if let imageUrlString = multimedia.first?.url, let imageUrl = URL(string: imageUrlString) {
                let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print("Error downloading image: \(error?.localizedDescription ?? "")")
                        return
                    }
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            self.imageView.image = image
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
struct ArticleView {
    let title: String
    let abstract: String
    let image: String
}
