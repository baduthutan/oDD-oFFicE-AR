//
//  Torch.swift
//  morser
//
//  Created by vin chen on 27/04/24.
//

import SwiftUI
import AVFoundation

struct Torch: View {
    @State private var brightnessText: String = ""
        
        var body: some View {
            VStack {
                Text(brightnessText)
                    .padding()
            }
            .onAppear {
                startBrightnessMonitoring()
            }
        }
        
        private func startBrightnessMonitoring() {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                updateBrightnessText()
            }
            timer.fire() // Immediately fire the timer to update the brightness text
        }
        
        private func updateBrightnessText() {
            let brightnessLevel = UIScreen.main.brightness
            
            if brightnessLevel == 1.0 {
                brightnessText = "Max Brightness"
            } else if brightnessLevel == 0.0 {
                brightnessText = "Min Brightness"
            } else {
                brightnessText = "Brightness Level: \(brightnessLevel)"
            }
        }
}




#Preview {
    Torch()
}
