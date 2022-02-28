//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let viewModel = MovieDataModel()
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpBinding()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? DetailViewController
        destination?.viewModel = viewModel
    }
    
    private func setUpUI() {
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        
//         display name
        if let name = UserDefaults.standard.string(forKey: Utils.keyName) {
            helloLabel.text = "Hello: \(name)"
        }
    }
    
    private func setUpBinding() {
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel.fetchData()
    }
    
    @IBAction func changeSegmentControl(_ sender: Any) {
    }
    
    @IBAction func editName(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

    extension SearchViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.movies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
            let row = indexPath.row
            let movie = viewModel.movies[row]
            cell.configureCell(row: row, title: movie.originalTitle, overview: movie.overview)
            cell.showdetails = { [weak self] row in
                print("from view controller")
                print(row)
                self?.viewModel.selectMovie(row: indexPath.row)
                self?.performSegue(withIdentifier: "showDeatilView", sender: nil)
            }
            cell.delegate = self
            cell.configureImageCell(row: row, viewModel: viewModel)
            
            return cell
        }
    }

extension SearchViewController: CustomTableViewCellDelegate {
    func showdetails(row: Int) {
        print("from delegate")
        print(row)
        viewModel.selectMovie(row: row)
        performSegue(withIdentifier: "showDeatilView", sender: nil)
    }
}
    

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectMovie(row: indexPath.row)
        performSegue(withIdentifier: "showDeatilView", sender: nil)
    }
}

    extension SearchViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.filterMovies(searchText: searchText)
        }
    }


