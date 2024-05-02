//
//  MainMenu.swift
//  nano1
//
//  Created by Dixon Willow on 26/04/24.
//

import SwiftUI

struct MainMenu: View {
    
    @State var isAnimating = false
    @State var isShowingAlert = false
    @State var arrowOpacity: Double = 1.0
    @State var isEnter = false
    @State var isNavigationActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .offset(x: -25)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack {
                    Button(action: {
                        AudioManager.shared.playTapSound()
//                        arrowOpacity = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isNavigationActive = true
                        }
                    }) {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "arrowshape.up.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                                .opacity(arrowOpacity)
                                .scaleEffect(isAnimating ? 1.2 : 1.0)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                                        self.isAnimating = true
                                    }
                                }
                                .padding()
                        }
                    }
                    .offset(y: -30)
                    
                    NavigationLink (
                        destination: Stage(),
                        isActive: $isNavigationActive,
                        label: { EmptyView() }
                    )
                    
                }
                .padding()
            }
            .onAppear {
                AudioManager.shared.playBackgroundMusic()
            }
            .onDisappear {
                AudioManager.shared.stopBackgroundMusic()
            }
        }
    }
}


#Preview {
    MainMenu()
}
