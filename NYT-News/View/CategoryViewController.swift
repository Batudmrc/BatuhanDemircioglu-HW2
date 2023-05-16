//
//  ViewController.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit
import Network


class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = [Category(categoryName: "Automobiles", categoryImage: "automobiles"),
                                  Category(categoryName: "Books", categoryImage: "books"),
                                  Category(categoryName: "Business", categoryImage: "business"),
                                  Category(categoryName: "Food", categoryImage: "food"),
                                  Category(categoryName: "Health", categoryImage: "health"),
                                  Category(categoryName: "Politics", categoryImage: "politics"),
                                  Category(categoryName: "Sports", categoryImage: "sports"),
                                  Category(categoryName: "Technology", categoryImage: "technology"),
                                  Category(categoryName: "U.S", categoryImage: "us"),
                                  Category(categoryName: "World", categoryImage: "world")]
    
    let pathMonitor = NWPathMonitor()
    
    override func viewDidLoad() {
        self.title = "Choose a Category"
        super.viewDidLoad()
        if !checkNetworkConnectivity() {
                let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                    self?.retryButtonTapped()
                }
                alert.addAction(retryAction)
                present(alert, animated: true, completion: nil)
            }
        setupCollectionView()
    }
    
    func checkNetworkConnectivity() -> Bool {
        let pathMonitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        var isConnected = false
        
        pathMonitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        pathMonitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 2)
        
        return isConnected
    }
    func retryButtonTapped() {
        if checkNetworkConnectivity() {
            dismiss(animated: true) {
                // Proceed with loading the view or performing any necessary actions
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.retryButtonTapped()
            }
            alert.addAction(retryAction)
            present(alert, animated: true, completion: nil)
        }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticlesVC" {
            if let selectedCategory = sender as? String, let destinationVC = segue.destination as? ArticlesViewController {
                destinationVC.categoryName = selectedCategory
                
            }
        }
    }
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.setup(category: category)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row].categoryImage
        performSegue(withIdentifier: "toArticlesVC", sender: selectedCategory)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth / 2 // Two cells per line
        let cellHeight: CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

