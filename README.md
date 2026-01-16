# Splitt

A full-featured iOS expense-sharing app - a clone of Splitwise built with SwiftUI and SwiftData.

## Features

### Core Functionality
- **User Management**: Onboarding flow and profile management
- **Friends**: Add and manage friends to split expenses with
- **Groups**: Create groups for different contexts (trips, roommates, etc.)
- **Expenses**: Add expenses with multiple split options
- **Balance Tracking**: Automatic calculation of who owes whom
- **Settlement**: Record payments to settle balances
- **Activity Feed**: View all expenses and payments in chronological order

### Split Options
- **Equal Split**: Divide expense equally among participants
- **Unequal Split**: Custom amounts for each person
- **Percentage Split**: Split by percentage (e.g., 60/40)
- **Shares Split**: Split by shares/units

### Smart Features
- **Balance Simplification**: Minimizes number of transactions needed to settle
- **Category Icons**: Visual categorization for expenses (Food, Transport, Entertainment, etc.)
- **Colorful Avatars**: Auto-generated colors for users and groups
- **Real-time Updates**: SwiftData persistence with automatic UI updates

## Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Apple's modern data persistence framework
- **iOS 17+**: Requires iOS 17.0 or later
- **Xcode 15+**: Built with Xcode 15.4

## Project Structure

```
Splitt/
├── SplittApp.swift           # App entry point
├── ContentView.swift          # Main view with tab navigation
├── Models/
│   ├── User.swift            # Current user model
│   ├── Friend.swift          # Friend model
│   ├── Group.swift           # Group model
│   ├── Expense.swift         # Expense model with split details
│   └── Settlement.swift      # Payment/settlement model
├── Views/
│   ├── OnboardingView.swift  # First-time user setup
│   ├── GroupsView.swift      # Groups list
│   ├── GroupDetailView.swift # Group details and expenses
│   ├── AddGroupView.swift    # Create new group
│   ├── AddExpenseView.swift  # Create new expense
│   ├── BalancesView.swift    # Balance summary and settlements
│   ├── FriendsView.swift     # Friends list
│   ├── ActivityView.swift    # Transaction history
│   └── AccountView.swift     # User profile and settings
└── Utils/
    ├── BalanceCalculator.swift   # Balance computation logic
    ├── ColorExtension.swift      # Hex color support
    └── EmptyStateView.swift      # Reusable empty state UI
```

## Building the App

1. Open `Splitt.xcodeproj` in Xcode
2. Select a simulator or device
3. Press Cmd+R to build and run

## How to Use

1. **First Launch**: Enter your name to get started
2. **Add Friends**: Go to Friends tab and add people you split expenses with
3. **Create Groups**: Create groups for different contexts (e.g., "Roommates", "Europe Trip")
4. **Add Expenses**: In any group, tap + to add an expense
5. **Choose Split Type**: Select how to split the expense
6. **View Balances**: See who owes what in the group detail view
7. **Settle Up**: Record payments when someone pays back their share

## Key Features Explained

### Balance Calculation
The app automatically calculates balances by:
- Tracking who paid for each expense
- Tracking how much each person owes based on the split
- Subtracting any settlements/payments made
- Using a debt simplification algorithm to minimize transactions

### Debt Simplification
When viewing balances, the app suggests the minimum number of payments needed to settle all debts in the group. For example, if A owes B $10, B owes C $10, the app simplifies this to: A pays C $10.

### Data Persistence
All data is stored locally on the device using SwiftData, Apple's modern persistence framework. Data persists across app launches and is tied to the specific device.

## Future Enhancements

Potential features for future versions:
- Cloud sync across devices
- Multi-currency support
- Receipt photo attachments
- Push notifications for new expenses
- Export to CSV/PDF
- Dark mode support
- Recurring expenses
- Split by item (itemized bills)

## License

This is a demo project created as a Splitwise clone for educational purposes
