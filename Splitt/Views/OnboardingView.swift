//
//  OnboardingView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                // Logo/Icon
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.teal)

                Text("Welcome to Splitt")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Split expenses with friends and groups")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                // Input fields
                VStack(spacing: 16) {
                    TextField("Your Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.name)

                    TextField("Email (optional)", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    TextField("Phone (optional)", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                .padding(.horizontal)

                Button {
                    createUser()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(name.isEmpty ? Color.gray : Color.teal)
                        .cornerRadius(12)
                }
                .disabled(name.isEmpty)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }

    private func createUser() {
        let user = User(name: name, email: email, phoneNumber: phoneNumber)
        modelContext.insert(user)
        try? modelContext.save()
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [User.self], inMemory: true)
}
