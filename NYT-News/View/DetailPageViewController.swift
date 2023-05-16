//
//  DetailPageViewController.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 16.05.2023.
//

import UIKit
import NewsAPI
import SafariServices

class DetailPageViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var article: ArticleResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        abstractLabel.text = article?.abstract
        bylineLabel.text = article?.byline
        titleLabel.text = article?.title
        
        spinner.startAnimating()
        spinner.style = .large
        spinner.color = .systemBlue
        spinner.hidesWhenStopped = true
        
        if let multimedia = article?.multimedia,
           let urlString = multimedia.first?.url,
           let url = URL(string: urlString) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating() // Stop the spinner if an error occurs
                }
                return
            }
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.spinner.stopAnimating() // Stop the spinner once the image is loaded
                self?.spinner.isHidden = true
            }
        }.resume()
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        if let urlString = article?.url,
           let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
