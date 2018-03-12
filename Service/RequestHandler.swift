//
//  RequestHandler.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation

class RequestHandler {
    
    static let shared : RequestHandler = RequestHandler()
    
    func getMusic(completion : @escaping(Bool) -> ()) {
        var z = 0
        DataHandler.shared.retrievePreferences(type: "music") { (stat) in
            if stat {
                DispatchQueue.main.async {
                for item in options
                {
                    musicURL = baseURL + "music/\(item)"
                    print(musicURL)
                    URLSession.shared.dataTask(with: URL(string: musicURL)!) { (data, response, error) in
                        guard let data = data else { return }
                        
                        do {
                            let songs = try JSONDecoder().decode(Music.self, from: data)
                            z = z + 1
                            print(z)
                            music.append(songs)
                            if z == 3 {
                                print(music)
                                completion(true)
                            }
                        }catch {
                            print(error.localizedDescription)
                        }
                        
                    }.resume()
                    
                }
                }
            }
        }
    }
    
    func getQuotes(completion : @escaping(Bool) -> ()) {
        
        URLSession.shared.dataTask(with: URL(string: quoteURL)!) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                quotes = try JSONDecoder().decode(Quote.self, from: data)
                print(quotes)
                completion(true)
            }catch {
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
    func getPlaces(completion : @ escaping (Bool) -> ()) {
        var z = 0
        let list : [String] = ["cafe","hospital","atm"]
        for item in list {
            DispatchQueue.main.async {
                
                placesURL = baseURL + "places/12.9198/79.1324/"
                placesURL = placesURL+"\(item)/\(item)"
                print(placesURL)
                URLSession.shared.dataTask(with: URL(string: placesURL)!) { (data, response, error) in
                    
                    do {
                        guard let data = data else { return }
                        let myplace = try JSONDecoder().decode(Places.self, from: data)
                        z = z + 1
                        places.append(myplace)

                        if z == 3 {
                            completion(true)
                            print(places)
                        }
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }.resume()
                
            }
        }
    }
    
    func getRestaurants(completion : @escaping (Bool) -> ()) {
        print(restaurantsURL)
        URLSession.shared.dataTask(with: URL(string: restaurantsURL)!) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let rest = try JSONDecoder().decode(Restaurant.self, from: data)
                print(rest)
                completion(true)
            }catch {
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
}
