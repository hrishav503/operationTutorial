//
//  User+CoreDataClass.swift
//  OperationTutorial
//
//  Created by Developer on 23/12/21.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
        
    class func insertOrUpdateUser(username:String, password:String, userDictionary:Dictionary<String, Any>?, context:NSManagedObjectContext) -> User? {
        
        var user:User?
        
        let entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(User.self), in: context)!
        user = NSManagedObject(entity: entity, insertInto: context) as? User
        
        if let user = user {
            
            if let crewBaseString = userDictionary?["CREWBASE"] as? String {
                user.crewBase = crewBaseString
            }
            if let crewCategoryString = userDictionary?["EB_CW_CAT"] as? String {
                user.crewCat = crewCategoryString
            }
            
            if let crewNumberString = userDictionary?["EB_CW_NUM"] as? String {
                user.crewNum = crewNumberString
            }
            
            if let crewQualificationString = userDictionary?["CREWQUAL"] as? String {
                user.crewQualification = crewQualificationString
            }
            
            if let crewRankString = userDictionary?["CREWRANK"] as? String {
                user.crewRank = crewRankString
            }
            
            if let crewTypeString = userDictionary?["CREWTYPE"] as? String {
                user.crewType = crewTypeString
            }
            
            if let crewFirstName = userDictionary?["EB_CW_FIRST_NAME"] as? String {
                user.firstName = crewFirstName
            }
            
            if let crewLastName = userDictionary?["EB_CW_LAST_NAME"] as? String {
                user.lastName = crewLastName
            }
        }
        
        return user
    }
}
