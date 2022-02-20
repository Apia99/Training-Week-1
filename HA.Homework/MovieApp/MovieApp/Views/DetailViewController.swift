//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie:Movie!
    var closure: (String) -> Void = { _ in }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var overviewTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Opening details for \(self.movie.title)")
        titleLabel!.text = self.movie.title
        getMovieDetails(movie: movie)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMovieDetails(movie: Movie) {
        
     //   let url = "https://www.omdbapi.com/?apikey=PlzBanMe&i=\(movie.id)&plot=short&r=json"
        let url = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4&query=\(movie.id)"

        HTTPHandler.getJson(urlString: url, completionHandler: movieDetailsCompletion)
    }
    
    func movieDetailsCompletion (data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                guard let plot = object["Plot"] as? String else { return }
                DispatchQueue.main.async {
                    self.overviewTextLabel.text = plot
                }
            }
        }
    }
    
}
