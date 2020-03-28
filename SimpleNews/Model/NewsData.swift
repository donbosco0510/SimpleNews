//
//  NewsData.swift
//  SimpleNews
//
//  Created by okky pribadi on 28/03/20.
//  Copyright © 2020 okky pribadi. All rights reserved.
//



import Foundation

public enum Category: String {
    case general = "General"
    case business = "Business"
    case entertainment = "Entertainment"
    case health = "Health"
    case science = "Science"
    case sports = "Sports"
    case technology = "Technology"
}

public class Source: Codable {
    var id: String?
    var name: String?
    var description: String?
    var url: URL?
    var category: String?
    var language: String?
    var country: String?

}

public class Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

struct RawSourcesData: Codable {
    var status: String
    var sources: [Source]
}

struct RawArticlesData: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

