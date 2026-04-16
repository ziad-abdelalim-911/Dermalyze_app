# Dermalyze Project Status & Walkthrough

This document tracks the implemented features, architecture choices, and ongoing progress of the **Dermalyze** flutter app. Keep this file updated as a reference for future chat sessions to quickly restore context.

## 1. Network & Architecture
- **API Layer**: We established a robust network layer utilizing `DioClient`.
- **Token Management**: `TokenStorage` class securely manages `shared_preferences` tokens.
- **State Management**: Uses **Flutter BLoC/Cubit** across features (e.g., `DoctorHomeBloc`, `ThemeCubit`).

## 2. Authentication & Roles
- Backend integration applied to Auth flows mapping directly to real APIs rather than dummy data.
- **Patient Journey**: Logs in/Registers as a patient -> Routed to `CustomBottomNavBar(isDoctor: false)` -> Maps to `PatientHomeScreen`.
- **Doctor Journey**: Logs in/Registers as a doctor -> Routed to `CustomBottomNavBar(isDoctor: true)` -> Maps to `DoctorHomeScreen`.

## 3. Dark Mode & Theming 🌓 (Recently Completed)
- **Centralized Theming**: `ThemeCubit` combined with `AppTheme.dart` to provide rich adaptive styling (`lightTheme` and `darkTheme`).
- **Settings Integration**: New `/Settings` screen accessible from user profiles allows dynamic toggling of Dark Mode. State is globally persisted.
- **Adaptive UI**: All screens (including `AiAnalysisResultScreen`, `ProgressReportView`, `ChatView`, `MedicationListView`, and more) use dynamic BLoC context colors like `Theme.of(context).cardColor` instead of hardcoded hex codes.

## 4. Doctor Features
- **Dashboard (`DoctorHomeScreen`)**: Displays dynamic statistics, quick action cards, and real upcoming patients fetched from APIs.
- **Patient Lists**: Implemented `AllPatientsScreen` & `CriticalPatientsScreen` with filter chips (All, Critical, Follow-up, Recent).
- **Patient Details (`PatientDetailsScreen`)**: Displays condition, severity, interactive progress timeline, follow-up scheduling bottom sheets, and the ability to add medical reviews directly submitted to backend.
- **Profile**: A fully implemented `DoctorProfileScreen` displaying specific identifiers & logout mechanics.

## 5. Patient Features
- **Upload & Analyze**: Users can upload images for AI skin condition analysis.
- **AI Analysis Results**: `AiAnalysisResultScreen` displays conditions, severity, confidence, comparative image views (Side by side/Slider), and dynamically tracks improvement vs. previous scans.
- **Progress Report (`ProgressReportView`)**: A data-rich visualization of patient recovery displaying improvement loops, timeline, and key metrics.
- **Medication Guide (`MedicationListView`)**: Displays active/completed prescriptive regimens and important reminders directly synced to their accounts.

## 6. Pending/Future Tasks
- Integration of live Push Notifications routing.
- Completing real-time functional Chatting (currently UI static elements).

***
*Note: Include this file in any new chat context regarding Dermalyze.*
