//
//  ViewController.swift
//  Homework 2.1
//
//  Created by Admin on 03/02/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private  weak var tableView: UITableView!
    var RDetail = [Response]()
    var PDetail = [MyPhoto]()
    var R2Detail = [Rover]()
    var CDetail = [Camera]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadJSON {
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource  = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  PDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text  = PDetail[indexPath.row].localized_name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let  destination = segue.destination as? TableViewController {
            destination.PDetail = MyPhoto[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func downloadJSON(completed: @escaping  ()  -> ()) {
         let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=Q9YNbzmt8C5OpY7L3MV4DHJhrdIGCbjx3tVWxRcf&sol=2000&page=1")
        
        URLSession.shared.dataTask(with: url!) { [self] (data, response, error) in
            
            if  error ==  nil {
                do {
                    self.PDetail = try JSONDecoder().decode([ MyPhoto].self, from: data!)
                   
                    DispatchQueue.main.async {
                        completed()
                    }
                    
                }catch {
                    print("Json error")
            }
        }
    }.resume()
  }
}
        
//        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=Q9YNbzmt8C5OpY7L3MV4DHJhrdIGCbjx3tVWxRcf&sol=2000&page=1"
//        getData(from: url)
//    }
//    private func getData(from url: String) {
//
//       let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
//
//            guard let data = data, error == nil else {
//                print("something went wrong")
//                return
//            }
//
//            var result: Response?
//            do {
//                result  = try JSONDecoder().decode(Response.self, from: data)
//            }
//            catch{
//                print("failed to convert \(error.localizedDescription)")
//            }
//            guard let json = result else {
//                return
//            }
//
//           let photos = result?.photos ?? []
//           let firstPhoto = photos.first
//
//           print(result?.photos.first?.img_src)
//           print(firstPhoto?.sol)
//           print(firstPhoto?.camera.name)
//           print(firstPhoto?.rover.status)
//           print(firstPhoto?.id)
//           print(firstPhoto?.earth_date)
//
//        })
//            task.resume()
//
//    }
//
//}
