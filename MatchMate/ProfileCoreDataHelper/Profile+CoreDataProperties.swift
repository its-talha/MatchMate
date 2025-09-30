//
//  Profile+CoreDataProperties.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//

import CoreData
import Foundation

extension Profile {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }
    
    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var city: String?
    @NSManaged public var pictureURL: String?
    @NSManaged public var status: String?
    @NSManaged public var isSynced: Bool
    @NSManaged public var updatedAt: Date?
    @NSManaged public var id: String?
}

