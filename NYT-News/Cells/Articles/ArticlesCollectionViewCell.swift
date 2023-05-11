//
//  ArticesCollectionViewCell.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit

class ArticlesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrlString: String?
    static let identifier = String(describing: ArticlesCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.layer.cornerRadius = 4
       
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setup(article: ArticleResult) {
        self.title.text = article.title
        self.abstractLabel.text = article.abstract
        
        // Show the spinner while the image is being loaded
        spinner.startAnimating()
        spinner.isHidden = false
        
        if let imageUrlString = article.multimedia?.first?.url {
            self.imageUrlString = imageUrlString
            
            if let cachedImage = ImageCache.shared.getImage(for: imageUrlString) {
                // Use the cached image if available
                imageView.image = cachedImage
                spinner.stopAnimating()
                spinner.isHidden = true
            } else {
                // Start image download if the image is not cached
                downloadImage(from: imageUrlString)
            }
        } else {
            // Hide the spinner if there is no image URL
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    func downloadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "")")
                return
            }
            guard let image = UIImage(data: data) else {
                return
            }
            // Cache the downloaded image
            ImageCache.shared.cacheImage(image, for: urlString)
            DispatchQueue.main.async {
                // Display the image if the URL matches the current cell
                if urlString == self?.imageUrlString {
                    self?.imageView.image = image
                    self?.spinner.stopAnimating()
                    self?.spinner.isHidden = true
                }
            }
        }
        task.resume()
    }
}
struct ArticleView {
    let title: String
    let abstract: String
    let image: String
}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    func cacheImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
}

