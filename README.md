# 🥗 NutriNepal

**NutriNepal** is a comprehensive nutrition tracking mobile application built with Flutter, designed to help users in Nepal monitor their daily food intake, track macronutrients, and achieve their health goals. The app features food recognition, barcode scanning, personalized nutrition tracking, and detailed analytics.

## 📱 Features

### 🔐 Authentication & User Management
- **User Registration & Login**: Secure authentication system with JWT token-based authorization
- **Profile Management**: Create and update user profiles with personalized nutrition goals
- **Persistent Sessions**: Automatic token validation and session management

### 🍽️ Food Tracking
- **Extensive Food Database**: Search and browse from a comprehensive database of Nepali and international foods
- **Multi-language Support**: Food names available in both English and Nepali
- **Detailed Nutritional Information**: View calories, protein, fat, and carbohydrate content for each food item
- **Custom Servings**: Track food intake with customizable serving sizes and units

### 📸 Food Recognition & Scanning
- **Camera Integration**: Take photos of food items for instant recognition
- **Gallery Upload**: Upload existing photos for food identification
- **Barcode Scanner**: Scan product barcodes for quick nutritional information lookup
- **AI-Powered Detection**: Automatic food recognition using integrated food detection services

### 📊 Nutrition Dashboard
- **Daily Overview**: Real-time visualization of daily calorie and macronutrient consumption
- **Progress Indicators**: Beautiful circular progress bars showing consumption vs. goals
- **Macro Tracking**: Monitor protein, fat, and carbohydrate intake separately
- **Goal-Based Tracking**: Personalized daily nutrition goals based on user profile

### 📝 Logging System
- **Meal Logging**: Log food items with timestamps throughout the day
- **History Tracking**: View complete food consumption history
- **Date-Based Filtering**: Review logs by specific dates
- **Quick Add**: Fast food logging with saved favorites

### 👤 User Profile
- **Personal Information**: Manage username, email, age, height, and weight
- **Activity Level**: Set activity level (sedentary, light, moderate, active, very active)
- **Health Goals**: Define personal health objectives
- **Macro Goals Calculation**: Automatic calculation of daily macronutrient targets
- **Gender-Specific Settings**: Customized recommendations based on gender

### 🎨 UI/UX Features
- **Onboarding Screens**: Beautiful introductory screens for new users
- **Splash Screens**: Smooth app launch experience
- **Responsive Design**: Optimized for various screen sizes
- **Material Design**: Modern and intuitive interface
- **Custom Color Scheme**: Consistent branding with NutriNepal theme colors

## 🛠️ Technology Stack

### Frontend
- **Flutter SDK**: ^3.9.2
- **Dart**: Latest stable version
- **State Management**: Provider package for efficient state management
- **HTTP Client**: Dio & HTTP packages for API communication

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^0.13.6
  dio: ^5.4.0
  provider: ^6.1.1
  flutter_secure_storage: ^8.0.0
  shared_preferences: ^2.2.2
  image_picker: latest
  flutter_barcode_sdk: latest
  percent_indicator: ^4.2.5
  intl: latest
  smooth_page_indicator: ^1.1.0
```

### Backend Integration
- **API Base URL**: https://nutrinepal-node-api.onrender.com
- **Database**: MongoDB (cloud-hosted)
- **Deployment**: Render cloud platform
- **Authentication**: JWT-based token authentication

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/keshavroka55/NutriNepal-Flutter-group_project.git
   cd NutriNepal-Flutter-group_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons** (if needed)
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Configuration

The app is pre-configured to connect to the production backend API. If you need to test with a local backend:

1. Open `lib/NutriNepal/API/api_path.dart`
2. Uncomment the localhost URL and comment out the production URL:
   ```dart
   // For Android Emulator
   static const String baseUrl = "http://10.0.2.2:5000";
   
   // For Physical Device (replace with your IP)
   // static const String baseUrl = "http://192.168.1.70:5000";
   ```

## 📂 Project Structure

```
lib/
├── main.dart                          # Application entry point
├── NutriNepal/
│   ├── API/
│   │   ├── api_client.dart           # HTTP client configuration
│   │   └── api_path.dart             # API endpoint definitions
│   ├── Features/
│   │   ├── Auth2/                    # Authentication module
│   │   │   ├── auth_service.dart     # Auth service & state management
│   │   │   ├── login_page.dart       # Login screen
│   │   │   ├── register_page.dart    # Registration screen
│   │   │   └── user_model.dart       # User data model
│   │   ├── FoodScanning/             # Food recognition module
│   │   │   ├── food_recognition_screen.dart
│   │   │   ├── logmeal_service.dart  # Food detection API integration
│   │   │   └── scan_model.dart       # Food scan data models
│   │   ├── food/                     # Food management module
│   │   │   ├── food_api.dart         # Food API calls
│   │   │   ├── food_model.dart       # Food data model
│   │   │   ├── food_screen.dart      # Food list/search screen
│   │   │   └── edit_food_screen.dart # Food editing interface
│   │   ├── logs/                     # Logging module
│   │   │   ├── logs_api.dart         # Logs API calls
│   │   │   ├── user_log_model.dart   # Log data model
│   │   │   ├── log.dart              # Log entry screen
│   │   │   ├── logs_history_screen.dart
│   │   │   └── totals_screen.dart    # Daily totals view
│   │   ├── profile/                  # Profile module
│   │   │   ├── profile_api.dart      # Profile API calls
│   │   │   ├── profile_model.dart    # Profile data model
│   │   │   ├── profile_screen.dart   # Profile view
│   │   │   └── profile_update_screen.dart
│   │   ├── homepage.dart             # Main dashboard
│   │   └── homepage2.dart            # Enhanced dashboard
│   └── UI/
│       ├── splashes/                 # Onboarding screens
│       │   ├── screen-1.dart
│       │   ├── screen-2.dart
│       │   ├── screen-3.dart
│       │   ├── startscreen.dart
│       │   └── app_colors.dart       # Color theme definitions
│       └── widgets/
│           └── bottom_control_panel.dart  # Bottom navigation
├── assets/
│   ├── icons/                        # App icons
│   └── images/                       # Image assets
```

## 🌐 API Endpoints

The application integrates with the following backend endpoints:

### Authentication
- `POST /api/auth/v1/login` - User login
- `POST /api/auth/v1/register` - User registration

### Foods
- `GET /api/foods` - List and search foods (supports query params)
- `GET /api/foods/:id` - Get food details

### Logs
- `POST /api/logs/add` - Add new food log entry
- `GET /api/logs/history` - Get user's log history
- `GET /api/logs/totals` - Get daily totals

### Profile
- `GET /api/v1/user/profile` - Get user profile
- `PUT /api/v1/user/profile` - Update user profile

## 🎯 Usage Guide

1. **First Time Setup**
   - Launch the app and go through the onboarding screens
   - Create an account or login with existing credentials
   - Set up your profile with personal information and nutrition goals

2. **Tracking Food**
   - Use the search function to find foods
   - Scan barcodes on packaged products
   - Take photos of meals for automatic recognition
   - Log food items with custom serving sizes

3. **Monitoring Progress**
   - View the dashboard for daily nutrition summary
   - Check circular progress indicators for each macronutrient
   - Review history to see past consumption patterns
   - Adjust goals in your profile as needed

## 🤝 Contributing

Contributions are welcome! This is a group project for educational purposes.

### Development Team
- Project Contributors: Group Project Members

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is created for educational purposes as part of a group project.

## 🐛 Known Issues & Future Enhancements

### Current Limitations
- Food recognition is currently using demo/simulated data
- Some features may require active internet connection
- Backend API hosted on free tier may have cold start delays

### Planned Features
- Offline mode support
- Recipe management
- Meal planning
- Social features (share progress, challenges)
- Integration with fitness trackers
- Barcode database expansion
- Enhanced AI food recognition

## 📞 Support

For issues, questions, or suggestions:
- Open an issue in the GitHub repository
- Contact the development team

## 🙏 Acknowledgments

- Flutter and Dart teams for the excellent framework
- Backend API hosted on Render
- MongoDB for database services
- All open-source package contributors

---

**Built with ❤️ for Nepal's nutrition awareness**
