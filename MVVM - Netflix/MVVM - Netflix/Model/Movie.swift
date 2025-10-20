//
//  Movie.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 18.10.2025.
//

import Foundation

struct MovieResponse : Decodable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results, totalPages, totalResults
    }
}

// Uygulama içinde posterPath olarak kullanacağız ancak API'den gelen yanıt "poster_path" dir demek. Bunu CodingKey ile sağladık
struct Movie : Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult, backdropPath, genreIds, id, originalTitle, overview, popularity, posterPath = "poster_path", releaseDate, title, video, voteAverage, voteCount
    }
}
