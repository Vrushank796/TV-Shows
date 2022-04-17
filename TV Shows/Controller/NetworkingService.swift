//
//  NetworkingService.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-07.
//

import Foundation
import UIKit

//Created delegate protocol to fetch and download image correcly
protocol networkingDelegateProtocol {
    func imageDownloadedCorrectly(image : UIImage)
    func imageDidNotDownloadedCorrectly()
}

class NetworkingService{
    var delegate : networkingDelegateProtocol?
    static var Shared = NetworkingService()
    
    //get TV show details from API using completion handler
    func getTVShowDataFromURL(completionHandler : @escaping (Result <[TVShow], Error>)->Void ){
        
        let url = "https://api.tvmaze.com/shows"
        let urlObj = URL(string:url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        {
            data,response,error in
            guard error == nil else{
                completionHandler(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
                print("Incorrect response")
                return
            }
            if let jsonData = data{
                print(jsonData)
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode([TVShow].self,from:jsonData)
                    
                    completionHandler(.success(result))
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //get searched TV show details using completion handler
    func getSearchedTVShowDataFromURL(tvShowName:String,completionHandler : @escaping (Result <[TVShowCollection], Error>)->Void ){
        
        let url = "https://api.tvmaze.com/search/shows?q=\(tvShowName)"
        let urlObj = URL(string:url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        {
            data,response,error in
            guard error == nil else{
                completionHandler(.failure(error!))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
                print("Incorrect response")
                //                completionHandler(.failure(error!))
                return
            }
            if let jsonData = data{
                print(jsonData)
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode([TVShowCollection].self,from:jsonData)
                    
                    completionHandler(.success(result))
                }
                catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //getImage using completion handler
    func getImage(url:String, completionHandler : @escaping (Result <UIImage, Error>)->Void ){
        let urlObj = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        { data, response, error in
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }
            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                print ("Incorrect response ")
                return
            }
            
            if let imageData = data {
                let image = UIImage(data:imageData)
                completionHandler(.success(image!))
            }
        }
        task.resume()
    }
    
    //getShowImage using delegate protocol
    func getShowImage(url:String){
        let urlObj = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: urlObj)
        { data, response, error in
            guard error == nil else {
                self.delegate?.imageDidNotDownloadedCorrectly()
                return
            }
            guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                print ("Incorrect response ")
                return
            }
            
            if let imageData = data {
                let image = UIImage(data:imageData)
                self.delegate?.imageDownloadedCorrectly(image:image!)
            }
        }
        task.resume()
    }
}
