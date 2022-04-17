//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Vrushank on 2022-04-08.
//

import UIKit

//protocol CustomCellDelegate{
//    func addToFav(_ cell: TVShowTableViewCell, didTap button: UIButton)
//}

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tvShowImage : UIImageView!
    @IBOutlet weak var showName : UILabel!
    @IBOutlet weak var genres : UILabel!
    @IBOutlet weak var ratings : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
