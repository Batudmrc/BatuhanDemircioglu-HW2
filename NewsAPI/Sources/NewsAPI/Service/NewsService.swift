//
//  NewsService.swift
//  
//
//  Created by Batuhan Demircioğlu on 15.05.2023.
//

import Foundation

public struct NYTimesAPIRequest {
     public static func fetchNews(for category: String, completion: @escaping (Result<Article, Error>) -> Void) {
        guard let url = buildURL(for: category) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        performRequest(with: url) { result in
            switch result {
            case .success(let data):
                do {
                    let articles = try decodeArticles(from: data)
                    completion(.success(articles))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func buildURL(for category: String) -> URL? {
        let apiKey = "ZYemLoVP2BFIO7AzaIbiUVwhcQzU7ydT"
        let baseURL = "https://api.nytimes.com/svc/topstories/v2/"
        let urlString = baseURL + "\(category.lowercased()).json?api-key=\(apiKey)"
        return URL(string: urlString)
    }
    
    private static func performRequest(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    private static func decodeArticles(from data: Data) throws -> Article {
        let decoder = JSONDecoder()
        return try decoder.decode(Article.self, from: data)
    }
}
