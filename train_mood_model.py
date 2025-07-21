#!/usr/bin/env python3
"""
Mood Tracker Core ML Model Training Script
Generates sample data and trains a machine learning model for mood prediction.
"""

import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import coremltools as ct
import datetime
import random

def generate_sample_data(num_samples=1000):
    """Generate realistic sample mood data for training."""
    
    np.random.seed(42)  # For reproducible results
    
    data = []
    
    for i in range(num_samples):
        # Generate realistic sleep hours (4-12 hours, normal distribution around 7.5)
        sleep_hours = np.random.normal(7.5, 1.5)
        sleep_hours = np.clip(sleep_hours, 4.0, 12.0)
        
        # Generate realistic step counts (1000-20000, skewed towards lower values)
        steps = int(np.random.exponential(5000))
        steps = np.clip(steps, 1000, 20000)
        
        # Generate realistic screen time (1-10 hours, normal distribution around 4)
        screen_time = np.random.normal(4.0, 2.0)
        screen_time = np.clip(screen_time, 1.0, 10.0)
        
        # Generate mood based on the features (with some randomness)
        mood_score = 0
        
        # Sleep impact (0-3 points)
        if 7.0 <= sleep_hours <= 9.0:
            mood_score += 3
        elif 6.0 <= sleep_hours <= 10.0:
            mood_score += 2
        elif 5.0 <= sleep_hours <= 11.0:
            mood_score += 1
        
        # Steps impact (0-3 points)
        if steps >= 10000:
            mood_score += 3
        elif steps >= 8000:
            mood_score += 2
        elif steps >= 5000:
            mood_score += 1
        
        # Screen time impact (0-2 points, inverted)
        if screen_time <= 2.0:
            mood_score += 2
        elif screen_time <= 4.0:
            mood_score += 1
        
        # Add some randomness to make it more realistic
        mood_score += np.random.normal(0, 0.5)
        mood_score = np.clip(mood_score, 0, 8)
        
        # Convert score to mood type
        if mood_score >= 6:
            mood = "Happy"
        elif mood_score >= 3:
            mood = "Neutral"
        else:
            mood = "Sad"
        
        # Generate a date within the last year
        days_ago = random.randint(0, 365)
        date = datetime.datetime.now() - datetime.timedelta(days=days_ago)
        
        data.append({
            'date': date,
            'sleep_hours': round(sleep_hours, 1),
            'steps': steps,
            'screen_time': round(screen_time, 1),
            'mood': mood,
            'mood_score': int(mood_score)
        })
    
    return pd.DataFrame(data)

def train_model(df):
    """Train a Random Forest model on the mood data."""
    
    # Prepare features and target
    X = df[['sleep_hours', 'steps', 'screen_time']].values
    y = df['mood'].values
    
    # Split the data
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )
    
    # Scale the features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train the model
    model = RandomForestClassifier(
        n_estimators=100,
        max_depth=10,
        random_state=42,
        class_weight='balanced'
    )
    
    model.fit(X_train_scaled, y_train)
    
    # Evaluate the model
    train_score = model.score(X_train_scaled, y_train)
    test_score = model.score(X_test_scaled, y_test)
    
    print(f"Training accuracy: {train_score:.3f}")
    print(f"Test accuracy: {test_score:.3f}")
    
    # Feature importance
    feature_names = ['sleep_hours', 'steps', 'screen_time']
    importances = model.feature_importances_
    
    print("\nFeature Importance:")
    for name, importance in zip(feature_names, importances):
        print(f"  {name}: {importance:.3f}")
    
    return model, scaler

def convert_to_coreml(model, scaler):
    """Convert the trained model to Core ML format."""
    
    # Create a pipeline that includes scaling
    from sklearn.pipeline import Pipeline
    pipeline = Pipeline([
        ('scaler', scaler),
        ('classifier', model)
    ])
    
    # Convert to Core ML using the correct approach for scikit-learn
    coreml_model = ct.converters.sklearn.convert(
        pipeline,
        input_features=["sleep_hours", "steps", "screen_time"],
        output_feature_names="mood"
    )
    
    # Add metadata
    coreml_model.author = "Sanjay Nelagadde"
    coreml_model.license = "MIT"
    coreml_model.short_description = "Mood prediction model based on sleep, steps, and screen time"
    coreml_model.version = "1.0"
    
    return coreml_model

def main():
    """Main function to generate data, train model, and save Core ML model."""
    
    print("🎯 Generating sample mood data...")
    df = generate_sample_data(2000)  # Generate 2000 samples
    
    print(f"Generated {len(df)} samples")
    print("\nData distribution:")
    print(df['mood'].value_counts())
    
    print("\n📊 Sample data:")
    print(df.head())
    
    # Save the sample data
    df.to_csv('sample_mood_data.csv', index=False)
    print("\n💾 Saved sample data to 'sample_mood_data.csv'")
    
    print("\n🤖 Training Random Forest model...")
    model, scaler = train_model(df)
    
    print("\n🔄 Converting to Core ML format...")
    coreml_model = convert_to_coreml(model, scaler)
    
    # Save the Core ML model
    coreml_model.save("MoodPredictor.mlmodel")
    print("✅ Saved Core ML model to 'MoodPredictor.mlmodel'")
    
    # Test the model
    print("\n🧪 Testing the model with sample inputs:")
    test_inputs = [
        (8.0, 10000, 2.0),  # Good sleep, high steps, low screen time
        (5.0, 3000, 8.0),   # Poor sleep, low steps, high screen time
        (7.0, 6000, 4.0),   # Moderate values
    ]
    
    for sleep, steps, screen in test_inputs:
        prediction = coreml_model.predict({
            'sleep_hours': sleep,
            'steps': steps,
            'screen_time': screen
        })
        print(f"  Sleep: {sleep}h, Steps: {steps}, Screen: {screen}h → {prediction['mood']}")
    
    print("\n🎉 Model training complete!")
    print("📱 You can now add 'MoodPredictor.mlmodel' to your Xcode project")

if __name__ == "__main__":
    main() 