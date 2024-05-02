//
//  Briefing.swift
//  nano1
//
//  Created by vin chen on 02/05/24.
//

import SwiftUI

struct Briefing: View {
    @State private var imageOpacity: Double = 0
    @State private var objectOpacity: Double = 0
    @State var isAnimating = false
    @State var isNavigationActive = false
    var body: some View {
        NavigationView{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                Image("BriefingImg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: -25)
                    .ignoresSafeArea(edges: .vertical)
                    .opacity(imageOpacity) // Apply opacity
                    .onAppear {
                        withAnimation(.easeInOut(duration: 5.0)) {
                            // Set opacity to 1 to make the image fade in
                            imageOpacity = 1
                        }
                    }
                VStack {
                    Button(action: {
                        AudioManager.shared.playTapSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isNavigationActive = true
                        }
                    }) {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "arrowshape.right.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
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
                        destination: ScoutroomAR(),
                        isActive: $isNavigationActive,
                        label: { EmptyView() }
                    )
                    
                }
                .padding()
                .opacity(objectOpacity) // Apply opacity
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        withAnimation {
                            objectOpacity = 1
                        }
                    }
                }
            }
            .onAppear {
                AudioManager.shared.playBriefing()
            }
            .onDisappear {
                AudioManager.shared.stopBackgroundMusic()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}

#Preview {
    Briefing()
}
