//
//  PreferencesViewController.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import UIKit
import Magnetic

class PreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var textData : [String] = ["Movies","Music","Places","Food"]
    var listOfSelected : [String] = []
    var indexTapped : [Int] = []
    var original : CGAffineTransform = CGAffineTransform()
    var selected : Int = 0
    var selectedTitle : String = ""
    var magnetic: Magnetic?
    var buffer : Int = 0
    
    @IBOutlet weak var bubbleView: MagneticView!
    @IBAction func doneBttnTapped(_ sender: Any) {
        print(listOfSelected)
        self.selectionTable.alpha = 1
        self.masterCaRD.transform = original
        self.selectionTable.reloadData()
        
        DataHandler.shared.persistPreferneces(type: selectedTitle, pref: listOfSelected) { (stat) in
            if stat {
                print("persisted")
            }
        }
        if self.buffer == 4 {
            self.performSegue(withIdentifier: "signedUp", sender: Any?.self)
        }
        
        listOfSelected.removeAll()
    }
    @IBOutlet weak var selectionTable: UITableView!
    @IBOutlet weak var masterCaRD: UIView!
    override func viewDidLoad() {
        self.magnetic?.delegate
        super.viewDidLoad()
        self.selectionTable.dataSource = self
        self.selectionTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        original = masterCaRD.transform
        self.load()
    }
    
    override func viewDidLayoutSubviews() {
        masterCaRD.layer.cornerRadius = 25
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreferencesTableViewCell
        cell.main.text = textData[indexPath.section]
        cell.main.layer.cornerRadius = 20
        cell.main.clipsToBounds = true
    
        cell.main.textColor = UIColor.black
        for item in indexTapped {
            if item == indexPath.section {
                cell.main.backgroundColor = .clear
                cell.contentView.setGradientBackground(colorOne: topLeft, colorTwo: bottomRight)
                cell.contentView.layer.cornerRadius = 20
                cell.contentView.clipsToBounds = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = textData[indexPath.section]
        selectedTitle = textData[indexPath.section]
        indexTapped.append(indexPath.section)
        bringView(text : text)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
    
    
    func bringView(text : String) {
        selected = 0
        var list : [String] = []
        var nodeList : [Node] = []
        magnetic?.removeAllChildren()
        self.selectionTable.alpha = 0.2
        UIView.animate(withDuration: 1) {
            self.masterCaRD.transform = CGAffineTransform(translationX: 0, y: -(self.masterCaRD.frame.height))
            
            if text.contains("Music") {
                self.buffer = self.buffer + 1
                list = ["Rock", "Pop", "Bollywood", "Electronic", "House", "Trance",  "Deep House", "PSYTrance",  "Trap",  "Slow", "Rap"]
                self.listOfSelected = ["rock","pop","trance"]
            }
            else if text.contains("Food") {
                self.buffer = self.buffer + 1
                list = ["Chineese", "Indian", "Continental", "Mexican", "Italian", "Mediterranean",  "Asian", "Japaneese",  "Lebaneese","American"]
                self.listOfSelected = ["indian","chineese","italian"]
            }

            else if text.contains("Places") {
                self.buffer = self.buffer + 1
                list = ["Temple", "Cafe", "Malls", "Theatres", "Grounds", "Beach",  "Mountains", "Monuments",  "Towers",  "Cities","Villages","Towns"]
                self.listOfSelected = ["Cafe","Town","Beach"]

            }

            else if text.contains("Movies") {

                self.buffer = self.buffer + 1
                list = ["Action", "Thriller", "Sci-Fi", "Anime", "Comedy", "Romantic",  "Rom-Com", "Scary",  "Horror",  "Suspense",  "Bollywood", "Hollywood", "Tollywood", "Tamil",  "Telugu", "Documentary"]
                
                self.listOfSelected = ["action","thriller","comedy"]
            }

            for item in list {
                let node = Node(text: item, image: nil, color: .orange, radius: 45)
                self.magnetic?.addChild(node)
                nodeList.append(node)
            }
            
            self.load()

         }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    func load() {
        
        magnetic = bubbleView.magnetic
        self.masterCaRD.addSubview(bubbleView)
    }

}

extension UIView {
    
    func setGradientBackground(colorOne : UIColor, colorTwo : UIColor)
    {
        DispatchQueue.main.async {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        
        gradientLayer.locations = [0.0,1.0]
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

extension PreferencesViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
}

class ImageNode: Node {

    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}
