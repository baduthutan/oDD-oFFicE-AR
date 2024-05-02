//
//  Testing.swift
//  morser
//
//  Created by vin chen on 27/04/24.
//

import SwiftUI
import Speech
import AVFoundation

struct Testing: View {
    @State private var isListening = false
    @State private var recognizedText = ""
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var audioEngine = AVAudioEngine()

    var body: some View {
        VStack {
            Button(action: {
                self.toggleListening()
            }) {
                Text(isListening ? "Turn Off Microphone" : "Turn On Microphone")
            }
            .padding()
            
            Text(recognizedText)
                .padding()
                .foregroundColor(.green)
        }
    }
    
    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    func startListening() {
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
                if bestString.lowercased().contains("swift") {
                    // Detected the secret word "swift"
                    print("Secret word spelled")
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
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        isListening = false
    }
}




#Preview {
    Testing()
}
