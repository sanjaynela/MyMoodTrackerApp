//
//  ContentView.swift
//  MyMoodTrackerApp
//
//  Created by Sanjay Nelagadde on 20/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = MoodDataManager()
    
    var body: some View {
        DashboardView(dataManager: dataManager)
    }
}

#Preview {
    ContentView()
}
