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
    
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var article: ArticleResult?
    
    override func viewWillAppear(_ animated: Bool) {
        // Connection check
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetailPage()
        setupSpinner()
    }
    
    func setupDetailPage() {
        abstractLabel.text = article?.abstract
        bylineLabel.text = article?.byline
        titleLabel.text = article?.title
        publishDateLabel.text = dateFormatter(article!.publishedDate)
        if let multimedia = article?.multimedia,
           let urlString = multimedia.first?.url,
           let url = URL(string: urlString) {
            loadImage(from: url)
        }
    }
    
    func setupSpinner() {
        spinner.startAnimating()
        spinner.style = .large
        spinner.color = .systemBlue
        spinner.hidesWhenStopped = true
    }
    // Date formatter to return days passed after articles publish
    func dateFormatter(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date, to: Date())
            
            if let days = components.day {
                if days == 0 {
                    return "Today"
                } else if days == 1 {
                    return "Yesterday"
                } else if days > 1 {
                    return "\(days) days ago"
                } else {
                    return "In the future"
                }
            }
        }
        
        return "Invalid date"
    }
    
    // Download image and store as UIImage
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                // dissolve animation after image is loaded
                if let strongSelf = self {
                    UIView.transition(with: strongSelf.imageView,
                                      duration: 0.1,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        strongSelf.imageView.image = image
                    },
                                      completion: { _ in
                        strongSelf.spinner.stopAnimating()
                        strongSelf.spinner.isHidden = true
                    })
                }
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
