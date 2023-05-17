//
//  ArticlesViewController+CollectionView.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 17.05.2023.
//

import UIKit
import NewsAPI

extension ArticlesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filteredArticles = articles.filter { !$0.title.isEmpty } // Filter the empty data
        return filteredArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticlesCollectionViewCell.identifier, for: indexPath) as! ArticlesCollectionViewCell
        let filteredArticles = articles.filter { !$0.title.isEmpty } // Filter the empty data
        let article = filteredArticles[indexPath.row]
        cell.setup(article: article)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                
                if currentOrientation == .landscapeLeft || currentOrientation == .landscapeRight {
                    let itemWidth = collectionView.bounds.width
                    let itemHeight: CGFloat = 150
                    return CGSize(width: itemWidth, height: itemHeight)
                }
                
                // Return your default item size for other orientations
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 5.2)
        //return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 5.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredArticles = articles.filter { !$0.title.isEmpty } // Filter the empty data
        let selectedArticle = filteredArticles[indexPath.row]
        performSegue(withIdentifier: Constants.SegueIdentifiers.toDetailVC.rawValue, sender: selectedArticle)
    }
    // Passing selected article to the detail VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.toDetailVC.rawValue {
            if let detailVC = segue.destination as? DetailPageViewController {
                detailVC.article = sender as? ArticleResult
            }
        }
    }
    
    
    // Creating smooth animation for scrolling
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // fade-out animation
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // fade-in animation
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.15) {
            cell.alpha = 1.0
        }
    }
    
}

