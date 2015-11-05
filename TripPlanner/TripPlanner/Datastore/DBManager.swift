//
//  DBManager.swift
//  TripPlanner
//
//  Created by Hunter on 11/3/15.
//  Copyright © 2015 larcolabs. All rights reserved.
//

import UIKit
import CoreData

class DBManager {
    
    class func save(trip: TripModel){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Trip", inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(trip.author.basicAuth.getAuthString(), forKey: "userAuthString")
        person.setValue(trip.name, forKey: "name")
        person.setValue(trip.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func getTrips(author: UserModel) -> [TripModel] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            var trips = [TripModel]()
            
            for result in results{
                let id = result.valueForKey("id") as! String
                let name = result.valueForKey("name") as! String
                let authorAuthString = result.valueForKey("userAuthString") as! String
                
                if authorAuthString != author.basicAuth.getAuthString() {
                    continue
                }
                
                let author = UserModel(basicAuth: BasicAuthString(authString: authorAuthString))
                trips.append(TripModel(id: id, name: name, author: author))
            }
            
            return trips
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    class func clearTrips() {
        return clearEntityGroup("Trip")
    }
    
    private class func clearEntityGroup(entityName: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            for item in results {
                managedContext.deleteObject(item as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Deletion error: \(error)")
        }
    }
    
}