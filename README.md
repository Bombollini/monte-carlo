# Monte Carlo - Professional Blackjack Intelligence

A high-performance Blackjack card counting and strategic probability engine built with Flutter and Riverpod. 

Monte Carlo goes beyond simple card counting by using real-time simulations to provide accurate win probabilities, side-bet odds, and professional strategic advice based on the exact composition of the remaining deck.

## 🚀 Key Features

### 🧠 Seamless Intelligence Engine
Unlike traditional counters, Monte Carlo uses a **Focus-Based Input System**:
- **Contextual Drawing**: Tap the Player or Dealer area to focus, then tap cards in the bottom bar to automatically add them to the hand and deplete the deck in a single step.
- **Monte Carlo Simulations**: Runs 4,000 real-time simulations per update to calculate exact win probabilities for Hitting vs. Standing.
- **Ace Sensitivity**: Intelligent handling of soft hands and Ace-high totals.

### 📊 Advanced Metrics
- **Group Probabilities**: Replaces complex count systems with intuitive percentages for:
  - **Small Cards (2-5)**: Safe drawing range.
  - **Medium Cards (6-8)**: Neutral transition cards.
  - **Large Cards (9-K)**: High-value/Bust-risk cards.
  - **Aces**: Critical for Blackjacks.
- **Side-Bet Odds**: Real-time probability tracking for popular side bets:
  - **Pairs Chance** (Any pair in next two cards).
  - **Straight Chance** (Sequence completion).
  - **Lucky 7s** (Probability of drawing a 7).

### 🃏 Professional Strategy
- **Dynamic Advice**: Real-time recommendations based on your total vs. dealer upcard and deck depletion.
- **Split Strategy**: Automated detection of pairs with "SPLIT" recommendations based on professional basic strategy.
- **High-Accuracy Tracking**: Distinct tracking for **10, Jack, Queen, and King** ensures the inventory screen perfectly mirrors the physical shoe.

### 📱 Optimized UI/UX
- **Multi-Screen Navigation**: Toggle between the **Dashboard** (Live Stats) and **Inventory** (Deck Composition) via top tabs.
- **Glassmorphism Design**: Premium, dark-mode focused aesthetic for high visibility in casino environments.
- **Quick Undo & Reset**: Effortlessly correct mistakes or reset the round with dedicated action buttons.

## 🛠️ Build & Installation

### Requirements
- Flutter SDK (Latest Stable)
- Android Studio / VS Code

### Run Locally
```bash
flutter pub get
flutter run --release
```

### Build APK
```bash
flutter build apk --release
```

## ⚖️ Disclaimer
*Monte Carlo is intended for educational and analytical purposes only. Card counting is not illegal in most jurisdictions but is strictly prohibited by most casinos and may result in being asked to leave. Use responsibly.*
