//
//  ViewFavTVShowTableViewController.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-07.
//

import UIKit

class ViewFavTVShowTableViewController: UITableViewController {

    var favTVShows : [FavTVShow] = [FavTVShow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favTVShows = CoreDataService.Shared.getAllFavTVShowsFromStorage()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favTVShows = CoreDataService.Shared.getAllFavTVShowsFromStorage()
        tableView.reloadData()
    }

    func updateTable(){
        favTVShows = CoreDataService.Shared.getAllFavTVShowsFromStorage()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favTVShows.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 81
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favTVShow", for: indexPath) as! TVShowTableViewCell
        
        let showName = favTVShows[indexPath.row].showName
        let genres = favTVShows[indexPath.row].genres
        let ratings = favTVShows[indexPath.row].ratings
        let imageURL = favTVShows[indexPath.row].imgURL
        
        cell.showName?.text = showName
        cell.genres?.text = genres
        if(ratings != 0){
            cell.ratings?.text = "\(ratings)"
        }else{
            cell.ratings?.text = "-"
        }
        if(imageURL != "nil"){
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
       

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            CoreDataService.Shared.deleteFavTVShow(toDeleteFavShow: self.favTVShows[indexPath.row])
            let successAlert = UIAlertController.init(title:"Successfully Deleted", message: "Deleted show from the favourite TV show list", preferredStyle: .alert)
            
            successAlert.addAction(UIAlertAction(title:"OK", style: .default))
                                   
            present(successAlert,animated: true)
            
            self.updateTable()
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toFavTVShowDetail"){
            let showFavVC = segue.destination as! FavTVShowDetailViewController
           
            showFavVC.showDetails = favTVShows[tableView.indexPathForSelectedRow!.row]
             
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
