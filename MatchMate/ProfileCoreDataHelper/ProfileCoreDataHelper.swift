//
//  ProfileCoreDataHelper.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//
import CoreData
import Foundation

protocol ProfileCoreDataHelping {
    func saveProfiles(_ users: [RandomUser])
    func fetchAllProfiles() -> [Profile]
    func fetchProfiles(with status: MatchStatus) -> [Profile]
    func updateStatus(for id: String, to status: MatchStatus)
    func fetchUnsyncedProfiles() -> [Profile]
    func markProfilesSynced(ids: [String])
}

final class ProfileCoreDataHelper: ProfileCoreDataHelping {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    // MARK: - Save Profiles from API
    func saveProfiles(_ users: [RandomUser]) {
        context.perform {
            for user in users {
                let fetchReq = Profile.fetchRequest() as! NSFetchRequest<Profile>
                fetchReq.predicate = NSPredicate(format: "id == %@", user.login.uuid)
                fetchReq.fetchLimit = 1
                
                if let existing = try? self.context.fetch(fetchReq).first {
                    // Update existing profile
                    existing.firstName = user.name.first
                    existing.lastName = user.name.last
                    existing.email = user.email
                    existing.age = Int16(user.dob.age)
                    existing.city = user.location.city
                    existing.pictureURL = user.picture.large
                    existing.updatedAt = Date()
                } else {
                    // Insert new profile
                    let newProfile = Profile(context: self.context)
                    newProfile.id = user.login.uuid
                    newProfile.firstName = user.name.first
                    newProfile.lastName = user.name.last
                    newProfile.email = user.email
                    newProfile.age = Int16(user.dob.age)
                    newProfile.city = user.location.city
                    newProfile.pictureURL = user.picture.large
                    newProfile.status = MatchStatus.pending.rawValue
                    newProfile.isSynced = false
                    newProfile.updatedAt = Date()
                }
            }
            self.saveContext()
        }
    }
    
    // MARK: - Fetch All Profiles
    func fetchAllProfiles() -> [Profile] {
        let request = Profile.fetchRequest() as! NSFetchRequest<Profile>
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Fetch Profiles by Status
    func fetchProfiles(with status: MatchStatus) -> [Profile] {
        let request = Profile.fetchRequest() as! NSFetchRequest<Profile>
        request.predicate = NSPredicate(format: "status == %@", status.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Update Status (Accept/Decline)
    func updateStatus(for id: String, to status: MatchStatus) {
        context.perform {
            let request = Profile.fetchRequest() as! NSFetchRequest<Profile>
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            if let profile = try? self.context.fetch(request).first {
                profile.status = status.rawValue
                profile.isSynced = false
                profile.updatedAt = Date()
                self.saveContext()
            }
        }
    }
    
    // MARK: - Fetch Unsynced Profiles
    func fetchUnsyncedProfiles() -> [Profile] {
        let request = Profile.fetchRequest() as! NSFetchRequest<Profile>
        request.predicate = NSPredicate(format: "isSynced == NO")
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Mark Profiles as Synced
    func markProfilesSynced(ids: [String]) {
        context.perform {
            let request = Profile.fetchRequest() as! NSFetchRequest<Profile>
            request.predicate = NSPredicate(format: "id IN %@", ids)
            if let profiles = try? self.context.fetch(request) {
                for p in profiles {
                    p.isSynced = true
                    p.updatedAt = Date()
                }
                self.saveContext()
            }
        }
    }
    
    // MARK: - Private Save Helper
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData Save Error: \(error.localizedDescription)")
            }
        }
    }
}
