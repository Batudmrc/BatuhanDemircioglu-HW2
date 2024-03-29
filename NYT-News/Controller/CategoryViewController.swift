//
//  ViewController.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories: [Category] = setCategoryList()
    
    override func viewWillDisappear(_ animated: Bool) {
        checkConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ConnectionCheck
        checkConnection()
    }
    
    override func viewDidLoad() {
        self.title = "Choose a Category"
        super.viewDidLoad()
        // ConnectionCheck
        checkConnection()
        setupCollectionView()
    }
    // Passing category to the next VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.toArticlesVC.rawValue {
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
        // Limiting the cells
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    func checkConnection() {
        NetworkUtils.checkConnection(in: self) {
            NetworkUtils.retryButtonTapped(in: self)
        }
    }
}

