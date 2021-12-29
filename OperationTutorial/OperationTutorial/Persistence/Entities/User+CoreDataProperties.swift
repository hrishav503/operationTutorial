//
//  User+CoreDataProperties.swift
//  OperationTutorial
//
//  Created by Developer on 23/12/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var crewNum: String?
    @NSManaged public var crewBase: String?
    @NSManaged public var crewQualification: String?
    @NSManaged public var crewCat: String?
    @NSManaged public var crewRank: String?
    @NSManaged public var crewType: String?
    @NSManaged public var newRelationship: NSSet?
    @NSManaged public var flights: NSSet?

}

// MARK: Generated accessors for newRelationship
extension User {

    @objc(addNewRelationshipObject:)
    @NSManaged public func addToNewRelationship(_ value: Flight)

    @objc(removeNewRelationshipObject:)
    @NSManaged public func removeFromNewRelationship(_ value: Flight)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: Flight)
    
    @objc(removeFlights:)
    @NSManaged public func removeFromFlight(_ value: Flight)
    
    @objc(addNewRelationship:)
    @NSManaged public func addToNewRelationship(_ values: NSSet)
    
    @objc(removeNewRelationship:)
    @NSManaged public func removeFromNewRelationship(_ values: NSSet)

}

extension User : Identifiable {

}
