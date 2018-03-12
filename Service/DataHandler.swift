//
//  DataHandler.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

var username : String = ""
var password : String = ""
var isLoggedIn : String = "false"

var options : [String] = []

class DataHandler {
    
    static let shared : DataHandler = DataHandler()
    
    func persistData(completion : @escaping (Bool) -> ()) {
        isLoggedIn = "true"
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MyData", into: context)
        
        
        entity.setValue(isLoggedIn, forKey: "isLoggedIn")
        entity.setValue(username, forKey: "username")
        entity.setValue(password, forKey: "password")
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("error, caching user data")
        }
        
    }
    
    func persistPreferneces(type : String, pref : [String],completion : @escaping (Bool) -> ()) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Pref", into: context)
        var count = 0
        
        entity.setValue(type.lowercased(), forKey: "type")
        
        for item in pref {
            count = count + 1
            entity.setValue(item, forKey: "e\(count)")
            
            do {
                try context.save()
                completion(true)
            } catch {
                print("error, caching user data")
            }
        }
        
        
        
    }
    
    func retrieveData(completion : @escaping (Bool) -> ()) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let requests = NSFetchRequest<NSFetchRequestResult>(entityName: "MyData")
        
        do {
            let results = try context.fetch(requests)
            
            for request in results as! [NSManagedObject]
            {
                isLoggedIn = request.value(forKey: "isLoggedIn") as? String ?? "false"
                username = request.value(forKey: "username") as! String
                password = request.value(forKey: "password") as! String
            }
            
            completion(true)
            
        } catch {
            print("error, retrieving user data")
        }
        
        
    }
    
    func retrievePreferences(type : String, completion : @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            options.removeAll()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pref")
            
            do {
                request.predicate = NSPredicate(format: "type = %@", argumentArray: [type])
                let results = try context.fetch(request)
                
                for result in results as! [NSManagedObject] {
                
                let type1 = result.value(forKey: "e1") as! String
                let type2 = result.value(forKey: "e2") as! String
                let type3 = result.value(forKey: "e3") as! String
                    
                    options.append(type1)
                    options.append(type2)
                    options.append(type3)
                }
                
                completion(true)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}
