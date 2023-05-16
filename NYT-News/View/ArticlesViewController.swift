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

extension ArticlesViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticlesCollectionViewCell.identifier, for: indexPath) as! ArticlesCollectionViewCell
        let article = articles[indexPath.row]
        cell.setup(article: article)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 5.2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: selectedArticle)
        print(articles[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let detailVC = segue.destination as? DetailPageViewController {
                detailVC.article = sender as? ArticleResult
            }
        }
    }
}

