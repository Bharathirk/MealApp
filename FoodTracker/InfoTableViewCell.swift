//
//  InfoTableViewCell.swift
//  FoodTracker
//
//  Created by Raja Bharathi on 2019/10/29.
//  Copyright © 2019 Raja Bharathi. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var foodRating: RatingControl!
    @IBOutlet weak var foodLableName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    static let cellName = "InfoTableViewCell"
    static let cellNib = UINib(nibName: "InfoTableViewCell", bundle: Bundle.main)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
