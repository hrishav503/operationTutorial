//
//  Flight+CoreDataClass.swift
//  OperationTutorial
//
//  Created by Developer on 24/12/21.
//
//

import Foundation
import CoreData

@objc(Flight)
public class Flight: NSManagedObject {
    
    class func getEmployeeRooster(user:User, flightPlanDictionary:Any?, context:NSManagedObjectContext) -> [Flight] {
        
        var flightArray: [Flight] = []
        
        var newflights = [Flight]()
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(Flight.self))
        
//        do {
//            flightArray = try context.fetch(fetchRequest) as! [Flight]
//            print("succesfully fetched")
//        }
//        catch {
//            print(error)
//            print("error in fetching")
//        }
        print("Flights")
        
        var rawFlightPlans = [[String : Any]] ()
        
        if let plans = flightPlanDictionary as? [[String:Any]] {
            rawFlightPlans = plans
        } else if let plan = flightPlanDictionary as? Dictionary<String,Any> {
            rawFlightPlans = [plan]
        }
        for flightDictionary in rawFlightPlans {
            var flight:Flight?
            
//            if (flightArray.count) > 0 {
//                flight = flightArray.first
//                print("flight first")
//            } else {
//                let entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(Flight.self), in: context)!
//                flight = NSManagedObject(entity: entity, insertInto: context) as? Flight
//                user.addToNewRelationship(flight!)
//            }
            let entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(Flight.self), in: context)!
            flight = (NSManagedObject(entity: entity, insertInto: context) as? Flight)!
           user.addToNewRelationship(flight!)
          //  print("user added to flight")
           
            
            if let flight = flight {
                
                if let aircraftType = flightDictionary["EB_AC_TYPE"] as? String
                {
                    flight.aircraftType = aircraftType;
                }
                
                if let departure = flightDictionary["EB_DEP_PORT"] as? String {
                    flight.departing = departure
                }
                
                if let destination = flightDictionary["EB_DEST_PORT"] as? String {
                    flight.destination = destination
                }
                
                if let flightNumber = flightDictionary["EB_FLT_NUM"] as? String {
                    flight.flightNumber = flightNumber
                }
                
                if let flightRego = flightDictionary["EB_AC_REG"] as? String {
                    flight.rego = flightRego
                    
                }
                
                if let flightStd = flightDictionary["EB_RC_STD_UTC"] as? String {
                    flight.std = flightStd
                }
                
            }
            newflights.append(flight!)
          
        }
        
        
        return newflights
        
    }
}
