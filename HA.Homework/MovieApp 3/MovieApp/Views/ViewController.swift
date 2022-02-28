//
//  ViewController.swift
//  MovieApp
//
//  Created by Admin on 16/02/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTextField.text = nil
    }
    @IBAction private func savebutton(_ sender: Any) {
        guard let name = userTextField.text, name.count >= 3
        else {
            let invalidAlert = createAlert("The username and/or password is blank or invalid")
            present(invalidAlert, animated: true, completion: nil)
            return
        }
        UserDefaults.standard.set(name, forKey: Utils.keyName)

        // validation is ok
        performSegue(withIdentifier: "searchMoviesSegue", sender: nil)
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "searchMoviesSegue" {
                _ = segue.destination as! SearchViewController
//                controller.name = userTextField.text!
            }
        }
    }
    
    func createAlert(_ message: String) -> UIAlertController {
       let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
       let acceptButton = UIAlertAction(title: "OK", style: .default, handler: nil)
       alert.addAction(acceptButton)
       return alert
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    }
