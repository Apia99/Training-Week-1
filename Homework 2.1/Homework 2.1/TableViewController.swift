//
//  TableViewController.swift
//  Homework 2 Get Data from API
//
//  Created by Admin on 03/02/2022.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class TableViewController: UITableViewController {

    @IBOutlet private weak var Label1: UILabel!
    @IBOutlet private weak var ImageView: UIImageView!
    
    var PDetail:MyPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Label1.text = PDetail?.localized_name
        
        let urlString = "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02000/opgs/edr/fcam/FLB_575055503EDR_F0682626FHAZ00337M_.JPG"+(PDetail?.img_src)!
        let url = URL(string: urlString)
        ImageView?.downloaded(from: url!)
    }
    
}
