# Flutter App Design Principles

## 1. Modular Folder Structure
```
lib/
├── backend/          # Data layer (repositories, storage, models)
├── domain/           # Business logic (state, calculations, converters)
├── presentation/     # UI layer (widgets only)
├── config/           # Configuration constants
├── constants/        # App-wide constants
└── screens/          # Top-level screens
```

## 2. Separation of Concerns
- **Domain layer** - Pure Dart logic with no Flutter dependencies
- **Presentation layer** - Only UI widgets, no business logic
- **Backend layer** - Persistence, API calls, data access

## 3. Barrel Exports
Create index files to simplify imports:
```dart
// domain/domain.dart
export 'models/model_a.dart';
export 'services/service_b.dart';
```

## 4. Single Responsibility Widgets
Each widget does exactly one thing. Split complex widgets into smaller focused ones.

## 5. Coordinate/Unit Systems Abstraction
Separate logical units from display units with dedicated converter classes.

## 6. State Management Pattern
- State class holds mutable data
- Handler classes encapsulate user interactions
- Clear separation between state and UI

## 7. Repository Pattern for Persistence
Abstract data access behind repository interfaces with async methods.

## 8. Reusable Widget Patterns
- Base classes for similar widgets
- Composition over inheritance
- Static factory methods for common configurations

## 9. Configuration Externalization
Keep magic numbers and constants in config files, not scattered in widgets.

## 10. Platform-Aware Code
Use `kIsWeb` or `Platform` checks for platform-specific behavior.

