# Rolla Fitness App - Preview Demo

A Flutter application demonstrating reusable UI components, clean architecture, and smooth interactions.

## App video demonstration (60 seconds)

https://www.youtube.com/shorts/IoQxtrSepTc

## Architecture Overview

This project follows **Clean Architecture** with a **feature-first** structure, ensuring separation of concerns and maintainability.

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌────────────┐  ┌──────────┐  ┌─────────────────────────┐ │
│  │   Pages    │  │  Widgets │  │  Cubits (State Mgmt)    │ │
│  └────────────┘  └──────────┘  └─────────────────────────┘ │
└────────────────────────┬────────────────────────────────────┘
                         │ Uses
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                           │
│  ┌──────────────┐  ┌────────────┐  ┌────────────────────┐  │
│  │   Entities   │  │  Use Cases │  │   Repositories     │  │
│  │   (Freezed)  │  │            │  │   (Interfaces)     │  │
│  └──────────────┘  └────────────┘  └────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │ Implements
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌──────────────┐  ┌────────────────┐  ┌─────────────────┐ │
│  │   Models     │  │  Repositories  │  │  Data Sources   │ │
│  │  (Freezed +  │  │ (Impl + Either)│  │  (Local JSON)   │ │
│  │   JSON)      │  │                │  │                 │ │
│  └──────────────┘  └────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                       Core Layer                             │
│  • Dependency Injection (GetIt + Injectable)                │
│  • Theme System (Light/Dark + Extensions)                   │
│  • Error Handling (Either<Failure, T>)                      │
│  • Reusable Widgets & Helpers                               │
│  • Data Generation Service                                  │
└─────────────────────────────────────────────────────────────┘
```

**Key Principles:**
- Feature-first structure (`lib/features/scores/`)
- Dependency inversion (domain defines interfaces, data implements)
- No exceptions for control flow (uses `Either<Failure, T>`)
- Immutable state with Freezed
- Dependency injection with GetIt + Injectable

**Directory Structure:**
```
lib/
├── core/                    # Shared utilities, theme, DI, widgets
└── features/
    └── scores/
        ├── data/            # Models, repositories, data sources
        ├── domain/          # Entities, use cases, repository interfaces
        └── presentation/    # Pages, widgets, cubits (BLoC)
```

## Tech Stack

### Core Dependencies
- **flutter_bloc** ^8.1.6 - State management
- **freezed** ^2.5.8 - Immutable data classes
- **get_it** ^8.0.3 + **injectable** ^2.6.0 - Dependency injection
- **dartz** ^0.10.1 - Functional programming (Either type)
- **equatable** ^2.0.5 - Value equality

### UI & Visualization
- **google_fonts** ^6.2.1 - Outfit font
- **fl_chart** ^0.69.2 - Trend charts
- Custom painters for radial gauge

### Utilities
- **intl** ^0.19.0 - Date formatting
- **json_annotation** ^4.9.0 - JSON serialization

### Development
- **flutter_lints** ^5.0.0 - Linting (passes with zero warnings)
- **build_runner** ^2.4.14 - Code generation

## Setup & Run Instructions

- Flutter version: 3.35.5
- Dart version: 3.9.2

**Install dependencies:**
```bash
flutter pub get
```

**Run the app:**
```bash
flutter run
```

**Devices used for development:**
- iPhone 11 (real iOS device)
- Xiaomi 10T (real Android device)

## Notes on Assumptions and Component Usage

**Data Generation:** To ensure data is fresh and this demo app is time-independent, a data generation service runs on every app start and creates realistic fitness data for the past six months starting from today. This intentionally leaves some empty data spots to demonstrate empty cases - for example, every 10th of the month is left empty, and some metrics randomly have null scores. This approach allows the app to work standalone without a backend while showcasing various UI states.

**Intentional Error States:** To fully demonstrate a realistic app flow, I've intentionally included error cases. On the home page, every third pull-to-refresh will trigger an error state showing an error snackbar - pressing "Try again" resolves it and returns to the loaded state. Similarly on the detail page, the last visited timeframe will intentionally emit an error state that can be fixed by pressing "Try again". This demonstrates proper error handling and recovery flows.

**State Management Choice:** I opted for Cubits over Blocs for state management. Having worked extensively with Cubits in previous projects, I've found they provide a cleaner, more straightforward approach for the scope of this assignment. Cubits offer everything needed without the additional complexity of events and event handlers that Blocs require. The simpler emit-based pattern perfectly suits the reactive nature of this UI.

**UI Philosophy:** The main goal was to create a smooth UX/UI that reacts to every user interaction.  The comprehensive component structure with reusable widgets, makes it easier to extend this project in the future with minimal effort. Every animation and every state (loading, empty and error) was implemented to feel polished and intentional.

**Device Orientation:** The app is configured to support portrait orientation only (both upright and upside down). Since the design specifications and task requirements focused exclusively on portrait mode, landscape support was intentionally excluded from the scope of this demo.

---

**Original Creator:** Emerald Podbicanin
