# 📰 Flutter News App

A modern Flutter news application with AI-powered chatbot, offline support, and Firebase authentication.

## 📋 Project Overview

This application is a full-featured news reader built with Flutter that includes:

- **Authentication**: Google Sign-In and Guest Login via Firebase
- **News Feed**: Real-time news from NewsAPI with category filtering
- **AI Chatbot**: Powered by Google Gemini AI with image recognition support
- **Offline Mode**: SQLite-based caching for news articles and chat history
- **Clean Architecture**: Organized codebase using GetX for state management

## 🚀 Installation Instructions

### Prerequisites

- **Flutter Version**: 3.38.4 (managed via FVM)
- **Dart SDK**: ^3.10.3

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd test_project
   ```

2. **Install FVM (Flutter Version Management)** - Optional but recommended
   ```bash
   dart pub global activate fvm
   fvm install
   fvm use
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure environment variables**
   
   Copy the example environment file and add your API keys:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file with your keys:
   ```env
   NEWS_API_KEY=your_newsapi_key_here
   GEMINI_API_KEY=your_gemini_api_key_here
   ```
   
   - Get NewsAPI key from: [https://newsapi.org](https://newsapi.org)
   - Get Gemini API key from: [https://aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)

5. **Configure Firebase**
   
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable **Authentication** with Google Sign-In and Anonymous providers
   - Download `google-services.json` and place it in `android/app/`
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`
   - Update `lib/firebase_options.dart` with your Firebase configuration

6. **Add SHA-1 Key for Google Sign-In (Android)**
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Add the SHA-1 fingerprint to your Firebase project settings.

## ▶️ Run Instructions

### Development

```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

The APK will be generated at:
- Debug: `build/app/outputs/apk/debug/app-debug.apk`
- Release: `build/app/outputs/apk/release/app-release.apk`

## 📁 Folder Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
└── app/
    ├── bindings/               # Dependency injection
    ├── controllers/            # Business logic (GetX Controllers)
    │   ├── auth_controller.dart
    │   ├── chat_controller.dart
    │   ├── home_controller.dart
    │   ├── profile_controller.dart
    │   └── splash_controller.dart
    ├── core/
    │   ├── database/           # SQLite database
    │   │   ├── dao/            # Data Access Objects
    │   │   │   ├── article_dao.dart
    │   │   │   └── chat_message_dao.dart
    │   │   └── database_helper.dart
    │   ├── network/            # Network utilities
    │   └── theme/              # App theming
    ├── models/                 # Data models
    │   └── article.dart
    ├── routes/                 # App navigation
    │   └── app_routes.dart
    ├── services/               # External services
    │   ├── auth_service.dart           # Firebase Auth
    │   ├── connectivity_service.dart   # Network monitoring
    │   └── news_api_service.dart       # NewsAPI integration
    ├── views/                  # UI screens
    │   ├── chat/               # AI Chatbot page
    │   ├── home/               # News list page
    │   ├── login/              # Authentication page
    │   ├── news_detail/        # Article detail page
    │   ├── profile/            # User profile page
    │   ├── splash/             # Splash screen
    │   └── webview/            # WebView for articles
    └── widgets/                # Reusable UI components
        ├── chat_bubble.dart
        └── news_card.dart
```

## ✅ Implemented Features

### Authentication
- [x] Google Sign-In integration
- [x] Guest/Anonymous login
- [x] User profile display
- [x] Secure sign-out

### News Page
- [x] Top headlines from NewsAPI
- [x] Category filtering (General, Business, Tech, Sports, Entertainment)
- [x] Pull-to-refresh functionality
- [x] News cards with image, title, and source
- [x] Offline mode indicator

### News Detail Page
- [x] Full article view
- [x] Article image display
- [x] Read in WebView option
- [x] Article metadata (author, date, source)

### Chatbot Page
- [x] AI-powered chatbot using Google Gemini
- [x] Text message support
- [x] Image attachment (Camera & Gallery)
- [x] Image recognition with AI response
- [x] Chat history persistence
- [x] Clear chat history option
- [x] Offline message queuing

### Offline Mode (SQLite)
- [x] News articles caching by category
- [x] Chat message persistence
- [x] Automatic fallback to cached data
- [x] Network connectivity monitoring

### State Management
- [x] GetX for reactive state management
- [x] Clean separation of concerns
- [x] Dependency injection via GetX bindings

## 🧪 Testing Instructions

### Integration Tests

```bash
# Run all integration tests
flutter test integration_test/

# Run with verbose output
flutter test integration_test/ --verbose
```

### Unit Tests

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

### Widget Tests

```bash
flutter test test/
```

> **Note**: Integration tests require a connected device or emulator.

## ⚠️ Additional Notes

### API Key Activation Delay

- **NewsAPI**: New API keys may take 5-10 minutes to activate. If you receive 401 errors, wait and try again.
- **Gemini API**: Usually activates immediately, but may require billing setup for high usage.

### Expected Offline Mode Behavior

- When offline, the app automatically displays cached articles from SQLite
- An "Offline Mode" indicator appears at the top of the news feed
- Chat messages are saved locally and displayed when offline
- AI chatbot responses are unavailable offline (user receives notification)
- When connection is restored, fresh data is fetched automatically

### Common Setup Issues

| Issue | Solution |
|-------|----------|
| `google-services.json` not found | Download from Firebase Console and place in `android/app/` |
| Google Sign-In fails on debug | Add debug SHA-1 key to Firebase project settings |
| NewsAPI returns 401 | Wait for API key activation or check key validity |
| Gemini API errors | Verify API key in `.env` and check quota limits |
| Build fails on iOS | Run `cd ios && pod install` and ensure `GoogleService-Info.plist` exists |
| Offline cache empty | Fetch news while online first to populate the cache |
| Emulator network issues | Check emulator network settings or use physical device |

### Firebase Configuration Checklist

- [ ] Create Firebase project
- [ ] Enable Authentication (Google + Anonymous)
- [ ] Add Android app with package name
- [ ] Add iOS app with bundle ID
- [ ] Download and add `google-services.json` (Android)
- [ ] Download and add `GoogleService-Info.plist` (iOS)
- [ ] Add SHA-1 fingerprint for Google Sign-In

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⚠️ Web (limited - some features may not work)

## 📄 License

This project is for educational purposes.

---

**Built with ❤️ using Flutter**
