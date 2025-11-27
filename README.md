# Rolla Fitness App - Score Detail Preview Demo

A Flutter application demonstrating reusable UI components, clean architecture, and smooth interactions for the Rolla Score Detail screens.

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

Flutter version: 3.35.5
Dart version: 3.9.2

**Install dependencies:**
```bash
flutter pub get
```

**Run the app:**
```bash
flutter run
```

## Notes on Assumptions and Component Usage

### Data Generation Service
Implemented a sophisticated data generation service that creates realistic fitness data with temporal patterns, score correlations, and missing data simulation. This allows for rich UI testing without a backend and demonstrates pull-to-refresh functionality.

### Key Implementation Decisions

**Timeframes:** All four timeframes (1D, 7D, 30D, 1Y) fully implemented. 1D shows daily totals with radial gauge, while 7D/30D/1Y show daily averages with "Avg" labels and trend charts.

**Health Score Composition:** Calculated as the average of Readiness and Activity scores. The Health detail screen shows summary metrics from both categories.

**Progress Bar Colors:** Conditional coloring based on score value - 0-49: neutral gray, 50-79: blue, 80+: green. This provides visual feedback relative to the personal baseline of 80.

**Loading States:** Skeleton loaders shown on first visit to each timeframe, instant switching thereafter. Tracks visited timeframes for smooth UX. Demo includes error state on 4th timeframe visit.

**Period Navigation:** Added previous/next period navigation for exploring historical data across all timeframes, with date-aware logic preventing navigation beyond today.

**Charts:** Custom painters for 1D radial gauge (precise control over appearance), fl_chart for trend charts (robust performance). Both handle missing data with visual gaps.

**Theme Support:** Full light/dark mode implementation with theme switcher, using centralized color system and Outfit font throughout.

**Component Reusability:** Extensive use of reusable widgets following atomic design principles - from basic elements (CustomCard, LoadingSkeleton) to complex organisms (ScoreCard, TrendChart, ScoreHeader). Same widget components used across home and detail screens.

---

**Flutter Version:** 3.35.5
