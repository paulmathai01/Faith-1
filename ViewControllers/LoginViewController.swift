//
//  LoginViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var masterCard: UIView!
    @IBAction func loginBttn(_ sender: Any) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            self.showAlert(title: "Error", message: "One of the following detailes has not been filled yet")
        }
            
        else {
            if usernameTextField.text == username && passwordTextField.text == password {
                self.performSegue(withIdentifier: "loginSuccessful", sender: Any?.self)
            }
            else {
                self.showAlert(title: "Error", message: "Invalid username and password")
            }
        }
        
        
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataHandler.shared.retrieveData { (stat) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        masterCard.layer.cornerRadius = 21.0
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let bttn = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(bttn)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
