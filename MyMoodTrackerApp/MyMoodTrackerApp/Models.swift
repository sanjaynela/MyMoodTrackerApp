//
//  Models.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import Foundation
import SwiftUI

// MARK: - Data Models
struct MoodEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let sleepHours: Double
    let steps: Int
    let screenTime: Double
    let mood: MoodType
    
    var moodScore: Int {
        switch mood {
        case .happy: return 2
        case .neutral: return 1
        case .sad: return 0
        }
    }
}

enum MoodType: String, Codable, CaseIterable {
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .neutral: return "😐"
        case .sad: return "😔"
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return .green
        case .neutral: return .orange
        case .sad: return .red
        }
    }
}

// MARK: - Data Manager
class MoodDataManager: ObservableObject {
    @Published var moodEntries: [MoodEntry] = []
    private let userDefaults = UserDefaults.standard
    private let moodEntriesKey = "MoodEntries"
    
    init() {
        loadMoodEntries()
    }
    
    func addMoodEntry(_ entry: MoodEntry) {
        moodEntries.append(entry)
        saveMoodEntries()
    }
    
    func deleteMoodEntry(_ entry: MoodEntry) {
        moodEntries.removeAll { $0.id == entry.id }
        saveMoodEntries()
    }
    
    private func saveMoodEntries() {
        if let encoded = try? JSONEncoder().encode(moodEntries) {
            userDefaults.set(encoded, forKey: moodEntriesKey)
        }
    }
    
    private func loadMoodEntries() {
        if let data = userDefaults.data(forKey: moodEntriesKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            moodEntries = decoded
        }
    }
    
    func getRecentEntries(limit: Int = 7) -> [MoodEntry] {
        return Array(moodEntries.sorted { $0.date > $1.date }.prefix(limit))
    }
    
    func getAverageMoodScore(for days: Int = 7) -> Double {
        let recentEntries = getRecentEntries(limit: days)
        guard !recentEntries.isEmpty else { return 0 }
        
        let totalScore = recentEntries.reduce(0) { $0 + $1.moodScore }
        return Double(totalScore) / Double(recentEntries.count)
    }
} 