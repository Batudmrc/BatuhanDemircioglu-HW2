//
//  ArticlesViewController.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var articles: [ArticleResult] = []
    var categoryName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = categoryName?.capitalized
        fetchNews()
    }
    
    func fetchNews() {
        guard let category = categoryName else { return }
        
        NYTimesAPIRequest.fetchNews(for: category) { [weak self] result in
            switch result {
            case .success(let article):
                DispatchQueue.main.async {
                    self?.articles.append(contentsOf: article.results) // Add the article to the articles array
                    print(self!.articles[0])
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
    }
    
}

extension ArticlesViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}
