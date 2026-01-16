//
//  AddGroupView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var friends: [Friend]
    @Query private var users: [User]

    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var selectedIcon = "person.3.fill"
    @State private var selectedMembers: Set<String> = []

    let icons = [
        "person.3.fill", "house.fill", "airplane", "cart.fill",
        "fork.knife", "beach.umbrella.fill", "gift.fill", "car.fill",
        "sportscourt.fill", "gamecontroller.fill", "briefcase.fill", "heart.fill"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Group Details") {
                    TextField("Group Name", text: $groupName)

                    TextField("Description (optional)", text: $groupDescription)
                }

                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(icons, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(selectedIcon == icon ? Color.teal.opacity(0.2) : Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundStyle(selectedIcon == icon ? .teal : .primary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Members") {
                    if let currentUser = users.first {
                        MemberToggleRow(name: "\(currentUser.name) (You)", isSelected: true, disabled: true)
                            .onAppear {
                                selectedMembers.insert(currentUser.name)
                            }
                    }

                    ForEach(friends) { friend in
                        MemberToggleRow(
                            name: friend.name,
                            isSelected: selectedMembers.contains(friend.name)
                        ) {
                            if selectedMembers.contains(friend.name) {
                                selectedMembers.remove(friend.name)
                            } else {
                                selectedMembers.insert(friend.name)
                            }
                        }
                    }

                    if friends.isEmpty {
                        Text("No friends added yet. Add friends to include them in groups.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createGroup()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }

    private func createGroup() {
        let group = Group(
            name: groupName,
            description: groupDescription,
            members: Array(selectedMembers),
            iconName: selectedIcon
        )
        modelContext.insert(group)
        dismiss()
    }
}

struct MemberToggleRow: View {
    let name: String
    var isSelected: Bool
    var disabled: Bool = false
    var onToggle: (() -> Void)?

    var body: some View {
        Button {
            if !disabled {
                onToggle?()
            }
        } label: {
            HStack {
                Text(name)
                    .foregroundStyle(disabled ? .secondary : .primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.teal)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.gray)
                }
            }
        }
        .disabled(disabled)
    }
}

#Preview {
    AddGroupView()
        .modelContainer(for: [Group.self, Friend.self, User.self], inMemory: true)
}
