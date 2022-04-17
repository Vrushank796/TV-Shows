//
//  CoreDataService.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-07.
//


import Foundation
import CoreData

class CoreDataService{
    static var Shared = CoreDataService()
    
    //Insert Favourite TV Show details to CoreData storage
    func insertFavTVShowIntoCoreData(showName:String,ratings:Float,premieredNetwork: String,schedule:String,premieredDate:String,genres:String,language:String,status:String,summary:String,imgUrl:String) -> Int{
        
        //Check if favourite tv show is not already in storage then add it, save context and return 1, otherwise return 0
        let checkShow = checkFavTVShowInStorage(showName: showName, genres: genres, ratings: ratings, imgUrl: imgUrl)
        if(!checkShow){
            let newTVshow = FavTVShow(context: persistentContainer.viewContext)
            newTVshow.showName = showName
            newTVshow.ratings = ratings
            newTVshow.premieredNetwork = premieredNetwork
            newTVshow.schedule = schedule
            newTVshow.premieredDate = premieredDate
            newTVshow.genres = genres
            newTVshow.language = language
            newTVshow.status = status
            newTVshow.summary = summary
            newTVshow.imgURL = imgUrl
            
            saveContext()
            return 1
        }else{
            return 0
        }
    }
    
    //Get all favourite TV show from storage to display it in table cell
    func getAllFavTVShowsFromStorage() -> [FavTVShow]{
        var result = [FavTVShow]()
        
        let fetchTVShowDetails = NSFetchRequest<NSFetchRequestResult>(entityName: "FavTVShow")
        do{
            result = try
            persistentContainer.viewContext.fetch(fetchTVShowDetails) as! [FavTVShow]
        }catch{
            print(error)
        }
        return result
    }
    
    //Check if show is already in storage or not
    func checkFavTVShowInStorage(showName:String, genres:String, ratings:Float,imgUrl:String) -> Bool{
        var result = [FavTVShow]()
        var showExist = 0
        let fetchTVShowDetails = NSFetchRequest<NSFetchRequestResult>(entityName: "FavTVShow")
        do{
            result = try
            persistentContainer.viewContext.fetch(fetchTVShowDetails) as! [FavTVShow]
        }catch{
            print(error)
        }
        
        //if show exist set variable to 1 otherwise 0
        for show in result{
            if(show.showName == showName && show.genres==genres && show.ratings == ratings && show.imgURL == imgUrl){
                showExist = 1
                break
            }else{
                showExist = 0
            }
        }
        
        //if showExist return true else false
        if(showExist == 1){
            return true
        }else{
            return false
        }
    }
    
    //Delete favourite TV show from CoreData storage
    func deleteFavTVShow(toDeleteFavShow: FavTVShow){
        persistentContainer.viewContext.delete(toDeleteFavShow)
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TV_Shows")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

