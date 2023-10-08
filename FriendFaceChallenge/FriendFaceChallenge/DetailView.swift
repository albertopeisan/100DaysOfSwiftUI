//
//  DetailView.swift
//  FriendFaceChallenge
//
//  Created by Alberto Peinado Santana on 25/8/23.
//

import SwiftUI


struct DetailView: View {
    
    let user: CachedUser
    
    var body: some View {
        List {
            Section {
                Text("Registered: \(user.wrappedRegisteredDate)")
                Text("Age: \(user.age)")
                Text("Email: \(user.wrappedEmail)")
                Text("Address: \(user.wrappedAddress)")
                Text("Works for: \(user.wrappedCompany)")
            } header: {
                Text("Basic Info")
            }
            
            Section {
                ForEach(user.wrappedTags, id: \.self) { tag in
                    Text("\(tag)")
                }
            } header: {
                Text("Tags")
            }
            
            Section {
                Text(user.wrappedAbout)
            } header: {
                Text("About")
            }
            
            Section {
                ForEach(user.friendsArray) { friend in
                    Text(friend.wrappedName)
                }
            } header: {
                Text("Friends")
            }
        }
        .navigationTitle(user.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
