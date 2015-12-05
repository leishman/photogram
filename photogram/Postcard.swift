//
//  Postcard.swift
//  photogram
//
//  Created by Alexander Leishman on 11/28/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import Foundation
import CoreData
import Contacts
import UIKit

class Postcard: NSManagedObject {
    class func createWithImageUrl(url: String, inManagedContext context: NSManagedObjectContext, callback: (Postcard)->Void) -> Postcard? {
        // store postcard in DB
        print("storing postcard")
        if let p = NSEntityDescription.insertNewObjectForEntityForName("Postcard", inManagedObjectContext: context) as? Postcard {
            p.created_at = NSDate()
            p.photo_url = url
            callback(p)
        }
        return nil
    }
    
    class func last(inManagedContext context: NSManagedObjectContext) -> Postcard? {
        
        let request = NSFetchRequest(entityName: "Postcard")
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        request.fetchLimit = 1
        if let p = (try? context.executeFetchRequest(request))?.first as? Postcard {
            return p
        } else {
            return nil
        }
    }
    
    
    
    func updateUrl(url: String, inManagedContext context: NSManagedObjectContext, callback: (Void)->Void) -> Postcard? {
        let request = NSFetchRequest(entityName: "Postcard")
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        request.fetchLimit = 1
        if let p = (try? context.executeFetchRequest(request))?.first as? Postcard {
            p.photo_url = url
            callback()
            return p
        } else {
            return nil
        }
    }
    
    func createOrUpdateAddress(address: CNPostalAddress, inManagedContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "Address")
        request.predicate = NSPredicate(format: "street = %@", address.street)
        if let a = (try? context.executeFetchRequest(request))?.first as? Address {
            self.address = a
        } else {
            if let a = NSEntityDescription.insertNewObjectForEntityForName("Address", inManagedObjectContext: context) as? Address {
                a.state = address.state
                a.street = address.street
                a.country = address.country
                a.city = address.city
                a.postal_code = address.postalCode
                a.postcards = [self]
            }
        }
    }
    
    // fetch all postcards in DB
    class func all(inManagedContext context: NSManagedObjectContext, callback: ([Postcard]) -> Void) -> [Postcard] {
        let request = NSFetchRequest(entityName: "Postcard")
        if let ps = (try? context.executeFetchRequest(request)) as? [Postcard] {
            callback(ps)
            return ps
        } else {
            callback([])
            return []
        }
    }
    
    func getUIImage() -> UIImage? {
        if let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString? {
            
            let fileManager = NSFileManager.defaultManager()
            let url = paths.stringByAppendingPathComponent(self.photo_url!)
            if(fileManager.fileExistsAtPath(url)) {
                return UIImage(contentsOfFile: url)
            }
        }
        return nil
    }
}
