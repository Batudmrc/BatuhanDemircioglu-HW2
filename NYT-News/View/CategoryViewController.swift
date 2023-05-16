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
    
    override func viewWillAppear(_ animated: Bool) {
        // ConnectionCheck
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
    }
    
    override func viewDidLoad() {
        self.title = "Choose a Category"
        super.viewDidLoad()
        // ConnectionCheck
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
        setupCollectionView()
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

