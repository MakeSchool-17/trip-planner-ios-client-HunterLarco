//
//  ManagedTripModel.swift
//  TripPlanner
//
//  Created by Hunter on 11/4/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import Foundation
import UIKit

class ManagedTripModel {
    
    class func getTripsFromCoreData(author: UserModel) -> [TripModel] {
        return DBManager.getTrips(author)
    }
    
    class func getTripsFromCoreData(onSuccess: (trips: [TripModel]) -> Void, author: UserModel){
        onSuccess(trips: getTripsFromCoreData(author))
    }
    
    class func getTripsFromServer(
        onSuccess: (trips: [TripModel]) -> Void,
        onUnknownError: () -> Void,
        author: UserModel
    ) {
        TripModel.getTrips(
            {(trips) -> Void in
                DBManager.clearTrips()
                for trip in trips {
                    DBManager.save(trip)
                }
                onSuccess(trips: trips)
            },
            onUnknownError: onUnknownError,
            author: author
        )
    }
    
    class func create(
        onSuccess: (trip: TripModel) -> Void,
        onUnknownError: () -> Void,
        author: UserModel,
        name: String
    ) {
        TripModel.create(
            {(trip) -> Void in
                DBManager.save(trip)
                onSuccess(trip: trip)
            },
            onUnknownError: onUnknownError,
            author: author,
            name: name
        )
    }
    
}