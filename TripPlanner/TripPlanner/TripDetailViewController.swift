//
//  TripDetailViewController.swift
//  TripPlanner
//
//  Created by Hunter on 10/28/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    @IBOutlet weak var tripForm: TripView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tripForm.delegate = self
    }
    
}

extension TripDetailViewController: TripViewDelegate {
    
    func formSubmitted(tripView: TripView, text: String) {
        let result = 2 === 2
        print(result)
    }

}
