//
//  PerformanceView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/6/24.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    @State private var title: String = "Some Title"
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                configure()
            }
    }
    
    private func configure() {
        let trace = Performance.startTrace(name: "performance_view_loading")
        
        trace?.setValue(title, forAttribute: "title_text")
        
        Task {
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Started Downloading", forAttribute: "func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            trace?.setValue("Continued Downloading", forAttribute: "func_state")
            trace?.setValue("Finished Downloading", forAttribute: "func_state")
            trace?.stop()
        }
    }
}

#Preview {
    PerformanceView()
}
