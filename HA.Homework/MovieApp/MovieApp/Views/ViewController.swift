//
//  ViewController.swift
//  MovieApp
//
//  Created by Admin on 16/02/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var favoriteMovies: [Movie] = []
    var selectedMovie: Movie?
    internal var customer = ""
    
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        saveButton.setTitleColor(UIColor.blue, for: .normal)
        return saveButton
    }()
    
    private let userTextField: UITextField = {
        let userTextField = UITextField()
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.attributedPlaceholder = NSAttributedString(
            string: "write your name here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator])
        userTextField.textColor = .black
        userTextField.borderStyle = UITextField.BorderStyle.roundedRect
        return userTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    private func setUpUI() {
        view.backgroundColor = .white
        
        
    }
    
    @objc private func pressed() {
        guard let user = userTextField.text, user.count >= 3 else
        {
            let invalidAlert = createAlert("The username and/or password is blank or invalid")
            present(invalidAlert, animated: true, completion: nil)
            return
        }
         func createAlert(_ message: String) -> UIAlertController {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let acceptButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(acceptButton)
            return alert
        }
     }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moviecell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        moviecell.tag = idx
        
        //title
        moviecell.movieTitle?.text = favoriteMovies[idx].originalTitle
        //year
        moviecell.movieYear?.text = favoriteMovies[idx].releaseDate
        // image
        displayMovieImage(idx, moviecell: moviecell)
        
        return moviecell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = favoriteMovies[indexPath.row]
    }
    
    func displayMovieImage(_ row: Int, moviecell: CustomTableViewCell) {
        let url: String = (URL(string: favoriteMovies[row].backdropPath)?.absoluteString)!
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "searchMoviesSegue" {
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
        
        if segue.identifier == "movieDetailSegue" {
            let controller = segue.destination as! DetailViewController
            let cell = sender as! CustomTableViewCell
            controller.movie = favoriteMovies[cell.tag]
        }
    }
}
