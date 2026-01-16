//
//  GroupsView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct GroupsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @State private var showingAddGroup = false

    var body: some View {
        NavigationStack {
            ZStack {
                if groups.isEmpty {
                    EmptyStateView(
                        icon: "person.3.fill",
                        title: "No Groups Yet",
                        message: "Create a group to start splitting expenses"
                    )
                } else {
                    List {
                        ForEach(groups) { group in
                            NavigationLink(destination: GroupDetailView(group: group)) {
                                GroupRowView(group: group)
                            }
                        }
                        .onDelete(perform: deleteGroups)
                    }
                }
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView()
            }
        }
    }

    private func deleteGroups(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }
    }
}

struct GroupRowView: View {
    let group: Group

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color(hex: group.avatarColor))
                    .frame(width: 50, height: 50)

                Image(systemName: group.iconName)
                    .foregroundStyle(.white)
                    .font(.title3)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)

                HStack {
                    Text("\(group.memberCount) members")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if group.totalExpenses > 0 {
                        Text("•")
                            .foregroundStyle(.secondary)
                        Text("$\(group.totalExpenses, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    GroupsView()
        .modelContainer(for: [Group.self, Expense.self], inMemory: true)
}
