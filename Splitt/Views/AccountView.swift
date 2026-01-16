//
//  AccountView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Query private var expenses: [Expense]
    @Query private var settlements: [Settlement]
    @Query private var groups: [Group]
    @Query private var friends: [Friend]
    @State private var showingEditProfile = false

    var currentUser: User? {
        users.first
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            List {
                if let user = currentUser {
                    Section {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: user.avatarColor))
                                    .frame(width: 70, height: 70)

                                Text(user.initials)
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.title2)
                                    .fontWeight(.bold)

                                if !user.email.isEmpty {
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                if !user.phoneNumber.isEmpty {
                                    Text(user.phoneNumber)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            Button {
                                showingEditProfile = true
                            } label: {
                                Text("Edit")
                                    .font(.subheadline)
                                    .foregroundStyle(.teal)
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Section("Statistics") {
                        StatRow(label: "Total Groups", value: "\(groups.count)")
                        StatRow(label: "Total Friends", value: "\(friends.count)")
                        StatRow(label: "Total Expenses", value: "$\(totalExpenses, specifier: "%.2f")")
                        StatRow(label: "Transactions", value: "\(expenses.count + settlements.count)")
                    }
                }

                Section("App Info") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("About")
                        Spacer()
                        Text("Splitwise Clone")
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        // Reset app data
                    } label: {
                        Text("Clear All Data")
                    }
                }
            }
            .navigationTitle("Account")
            .sheet(isPresented: $showingEditProfile) {
                if let user = currentUser {
                    EditProfileView(user: user)
                }
            }
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var user: User

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Name", text: $user.name)
                        .textContentType(.name)

                    TextField("Email", text: $user.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    TextField("Phone", text: $user.phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AccountView()
        .modelContainer(for: [User.self, Group.self, Friend.self, Expense.self, Settlement.self], inMemory: true)
}
