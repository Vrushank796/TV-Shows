//
//  ViewTVShowTableViewController.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-07.
//

import UIKit

class ViewTVShowTableViewController: UITableViewController,UISearchBarDelegate{
    
    //showResult array would have all tv shows details
    var showResult:[TVShow] = [TVShow]()
    
    //showSearchedResult array would have all searched tv shows details
    var showSearchedResult:[TVShowCollection] = [TVShowCollection]()
    
    //searching variable to check if user is searching or not
    var searching:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user is not searching get all tv shows details
        if(searching == 0){
            getTVShows()
        }
        tableView.reloadData()
    }
    
    //To get all TV show details
    func getTVShows() {
        
        //Networking service method would be called to get all tv show details
        NetworkingService.Shared.getTVShowDataFromURL() { result in
            switch result {
            case .success(let tvShowCollection) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store TV show collection array to showResult array and reload the table
                    self.showResult = tvShowCollection
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //To get all searched TV show details
    func getSearchedTVShows(name:String)  {
        //Networking service method would be called to get all searched tv show details
        NetworkingService.Shared.getSearchedTVShowDataFromURL(tvShowName: name) { result in
            switch result {
            case .success(let tvShowCollection) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store TV show collection array to showSearchedResult array and reload the table
                    self.showSearchedResult = tvShowCollection
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //If user interact with search bar and enter text to search then this method would be called
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Filter the searchText by adding percentage encoding
        let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //if user search tv shows then call getSearchedTVShows method to get the searched TV shows details else it will get all TV shows details
        if searchText!.count == 0{
            searching = 0
            getTVShows()
            
        }else{
            searching = 1
            getSearchedTVShows(name:searchText!)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searching == 0){
            return showResult.count
        }
        else{
            return showSearchedResult.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 81
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvShow", for: indexPath) as! TVShowTableViewCell
        
        if(searching == 0){
            
            let showName : String? = showResult[indexPath.row].name
            
            var showGenres:String? = "-"
            
            if (!showResult[indexPath.row].genres!.isEmpty){
                showGenres = showResult[indexPath.row].genres!.joined(separator:",")
            }else{
                showGenres = "-"
            }
            
            let rating = showResult[indexPath.row].rating?.average
            
            if(rating != nil){
                cell.ratings?.text = "\(rating!)"
            }else{
                cell.ratings?.text = "-"
            }
            
            let imageURL = showResult[indexPath.row].image?.original
            
            // Configure the cell...
            cell.showName?.text = showName ?? "-"
            cell.genres?.text = showGenres
            
            if(imageURL != nil){
                NetworkingService.Shared.getImage(url:imageURL!)
                {
                    result in
                    switch result{
                    case .success(let imageFromURL):
                        DispatchQueue.main.async{
                            cell.tvShowImage.image = imageFromURL
                        }
                        break
                    case .failure(_):
                        break
                    }
                    
                }
            }else{
                cell.tvShowImage.image = UIImage(systemName:"photo")
            }
        }
        else{
            
            let showName: String? = showSearchedResult[indexPath.row].show.name
            var showGenres:String? = "-"
            
            if (!showSearchedResult[indexPath.row].show.genres!.isEmpty){
                showGenres = showSearchedResult[indexPath.row].show.genres!.joined(separator:",")
            }else{
                showGenres = "-"
            }
            
            let rating = showSearchedResult[indexPath.row].show.rating?.average
            
            if(rating != nil){
                cell.ratings?.text = "\(rating!)"
            }else{
                cell.ratings?.text = "-"
            }
            let imageURL = showSearchedResult[indexPath.row].show.image?.original
            
            // Configure the cell...
            cell.showName?.text = showName ?? "-"
            cell.genres?.text = showGenres
            if(imageURL != nil){
                NetworkingService.Shared.getImage(url:imageURL!)
                {
                    result in
                    switch result{
                    case .success(let imageFromURL):
                        DispatchQueue.main.async{
                            cell.tvShowImage.image = imageFromURL
                        }
                        break
                    case .failure(_):
                        break
                    }
                    
                }
            }else{
                cell.tvShowImage.image = UIImage(systemName:"photo")
            }
        }
        return cell
    }
    
    //prepare before going to the TV show detail view and send the TV show details for selected row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toTVShowDetail"){
            let showVC = segue.destination as! TVShowDetailViewController
            if searching == 0 {
                showVC.showDetails = showResult[tableView.indexPathForSelectedRow!.row]
                
            }else{
                showVC.showDetails = showSearchedResult[tableView.indexPathForSelectedRow!.row].show
            }
        }
    }
}
