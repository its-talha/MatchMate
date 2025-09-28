//
//  ProfileViewModelWrapper.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//

import Foundation
import CoreData
import Combine

final class ProfileViewModelWrapper: ObservableObject {
    @Published var profiles: [ProfileViewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let coreDataHelper: ProfileCoreDataHelping
    
    init(coreDataHelper: ProfileCoreDataHelping = ProfileCoreDataHelper()) {
        self.coreDataHelper = coreDataHelper
        loadProfiles()
    }
    
    func loadProfiles() {
        let fetchedProfiles = coreDataHelper.fetchAllProfiles()
        profiles = fetchedProfiles.map { ProfileViewModel(profile: $0, coreDataHelper: coreDataHelper) }
    }
    
    func refreshFromNetwork() {
        isLoading = true
        errorMessage = nil
        
        NetworkManager.shared.fetchProfiles { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let users):
                    self?.coreDataHelper.saveProfiles(users)
                    self?.loadProfiles()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
