//
//  SpeakerAR.swift
//  morser
//
//  Created by vin chen on 01/05/24.
//

import SwiftUI
import RealityKit
import AVFoundation
import Speech


class Catcherr: ObservableObject {
    
    @Published var scene = Tryspeaker.Scene()
    
    @Published var secretSpelled: Bool = false
    @Published var isListening: Bool = false
    @State private var recognizedText = ""
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var audioEngine = AVAudioEngine()
    
  
    
    
    @MainActor func sceneLoader() {
        Tryspeaker.loadSceneAsync(completion: { [self] result in
            do {
                self.scene = try result.get()
                self.scene.actions.voiceInput.onAction = pressSafe(_:)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
    func pressSafe(_ entity: Entity?) {
        toggleListening()
    }
    
        func toggleListening() {
            print(isListening)
            if isListening {
                stopListening()
            } else {
          
                startListening()
            }
        }
    
        func startListening() {
            print("start listening")
            guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
                SFSpeechRecognizer.requestAuthorization { status in
                    if status == .authorized {
                        self.startListening()
                    }
                }
                return
            }
    
            try? AVAudioSession.sharedInstance().setCategory(.record)
            try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    
            let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
    
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                recognitionRequest.append(buffer)
            }
    
            speechRecognizer.recognitionTask(with: recognitionRequest) { (result, _) in
                if let result = result {
                    let bestString = result.bestTranscription.formattedString
                    self.recognizedText = bestString
                    if bestString.lowercased().contains("scout") {
                        // Detected the secret word "swift"
                        print("Secret word spelled")
                        self.secretSpelled = true
                    }
                }
            }
    
            audioEngine.prepare()
            do {
                try audioEngine.start()
            } catch {
                print("Error starting audio engine: \(error.localizedDescription)")
            }
    
            isListening = true
        }
    
        func stopListening() {
            print("listening stopped")
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            isListening = false
        }
    
}


struct SpeakerAR: View {
    var body: some View {
            Speaker()
            .edgesIgnoringSafeArea(.all)
    }
}

struct Speaker: UIViewRepresentable {
    
    @ObservedObject var catcherr = Catcherr()
    
    let arView = ARView(frame: .zero)
    func makeUIView(context: Context) -> ARView {
        
        catcherr.sceneLoader()
        return arView
        
    }
    
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
        uiView.scene.anchors.append(catcherr.scene)
    }
    
}
#Preview {
    SpeakerAR()
}
