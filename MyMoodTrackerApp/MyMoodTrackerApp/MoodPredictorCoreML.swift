//
//  MoodPredictorCoreML.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import Foundation
import CoreML

class MoodPredictorCoreML {
    
    // Core ML model for mood prediction
    private var model: MoodPredictor?
    
    init() {
        // Temporarily disable Core ML model to fix build issues
        // TODO: Re-enable after properly adding model to Xcode project
        print("⚠️ Core ML model temporarily disabled - using heuristic model")
        print("📋 Follow instructions in add_coreml_to_xcode.md to enable Core ML")
    }
    
    func predictMood(sleepHours: Double, steps: Int, screenTime: Double) -> (MoodType, Double) {
        // Temporarily use only heuristic model until Core ML is properly added
        return predictMoodHeuristic(sleepHours: sleepHours, steps: steps, screenTime: screenTime)
    }
    
    private func predictMoodHeuristic(sleepHours: Double, steps: Int, screenTime: Double) -> (MoodType, Double) {
        var score = 0.0
        var confidence = 0.0
        
        // Sleep scoring (0-3 points)
        if sleepHours >= 7.0 && sleepHours <= 9.0 {
            score += 3.0 // Optimal sleep
            confidence += 0.4
        } else if sleepHours >= 6.0 && sleepHours <= 10.0 {
            score += 2.0 // Good sleep
            confidence += 0.3
        } else if sleepHours >= 5.0 && sleepHours <= 11.0 {
            score += 1.0 // Acceptable sleep
            confidence += 0.2
        } else {
            confidence += 0.3 // Very clear indicator
        }
        
        // Steps scoring (0-3 points)
        if steps >= 10000 {
            score += 3.0 // Excellent activity
            confidence += 0.3
        } else if steps >= 8000 {
            score += 2.0 // Good activity
            confidence += 0.25
        } else if steps >= 5000 {
            score += 1.0 // Moderate activity
            confidence += 0.2
        } else {
            confidence += 0.3 // Very clear indicator
        }
        
        // Screen time scoring (0-2 points, inverted)
        if screenTime <= 2.0 {
            score += 2.0 // Low screen time (good)
            confidence += 0.3
        } else if screenTime <= 4.0 {
            score += 1.0 // Moderate screen time
            confidence += 0.2
        } else {
            confidence += 0.3 // Very clear indicator
        }
        
        // Normalize confidence
        confidence = min(confidence, 1.0)
        
        // Convert score to mood prediction with some randomness for realism
        let randomFactor = Double.random(in: -0.5...0.5)
        let finalScore = score + randomFactor
        
        let predictedMood: MoodType
        if finalScore >= 6.0 {
            predictedMood = .happy
        } else if finalScore >= 3.0 {
            predictedMood = .neutral
        } else {
            predictedMood = .sad
        }
        
        return (predictedMood, confidence)
    }
    
    func getFeatureImportance() -> [String: Double] {
        // Return actual feature importance from the trained model
        return [
            "steps": 0.511,
            "sleep_hours": 0.285,
            "screen_time": 0.204
        ]
    }
    
    func getModelInfo() -> String {
        if model != nil {
            return """
            Model Type: Core ML Random Forest Classifier
            Features: Sleep Hours, Steps, Screen Time
            Output: Mood Classification (Happy/Neutral/Sad)
            Training Data: 2000 samples
            Accuracy: 80% (test set)
            Confidence: ML-based probability scores
            """
        } else {
            return """
            Model Type: Enhanced Heuristic Classifier (Fallback)
            Features: Sleep Hours, Steps, Screen Time
            Output: Mood Classification (Happy/Neutral/Sad)
            Confidence: Based on feature clarity
            """
        }
    }
}

// MARK: - Core ML Model Integration (Future Implementation)
/*
 To integrate a real Core ML model:

 1. Create a .mlmodel file using Create ML in Xcode:
    - Open Xcode
    - File > New > File > Create ML Model
    - Choose "Classifier" for mood prediction
    - Import your training data
    - Train the model
    - Save as MoodPredictor.mlmodel

 2. Add the .mlmodel file to your Xcode project

 3. Replace the heuristic logic with:
 
 class MoodPredictorCoreML {
     private var model: MoodPredictor?
     
     init() {
         do {
             let config = MLModelConfiguration()
             model = try MoodPredictor(configuration: config)
         } catch {
             print("Failed to load model: \(error)")
         }
     }
     
     func predictMood(sleepHours: Double, steps: Int, screenTime: Double) -> (MoodType, Double) {
         guard let model = model else {
             return (.neutral, 0.0)
         }
         
         do {
             let input = MoodPredictorInput(
                 sleep_hours: sleepHours,
                 steps: Double(steps),
                 screen_time: screenTime
             )
             
             let prediction = try model.prediction(input: input)
             
             let moodType: MoodType
             switch prediction.mood {
             case "Happy": moodType = .happy
             case "Neutral": moodType = .neutral
             case "Sad": moodType = .sad
             default: moodType = .neutral
             }
             
             // Get confidence from prediction
             let confidence = prediction.confidence[prediction.mood] ?? 0.0
             
             return (moodType, confidence)
         } catch {
             print("Prediction failed: \(error)")
             return (.neutral, 0.0)
         }
     }
 }
 */ 