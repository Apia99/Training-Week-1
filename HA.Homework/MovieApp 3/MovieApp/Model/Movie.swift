//
//  MovieModel.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    
}

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let productionCompanies: [Company]?


    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id, overview
        case originalTitle = "original_title"
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case productionCompanies = "production_companies"
    }
    
    init(id: Int, originalTitle: String, releaseDate: String, backdropPath: String, overview: String, genreIds: [Int]? ) {
        self.id = id
        self.originalTitle = originalTitle
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.overview = overview
        self.productionCompanies = nil
        self.adult = false
        self.genreIDS = []
        self.popularity = 0.0
        self.posterPath = ""
        self.title = ""
        self.video = false
        self.voteAverage = 0.0
        self.voteCount = 0
        
    }
 
}
