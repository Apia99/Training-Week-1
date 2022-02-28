//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    var viewModel: MovieDataModel?
    private var subscribers = Set<AnyCancellable>()
    
    // UI elements
//    private lazy var mainStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        return stackView
//    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TITLE"
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OVERVIEW"
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var companyTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: 80)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
//        collection.delegate = self
        collection.register(CompanyViewCell.self, forCellWithReuseIdentifier: CompanyViewCell.identifier)
        collection.backgroundColor = .lightGray
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpBinding()
    }
    
    private func setUpUI() {
        descriptionStackView.addArrangedSubview(movieTitleLabel)
        descriptionStackView.addArrangedSubview(overviewLabel)

        headerStackView.addArrangedSubview(movieImageView)
        headerStackView.addArrangedSubview(descriptionStackView)
        
//        mainStackView.addArrangedSubview(headerStackView)
//        mainStackView.addArrangedSubview(companyTitleLabel)
//        mainStackView.addArrangedSubview(collectionView)
        
        view.addSubview(headerStackView)
        view.addSubview(companyTitleLabel)
        view.addSubview(collectionView)
        
        // constraints
        let safeArea = view.safeAreaLayoutGuide
        
//        mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//        mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
//        mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
//        mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
        headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        headerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        headerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        movieImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        movieImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        companyTitleLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor).isActive = true
        companyTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        companyTitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: companyTitleLabel.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    private func setUpBinding() {
        
        viewModel?
            .$movieSelected
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.populateUI()
            }
            .store(in: &subscribers)
        
        viewModel?
            .$companyImages
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel?.getMovieDetails()
    }
    
    private func populateUI() {
        let movie = viewModel?.movieSelected
        movieTitleLabel.text = movie?.originalTitle
        overviewLabel.text = movie?.overview
        companyTitleLabel.text = "Production companies"
        
        viewModel?.downloadImage(movie: viewModel?.movieSelected, completion: { [weak self] data in
            let image = UIImage(data: data)
            self?.movieImageView.image = image
        })
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = viewModel?.companyImages.count ?? 0
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyViewCell.identifier, for: indexPath) as! CompanyViewCell
        let data = viewModel?.companyImages[indexPath.row] ?? Data()
        cell.configureCell(imageData: data)
        return cell
    }
    
}

