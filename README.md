# 🎰 Monte Carlo Blackjack Counter

![Monte Carlo Logo](assets/images/monte_carlo_logo.png)

**Monte Carlo** is a professional-grade Blackjack tool designed for advanced players. It combines the classic **Hi-Lo Card Counting** system with a high-performance **Monte Carlo Simulation Engine** to provide real-time strategic advice and probability estimations.

---

## 🚀 Key Features

- **Advanced Counting**: Implements the Hi-Lo system with automated True Count calculations based on remaining decks.
- **Real-Time Simulation**: Uses an asynchronous Monte Carlo engine (running on a separate isolate) to calculate win probabilities for both 'Hit' and 'Stand' decisions.
- **Dealer Analytics**: Provides precise percentage breakdowns of dealer outcomes, including bust probability and likely final totals.
- **Inventory Tracking**: A visual grid of the remaining shoe composition to monitor high/low card depletion.
- **Premium UI**: Dark mode glassmorphism interface with neon green/digital gold highlights for optimal visibility in low-light environments.

## 🛠 Tech Stack

- **Framework**: Flutter (Cross-platform)
- **State Management**: Riverpod (Notifier & FutureProvider)
- **Engine**: Multi-threaded Monte Carlo Simulation (using Dart `compute`)
- **Theme**: Custom Dark Theme with Google Fonts (Outfit)

## 📋 Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**
   ```bash
   git clone [your-repo-link]
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🧠 How it Works

### 1. Hi-Lo Counting
The app tracks every card drawn and calculates:
- **Running Count**: Sum of Hi-Lo values (-1 for 10-A, 0 for 7-9, +1 for 2-6).
- **True Count**: Running Count divided by the estimated number of decks remaining in the shoe.

### 2. Monte Carlo Engine
Every time the game state changes, the engine runs **4,000 simulated hands** in milliseconds. This allows the app to predict outcomes based on the exact current composition of the deck, rather than just standard averages.

### 3. Strategic Advice
The app compares the expected value of Hitting vs. Standing and recommends the mathematically superior move.

## 🛡 Disclaimer
This application is for educational and entertainment purposes only. Card counting is not illegal in most jurisdictions, but it is against casino policies and may result in being asked to leave. Use responsibly.

---

