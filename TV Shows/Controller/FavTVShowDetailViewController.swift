//
//  FavTVShowDetailViewController.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-15.
//

import UIKit

class FavTVShowDetailViewController: UIViewController,networkingDelegateProtocol {
    
    var showDetails : FavTVShow = FavTVShow()
    
    //Connect required IBOutlets and IBActions
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var premieredNetwork: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var premieredDate: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.Shared.delegate = self
        
        //set the label text to display TV show details
        showName.text = showDetails.showName
        
        if(showDetails.ratings != 0){
            ratings.text = "Ratings: \(showDetails.ratings)"
        }else{
            ratings.text = "Ratings: -"
        }
        premieredNetwork.text = "Airs On: \(showDetails.premieredNetwork!)"
        schedule.text = "Schedule: \(showDetails.schedule!)"
        premieredDate.text = "Premiered On: \(showDetails.premieredDate!)"
        genres.text = "Genres: \(showDetails.genres!)"
        language.text = "Language: \(showDetails.language!)"
        status.text = "Status: \(showDetails.status!)"
        summary.text = showDetails.summary!
        
        if(showDetails.imgURL != "nil"){
            NetworkingService.Shared.getShowImage(url:(showDetails.imgURL)!)
        }else{
            showImage.image = UIImage(systemName:"photo")
        }
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
