//
//  Article.swift
//  
//
//  Created by Batuhan Demircioğlu on 15.05.2023.
//

import Foundation

// MARK: - Welcome
public struct Article: Codable {
    public let copyright, section: String
    public let lastUpdated: String
    public let numResults: Int
    public let results: [ArticleResult]

    enum CodingKeys: String, CodingKey {
        case copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result
public struct ArticleResult: Codable {
    public let section, subsection, title, abstract: String
    public let url: String
    public let byline: String
    public let updatedDate, createdDate, publishedDate: String
    public let multimedia: [Multimedia]?
    public let shortURL: String

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
public struct Multimedia: Codable {
    public let url: String
    public let format: Format
    public let height, width: Int
    public let caption: String
}

public enum Format: String, Codable {
    case largeThumbnail = "Large Thumbnail"
    case superJumbo = "Super Jumbo"
    case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
}


