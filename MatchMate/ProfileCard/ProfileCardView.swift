//
//  ProfileCardView.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//
import SwiftUI
import SDWebImageSwiftUI

struct ProfileCardView: View {
    @ObservedObject var vm: ProfileCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                WebImage(url: vm.pictureURL, content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }, placeholder: {
                    ProgressView()
                })
                    
                
                VStack(alignment: .leading) {
                    Text(vm.fullName).font(.headline)
                    Text(vm.ageAndCity).font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
                if vm.status != .pending {
                    Text(vm.status.rawValue.capitalized)
                        .font(.caption)
                        .padding(6)
                        .background(vm.status == .accepted ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .cornerRadius(8)
                }
            }

            HStack {
                Button("Accept") { vm.acceptProfile() }
                    .buttonStyle(.borderedProminent)
                Button("Decline") { vm.declineProfile() }
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}
