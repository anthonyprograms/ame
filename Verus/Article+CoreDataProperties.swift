//
//  Article+CoreDataProperties.swift
//  Verus
//
//  Created by Anthony Williams on 7/23/16.
//  Copyright © 2016 Verus. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Article {

    @NSManaged var link: String?
    @NSManaged var rating: NSNumber?

}
