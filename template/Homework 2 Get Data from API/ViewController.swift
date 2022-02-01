//
//  ViewController.swift
//  Homework 2 Get Data from API
//
//  Created by Admin on 01/02/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=Q9YNbzmt8C5OpY7L3MV4DHJhrdIGCbjx3tVWxRcf&sol=2000&page=1"
        getData(from: url)
    }
    private func getData(from url: String) {
        
       let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("someething went wrong")
                return
            }
            
            var result: Response?
            do {
                result  = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
           
           let photos = result?.photos ?? []
           let firstPhoto = photos.first
           
           print(result?.photos.first?.img_src)
           print(firstPhoto?.img_src)
           print(firstPhoto?.camera.name)
           print(firstPhoto?.rover.id)
            print(firstPhoto?.id)
        })
            task.resume()
        
    }

}

struct Response: Codable {
    let photos: [MyPhoto]
}
struct MyPhoto: Codable  {
    let id: Int
    let img_src: String
    let rover: Rover
    let camera: Camera
}
struct Rover: Codable {
    let id: Int
    let status: String
}
struct Camera: Codable {
    let full_name: String
    let name: String
}
