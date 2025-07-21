#!/usr/bin/env python3
"""
Test script for the Core ML model
"""

import coremltools as ct

def test_coreml_model():
    """Test the Core ML model with sample inputs."""
    
    try:
        # Load the model
        model = ct.models.MLModel("MyMoodTrackerApp/MyMoodTrackerApp/MoodPredictor.mlmodel")
        print("✅ Core ML model loaded successfully!")
        
        # Test cases
        test_cases = [
            (8.0, 10000, 2.0),  # Should predict Happy
            (5.0, 3000, 8.0),   # Should predict Sad
            (7.0, 6000, 4.0),   # Should predict Neutral
            (6.5, 8000, 3.0),   # Should predict Happy
            (4.5, 2000, 9.0),   # Should predict Sad
        ]
        
        print("\n🧪 Testing Core ML model predictions:")
        print("-" * 50)
        
        for i, (sleep, steps, screen) in enumerate(test_cases, 1):
            prediction = model.predict({
                'sleep_hours': sleep,
                'steps': steps,
                'screen_time': screen
            })
            
            mood = prediction['mood']
            confidence = prediction['classProbability'][mood]
            
            print(f"Test {i}: Sleep: {sleep}h, Steps: {steps}, Screen: {screen}h")
            print(f"  → Predicted: {mood} (Confidence: {confidence:.3f})")
            print()
        
        print("✅ All tests completed successfully!")
        
    except Exception as e:
        print(f"❌ Error testing Core ML model: {e}")

if __name__ == "__main__":
    test_coreml_model() 