//
//  ContentView.swift
//  MatchMate
//
//  Created by Mohammad Talha on 27/09/25.
//

import SwiftUI
import CoreData

struct LandingView: View {
    @StateObject private var vm = LandingProfileViewModelWrapper()
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.profiles.isEmpty {
                    VStack(spacing: 16) {
                        if vm.isLoading {
                            ProgressView("Loading profiles...")
                        } else {
                            Text("No profiles available")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Button("Fetch Profiles") {
                                vm.refreshFromNetwork()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                } else {
                    List {
                        ForEach(vm.profiles) { profileVM in
                            ProfileCardView(vm: profileVM)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("MatchMate")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.refreshFromNetwork()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .overlay {
                if let error = vm.errorMessage {
                    VStack {
                        Spacer()
                        Text("⚠️ \(error)")
                            .font(.caption)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(8)
                        Spacer().frame(height: 50)
                    }
                    .transition(.opacity)
                }
            }
        }
    }
}
