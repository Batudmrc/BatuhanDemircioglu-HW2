//
//  NewsRequest.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import Foundation

struct NYTimesAPIRequest {
    static func fetchNews(for category: String, completion: @escaping (Result<Article, Error>) -> Void) {
        let apiKey = "ZYemLoVP2BFIO7AzaIbiUVwhcQzU7ydT"
        let baseURL = "https://api.nytimes.com/svc/topstories/v2/"
        let urlString = baseURL + "\(category.lowercased()).json?api-key=\(apiKey)"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let articles = try decoder.decode(Article.self, from: data)
                    completion(.success(articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}


