//
//  CompanyViewCell.swift
//  MovieApp
//
//  Created by Admin on 26/02/2022.
//

import UIKit

class CompanyViewCell: UICollectionViewCell {
    
    static let identifier = "CompanyViewCell"
    
    private lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configureCell(imageData: Data) {
        
        contentView.addSubview(companyImageView)
        
        let image = UIImage(data: imageData)
        companyImageView.image = image
        
        let safeArea = contentView.safeAreaLayoutGuide
        companyImageView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        companyImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        companyImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        companyImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
}
