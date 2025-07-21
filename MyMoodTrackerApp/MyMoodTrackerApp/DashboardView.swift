//
//  DashboardView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var showingMoodForm = false
    @State private var showingPrediction = false
    @State private var predictionInput = PredictionInput()
    
    struct PredictionInput {
        var sleepHours: Double = 7.0
        var steps: String = ""
        var screenTime: Double = 2.0
    }
    
    private let moodPredictor = MoodPredictorCoreML()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How are you feeling today?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Track your mood and discover patterns")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Quick action buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            showingMoodForm = true
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                Text("Add Entry")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingPrediction = true
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "brain.head.profile")
                                    .font(.title)
                                Text("Predict Mood")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Today's summary
                    if let todayEntry = getTodayEntry() {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Today's Entry")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(todayEntry.mood.emoji)
                                            .font(.title2)
                                        Text(todayEntry.mood.rawValue)
                                            .font(.headline)
                                    }
                                    Text("Sleep: \(todayEntry.sleepHours, specifier: "%.1f")h")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Steps: \(todayEntry.steps)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Screen: \(todayEntry.screenTime, specifier: "%.1f")h")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Mood Score")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(todayEntry.moodScore)/2")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(todayEntry.mood.color)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recent entries
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Entries")
                                .font(.headline)
                            Spacer()
                            NavigationLink("See All", destination: MoodListView(dataManager: dataManager))
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        let recentEntries = dataManager.getRecentEntries(limit: 3)
                        if recentEntries.isEmpty {
                            VStack {
                                Image(systemName: "list.bullet.clipboard")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No entries yet")
                                    .foregroundColor(.gray)
                                Text("Add your first mood entry to get started")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                        } else {
                            ForEach(recentEntries) { entry in
                                HStack {
                                    Text(entry.mood.emoji)
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(entry.mood.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text(entry.date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(entry.sleepHours, specifier: "%.1f")h")
                                            .font(.caption)
                                        Text("\(entry.steps) steps")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Quick stats
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Stats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            QuickStatCard(
                                title: "7-Day Avg",
                                value: String(format: "%.1f", dataManager.getAverageMoodScore(for: 7)),
                                icon: "chart.line.uptrend.xyaxis",
                                color: .blue
                            )
                            
                            QuickStatCard(
                                title: "Total Entries",
                                value: "\(dataManager.moodEntries.count)",
                                icon: "list.bullet",
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Mood Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MoodChartsView(dataManager: dataManager)) {
                        Image(systemName: "chart.bar")
                    }
                }
            }
        }
        .sheet(isPresented: $showingMoodForm) {
            MoodEntryFormView(dataManager: dataManager)
        }
        .sheet(isPresented: $showingPrediction) {
            MoodPredictionView(dataManager: dataManager)
        }
    }
    
    private func getTodayEntry() -> MoodEntry? {
        let calendar = Calendar.current
        return dataManager.moodEntries.first { entry in
            calendar.isDate(entry.date, inSameDayAs: Date())
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView(dataManager: MoodDataManager())
} 