//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ViewController!
    var searchResults: [Movie] = []
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func search(_ sender: UIButton) {print("Searching for \(self.searchText.text!)")
    }
    @IBAction func addFav(_ sender: UIButton) { print("Item #\(sender.tag) was selected as a favorite")
        self.delegate.favoriteMovies.append(searchResults[sender.tag])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviecell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        moviecell.favButton.tag = idx
        
        //title
        moviecell.movieTitle?.text = searchResults[idx].originalTitle
        //year
        moviecell.movieYear?.text = searchResults[idx].releaseDate
        // image
        displayMovieImage(idx, moviecell: moviecell)
        
        return moviecell
    }
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: searchResults[row].backdropPath)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                moviecell.movieImageView?.image = image
            })
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveMoviesByTerm(searchTerm: "Batman")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        let url =  "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=6622998c4ceac172a976a1136b204df4&query=\(searchTerm)"
        HTTPHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                self.searchResults = MovieDataModel.mapJsonToMovies(object: object, moviesKey: "results")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
//    private enum MovieSelection: Int {
//        case MovieList
//        case FavoritesList
//
//        var table: UITableView? {
//            switch self {
//            case .MovieList:
//                return UITableView(named: "MovieList")
//            case .FavoritesList:
//                return UITableView(named: "FavoritesList")
//
//            }
//        }
//    }
//    @IBOutlet private weak var segmentControl: UISegmentedControl!
//
//    @IBOutlet weak var table: UITableView!
//    @IBAction private func changeSegmentControl(_ sender: Any) {
//
//        let index = segmentControl.selectedSegmentIndex
//
//        guard let segmentCase = MovieSelection(rawValue: index)
//        else { return }
//
//        UITableView.table = segmentCase.table
//    }
//
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? DetailViewController
        destination?.closure
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
