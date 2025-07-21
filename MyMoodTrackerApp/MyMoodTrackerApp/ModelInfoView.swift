//
//  ModelInfoView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI
import Charts

struct ModelInfoView: View {
    @Environment(\.dismiss) private var dismiss
    private let moodPredictor = MoodPredictorCoreML()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("ML Model Information")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Understanding how your mood is predicted")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Model details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Model Details")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            InfoCard(
                                title: "Model Type",
                                value: "Enhanced Heuristic Classifier",
                                icon: "cpu",
                                color: .blue
                            )
                            
                            InfoCard(
                                title: "Features",
                                value: "3 Input Variables",
                                icon: "chart.bar.doc.horizontal",
                                color: .green
                            )
                            
                            InfoCard(
                                title: "Output",
                                value: "3 Mood Classes",
                                icon: "target",
                                color: .orange
                            )
                            
                            InfoCard(
                                title: "Confidence",
                                value: "Feature-based Scoring",
                                icon: "percent",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Feature importance chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Feature Importance")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let featureImportance = moodPredictor.getFeatureImportance()
                        let chartData = featureImportance.map { (key, value) in
                            FeatureImportanceData(feature: key, importance: value)
                        }.sorted { $0.importance > $1.importance }
                        
                        Chart(chartData) { item in
                            BarMark(
                                x: .value("Importance", item.importance),
                                y: .value("Feature", item.feature)
                            )
                            .foregroundStyle(by: .value("Feature", item.feature))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // How it works
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How It Works")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureExplanationCard(
                                title: "Sleep Hours",
                                description: "Optimal sleep (7-9 hours) boosts mood score. Poor sleep reduces it.",
                                icon: "bed.double.fill",
                                color: .blue
                            )
                            
                            FeatureExplanationCard(
                                title: "Step Count",
                                description: "Higher activity levels correlate with better mood. 10,000+ steps is excellent.",
                                icon: "figure.walk",
                                color: .green
                            )
                            
                            FeatureExplanationCard(
                                title: "Screen Time",
                                description: "Lower screen time generally indicates better mood. Under 2 hours is ideal.",
                                icon: "iphone",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Model info text
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Technical Details")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(moodPredictor.getModelInfo())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Future enhancements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Future Enhancements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            EnhancementRow(
                                title: "Core ML Integration",
                                description: "Replace heuristics with trained neural networks",
                                icon: "brain.head.profile"
                            )
                            
                            EnhancementRow(
                                title: "HealthKit Data",
                                description: "Automatic data collection from Apple Health",
                                icon: "heart.fill"
                            )
                            
                            EnhancementRow(
                                title: "Personalized Training",
                                description: "Model adapts to your personal patterns",
                                icon: "person.crop.circle"
                            )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("ML Model Info")
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
}

struct FeatureImportanceData: Identifiable {
    let id = UUID()
    let feature: String
    let importance: Double
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct FeatureExplanationCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct EnhancementRow: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ModelInfoView()
} 