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
- Python 3.8+ (for model training)

### Installation & End-to-End ML Workflow

#### 1. **Train and Export the Core ML Model (Python)**
- Create and activate a virtual environment:
  ```bash
  python3 -m venv mood_tracker_env
  source mood_tracker_env/bin/activate
  pip install pandas numpy scikit-learn coremltools
  ```
- Run the training script to generate data, train the model, and export to Core ML:
  ```bash
  python train_mood_model.py
  # This will create MoodPredictor.mlmodel in your project directory
  ```
- (Optional) Test the model in Python:
  ```bash
  python test_coreml_model.py
  ```

#### 2. **Add the Model to Xcode**
- In Xcode, right-click your app folder > **Add Files to "MyMoodTrackerApp"** > select `MoodPredictor.mlmodel`
- Ensure "Copy items if needed" and your main target are checked
- Xcode will auto-generate a `MoodPredictor` Swift class

#### 3. **Build and Run the App**
- Open `MyMoodTrackerApp.xcodeproj` in Xcode
- Build and run on your device or simulator
- The app will use the Core ML model for all mood predictions

### Usage
1. **Add Your First Entry**: Tap "Add Entry" to record your mood and daily activities
2. **Track Regularly**: Add entries daily to build your mood database
3. **Predict Mood**: Use the prediction feature to see how your activities might affect your mood
4. **Analyze Trends**: View charts and statistics to understand your patterns

## 🔄 End-to-End ML Workflow

1. **Data Generation & Model Training (Python)**
   - `train_mood_model.py`: Generates realistic mood data, trains a Random Forest model, and converts it to Core ML format (`MoodPredictor.mlmodel`).
   - `test_coreml_model.py`: (Optional) Test the exported model in Python before using it in the app.
2. **Model Integration (Xcode)**
   - Add `MoodPredictor.mlmodel` to your Xcode project (see above).
   - Xcode auto-generates Swift classes for easy integration.
3. **App Usage (Swift)**
   - The app loads the Core ML model and uses it for all mood predictions.
   - All predictions are made on-device for privacy.

## 🧠 Machine Learning Approach

### Current Implementation
The app uses a trained Core ML model (Random Forest) that considers:
- **Sleep Quality**: Optimal sleep (7-9 hours) boosts mood score
- **Physical Activity**: Higher step counts correlate with better mood
- **Screen Time**: Lower screen time generally indicates better mood
- **Confidence Scoring**: ML-based probability calculation

### Core ML Integration
- **Model Training**: Done in Python using `train_mood_model.py`
- **Model Conversion**: Exported to `.mlmodel` using `coremltools`
- **Model Usage**: Integrated in Swift via the auto-generated `MoodPredictor` class
- **Feature Importance**: Visual representation in the app
- **Model Transparency**: Detailed model information and insights
- **Easy Retraining**: Just rerun the Python script and replace the `.mlmodel` file

### Future Enhancements
- **Personalized Training**: Models that adapt to individual patterns
- **HealthKit Integration**: Automatic data collection from Apple Health
- **Advanced Analytics**: More sophisticated pattern recognition

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
- **Python**: For model training and conversion

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
- [x] Core ML model integration
- [x] Data visualization
- [x] Local storage

### Phase 2: Enhanced ML
- [x] Model training pipeline (Python)
- [x] Improved prediction accuracy
- [x] Feature importance analysis

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

---

## 📚 Further Reading

- [CoreML_Integration_Summary.md](./CoreML_Integration_Summary.md):
  - A concise summary of the end-to-end workflow for generating, testing, and integrating your Core ML model into the app.
- [CreateML_Instructions.md](./CreateML_Instructions.md):
  - Step-by-step instructions for both the Python-based and Create ML (Xcode GUI) approaches to model creation and integration. 