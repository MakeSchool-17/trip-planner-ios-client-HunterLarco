//
//  TripsViewController.swift
//  TripPlanner
//
//  Created by Hunter on 11/4/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tripsView: TripsView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tripsView.delegate = self
    }
    
}

extension TripsViewController: TripsViewDelegate {
    
    func doViewTrip(trip: TripModel) {
        self.performSegueWithIdentifier("showTableCellSeque", sender: self)
    }
    
}
