//
//  HTTPHandler.swift
//  MovieApp
//
//  Created by Admin on 17/02/2022.
//

import Foundation

class HTTPHandler {
    static func getJson(urlString: String, completionHandler: @escaping (Data?) -> (Void)) {
        let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        
        print("URL being used is \(url!)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                print("request completed with code: \(statusCode)")
                if (statusCode == 200) {
                    print("return to completion handler with the data")
                    completionHandler(data as Data)
                }
            } else if let error = error {
                print("***There was an error making the HTTP request***")
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    func getImage(from url: String, completion: @escaping(Data?) -> Void ) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
    }
        URLSession.shared.dataTask(with: url) { data, response , error in
            completion(data)
        }
        .resume()
   }
}
