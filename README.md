<div align="center">

<img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"/>
<img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
<img src="https://img.shields.io/badge/Material%203-UI-blue?style=for-the-badge&logo=google&logoColor=white" alt="Material 3"/>

<br/><br/>

# 🎂 Age Calculator

### *A beautiful, feature-rich Flutter app that tells you everything about your age — down to the very second.*

<br/>

[![Version](https://img.shields.io/badge/version-1.0.0-blue?style=flat-square)](https://github.com/JAIN2309/Age_Calculator/releases)
[![Flutter](https://img.shields.io/badge/Flutter-≥3.10.1-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey?style=flat-square)](https://flutter.dev/multi-platform)

<br/>

---

</div>

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📅 **Exact Age** | Years, months & days — precise to the calendar |
| ⏱️ **Total Time Elapsed** | Total months, weeks, days, hours, minutes & seconds |
| 📆 **Calendar View** | Visual birth date & target date on a calendar widget |
| 🎉 **Birthday Countdown** | Days until your next birthday with celebration styling |
| 🔄 **Custom Target Date** | Calculate age at *any* date — not just today |
| 🎨 **Beautiful UI** | Material 3, gradient headers, smooth page transitions |
| 📱 **Cross-Platform** | Runs on Android, iOS, Web, Windows, macOS & Linux |
| 🌈 **Smooth Animations** | Fade & slide entry effects with custom route transitions |

---

## 🖼️ App Screens

```
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  🏠 Home Screen  │    │  📊 Result Screen │    │  📅 Calendar     │
│                  │    │                  │    │                  │
│  ┌────────────┐  │    │  ┌────────────┐  │    │  ┌────────────┐  │
│  │ Date of    │  │    │  │  26 Years  │  │    │  │  Jun 2026  │  │
│  │ Birth      │  │    │  │  3 Months  │  │    │  │ Su Mo Tu W │  │
│  └────────────┘  │ →  │  │  12 Days   │  │ →  │  │  1  2  3  4│  │
│  ┌────────────┐  │    │  └────────────┘  │    │  │  ...       │  │
│  │ Calculate  │  │    │  Total: 9,598    │    │  └────────────┘  │
│  │ Age At     │  │    │  Days Elapsed    │    │  Birth & Target  │
│  └────────────┘  │    │  🎂 27 days left │    │  dates marked    │
│  [Calculate Age] │    │  to birthday!    │    │                  │
└──────────────────┘    └──────────────────┘    └──────────────────┘
```

---

## 📊 What the App Calculates

Once you enter your date of birth, the app instantly shows:

```
📌 Primary Age Banner
   └── ✅ Years  (e.g. 26 years)
   └── ✅ Months (e.g. 315 total months)
   └── ✅ Weeks  (e.g. 1,371 total weeks)
   └── ✅ Days   (e.g. 9,598 total days)

⏱️  Time Conversion Card
   └── ✅ Total Hours   (e.g. 230,352 hours)
   └── ✅ Total Minutes (e.g. 13,821,120 minutes)
   └── ✅ Total Seconds (e.g. 829,267,200 seconds)

🧩  Detailed Breakdown
   └── ✅ Years + Months + Days individually
   └── ✅ Day of the week you were born
   └── ✅ Days remaining to next birthday
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.10+ |
| **Language** | Dart |
| **UI System** | Material Design 3 |
| **Date Formatting** | [`intl`](https://pub.dev/packages/intl) ^0.19.0 |
| **Icons** | [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) ^1.0.8 |

---

## 🏗️ Project Structure

```
age_calculator/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── age_result.dart          # AgeResult data model
│   ├── utils/
│   │   └── age_calculator.dart      # Core calculation logic
│   ├── screens/
│   │   ├── home_screen.dart         # Date input & action buttons
│   │   ├── result_screen.dart       # Full age breakdown display
│   │   └── calendar_screen.dart     # Calendar visualization
│   ├── widgets/
│   │   ├── date_input_card.dart     # Reusable date picker card
│   │   ├── result_card.dart         # Result section card
│   │   └── calendar_widget.dart     # Mini calendar component
│   └── theme/
│       └── app_theme.dart           # Colors, gradients & theme
├── android/   ios/   web/
├── windows/   macos/ linux/
└── pubspec.yaml
```

---

## 🎨 Color Palette

```
Primary Blue    #1565C0  ████
Primary Dark    #0D47A1  ████   Header Gradient ──►  #1565C0 → #1976D2 → #42A5F5
Accent Blue     #42A5F5  ████
Result Green    #2E7D32  ████   Result Gradient ──►  #2E7D32 → #388E3C → #43A047
Highlight       #FDD835  ████   Birthday Celebration
Surface         #F8FAFF  ████
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.1
- Dart ≥ 3.0.0
- Android Studio / VS Code with Flutter extension

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/JAIN2309/Age_Calculator.git

# 2. Navigate to the project
cd Age_Calculator

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

### Running on a specific platform

```bash
flutter run -d android      # Android device or emulator
flutter run -d ios          # iOS simulator (macOS only)
flutter run -d chrome       # Web browser
flutter run -d windows      # Windows desktop
flutter run -d macos        # macOS desktop
flutter run -d linux        # Linux desktop
```

### Build for production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8    # iOS-style icons
  intl: ^0.19.0               # Date & number formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0       # Lint rules
```

---

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** the repository
2. **Create** your feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

---

## 🐛 Found a Bug?

Open an [issue](https://github.com/JAIN2309/Age_Calculator/issues) with:
- Steps to reproduce
- Expected vs actual behavior
- Device / platform / Flutter version

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ and Flutter

⭐ **If you find this useful, please star the repo!** ⭐

[![GitHub stars](https://img.shields.io/github/stars/JAIN2309/Age_Calculator?style=social)](https://github.com/JAIN2309/Age_Calculator)
[![GitHub forks](https://img.shields.io/github/forks/JAIN2309/Age_Calculator?style=social)](https://github.com/JAIN2309/Age_Calculator/fork)

</div>
