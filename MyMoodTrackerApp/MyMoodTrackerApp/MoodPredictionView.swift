//
//  MoodPredictionView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI

struct MoodPredictionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dataManager: MoodDataManager
    
    @State private var sleepHours: Double = 7.0
    @State private var steps: String = ""
    @State private var screenTime: Double = 2.0
    @State private var showingPrediction = false
    @State private var predictedMood: MoodType = .neutral
    @State private var confidence: Double = 0.0
    
    private let moodPredictor = MoodPredictor()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("Mood Prediction")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Enter your data to predict your mood")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Input form
                    VStack(spacing: 20) {
                        // Sleep input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sleep Hours")
                                .font(.headline)
                            
                            HStack {
                                Text("\(sleepHours, specifier: "%.1f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("hours")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            Slider(value: $sleepHours, in: 0...12, step: 0.5)
                                .accentColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Steps input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.headline)
                            
                            TextField("Enter your step count", text: $steps)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.title2)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Screen time input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Screen Time")
                                .font(.headline)
                            
                            HStack {
                                Text("\(screenTime, specifier: "%.1f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                Text("hours")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                            Slider(value: $screenTime, in: 0...24, step: 0.5)
                                .accentColor(.orange)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Prediction button
                    Button(action: {
                        predictMood()
                    }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Predict My Mood")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(steps.isEmpty)
                    
                    // Prediction result
                    if showingPrediction {
                        VStack(spacing: 16) {
                            Text("Predicted Mood")
                                .font(.headline)
                            
                            VStack(spacing: 12) {
                                Text(predictedMood.emoji)
                                    .font(.system(size: 80))
                                
                                Text(predictedMood.rawValue)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(predictedMood.color)
                                
                                Text("Confidence: \(Int(confidence * 100))%")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(predictedMood.color.opacity(0.1))
                            .cornerRadius(16)
                            
                            // Insights
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Insights")
                                    .font(.headline)
                                
                                Text(getInsights())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Mood Prediction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func predictMood() {
        guard let stepsInt = Int(steps), stepsInt >= 0 else { return }
        
        predictedMood = moodPredictor.predictMood(
            sleepHours: sleepHours,
            steps: stepsInt,
            screenTime: screenTime
        )
        
        confidence = moodPredictor.getPredictionConfidence(
            sleepHours: sleepHours,
            steps: stepsInt,
            screenTime: screenTime
        )
        
        showingPrediction = true
    }
    
    private func getInsights() -> String {
        guard let stepsInt = Int(steps) else { return "" }
        
        var insights: [String] = []
        
        if sleepHours < 6.0 {
            insights.append("• Low sleep may affect your mood negatively")
        } else if sleepHours >= 7.0 && sleepHours <= 9.0 {
            insights.append("• Good sleep duration should help your mood")
        }
        
        if stepsInt < 5000 {
            insights.append("• Low activity levels might impact your mood")
        } else if stepsInt >= 8000 {
            insights.append("• High activity levels should boost your mood")
        }
        
        if screenTime > 6.0 {
            insights.append("• High screen time might affect your mood")
        }
        
        if insights.isEmpty {
            insights.append("• Your data suggests a balanced lifestyle")
        }
        
        return insights.joined(separator: "\n")
    }
}

#Preview {
    MoodPredictionView(dataManager: MoodDataManager())
} 