<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Pet Care Reminder App - Copilot Instructions

This is a Flutter mobile application for managing pet care reminders and schedules.

## Project Context

- **Framework**: Flutter 3.0+ with Dart
- **State Management**: Provider pattern
- **Database**: SQLite via sqflite package
- **Notifications**: flutter_local_notifications
- **UI**: Material Design 3 components
- **Target Platform**: Android (with future iOS support)

## Code Style Guidelines

- Use null safety features
- Prefer const constructors where possible
- Follow Flutter/Dart naming conventions (camelCase for variables, PascalCase for classes)
- Use meaningful variable and function names
- Organize imports: dart core, flutter, third-party, relative imports
- Add proper error handling with try-catch blocks
- Use async/await for asynchronous operations

## Project Structure

- `lib/models/` - Data models (Pet, Reminder)
- `lib/providers/` - State management classes using ChangeNotifier
- `lib/screens/` - UI screens and pages
- `lib/widgets/` - Reusable UI components
- `lib/services/` - Business logic and external service integrations

## Key Patterns

- Use Provider for state management
- Database operations should be in DatabaseService
- UI updates should happen through providers
- Follow Material Design guidelines
- Handle loading states and errors gracefully
- Use proper form validation

## Dependencies Focus

When suggesting code, prioritize using these packages:
- provider (state management)
- sqflite (database)
- flutter_local_notifications (notifications)
- intl (date formatting)
- permission_handler (permissions)

## Best Practices

- Always dispose controllers and resources
- Use const widgets where possible for performance
- Implement proper error handling for database operations
- Follow accessibility guidelines
- Use proper DateTime handling for reminders
- Validate user input thoroughly
