//
//  ProfileViewModel.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//
import Foundation
import Combine
import CoreData
import SwiftUI

enum MatchStatus: String {
    case pending
    case accepted
    case declined
}

final class ProfileCardViewModel: ObservableObject, Identifiable {
    
    private let coreDataHelper: ProfileCoreDataHelping
    private let profileId: String
    
    // Published properties for UI binding
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var age: Int
    @Published var city: String
    @Published var pictureURL: URL?
    @Published var status: MatchStatus
    
    init(profile: Profile, coreDataHelper: ProfileCoreDataHelping = ProfileCoreDataHelper()) {
        self.coreDataHelper = coreDataHelper
        self.profileId = profile.id ?? UUID().uuidString
        self.firstName = profile.firstName ?? ""
        self.lastName = profile.lastName ?? ""
        self.email = profile.email ?? ""
        self.age = Int(profile.age)
        self.city = profile.city ?? ""
        self.pictureURL = URL(string: profile.pictureURL ?? "")
        self.status = MatchStatus(rawValue: profile.status ?? "") ?? .pending
    }
    
    // MARK: - User Actions
    
    func acceptProfile() {
        updateStatus(.accepted)
    }
    
    func declineProfile() {
        updateStatus(.declined)
    }
    
    // MARK: - Private Helpers
    
    func updateStatus(_ newStatus: MatchStatus) {
        coreDataHelper.updateStatus(for: profileId, to: newStatus)
        DispatchQueue.main.async {
            self.status = newStatus
        }
    }
    
    // MARK: - Computed Properties
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var ageAndCity: String {
        "\(age) • \(city)"
    }
}
