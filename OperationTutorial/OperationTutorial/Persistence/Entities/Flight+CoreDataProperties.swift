//
//  Flight+CoreDataProperties.swift
//  OperationTutorial
//
//  Created by Developer on 24/12/21.
//
//

import Foundation
import CoreData


extension Flight {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }
    
    @NSManaged public var flightNumber: String?
    @NSManaged public var departing: String?
    @NSManaged public var destination: String?
    @NSManaged public var rego: String?
    @NSManaged public var aircraftType: String?
    @NSManaged public var std: String?
    @NSManaged public var user: User?
    
}

extension Flight : Identifiable {
    
}
