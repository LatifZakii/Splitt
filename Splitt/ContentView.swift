//
//  ContentView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var currentUser: [User]
    @State private var showingOnboarding = false

    var body: some View {
        if currentUser.isEmpty || currentUser.first?.name.isEmpty == true {
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            GroupsView()
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }

            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }

            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "clock.fill")
                }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
        }
        .tint(.teal)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Group.self, Expense.self, Friend.self, Settlement.self], inMemory: true)
}
