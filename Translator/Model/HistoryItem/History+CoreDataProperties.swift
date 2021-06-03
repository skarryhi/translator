//
//  History+CoreDataProperties.swift
//  Translator
//
//  Created by Saturn Karry on 6/2/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var source: String?
    @NSManaged public var result: String?

}
