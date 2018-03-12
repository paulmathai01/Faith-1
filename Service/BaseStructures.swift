//
//  BaseStructures.swift
//  Faith
//
//  Created by Pranav Karnani on 11/03/18.
//  Copyright © 2018 Pranav Karnani. All rights reserved.
//

import Foundation

struct Music : Decodable {
    var mydata : [MusicBase]
}

struct MusicBase : Decodable {
    var preview : String?
    var title : String?
    var artist : String?
    var image : String?
}

struct Restaurant : Decodable {
    var mydata : [RestaurantBase]
}

struct RestaurantBase : Decodable {
    var name : String?
    var address : String?
    var cuisines : String?
    var rating : String?
    var menu : String?
}

struct Quote : Decodable {
    var quote : String?
    var author : String?
}

struct Places : Decodable {
    var mydata : [PlaceBase]
}

struct PlaceBase : Decodable {
    var name : String?
    var address : String?
    var place : String?
}

var music : [Music] = []
var quotes : Quote = Quote(quote: "", author: "")
var restaurants : [Restaurant] = []
var places : [Places] = []
