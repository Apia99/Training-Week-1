//
//  MovieDataModel.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

class MovieDataModel {
    
    static func mapJsonToMovies(object: [String: AnyObject], moviesKey: String) -> [Movie] {
        var mappedMovies: [Movie] = []
        
        guard let movies = object[moviesKey] as? [[String: AnyObject]] else { return mappedMovies }
        
        for movie in movies {
            guard let id = movie["id"] as? Int,
                let name = movie["original_title"] as? String,
                let year = movie["release_date"] as? String,
                let imageUrl = movie["backdrop_path"] as? String else { continue }
            
            let movieClass = Movie(id: id, originalTitle: name, releaseDate: year, backdropPath: imageUrl)
            mappedMovies.append(movieClass)
        }
        return mappedMovies
    }
    
    static func write(movies: [Movie]) {
    }
}
