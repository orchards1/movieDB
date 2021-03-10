//
//  DetailTableViewCell.swift
//  KitabisaTestingMovieDB
//
//  Created by Michael Louis on 10/03/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var ReviewContent: UITextView!
    @IBOutlet var ReviewerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
