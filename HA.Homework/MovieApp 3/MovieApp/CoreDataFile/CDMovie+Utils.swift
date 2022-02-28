//
//  CDMovie+Utils.swift
//  MovieApp
//
//  Created by Admin on 22/02/2022.
//

import Foundation

extension CDMovie {
    
    func createMovie() -> Movie {
        
        let id = Int(self.id)
        let backdropPath = self.backdropPath ?? ""
        let originalTitle = self.title ?? ""
        let overview = self.overview ?? ""
        let releaseDate = self.releaseDate ?? ""
        
        return Movie(id: id, originalTitle: originalTitle, releaseDate: releaseDate, backdropPath: backdropPath ,
                     overview: overview, genreIds: nil)
    }
    
}
