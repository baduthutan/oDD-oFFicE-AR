//
//  Haptic.swift
//  morser
//
//  Created by vin chen on 01/05/24.
//

import SwiftUI

struct Haptic: View {
    @State var hapticOn: Bool = false
    let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightGenerator = UIImpactFeedbackGenerator(style: .soft)
    var body: some View {
        VStack {
            Button(action: {
                if !hapticOn{
                    morseHaptics()
                }
            }) {
                Text("morse")
            }
            .padding()
        }
    }
   
    func morseHaptics() {
        hapticOn = true
        //B
        heavyGenerator.impactOccurred()
        heavyGenerator.impactOccurred()
        heavyGenerator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            lightGenerator.impactOccurred()
        }
        
        //R
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            lightGenerator.impactOccurred()
        }
        
        //I
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            lightGenerator.impactOccurred()
        }
        
        //G
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
            lightGenerator.impactOccurred()
        }
        
        //H
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.5) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
            lightGenerator.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.5) {
            lightGenerator.impactOccurred()
        }
        
        //T
        DispatchQueue.main.asyncAfter(deadline: .now() + 13.0) {
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
            heavyGenerator.impactOccurred()
            hapticOn = false
        }
        
    }
}

#Preview {
    Haptic()
}
