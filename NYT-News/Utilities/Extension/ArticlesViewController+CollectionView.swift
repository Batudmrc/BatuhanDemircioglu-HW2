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
        performSegue(withIdentifier: Constants.SegueIdentifiers.toDetailVC.rawValue, sender: selectedArticle)
        print(articles[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.toDetailVC.rawValue {
            if let detailVC = segue.destination as? DetailPageViewController {
                detailVC.article = sender as? ArticleResult
            }
        }
    }
}

