# Shinde Roadlines Driver App

A comprehensive, real-time logistics and fleet management solution built for Shinde Roadlines. This Flutter application empowers drivers with advanced tools for navigation, communication, and meticulous trip data tracking.

## ✨ Core Features

### 🚛 Logistics & Fleet Management
A robust system to track every aspect of transport operations:
- **Trip Data Logging**: Record Trip ID, Date, Vehicle ID, and Driver ID.
- **Precision Tracking**: Monitor distance (km), duration (hrs), and cargo weight (kg).
- **Financial Oversight**: Integrated tracking for Fuel Costs, Maintenance, Tolls, Parking Fees, and Driver Wages/Incentives.
- **Profitability Analysis**: Automated Profit/Loss calculation per trip.
- **Categorized Expenses**: Dedicated breakdown for operational spending.

### 🗺️ Intelligent Navigation
Advanced mapping features for optimal route planning:
- **Interactive Google Maps**: Real-time marker placement and visualization.
- **Smart Search**: Destination search with suggestions powered by **OpenStreetMap (Nominatim)**.
- **Dynamic Routing**: Pathfinding and route drawing using the **OSRM API**.
- **Live Metrics**: Automatic calculation of travel distance and estimated time of arrival (ETA).
- **Reverse Geocoding**: Automatic address resolution from geographic coordinates.

### 💬 Real-time Communication
Integrated chat system for seamless driver-to-office communication:
- **Instant Messaging**: Real-time chat powered by **Firebase Firestore**.
- **Message History**: Persistent chat rooms with message timestamps.
- **User Discovery**: Dynamic user directory for quick contact.

### 👤 Driver Portal
Simplified personal and vehicle management:
- **Secure Authentication**: Firebase-backed login, signup, and password recovery.
- **Personalized Profile**: Manage driver details and view membership status (e.g., Gold Member).
- **Quick Actions**: One-tap access to Choose Truck, Pickup Point, and Expense/Wallet views.

---

## � Technical Architecture

### Frontend
- **Framework**: Flutter (v3.5.4+)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **UI Design**: Responsive with a distinct logistics-focused theme (Secondary Orange).

### Backend & Infrastructure
- **Authentication**: Firebase Authentication (Email/Password, Google Sign-In).
- **Database**: Cloud Firestore for real-time data sync.
- **Routing Engine**: OSRM (Open Source Routing Machine).
- **Geocoding**: Nominatim (OpenStreetMap) and Google Geocoding.
- **Maps API**: Google Maps Flutter.

---

## 📂 Project Structure (lib/)

```text
lib/
├── Chat/                # Real-time messaging implementation
│   ├── chat_service.dart   # Firestore messaging logic
│   ├── Chatpage.dart       # Main chat interface
│   └── displayuserhome.dart # User directory
├── input data/          # Comprehensive data entry modules
│   ├── TripDataPage.dart       # Core trip logging
│   ├── ExpenseBreakdownPage.dart # Detailed expense tracking
│   ├── VehiclesDataPage.dart   # Fleet management
│   ├── RouteAndRegionPage.dart # Operational areas
│   └── TimeAndDateDataPage.dart # Timing records
├── Profilepage.dart     # Driver portal and settings
├── location_page.dart   # Map, Search, and Routing engine
├── login.dart           # Secure entry point
├── main.dart            # App initialization
└── wrapper.dart         # Authentication state monitor
```

---

## ⚙️ Installation & Setup

1. **Prerequisites**:
   - Flutter SDK installed and path configured.
   - A Firebase project for authentication and database services.

2. **Clone & Initialize**:
   ```bash
   git clone <repository-url>
   cd demo1
   flutter pub get
   ```

3. **Service Configuration**:
   - **Android**: Place `google-services.json` in `android/app/`.
   - **iOS**: Place `GoogleService-Info.plist` in `ios/Runner/`.
   - **API Key**: Ensure a valid Google Maps API Key is configured in `AndroidManifest.xml` and `AppDelegate.swift`.

4. **Run the App**:
   ```bash
   flutter run
   ```

---
*Developed for Shinde Roadlines – Moving Excellence.*
