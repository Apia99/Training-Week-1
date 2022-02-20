//
//  MovieModel.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

struct Movie: Codable {
    var adult: Bool
    var backdropPath: String
    var genreIDS: [Int]
    var id: Int
//    var originalLanguage: OriginalLanguage
    var originalTitle, overview: String
    var popularity: Double
    var posterPath, releaseDate, title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(id: Int, originalTitle: String, releaseDate: String, backdropPath: String, overview: String = "") {
        self.id = id
        self.originalTitle = originalTitle
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.overview = overview
        
        self.adult = false
        self.genreIDS = []
        self.popularity = 0.0
        self.posterPath = ""
        self.title = ""
        self.video = false
        self.voteAverage = 0.0
        self.voteCount = 0
        
       
    }
    


//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case es = "es"
//}
}
