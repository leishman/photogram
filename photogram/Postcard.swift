//
//  Postcard.swift
//  photogram
//
//  Created by Alexander Leishman on 11/28/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import Foundation
import CoreData

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
}
