//
//  TVShowModelClasses.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-07.
//

import Foundation


struct TVShow:Codable{
    var id:Int? = 0
    var name: String? = ""
    var image : Image? = Image()
    var rating : Rating? = Rating()
    var network : Network? = Network()
    var schedule : Schedule? = Schedule()
    var genres : [String]? = [String]()
    var summary : String? = nil
    var premiered:String? = nil
    var language : String? = nil
    var status: String? = nil
}

struct Image:Codable{
    var original:String? = nil
}

struct Rating:Codable{
    var average:Float? = nil
}

struct Network:Codable{
    var name:String? = nil
}

struct Schedule:Codable{
    var days:[String]? = [String]()
    var time:String? = nil
}

class TVShowCollection:Codable{
    var show:TVShow = TVShow()
}
