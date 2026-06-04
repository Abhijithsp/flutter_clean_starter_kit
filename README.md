# 🚀 Flutter Clean Starter Kit

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.8.0-blue.svg?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.8.0-blue.svg?style=for-the-badge&logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success.svg?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-Bloc%20%2F%20Cubit-red.svg?style=for-the-badge)](https://bloclibrary.dev)

A production-ready, highly modular Flutter starter kit designed with **Clean Architecture (Feature-first structure)**, **BLoC/Cubit** for robust state management, and **Freezed** for immutable states and serialization. It features a complete, modern E-Commerce shop client inspired by Flipkart, along with an extensive developer UI component showcase.

---

## 🌟 Key Features

### 🔐 Authentication Flow
- **Session Persistence:** Remembers user logins automatically using local preference caching.
- **Secure Mock Auth:** Provides interactive login and registration sheets with real-time UI state feedback.

### 🛍️ Flipkart-Style Shop (E-Commerce Client)
- **Interactive Search:** Top search bar with real-time query matching and instant clear functionality.
- **Pinned Category Navigation:** Beautiful horizontal emoji category strip (Mobiles, Electronics, Fashion, Home, etc.) for quick browsing.
- **Minimal Clean Filtering:** Category selection replaces busy homepage components with a streamlined, clutter-free grid of filtered items.
- **Deal of the Day Countdown:** Dynamic countdown timer showing products with exclusive discount rates.
- **Curated Promo Carousel:** Automatic page-sliding banner showcasing offers.
- **Banners & Grids:** Layouts for Best Sellers, Trending Now, and Top Picks.

### 🛒 Cart & Checkout Management
- **Interactive Cart:** Real-time quantity adjustments, price calculations, and item removals.
- **Wishlist:** Favorite items instantly with responsive visual heart indicators.
- **Simulated Checkout:** Choose cards, UPI, Wallets, or COD with full checkout summary computations.
- **Payment Processing Page:** A processing overlay that transitions smoothly to success.

### 📦 Order History & Tracking
- **Purchase History:** Lists past orders with total cost, product count, and dates.
- **Real-Time Step Tracking:** Interactive delivery tracking timeline (Order Placed ➔ Packed ➔ Shipped ➔ Out for Delivery ➔ Delivered).

### 🛠️ Developer UI Showcase (`/showcase`)
A playground screen showing all custom reusable widgets defined in the design system:
- **Cards & Badges:** `AppGridCard`, `AppStatsCard`, `AppBadge` variants.
- **Navigation & Info:** `AppInfoCard`, `AppContactTile`, custom `AppAvatar` / `AppAvatarGroup`.
- **Inputs & Selection:** Single/Multi-select `AppChipGroup`, `AppTextField`, secure `AppPasswordField`, `AppSearchField`, custom `AppDropdown`, and `AppSegmentedPicker`.
- **Buttons:** Filled, Tonal, Outlined, Text, and Elevated states featuring integrated asynchronous loading animations.
- **Loaders & Skeletons:** Premium shimmer overlays (`AppSkeletonLoader`) and clean `AppEmptyState` panels.
- **Modals & Snacks:** Interactive `AppDialog` confirmations and error/warning/success `AppSnackbar` notifications.

### ⚙️ Preferences & Local Services
- **System Theme Integration:** Supports Material 3 Light/Dark theme switching automatically.
- **Local Notifications:** Dedicated API bridge to trigger instant native system alerts.
- **Mock Configuration:** Uses offline asset-based data providers that can be swapped for API endpoints.

---

## 🏗️ Architecture & Project Directory

The project follows a **Feature-First Clean Architecture** layout. Code is divided into independent modules containing `domain`, `data`, and `presentation` layers to isolate business logic, UI, and external data sources.

```text
lib/
├── core/                       # Shared/Common utilities and assets
│   ├── error/                  # Domain failures and exceptions
│   ├── router/                 # GoRouter navigation paths
│   ├── services/               # Local notifications and device services
│   ├── theme/                  # Material 3 colors, text styles, and curves
│   └── widgets/                # Reusable design system UI components (app_widgets.dart)
│
├── features/                   # Feature-specific modules
│   ├── auth/                   # Session administration
│   ├── dashboard/              # Core container holding tabs & bottom navigation
│   ├── shop/                   # Shop, Cart, Wishlist, Payments, Orders
│   │   ├── data/               # Local JSON sources & Repository implementations
│   │   ├── domain/             # Product/Order entities & Repository interfaces
│   │   └── presentation/       # Cubit state controllers & UI Views
│   └── showcase/               # Developer design playground
│
└── main.dart                   # Application entry point & dependency injection setup
```

### 💡 Why Clean Architecture?
- **Separation of Concerns:** UI does not talk to data sources; it only knows about domain models and abstract contracts.
- **Maintainability:** Adding or replacing features (e.g., swapping Local JSON storage with a Remote REST API) only requires changing the data source implementation without editing any UI screens.
- **Testability:** Business logic inside Cubits and Repositories can be unit-tested in isolation without mocking UI overlays.

---

## 📦 Tech Stack & Core Dependencies

| Package | Version | Purpose |
| :--- | :--- | :--- |
| **flutter_bloc** | `^9.1.0` | State management using Cubits to emit immutable UI states |
| **go_router** | `^17.2.3` | Declarative routing configuration supporting deep linking |
| **freezed** | `^3.1.0` | Code generator for union states and data modeling serialization |
| **dio** | `^5.7.0` | HTTP network client equipped with timeout and interceptor defaults |
| **shared_preferences**| `^2.3.3` | Local persistent cache for login sessions and settings |
| **flutter_local_notifications** | `^18.0.1` | Local native notifications generator |
| **google_fonts** | `^8.1.0` | Sleek Outfit fonts loading |
| **cached_network_image** | `^3.4.1` | Cache network images with beautiful shimmer placeholders |

---

## 🚀 Getting Started & Setup Guide

Follow this guide to get the project running locally on your machine.

### 📋 Prerequisites
Ensure you have the following installed:
1. **Flutter SDK:** Version `>= 3.8.0`. Run `flutter --version` in your terminal to check.
2. **Dart SDK:** Installed automatically with Flutter.
3. **IDE:** VS Code (recommended), Android Studio, or IntelliJ.
4. **Emulators:** An Android Emulator, iOS Simulator, or Web Browser (Chrome).

---

### 🔧 Step-by-Step Installation

#### Step 1: Clone the Repository
Clone the codebase to your local directory:
```bash
git clone <repository-url>
cd flutter_clean_starter
```

#### Step 2: Fetch Dependencies
Download the project dependencies specified in `pubspec.yaml`:
```bash
flutter pub get
```

#### Step 3: Run Code Generation (CRITICAL)
This project uses **Freezed** and **Json Serializable** for model generation. You **must** run the build runner script before compiling, otherwise you will see compiling errors regarding missing files (e.g., `product.freezed.dart`, `cart_state.freezed.dart`):
```bash
dart run build_runner build --delete-conflicting-outputs
```
> 💡 *Note: The `--delete-conflicting-outputs` flag tells Flutter to overwrite any existing generated files to prevent building errors.*

#### Step 4: Run the Application
Start the application on your connected device/emulator:
```bash
flutter run
```

---

## 🛠️ Helper Scripts
The project provides Python scripts to automatically generate template boilerplates for new features or authentication modules:
- **`setup_script.py`**: Generates boilerplate pages, failures, and routing rules for default layouts.
- **`setup_auth.py`**: Generates pre-configured domain models, local caching sources, and state providers for a Riverpod-based layout (if migrating).

To execute these generator scripts:
```bash
python setup_script.py
python setup_auth.py
```

---

## 🤝 Extending the Codebase
Want to add a new feature? Follow the guide documented in [FEATURE_GUIDE.md](file:///d:/flutter_projects/freelance_work/flutter_clean_starter/FEATURE_GUIDE.md) in the project root. It provides a detailed, 9-step checklist to write entities, repositories, cubits, routes, and UI controllers from scratch.

---

## 🔍 Troubleshooting (FAQ)

### Why are product images showing blank or not loading?
If external Unsplash images are not showing up on your device/emulator, check the following:
1. **Network Connectivity:** Ensure your testing emulator, simulator, or physical device is connected to the internet.
2. **Android Internet Permission:** By default, Android blocks network requests in some compilation settings if permissions are omitted. We have added the required `<uses-permission android:name="android.permission.INTERNET"/>` tag inside [AndroidManifest.xml](file:///d:/flutter_projects/freelance_work/flutter_clean_starter/android/app/src/main/AndroidManifest.xml).
3. **Flutter Web CORS Restriction:** If you are testing the app on **Chrome/Web**, external images will fail to load in default CanvasKit mode due to Cross-Origin Resource Sharing (CORS) security. To bypass this during testing, run the app using the HTML web renderer:
   ```bash
   flutter run -d chrome --web-renderer html
   ```

---

## 📄 License
This project is proprietary and confidential. All rights reserved.
