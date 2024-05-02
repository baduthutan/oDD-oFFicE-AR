//
//  Stage.swift
//  nano1
//
//  Created by Dixon Willow on 26/04/24.
//

import SwiftUI

struct Stage: View {
    
    @State var isNavigationActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Stage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    HStack {
                        
                        Button(action: {
                            AudioManager.shared.enterDoorSound()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isNavigationActive = true
                            }
                        }) {
                            ZStack {
                                Image("PlayableStage")
                                    .resizable()
                                    .scaleEffect(0.79)
                                    .padding()
                                
                                Image("ScoutLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(0.3)
                                    .offset(y: -100)
                                    .padding()
                            }
                        }
                        
                        NavigationLink (
                            destination: Briefing(),
                            isActive: $isNavigationActive,
                            label: { EmptyView() }
                        )
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    Stage()
}
