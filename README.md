# Legash — Mobile Donor Application

Legash is a Smart Blood Donation Management System designed to connect blood donors with hospitals and blood centers through a unified digital platform.

This repository, **legash-mobile**, contains the Flutter mobile application developed exclusively for blood donors. It allows donors to register, manage their profiles, discover nearby blood centers, respond to blood requests, track donation history, receive notifications, and access blood donation and health-related information. Hospitals, blood centers, and super administrators operate through the separate web application.

## Repository Information

**Project:** Legash — Smart Blood Donation Management System

**Repository:** Legash-Team/Mobile

**Architecture:** Flutter and Dart cross-platform mobile application integrated with the Legash Backend REST API.

**Primary Responsibility:** Donor-facing mobile application development, onboarding, profile management, localization, blood center discovery, notifications, donation workflows, and mobile API integration.

---

## Contributors

- Firaol Tsegaye — CTC-7007-26
- Falmi Abdi — CTC-927-26

---

## Tech Stack

- Flutter — Cross-platform mobile application framework
- Dart — Programming language
- Firebase Cloud Messaging (FCM) — Push notification integration
- Firebase — Mobile application services
- REST API — Backend communication
- Local Notifications — On-device notification handling
- Geolocation — Location-based blood center discovery

## Engineering Team & Responsibilities

The mobile application is developed through collaboration between two engineers, with responsibilities covering donor onboarding, mobile feature development, user interface implementation, localization, location-based services, notifications, media rendering, and application performance.

### 1. Firaol Tsegaye

**Mobile Subsystem Engineer**

**Institutional ID:** CTC-7007-26

**Primary Responsibilities:**

**Flutter Donor Onboarding Experience:** Develops and improves the donor onboarding experience, including the initial application flow, registration-related screens, user interactions, and the overall experience for new donors joining the platform.

**Version 2 Feature Walkthrough:** Implements and maintains the walkthrough experience for the application's version 2 features, helping donors understand new functionality and navigate the application's capabilities.

**Donor Profile Short ID Display:** Implements the display of donor Short IDs within the mobile application, including clipboard integration that allows donors to easily copy and share their unique identification codes.

**Community Feed & Event Card UI Harmonization:** Develops and improves the user interface of community feeds and event cards, maintaining consistent layouts, visual presentation, and interactions across the relevant mobile screens.

**Media Rendering:** Handles media rendering within the mobile application, ensuring that images and other supported media are displayed appropriately across different screens and device configurations.

**Video Overlay Player:** Implements and maintains video overlay player functionality to support video playback and media-related experiences within the application.

**Network Exception Handling:** Improves mobile network exception handling to ensure that connectivity issues and failed API requests are handled more reliably, with appropriate application behavior and user feedback.

**Mobile API Integration:** Works on integrating mobile features with backend services, ensuring that donor-facing screens correctly communicate with the Legash Backend API and handle returned data.

### 2. Falmi Abdi

**Mobile Subsystem Engineer**

**Institutional ID:** CTC-927-26

**Primary Responsibilities:**

**Afaan Oromo Localization:** Implements Afaan Oromo mobile localization and translation packs, expanding language accessibility and improving the application experience for Afaan Oromo-speaking donors.

**Multilingual Translation Support:** Develops and maintains mobile translation resources to ensure that localized text and interface labels are displayed consistently throughout the application.

**Nearby Blood Center Discovery:** Implements location-based discovery of nearby blood centers using GPS geolocation, allowing donors to find relevant blood centers based on their current location.

**Distance Calculation:** Develops distance calculation functionality for nearby blood center listings, helping donors understand the proximity of available blood centers.

**Donor Statistics Counter:** Implements donor statistics and counters to display relevant donation-related information and help donors track their contribution history.

**Notification Center:** Develops and maintains the mobile notification center, enabling donors to receive and view relevant application notifications and stay informed about blood requests, donation activities, and other updates.

**Flutter Dependency Lifecycle:** Manages Flutter dependency lifecycle and package compatibility, helping maintain stable dependencies and reduce issues caused by package updates or incompatible versions.

**Static Analysis:** Performs Flutter static analysis to identify potential code issues, maintain code quality, and support application reliability and maintainability.

**Mobile Feature Integration:** Ensures that localization, geolocation, donor statistics, and notification features integrate properly with the existing mobile application architecture and backend services.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android emulator or physical Android device
- Git

### Installation

Clone the repository and install dependencies:

```bash
git clone <mobile-repository-url>
cd Mobile
flutter pub get
```

### Environment Configuration

Configure the required Firebase and backend settings before running the application.

Ensure that the appropriate `google-services.json` file is available in the Android application configuration directory.

Configure the mobile application to communicate with the correct Legash Backend API URL.

Never commit private credentials or sensitive configuration files to the repository.

### Running the Application

Start the application:

```bash
flutter run
```

## Backend Integration

The mobile application communicates with the Legash Backend API through RESTful endpoints.

The backend manages authentication, donor information, blood requests, donation records, compatibility matching, and other application business logic, while the mobile application provides the corresponding donor-facing interfaces.

Firebase Cloud Messaging is used for push notification delivery, while local notification functionality supports on-device notification presentation.

Ensure that the configured API URL points to the correct backend environment and that the backend server is accessible.

## Testing

Run Flutter static analysis:

```bash
flutter analyze
```

Run the automated test suite:

```bash
flutter test
```

Verify the affected mobile screens, API integrations, localization, notification behavior, and location-based functionality before submitting changes.

## Git Workflow

- Create a separate branch for each task.
- Keep changes focused on the assigned mobile feature or fix.
- Open a pull request for review by another mobile developer.
- Run Flutter analysis and automated tests before merging.
- Avoid committing directly to the main branch.
