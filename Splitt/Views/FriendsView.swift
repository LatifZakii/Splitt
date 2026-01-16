//
//  FriendsView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var friends: [Friend]
    @Query private var expenses: [Expense]
    @Query private var settlements: [Settlement]
    @Query private var users: [User]
    @State private var showingAddFriend = false

    var friendBalances: [String: Double] {
        var balances: [String: Double] = [:]

        // Calculate from all expenses
        for expense in expenses {
            let payer = expense.paidBy
            for (participant, amount) in expense.splitDetails {
                if participant != payer {
                    // participant owes payer
                    let key = "\(participant)-\(payer)"
                    balances[key, default: 0] += amount
                }
            }
        }

        // Subtract settlements
        for settlement in settlements {
            let key = "\(settlement.payer)-\(settlement.recipient)"
            balances[key, default: 0] -= settlement.amount
        }

        return balances
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if friends.isEmpty {
                    EmptyStateView(
                        icon: "person.2.fill",
                        title: "No Friends Yet",
                        message: "Add friends to split expenses with them"
                    )
                } else {
                    List {
                        ForEach(friends) { friend in
                            FriendRowView(friend: friend, balance: getBalance(for: friend))
                        }
                        .onDelete(perform: deleteFriends)
                    }
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddFriend = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddFriend) {
                AddFriendView()
            }
        }
    }

    private func getBalance(for friend: Friend) -> Double {
        guard let currentUser = users.first else { return 0 }

        let owedToUser = friendBalances["\(friend.name)-\(currentUser.name)"] ?? 0
        let owedByUser = friendBalances["\(currentUser.name)-\(friend.name)"] ?? 0

        return owedToUser - owedByUser
    }

    private func deleteFriends(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(friends[index])
        }
    }
}

struct FriendRowView: View {
    let friend: Friend
    let balance: Double

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: friend.avatarColor))
                    .frame(width: 50, height: 50)

                Text(friend.initials)
                    .foregroundStyle(.white)
                    .font(.headline)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.headline)

                if balance != 0 {
                    if balance > 0 {
                        Text("owes you $\(balance, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Text("you owe $\(abs(balance), specifier: "%.2f")")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                } else {
                    Text("settled up")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AddFriendView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [User]

    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Friend Details") {
                    TextField("Name", text: $name)
                        .textContentType(.name)

                    TextField("Email (optional)", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    TextField("Phone (optional)", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addFriend()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func addFriend() {
        let friend = Friend(name: name, email: email, phoneNumber: phoneNumber)
        if let user = users.first {
            friend.user = user
        }
        modelContext.insert(friend)
        dismiss()
    }
}

#Preview {
    FriendsView()
        .modelContainer(for: [Friend.self, User.self, Expense.self, Settlement.self], inMemory: true)
}
