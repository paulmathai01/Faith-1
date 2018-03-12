//
//  LandingViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit
import MapKit

var latitude : Double = 0
var longitude : Double = 0

class LandingViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            
        
            
        
        DataHandler.shared.retrieveData { (stat) in
            if stat {
                print(isLoggedIn)
                if isLoggedIn == "true"{
                    self.performSegue(withIdentifier: "alreadyLoggedIn", sender: Any?.self)
                }
                else {
                    self.performSegue(withIdentifier: "toLogin", sender: Any?.self)
                }
            }
        }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    

}
