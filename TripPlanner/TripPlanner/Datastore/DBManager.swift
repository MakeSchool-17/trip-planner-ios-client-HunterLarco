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
    
    class func save(user: UserModel){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(user.basicAuth.getAuthString(), forKey: "authstring")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    class func getUsers() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    
    
}