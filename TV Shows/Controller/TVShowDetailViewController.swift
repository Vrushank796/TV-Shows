//
//  TVShowDetailViewController.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-08.
//

import UIKit

class TVShowDetailViewController: UIViewController,networkingDelegateProtocol{
    
    var showDetails : TVShow = TVShow()
    
    //Connect required IBOutlets and IBActions
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var premieredNetwork: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var premieredDate: UILabel!
    @IBOutlet weak var status: UILabel!
    
    //Define and initialize the required variables
    var name:String? = "-"
    var rating:Float?
    var showRating:String?
    var networkName:String? = "-"
    var scheduleDetail:String? = "-"
    var airedDate :String? = "-"
    var showGenres:String? = "-"
    var lang:String? = "-"
    var currentStatus:String? = "-"
    var summaryDetail:String? = "-"
    var imageUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate as self
        NetworkingService.Shared.delegate = self
        
        //set the variables to get TV show details
        name = showDetails.name ?? "-"
        rating = showDetails.rating?.average ?? 0
        if (rating != 0){
            showRating = "\(rating!)"
        }else{
            showRating = "-"
        }
        networkName = showDetails.network?.name ?? "-"
        scheduleDetail = "\(showDetails.schedule!.days!.joined(separator:",")) - \(showDetails.schedule!.time!)"
        airedDate = showDetails.premiered ?? "-"
        
        if (!showDetails.genres!.isEmpty){
            showGenres = showDetails.genres!.joined(separator:",")
        }else{
            showGenres = "-"
        }
        
        lang = showDetails.language ?? "-"
        currentStatus = showDetails.status ?? "-"
        summaryDetail = showDetails.summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? "-"
        imageUrl = showDetails.image?.original!
        
        
        showName.text = name ?? "-"
        ratings.text = "Ratings: \(showRating!)"
        genres.text = "Genres: \(showGenres!)"
        premieredNetwork.text = "Airs On: \(networkName!)"
        language.text = "Language: \(lang!)"
        schedule.text = "Schedule: \(scheduleDetail!)"
        premieredDate.text = "Premiered On: \(airedDate!)"
        status.text = "Status: \(currentStatus!)"
        summary.text = "\(summaryDetail!)"
        
        if(imageUrl != nil){
            NetworkingService.Shared.getShowImage(url:(imageUrl)!)
        }else{
            imageUrl = "nil"
            showImage.image = UIImage(systemName:"photo")
        }
    }
    
    //Add TV Show to favourite TV show list using CoreData storage
    @IBAction func addToFav(_ sender: Any) {
        let alert = UIAlertController.init(title:"Are You Sure?" , message: "Do you want to add this show to favourite?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:"Save",style:.default,handler:{ [self]
            action in
            
            let check = CoreDataService.Shared.insertFavTVShowIntoCoreData(showName:name!,ratings:rating!,premieredNetwork:networkName!,schedule:scheduleDetail!,premieredDate:airedDate!,genres:showGenres!,language:lang!,status:currentStatus!,summary:summaryDetail!,imgUrl:imageUrl!)
            
            if(check == 1){
                let successAlert = UIAlertController.init(title:"Successfully Added", message: "Added show to the favourite TV show list", preferredStyle: .alert)
                
                successAlert.addAction(UIAlertAction(title:"OK", style: .default))
                
                present(successAlert,animated: true)
            }
            else{
                let failureAlert = UIAlertController.init(title:"Already Added" , message: "Show already exist in the favourite TV show list", preferredStyle: .alert)
                
                failureAlert.addAction(UIAlertAction(title:"OK", style: .default))
                
                present(failureAlert,animated: true)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel",style:.cancel,handler:nil))
        
        present(alert,animated: true)
    }
    
    //Delegate methods to get correctly downloaded image and set TV show image
    func imageDownloadedCorrectly(image: UIImage) {
        DispatchQueue.main.async {
            self.showImage!.image = image
        }
    }
    
    func imageDidNotDownloadedCorrectly() {
        
    }
}
