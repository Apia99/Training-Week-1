//
//  CustomTableViewCells.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit

protocol CustomTableViewCellDelegate: AnyObject {
    func showdetails(row: Int)
}

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"

    weak var delegate: CustomTableViewCellDelegate?
    
    var showdetails: (Int) -> Void = { _ in }
    private var rowSelected = 0

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favButton_: UIButton!
    
    func configureCell(row: Int, title: String?, overview: String?) {
            titleLabel.text = title
            overviewLabel.text = overview
            rowSelected = row
        }
    
    @IBAction func showdetails(_ sender: Any) {
        showdetails(rowSelected)
        delegate?.showdetails(row: rowSelected)
    }
    
    
    @IBAction func favButton(_ sender: UIButton) { print("Item #\(sender.tag) was selected as a favorite")
    }
    func configureImageCell(row: Int, viewModel: MovieDataModel) {
            
            movieImageView.image = nil
            
            viewModel
                .downloadImage(row: row) { [weak self] data in
                    let image = UIImage(data: data)
                    self?.movieImageView.image = image
                }
        }
        
    }

//    var userTapOnDetailsButton: () -> Void = { }

        
