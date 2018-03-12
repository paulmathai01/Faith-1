//
//  AgeViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController {

    @IBAction func nextBttnTapped(_ sender: Any) {
        
        if ageField.text != "" {
            self.performSegue(withIdentifier: "preferences", sender: Any?.self)
        }
        
    }
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var masterCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        masterCard.layer.cornerRadius = 21
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



