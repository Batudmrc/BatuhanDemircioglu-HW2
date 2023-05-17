//
//  CategoryViewController+CollectionView.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 17.05.2023.
//

import UIKit

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
        performSegue(withIdentifier: Constants.SegueIdentifiers.toArticlesVC.rawValue, sender: selectedCategory)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth / 2 // Two cells per line
        let cellHeight: CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
