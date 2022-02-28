//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

class NetworkManager {

//    func getModel<Model: Codable>(_ type: Model.Type, from url: String, completion: @escaping (Result<Model, NetworkError>) -> ()) {
    func getModel<T: Codable>(_ model: T.Type, from url: String, completion: @escaping (Result<T, NetworkError>) -> Void) {

    guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(model, from: data)
                    completion(.success(response))
                } catch let error  {
                    completion(.failure(.other(error)))
                }
            }
        }
        .resume()
    }

    func getData(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            }
            
            if let error = error {
                completion(.failure(.other(error)))
            }
        }
        .resume()
    }
    
}
