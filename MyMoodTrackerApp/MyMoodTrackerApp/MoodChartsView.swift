//
//  MoodChartsView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI
import Charts

struct MoodChartsView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return 365
            }
        }
    }
    
    var filteredEntries: [MoodEntry] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        
        return dataManager.moodEntries
            .filter { $0.date >= startDate }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time range picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Mood trend chart
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mood Trend")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if filteredEntries.isEmpty {
                            VStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No data to display")
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                        } else {
                            Chart(filteredEntries) { entry in
                                LineMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Mood Score", entry.moodScore)
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                
                                PointMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Mood Score", entry.moodScore)
                                )
                                .foregroundStyle(entry.mood.color)
                                .symbolSize(100)
                            }
                            .chartYScale(domain: 0...2)
                            .chartYAxis {
                                AxisMarks(values: [0, 1, 2]) { value in
                                    AxisValueLabel {
                                        switch value.as(Int.self) {
                                        case 0: Text("Sad")
                                        case 1: Text("Neutral")
                                        case 2: Text("Happy")
                                        default: Text("")
                                        }
                                    }
                                }
                            }
                            .chartXAxis {
                                AxisMarks { value in
                                    AxisValueLabel {
                                        if let date = value.as(Date.self) {
                                            Text(date, style: .date)
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                            .frame(height: 200)
                            .padding(.horizontal)
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Statistics cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Average Mood",
                            value: String(format: "%.1f", dataManager.getAverageMoodScore(for: selectedTimeRange.days)),
                            icon: "heart.fill",
                            color: .pink
                        )
                        
                        StatCard(
                            title: "Entries",
                            value: "\(filteredEntries.count)",
                            icon: "list.bullet",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Best Day",
                            value: bestMoodDay,
                            icon: "star.fill",
                            color: .yellow
                        )
                        
                        StatCard(
                            title: "Streak",
                            value: "\(currentStreak)",
                            icon: "flame.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Mood Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var bestMoodDay: String {
        guard let bestEntry = filteredEntries.max(by: { $0.moodScore < $1.moodScore }) else {
            return "N/A"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: bestEntry.date)
    }
    
    private var currentStreak: Int {
        let sortedEntries = dataManager.moodEntries.sorted { $0.date > $1.date }
        var streak = 0
        let calendar = Calendar.current
        
        for i in 0..<sortedEntries.count {
            if i == 0 {
                streak = 1
            } else {
                let daysBetween = calendar.dateComponents([.day], from: sortedEntries[i].date, to: sortedEntries[i-1].date).day ?? 0
                if daysBetween == 1 {
                    streak += 1
                } else {
                    break
                }
            }
        }
        
        return streak
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    MoodChartsView(dataManager: MoodDataManager())
} 