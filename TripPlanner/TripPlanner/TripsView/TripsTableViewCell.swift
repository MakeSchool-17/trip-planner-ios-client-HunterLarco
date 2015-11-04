//
//  TripsViewTableViewCell.swift
//  TripPlanner
//
//  Created by Hunter on 10/30/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation
import UIKit

class TripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        backgroundImage.layer.cornerRadius = 4;
        backgroundImage.clipsToBounds = true;
    }

}
