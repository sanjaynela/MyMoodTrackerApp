//
//  MoodPredictor.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import Foundation

class MoodPredictor {
    
    // Simple heuristic-based prediction model
    // In a real app, this would be replaced with a Core ML model
    func predictMood(sleepHours: Double, steps: Int, screenTime: Double) -> MoodType {
        var score = 0
        
        // Sleep scoring (0-3 points)
        if sleepHours >= 7.0 && sleepHours <= 9.0 {
            score += 3 // Optimal sleep
        } else if sleepHours >= 6.0 && sleepHours <= 10.0 {
            score += 2 // Good sleep
        } else if sleepHours >= 5.0 && sleepHours <= 11.0 {
            score += 1 // Acceptable sleep
        }
        // 0 points for very poor sleep
        
        // Steps scoring (0-3 points)
        if steps >= 10000 {
            score += 3 // Excellent activity
        } else if steps >= 8000 {
            score += 2 // Good activity
        } else if steps >= 5000 {
            score += 1 // Moderate activity
        }
        // 0 points for low activity
        
        // Screen time scoring (0-2 points, inverted)
        if screenTime <= 2.0 {
            score += 2 // Low screen time (good)
        } else if screenTime <= 4.0 {
            score += 1 // Moderate screen time
        }
        // 0 points for high screen time (bad)
        
        // Convert score to mood prediction
        switch score {
        case 6...8:
            return .happy
        case 3...5:
            return .neutral
        default:
            return .sad
        }
    }
    
    func getPredictionConfidence(sleepHours: Double, steps: Int, screenTime: Double) -> Double {
        // Calculate confidence based on how clear the indicators are
        var confidence = 0.0
        
        // Sleep confidence
        if sleepHours >= 7.0 && sleepHours <= 9.0 {
            confidence += 0.4
        } else if sleepHours < 5.0 || sleepHours > 11.0 {
            confidence += 0.3
        } else {
            confidence += 0.2
        }
        
        // Steps confidence
        if steps >= 10000 || steps < 2000 {
            confidence += 0.3
        } else {
            confidence += 0.2
        }
        
        // Screen time confidence
        if screenTime <= 2.0 || screenTime >= 8.0 {
            confidence += 0.3
        } else {
            confidence += 0.2
        }
        
        return min(confidence, 1.0)
    }
} 