//
//  MovieDataModel.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation
import CoreData

class MovieDataModel {
    
    private let networkManager: NetworkManager
    @Published private(set) var movies = [Movie]()
    private var cache = [String: Data]()
    @Published private(set) var movieSelected: Movie?
    @Published private(set) var companyImages = [Data]()
    private var arrayCompanies: [Company]?
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovieDetails() {
        
        let id = movieSelected?.id ?? 0
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=6622998c4ceac172a976a1136b204df4"
        
        networkManager
            .getModel(Movie.self, from: url) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.movieSelected = response
                    self?.arrayCompanies = response.productionCompanies
                    self?.downloadCompaniesImages()
                case .failure(let error):
                    print(error)
                }
            }
    }

    func fetchData() {
        let url = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4"
        
        // ask if I have data
        let currentMovies = getAllCDMovie()
        
        // every day 24 hours you need to clean data base
        print(UserDefaults.standard.object(forKey: "cacheTime"))
        var forceUpdate = false
        let cacheTime = UserDefaults.standard.double(forKey: "cacheTime")
        let currentTime = Date().timeIntervalSince1970
        let time = currentTime - cacheTime
        if time >= 60 * 60 * 24 {
            forceUpdate = true
        }
        
        if currentMovies.isEmpty || forceUpdate {
            cleanMovies()
            networkManager
                .getModel(MoviesResponse.self, from: url) { [weak self] result in
                    switch result {
                    case .success(let response):
                        let results = response.results
                        self?.movies = results
                        self?.saveMovies()
                        
                        // save cache time
                        print(Date().timeIntervalSince1970)
                        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "cacheTime")
                        UserDefaults.standard.synchronize()
                        
                    case .failure(let error):
                        print(error)
                    }
                }
        } else {
            movies = currentMovies
        }
        
    }
    
    private func downloadImage(from imageUrl: String, completion: @escaping (Data) -> Void) {
        if let data = cache[imageUrl] {
            completion(data)
            return
        }
        
        networkManager
            .getData(from: imageUrl) { result in
                switch result {
                case .success(let data):
                    self.cache[imageUrl] = data
                    DispatchQueue.main.async {
                        completion(data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func downloadImage(row: Int, completion: @escaping (Data) -> Void) {
        
        let movie = movies[row]
        let backdropPath = movie.backdropPath
        let imageUrl = "https://image.tmdb.org/t/p/w500\(backdropPath)"
        
        downloadImage(from: imageUrl, completion: completion)

    }
    
    func downloadImage(movie: Movie?, completion: @escaping (Data) -> Void) {
        
        let backdropPath = movie?.backdropPath ?? ""
        let imageUrl = "https://image.tmdb.org/t/p/w500\(backdropPath)"
        
        downloadImage(from: imageUrl, completion: completion)
        
    }

    private func cleanMovies() {
        
    }
    
    private func saveMovies() {
        
        /*
         // user defaults
         if let data = try? JSONEncoder().encode(movies) {
             UserDefaults.standard.set(data, forKey: "keyMovies")
         }
         */
        
        let context = CoreDataManager.shared.mainContext
        
        guard let description = NSEntityDescription.entity(forEntityName: "CDMovie", in: context)
        else { return }
        
        context.perform {
            for movie in self.movies {
                let cdMovie = CDMovie(entity: description, insertInto: context)
                cdMovie.id = Int64(movie.id)
                cdMovie.backdropPath = movie.backdropPath
                cdMovie.title = movie.originalTitle
                cdMovie.overview = movie.overview
                try? context.save()
            }
        }
    }
    
    private func getAllCDMovie() -> [Movie] {
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let context = CoreDataManager.shared.mainContext
        var newMovies = [Movie]()
        context.performAndWait {
            let cdMovies = try? context.fetch(request)
            for cdMovie in (cdMovies ?? []) {
                let tempMovie = cdMovie.createMovie()
                newMovies.append(tempMovie)
            }
        }
        return newMovies
    }
    
    func filterMovies(searchText: String) {
        
        /*
        // without coredata
        let filtered = movies.filter { movie in
            let title = movie.originalTitle.lowercased()
            return title.contains(searchText)
        }
        movies = filtered
         */
        
        
        if searchText.isEmpty {
            movies = getAllCDMovie()
            return
        }
        
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        let predicateTitle = NSPredicate(format: "title CONTAINS[c] %@", searchText)
//        let predicateOverview = NSPredicate(format: "overview CONTAINS[c] %@", searchText)
//        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateOverview])
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle])
        request.predicate = predicate
        
        let context = CoreDataManager.shared.mainContext
        
        context.performAndWait { [weak self] in
            if let cdMovies = try? context.fetch(request) {
                let moviesFiltered = cdMovies.map { $0.createMovie() }
                self?.movies = moviesFiltered
            }
        }
    }
    
    func selectMovie(row: Int) {
        let movie = movies[row]
        movieSelected = movie
    }
    
    func downloadCompaniesImages() {
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        let array = movieSelected?.productionCompanies ?? []
        let pathArray = array.map { company -> String in
            var completeURL = baseImageURL
            let path = company.logoPath ?? ""
            completeURL.append(path)
            return completeURL
        }
        
        let group = DispatchGroup()
        var temp = [Data]()
        group.enter()
        for (url) in pathArray {
            networkManager.getData(from: url) { result in
                switch result {
                case .success(let data):
                    temp.append(data)
                case .failure(let error):
                    print(error)
                }
            }
        }
        group.leave()
        group.notify(queue: .main) { [weak self] in
            self?.companyImages = temp
        }
    }
    
}
