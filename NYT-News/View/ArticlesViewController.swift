//
//  ArticlesViewController.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit
import NewsAPI // Network package

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let spinner = UIActivityIndicatorView(style: .large)
    var articles: [ArticleResult] = []
    var categoryName: String?
    
    override func viewWillAppear(_ animated: Bool) {
        // Connection Check
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryName?.capitalized
        
        setupSpinner()
        fetchNews()
        setupCollectionView()
    }
    
    func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func fetchNews() {
        guard let category = categoryName else { return }
        spinner.isHidden = false
        spinner.startAnimating()
        NYTimesAPIRequest.fetchNews(for: category) { [weak self] result in
            switch result {
            case .success(let article):
                DispatchQueue.main.async {
                    self?.articles.append(contentsOf: article.results)
                    self?.collectionView.reloadData()
                    self?.spinner.stopAnimating()
                }
            case .failure(let error):
                print("Error fetching news: \(error)")
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                }
            }
        }
    }
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: ArticlesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ArticlesCollectionViewCell.identifier)
    }
}


