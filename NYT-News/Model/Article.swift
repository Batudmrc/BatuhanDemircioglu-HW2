//
//  Article.swift
//  NYT-News
//
//  Created by Batuhan Demircioğlu on 11.05.2023.
//

import Foundation

// MARK: - Welcome
struct Article: Codable {
    let status, copyright, section: String
    let lastUpdated: String
    let numResults: Int
    let results: [ArticleResult]

    enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
struct ArticleResult: Codable {
    let section, subsection, title, abstract: String
    let url: String
    let byline: String
    let updatedDate, createdDate, publishedDate: String
    let multimedia: [Multimedia]?
    let shortURL: String

    enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, byline
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case multimedia
        case shortURL = "short_url"
    }
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let url: String
    let format: Format
    let height, width: Int
    let caption: String
}

enum Format: String, Codable {
    case largeThumbnail = "Large Thumbnail"
    case superJumbo = "Super Jumbo"
    case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
}


