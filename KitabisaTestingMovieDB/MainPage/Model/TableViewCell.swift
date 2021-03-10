//
//  HomeTableViewCell.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 09/03/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
override func prepareForReuse() {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
