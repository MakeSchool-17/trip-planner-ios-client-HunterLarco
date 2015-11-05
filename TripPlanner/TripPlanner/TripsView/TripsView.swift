//
//  TripsView.swift
//  TripPlanner
//
//  Created by Hunter on 10/29/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit


class TripsView: UIView {
    
    var delegate: TripsViewDelegate?
    
    var view: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TripsView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellnib = UINib(nibName: "TripsTableViewCell", bundle: bundle)
        tableView.registerNib(cellnib, forCellReuseIdentifier: textCellIdentifier)
        
        return view
    }
    
    func updateTripsFromCoreData() {
        let currentUser = ManagedUserModel.getCurrentUser()!.user
        self.trips = ManagedTripModel.getTripsFromCoreData(currentUser)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func updateTripsFromServer(){
        let currentUser = ManagedUserModel.getCurrentUser()!.user
        ManagedTripModel.getTripsFromServer(onSuccess, onUnknownError: onUnknownError, author: currentUser)
    }
    
    func onSuccess(trips: [TripModel]){
        self.trips = trips
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func onUnknownError(){
        
    }
    
    var trips = [TripModel]()
    let textCellIdentifier = "TextCell"
}

extension TripsView: UITableViewDelegate {
    
}

extension TripsView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! TripsTableViewCell
        
        let row = indexPath.row
        cell.label.text = trips[row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
//        delegate?.doViewTrip(TripModel())
    }
    
}

protocol TripsViewDelegate {
    
    func doViewTrip(trip: TripModel)
    
}