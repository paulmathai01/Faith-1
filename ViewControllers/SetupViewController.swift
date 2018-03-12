//
//  SetupViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    
    
    @IBOutlet weak var yearsOld: UILabel!
    @IBOutlet weak var width: NSLayoutConstraint!
    let fields : [String] = ["I’d like to set my username to","I’d like to set my password to"]
    var count = 0
    @IBAction func nextBttnTapped(_ sender: Any) {
        if detailsField.text != "" {
            count = count + 1
            if count <= 1 {
                if count == 1 {
                    username = detailsField.text!
                }
                if count == 2 {
                    password = detailsField.text!
                }
                animateCard()
            }

                
            else {
                self.performSegue(withIdentifier: "toAge", sender: Any?.self)
            }
        }
        else {
            showAlert(title: "Error", message: "Please enter the text field before proceeding")
        }
    }
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var masterCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        masterCard.layer.cornerRadius = 11
    }
    
    func animateCard() {
        let original = self.masterCard.transform
        UIView.animate(withDuration: 1, animations: {
            self.masterCard.transform = CGAffineTransform(translationX: self.masterCard.frame.origin.x + self.masterCard.frame.width, y: 0)
        }) { (true) in
            self.masterCard.alpha = 0
            self.greeting.text = self.fields[self.count]
            self.detailsField.text = ""
            if self.count == 1 {
                self.detailsField.isSecureTextEntry = true
            }
            self.masterCard.transform = CGAffineTransform(translationX: -(self.view.frame.width + self.masterCard.frame.width), y: 0)
            self.masterCard.alpha = 1
            UIView.animate(withDuration: 1, animations: {
                self.masterCard.transform = original
            }, completion: nil)
        }
    }

    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let bttn = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(bttn)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
