# Alarm App - Flutter Alarm Management System

A comprehensive, feature-rich alarm management application built with Flutter. This app provides a modern and intuitive interface for creating, managing, and customizing alarms with audio control, vibration settings, and persistent data storage.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Key Features Explained](#key-features-explained)
- [Usage Guide](#usage-guide)
- [Architecture](#architecture)
- [Database Schema](#database-schema)
- [Contributing](#contributing)

---

## 🎯 Overview

The Alarm App is a sophisticated mobile application that allows users to set, manage, and customize alarms with fine-grained control over audio playback, volume settings, vibration patterns, and alarm titles. It uses a modern provider-based state management pattern and local SQLite database for persistent storage.

The app supports:
- Creating and editing multiple alarms
- Custom alarm tones with audio file picker
- Staircase volume fade control for gradual audio increase
- Vibration settings
- Alarm titles and descriptions
- Full alarm lifecycle management (create, read, update, delete)
- Material Design 3 themed UI with deep purple color scheme

---

## ✨ Features

### Core Alarm Management
- **Create Alarms**: Set alarms with custom times, titles, and audio settings
- **Edit Alarms**: Modify existing alarms on the fly
- **Delete Alarms**: Remove single or multiple alarms at once
- **Alarm Status**: Track enabled/disabled status of alarms
- **Persistent Storage**: All alarms are saved to SQLite database

### Audio Control
- **Custom Audio Files**: Select custom ringtones or audio files using file picker
- **Default Alarm Tone**: Pre-configured default alarm.mp3 in assets
- **Volume Control**: Set volume levels (0.0 - 1.0)
- **Staircase Volume Fade**: Gradual volume increase in steps:
  - 0s: 10% volume
  - 20s: 30% volume
  - 50s: 50% volume
  - 70s: 70% volume
  - 100s: 90% volume
- **Loop Audio**: Option to continuously loop audio until alarm is stopped
- **Volume Enforcement**: Force volume to set level regardless of device settings

### Vibration & Notification
- **Vibration Control**: Toggle vibration on/off for alarms
- **Custom Notifications**: Display custom titles and body text
- **Stop Button**: Built-in notification button to dismiss alarm

### User Interface
- **Home Page**: View all alarms in a list with status indicators
- **Alarm Creation Page**: Dedicated interface for creating new alarms
- **Time Selection**: Intuitive time picker with 12/24 hour format support
- **Multi-Select**: Select and delete multiple alarms at once
- **Dark Theme**: Material Design 3 with deep purple color scheme

### Time Management
- **12-Hour Format Display**: Clear AM/PM display in notifications
- **24-Hour Internal Storage**: Proper time handling and database storage
- **Day-Based Scheduling**: Support for day-based alarm scheduling

---

## 🛠 Tech Stack

### Framework & Language
- **Flutter**: 3.10.4 or higher
- **Dart**: Latest stable version

### Core Dependencies
- **Provider 6.1.5+1**: State management with ChangeNotifier pattern
- **Alarm 5.1.5**: Native alarm scheduling and management
- **SQLite 2.4.2**: Local database for persistent storage
- **File Picker 10.3.8**: Custom audio file selection


### Utilities
- **Intl 0.20.2**: Internationalization and number formatting
- **Permission Handler 12.0.1**: Runtime permissions management
- **Path Provider 2.1.5**: File system paths
- **Math Expressions 2.6.0**: Mathematical expression evaluation

### Development Tools
- **Flutter Launcher Icons 0.14.4**: App icon management
- **Rename App 1.6.5**: App branding utilities
- **Flutter Lints 6.0.0**: Code analysis

---

## 📁 Project Structure

```
alarm_app/
├── lib/
│   ├── main.dart                          # App entry point & theme configuration
│   ├── permissions.dart                   # Permission handling logic
│   ├── database/
│   │   └── db.dart                        # SQLite database helper class
│   ├── modules/
│   │   └── alarm_module.dart              # AlarmWrapper class & alarm logic
│   ├── pages/
│   │   ├── alarm_page/
│   │   │   ├── pages/
│   │   │   │   └── alarm_page.dart        # Alarm creation/editing UI
│   │   │   └── widgets/
│   │   │       ├── alarm_chooser.dart     # Time picker widget
│   │   │       ├── alarm_title.dart       # Title input widget
│   │   │       ├── pick_file.dart         # File picker widget
│   │   │       ├── time_phase_toggle.dart # AM/PM toggle
│   │   │       └── vibration.dart         # Vibration toggle
│   │   └── home/
│   │       ├── pages/
│   │       │   └── home_page.dart         # Main home screen
│   │       └── widgets/
│   │           └── alarm_containers.dart  # Alarm list item widget
│   ├── provider/
│   │   ├── alarm_configs.dart             # AlarmConfig state management
│   │   ├── del.dart                       # Delete provider for multi-select
│   │   └── edit.dart                      # Edit provider state
│   └── assets/
│       ├── images/                        # App images
│       └── ringtones/
│           └── alarm.mp3                  # Default alarm tone
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── web/                                   # Web platform files
├── linux/                                 # Linux platform files
├── macos/                                 # macOS platform files
├── windows/                               # Windows platform files
├── pubspec.yaml                           # Dependencies & project metadata
└── analysis_options.yaml                  # Linting configuration
```

---

## 📦 Installation

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK (included with Flutter)
- Android SDK (for Android development)
- Xcode (for iOS development)
- Git (for version control)

### Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/aditya7balotra/alarm_app.git
   cd alarm_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Build for Production**
   - Android: `flutter build apk`
   - iOS: `flutter build ios`

---

## 📚 Dependencies

### Direct Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| alarm | 5.1.5 | Core alarm scheduling |
| sqflite | 2.4.2 | Local database |
| provider | 6.1.5+1 | State management |
| file_picker | 10.3.8 | Audio file selection |
| intl | 0.20.2 | Number formatting |
| permission_handler | 12.0.1 | Runtime permissions |
| path_provider | 2.1.5 | File paths |
| math_expressions | 2.6.0 | Math operations |
| material_symbols_icons | 4.2801.0 | Icon library |

---

## 🎨 Key Features Explained

### 1. **AlarmWrapper Module** (`lib/modules/alarm_module.dart`)

The `AlarmWrapper` class is the core data model that encapsulates all alarm-related functionality:

```dart
AlarmWrapper({
  required DateTime datetime,
  String? audioPath,
  String? title,
  bool loopAudio = false,
  bool vibrate = true,
  double? volume = 0.9,
  bool enforceVolume = false,
  List<VolumeFadeStep>? fadeSteps,
})
```

**Key Methods:**
- `setAlarm(int id)`: Creates and schedules an alarm
- `stopAlarm(int id)`: Stops a specific alarm
- `stopAllAlarms()`: Stops all active alarms

**Volume Fade Feature:**
The app implements a staircase volume fade effect that gradually increases alarm volume:
```
Duration → Volume
0s → 10%
20s → 30%
50s → 50%
70s → 70%
100s → 90%
```

### 2. **State Management with Provider** (`lib/provider/`)

The app uses Provider pattern for reactive state management:

- **AlarmConfig**: Manages alarm creation and configuration
- **deleteProvider**: Handles multi-select deletion functionality
- **Edit**: Manages alarm editing state

### 3. **Database Operations** (`lib/database/db.dart`)

Uses SQLite with the following operations:
- `createAlarm()`: Add new alarm to database
- `delAlarm(id)`: Delete alarm by ID
- `updateAlarm()`: Update existing alarm
- `getData()`: Retrieve all alarms
- `getAlarmById(id)`: Fetch specific alarm

### 4. **Permissions System** (`lib/permissions.dart`)

Handles runtime permissions:
- Notification permissions
- Vibration permissions
- File access permissions

---

## 🚀 Usage Guide

### Creating an Alarm

1. Navigate to the Home Page
2. Tap the "+" or "Create Alarm" button
3. Fill in the alarm details:
   - **Time**: Select desired hour and minute
   - **Title**: Enter a custom alarm name
   - **Audio File**: Choose a ringtone or custom audio
   - **Vibration**: Toggle vibration on/off
4. Tap "Done" to save and schedule the alarm

### Editing an Alarm

1. Tap on an alarm in the list
2. Modify desired settings
3. Tap "Done" to save changes

### Deleting Alarms

- **Single Delete**: long-press an alarm
- **Multi-Delete**: 
  - Long-press to select multiple alarms
  - Tap the delete button to remove selected alarms

### Customizing Audio

1. Tap "Pick File" in alarm creation
2. Browse and select an audio file from your device
3. File path is saved to the alarm

---

## 🏗 Architecture

### Design Pattern: Provider + MVVM

**Model Layer:**
- `AlarmWrapper`: Data model for alarms
- `DatabaseHelper`: Database operations

**View Layer:**
- Home Page: List display
- Alarm Page: Creation/editing interface
- Widgets: Reusable UI components

**ViewModel/Provider Layer:**
- `AlarmConfig`: Business logic for alarm management
- `deleteProvider`: Multi-select logic
- `Edit`: Edit state management

### Data Flow

1. User creates alarm → AlarmPage collects input
2. AlarmConfig provider receives data → Validates
3. AlarmWrapper creates AlarmSettings → Schedules with alarm package
4. DatabaseHelper saves to SQLite → Persistent storage
5. Home page updates via Provider notification

---

## 🗄 Database Schema

### Alarm Table

```sql
CREATE TABLE alarm (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  hour INTEGER NOT NULL,
  minute INTEGER NOT NULL,
  vibrate INTEGER,         -- 0 = off, 1 = on
  tone_path TEXT,          -- Path to custom audio file
  days INTEGER,            -- Day-based scheduling
  title TEXT,              -- Alarm name/description
  enabled INTEGER          -- 0 = disabled, 1 = enabled
);
```

---

## 🎯 Future Enhancements

Potential features for future versions:
- Recurring alarms (daily, weekly, etc.)
- Sleep timer functionality
- Alarm snooze with configurable intervals
- Weather-based alarm notifications
- Alarm statistics and history
- Custom notification sounds
- Theme customization
- Multi-language support
- Cloud backup
- Alarms sync across devices

---


---

## 👤 Developer Notes

- The app is optimized for Android and iOS platforms
- Supports Flutter 3.10.4 and higher
- Uses Material Design 3 for modern UI
- All data persists locally via SQLite
- No internet connectivity required for core functionality

---

## 🐛 Troubleshooting

### Alarm not playing sound
- Ensure notification permission is granted
- Check if audio file path is valid
- Verify volume is not muted

### Database errors
- Clear app data and reinstall
- Check SQLite compatibility
- Ensure proper permissions for file access

### Permissions not granted
- Check app settings on device
- Re-request permissions in app
- Restart app after permission change

---

## 📞 Support

For issues or feature requests, please refer to the project repository or contact the development team.

---

**Last Updated:** January 2026
**Version:** 1.0.0
