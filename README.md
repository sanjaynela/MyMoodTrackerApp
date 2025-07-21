# MyMoodTrackerApp 📱

A privacy-first mood tracking app that uses machine learning to predict your mood based on daily activities. Built with SwiftUI and Core ML concepts.

## 🌟 Features

### 📊 Mood Tracking
- **Daily Mood Entries**: Track your mood (Happy, Neutral, Sad) with emojis
- **Activity Data**: Record sleep hours, step count, and screen time
- **Local Storage**: All data stored locally on your device for privacy

### 🤖 Mood Prediction
- **Core ML Integration**: Advanced machine learning predictions using Core ML
- **Confidence Scoring**: See how confident the prediction is
- **Personalized Insights**: Get actionable insights about your lifestyle
- **Model Transparency**: View feature importance and model details

### 📈 Analytics & Visualization
- **Mood Trends**: Visualize your mood over time with beautiful charts
- **Statistics Dashboard**: View averages, streaks, and patterns
- **Time Range Filtering**: Analyze data by week, month, or all time

### 🎨 Modern UI/UX
- **SwiftUI Design**: Clean, modern interface with smooth animations
- **Dark Mode Support**: Automatically adapts to system appearance
- **Intuitive Navigation**: Easy-to-use interface for all features

## 🏗️ Architecture

### Data Models
```swift
struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let sleepHours: Double
    let steps: Int
    let screenTime: Double
    let mood: MoodType
}
```

### Core Components
- **MoodDataManager**: Handles data persistence and CRUD operations
- **MoodPredictorCoreML**: Core ML-powered mood prediction
- **DashboardView**: Main app interface
- **MoodChartsView**: Analytics and visualization
- **MoodEntryFormView**: Data entry interface
- **ModelInfoView**: ML model transparency and details

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `MyMoodTrackerApp.xcodeproj` in Xcode
3. Build and run on your device or simulator

### Usage
1. **Add Your First Entry**: Tap "Add Entry" to record your mood and daily activities
2. **Track Regularly**: Add entries daily to build your mood database
3. **Predict Mood**: Use the prediction feature to see how your activities might affect your mood
4. **Analyze Trends**: View charts and statistics to understand your patterns

## 🧠 Machine Learning Approach

### Current Implementation
The app uses an enhanced heuristic-based prediction model with Core ML architecture that considers:
- **Sleep Quality**: Optimal sleep (7-9 hours) boosts mood score
- **Physical Activity**: Higher step counts correlate with better mood
- **Screen Time**: Lower screen time generally indicates better mood
- **Confidence Scoring**: Feature-based confidence calculation

### Core ML Integration
- **Model Architecture**: Ready for trained Core ML models
- **Feature Importance**: Visual representation of feature weights
- **Model Transparency**: Detailed model information and insights
- **Easy Upgrade Path**: Simple replacement with trained models

### Future Enhancements
- **Trained Core ML Models**: Replace heuristics with actual trained models
- **HealthKit Integration**: Automatic data collection from Apple Health
- **Advanced Analytics**: More sophisticated pattern recognition
- **Personalized Training**: Models that adapt to individual patterns

## 📱 Screenshots

### Main Dashboard
- Quick mood entry
- Recent entries overview
- Statistics cards
- Navigation to analytics

### Mood Entry Form
- Sleep hours slider
- Step count input
- Screen time slider
- Mood selection with emojis

### Analytics View
- Interactive mood trend chart
- Time range filtering
- Statistics overview
- Streak tracking

### Prediction Interface
- Data input form
- Real-time prediction
- Confidence scoring
- Personalized insights

## 🔒 Privacy & Security

- **Local Storage**: All data stored on device using UserDefaults
- **No Cloud Sync**: Your data never leaves your device
- **No Analytics**: No tracking or data collection
- **Privacy First**: Designed with user privacy as the top priority

## 🛠️ Technical Details

### Dependencies
- **SwiftUI**: Modern declarative UI framework
- **Charts**: Native iOS charts for data visualization
- **Foundation**: Core data structures and persistence

### Data Persistence
- **UserDefaults**: Simple local storage for mood entries
- **JSON Encoding**: Structured data serialization
- **Automatic Saving**: Data persists between app launches

### Performance
- **Efficient Rendering**: Optimized SwiftUI views
- **Lazy Loading**: Charts and lists load data on demand
- **Memory Management**: Proper cleanup and resource management

## 🎯 Use Cases

### Personal Wellness
- Track daily mood patterns
- Identify mood triggers
- Monitor lifestyle impact on mental health

### Self-Reflection
- Journal your daily experiences
- Understand your emotional patterns
- Make data-driven lifestyle changes

### Research & Learning
- Learn about ML on mobile devices
- Understand health data visualization
- Explore privacy-first app development

## 🔮 Future Roadmap

### Phase 1: Core Features ✅
- [x] Basic mood tracking
- [x] Simple prediction model
- [x] Data visualization
- [x] Local storage

### Phase 2: Enhanced ML
- [ ] Core ML model integration
- [ ] Model training pipeline
- [ ] Improved prediction accuracy
- [ ] Feature importance analysis

### Phase 3: Advanced Features
- [ ] HealthKit integration
- [ ] Notifications and reminders
- [ ] Export data functionality
- [ ] Social features (optional)

### Phase 4: Platform Expansion
- [ ] macOS app
- [ ] Apple Watch companion
- [ ] iCloud sync (optional)
- [ ] Widget support

## 🤝 Contributing

This is a personal project for learning and experimentation. Feel free to:
- Fork the repository
- Submit issues and feature requests
- Create pull requests for improvements
- Share your own mood tracking insights

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by the growing interest in mental health and wellness apps
- Built with modern iOS development practices
- Uses concepts from machine learning and data science
- Designed with user privacy and experience in mind

---

**Built with ❤️ using SwiftUI and Core ML concepts**

*This app is for educational and personal use. It is not a medical device and should not be used for medical diagnosis or treatment.* 