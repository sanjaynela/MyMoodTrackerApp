//
//  MoodEntryFormView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI

struct MoodEntryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var dataManager: MoodDataManager
    
    @State private var sleepHours: Double = 7.0
    @State private var steps: String = ""
    @State private var screenTime: Double = 2.0
    @State private var selectedMood: MoodType = .neutral
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sleep") {
                    HStack {
                        Text("Sleep Hours")
                        Spacer()
                        Text("\(sleepHours, specifier: "%.1f")")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $sleepHours, in: 0...12, step: 0.5)
                }
                
                Section("Activity") {
                    HStack {
                        Text("Steps")
                        Spacer()
                        TextField("Enter steps", text: $steps)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Screen Time") {
                    HStack {
                        Text("Screen Time (hours)")
                        Spacer()
                        Text("\(screenTime, specifier: "%.1f")")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $screenTime, in: 0...24, step: 0.5)
                }
                
                Section("Mood") {
                    Picker("How are you feeling?", selection: $selectedMood) {
                        ForEach(MoodType.allCases, id: \.self) { mood in
                            HStack {
                                Text(mood.emoji)
                                Text(mood.rawValue)
                            }
                            .tag(mood)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("Save Entry") {
                        saveEntry()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(selectedMood.color)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("New Mood Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Entry Saved", isPresented: $showingAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveEntry() {
        guard let stepsInt = Int(steps), stepsInt >= 0 else {
            alertMessage = "Please enter a valid number of steps"
            showingAlert = true
            return
        }
        
        let newEntry = MoodEntry(
            date: Date(),
            sleepHours: sleepHours,
            steps: stepsInt,
            screenTime: screenTime,
            mood: selectedMood
        )
        
        dataManager.addMoodEntry(newEntry)
        alertMessage = "Mood entry saved successfully!"
        showingAlert = true
    }
}

#Preview {
    MoodEntryFormView(dataManager: MoodDataManager())
} 