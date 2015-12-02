//
//  Postcard+CoreDataProperties.swift
//  photogram
//
//  Created by Alexander Leishman on 12/1/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Postcard {

    @NSManaged var message: String?
    @NSManaged var photo_url: String?
    @NSManaged var address: Address?
    @NSManaged var created_at: NSDate
}
