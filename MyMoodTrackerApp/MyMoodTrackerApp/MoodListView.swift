//
//  MoodListView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI

struct MoodListView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var showingDeleteAlert = false
    @State private var entryToDelete: MoodEntry?
    
    var sortedEntries: [MoodEntry] {
        dataManager.moodEntries.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            List {
                if sortedEntries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No mood entries yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Add your first mood entry to start tracking")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(sortedEntries) { entry in
                        MoodEntryRow(entry: entry) {
                            entryToDelete = entry
                            showingDeleteAlert = true
                        }
                    }
                }
            }
            .navigationTitle("All Entries")
            .navigationBarTitleDisplayMode(.large)
            .alert("Delete Entry", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let entry = entryToDelete {
                        dataManager.deleteMoodEntry(entry)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this mood entry? This action cannot be undone.")
            }
        }
    }
}

struct MoodEntryRow: View {
    let entry: MoodEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Mood emoji and color
            VStack {
                Text(entry.mood.emoji)
                    .font(.title)
                Text(entry.mood.rawValue)
                    .font(.caption)
                    .foregroundColor(entry.mood.color)
            }
            .frame(width: 60)
            
            // Entry details
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, style: .date)
                    .font(.headline)
                
                Text(entry.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    Label("\(entry.sleepHours, specifier: "%.1f")h", systemImage: "bed.double")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Label("\(entry.steps)", systemImage: "figure.walk")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Label("\(entry.screenTime, specifier: "%.1f")h", systemImage: "iphone")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Spacer()
            
            // Mood score
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.moodScore)/2")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(entry.mood.color)
                
                Text("Score")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MoodListView(dataManager: MoodDataManager())
} 