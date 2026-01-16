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

## Getting Started

### Prerequisites

Before running the app, ensure you have:
- **macOS 13.0+** (Ventura or later)
- **Xcode 15.0+** with Command Line Tools installed
- **iOS 17.0+ Simulator** or physical device
- Active **Apple Developer account** (for device deployment)

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/LatifZakii/Splitt.git
   cd Splitt
   ```

2. **Open in Xcode**
   ```bash
   open Splitt.xcodeproj
   ```
   Or double-click `Splitt.xcodeproj` in Finder

3. **Select Target Device**
   - In Xcode, click the device selector in the toolbar
   - Choose an iOS 17+ simulator (e.g., "iPhone 15 Pro")
   - Or connect a physical device with iOS 17+

4. **Build & Run**
   - Press `Cmd + R` or click the Play button
   - Wait for the build to complete (first build may take 1-2 minutes)
   - The app will launch automatically on your selected device

### First Launch Setup

When you first launch the app:

1. **Onboarding Screen** will appear
2. Enter your **name** (required)
3. Optionally add your **email** and **phone number**
4. Tap **"Get Started"**
5. You'll be taken to the main app with 4 tabs

## Next Steps

### 1. Create a Pull Request

Your code is on the `claude/splitwise-clone-app-1GVEq` branch. To merge it to main:

**Option A: Via GitHub Web Interface**
1. Visit: https://github.com/LatifZakii/Splitt/pull/new/claude/splitwise-clone-app-1GVEq
2. Review the changes (24 files added)
3. Add a title: "Complete Splitwise Clone iOS App"
4. Review the description (auto-populated)
5. Click **"Create Pull Request"**
6. Review and merge when ready

**Option B: Via Command Line**
```bash
# Install GitHub CLI if not already installed
brew install gh

# Create pull request
gh pr create \
  --title "Complete Splitwise Clone iOS App" \
  --body "Implements full Splitwise clone with groups, expenses, friends, and balance tracking" \
  --base main
```

### 2. Test the App

**Basic Testing Flow:**

1. **Add Friends** (Friends Tab)
   - Tap the `+` button
   - Add 2-3 friends (e.g., "Alice", "Bob", "Charlie")
   - Include email/phone if desired

2. **Create a Group** (Groups Tab)
   - Tap the `+` button
   - Name: "Roommates" or "Trip to Paris"
   - Select an icon (e.g., house or airplane)
   - Add your friends as members
   - Tap **"Create"**

3. **Add an Expense**
   - Open the group you created
   - Tap the `+` button in the group detail view
   - Description: "Dinner at restaurant"
   - Amount: $120
   - Paid by: Select yourself
   - Category: "Food"
   - Split type: "Equally"
   - Tap **"Add"**

4. **View Balances**
   - In the group detail, tap **"View Balances"**
   - See who owes whom
   - Notice the simplified transactions

5. **Settle Up**
   - When someone pays you back, tap their name
   - Tap **"Record Payment"**
   - Enter the amount
   - Balances update automatically

6. **Check Activity** (Activity Tab)
   - View all expenses and settlements chronologically
   - Filter by date or transaction type

7. **Edit Profile** (Account Tab)
   - View your statistics
   - Edit name, email, phone
   - See total expenses and transactions

### 3. Deploy to Physical Device

To run on your iPhone/iPad:

1. **Connect Device**
   - Connect via USB cable
   - Unlock device and trust computer

2. **Configure Signing**
   - In Xcode, select the `Splitt` target
   - Go to **"Signing & Capabilities"** tab
   - Select your **Team** (Apple Developer account)
   - Xcode will automatically provision the app

3. **Run on Device**
   - Select your device from the device selector
   - Press `Cmd + R`
   - First time: Settings > General > VPN & Device Management > Trust Developer

4. **Test on Real Device**
   - Better performance than simulator
   - Test touch interactions and gestures
   - Verify data persistence across app launches

### 4. Customize the App

Want to modify the app? Here are some ideas:

**Easy Customizations:**
- Change accent color: `Splitt/Assets.xcassets/AccentColor.colorset/Contents.json`
- Add more expense categories: `AddExpenseView.swift:19`
- Add more group icons: `AddGroupView.swift:16-19`
- Modify avatar colors: `User.swift:26`

**Intermediate Customizations:**
- Add currency selection (USD, EUR, GBP)
- Implement export to CSV
- Add expense photos/receipts
- Create custom split rules

**Advanced Customizations:**
- Implement CloudKit sync
- Add push notifications
- Multi-currency with exchange rates
- Recurring/scheduled expenses

### 5. Troubleshooting

**Build Errors:**
- Ensure Xcode 15+ is installed
- Clean build folder: `Cmd + Shift + K`
- Delete derived data: Xcode > Settings > Locations > Derived Data > Delete

**Simulator Issues:**
- Reset simulator: Device > Erase All Content and Settings
- Restart simulator: Device > Restart
- Try different simulator (iPhone 15 Pro recommended)

**Data Issues:**
- App data is stored locally per device
- To reset: Delete app from simulator/device and reinstall
- Check SwiftData container in Debug Navigator

**Signing Issues:**
- Ensure Apple ID is logged into Xcode
- Use "Automatically manage signing"
- Free accounts: Apps expire after 7 days, need re-signing

### 6. Share Your App

**TestFlight (Beta Testing):**
1. Archive the app: Product > Archive
2. Upload to App Store Connect
3. Create TestFlight build
4. Invite testers via email

**App Store Submission:**
1. Add app icons (all sizes)
2. Create screenshots and previews
3. Write app description and keywords
4. Submit for review (typically 1-3 days)

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
