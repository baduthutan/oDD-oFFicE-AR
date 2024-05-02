import SwiftUI
import RealityKit
import Speech
import AVFoundation
import ARKit

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }

    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("did deactivate")
    }
}

class Catcher: ObservableObject {
    
    @Published var scene = Scoutroom.Scene()
    @Published var hapticOn: Bool = false
    @Published var theEnd: Bool = false
    @Published var secretSpelled: Bool = false
    @Published private var isListening = false
    @Published var isNavigationActive = false
    
    @State private var recognizedText = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var audioEngine = AVAudioEngine()
    
    
    @MainActor func sceneLoader() {
        Scoutroom.loadSceneAsync(completion: { [self] result in
            do {
                self.scene = try result.get()
                self.scene.actions.morseHaptic.onAction = toggleHaptic(_:)
                self.scene.actions.voiceInput.onAction = pressSafe(_:)
//                self.scene.actions.exitGame.onAction = endSession(_:)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
   
    
    func toggleHaptic(_ entity: Entity?){
        if !self.hapticOn{
            morseHaptics()
        }
    }
    
//    func endSession(_ entity: Entity?){
//        self.isNavigationActive = true
//    }
    
    func morseHaptics() {
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        let lightGenerator = UIImpactFeedbackGenerator(style: .light)
        self.hapticOn = true
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
                self.hapticOn = false
            }        
    }
    
    func pressSafe(_ entity: Entity?) {
        toggleListening()
    }
    
    func toggleListening() {
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        let lightGenerator = UIImpactFeedbackGenerator(style: .light)
            if isListening {
                lightGenerator.impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    lightGenerator.impactOccurred()
                }
                stopListening()
            } else {
                heavyGenerator.impactOccurred()
                startListening()
            }
        }
    
        func startListening() {
            guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
                SFSpeechRecognizer.requestAuthorization { status in
                    if status == .authorized {
                        DispatchQueue.main.async {
                            self.startListening()
                        }
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
            self.isListening = true
        }
    
        func stopListening() {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            self.isListening = false
        }
    
    @MainActor func brightnessNotificationLoader() {
        if scene.notifications.allNotifications.count > 0 {
            self.scene.notifications.showPigpen.post()
        }
    }
    @MainActor func darkOnNotificationLoader() {
        if scene.notifications.allNotifications.count > 0 {
            self.scene.notifications.darkOn.post()
        }
    }
    @MainActor func darkOffNotificationLoader() {
        if scene.notifications.allNotifications.count > 0 {
            self.scene.notifications.darkOff.post()
        }
    }
    @MainActor func secretNotificationLoader() {
        if scene.notifications.allNotifications.count > 0 {
            self.scene.notifications.voiceCorrect.post()
        }
    }
}

struct ScoutroomAR : View {
    @State public var brightnessStatus: Bool = false
    @State public var theEnd: Bool = false
    @ObservedObject var catcher = Catcher()
    
    var body: some View {
        NavigationView{
            ZStack{
                ScoutRoom(brightnessStatus: $brightnessStatus, theEnd: $theEnd)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        startMonitoring()
                        
                    }
                if theEnd{
                    Image("gmbr")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .offset(x: -25)
                        .ignoresSafeArea(edges: .vertical)
                   
                }
            }
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(!theEnd)
//        .navigationBarItems(leading: CustomBackButton())
//        .background(
//                    NavigationLink(
//                        destination: MainMenu(),
//                        isActive: $theEnd,
//                        label: { EmptyView() }
//                    )
//                    .hidden()
//                )
    }
    
    private func startMonitoring() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateBrightnessStatus()
//            if catcher.isNavigationActive {
//                            theEnd = true
//                        }
        }
        timer.fire()
    }
    
    private func updateBrightnessStatus() {
        let brightnessLevel = UIScreen.main.brightness
        if brightnessLevel == 1.0 {
            brightnessStatus = true
//            print("max brightness")
        } else{
//            print("no bueno")
        }
    }
    

    

    
}

struct CustomBackButton: View {
    @State var isNavigationActive: Bool = false
    
    var body: some View {
        Button(action: {
                isNavigationActive = true
        }) {
            HStack{
                Image(systemName: "chevron.left")
                Text("🏃‍♂️🏢")
            }
            .foregroundColor(.green)
        }
        NavigationLink (
            destination: MainMenu(),
            isActive: $isNavigationActive,
            label: { EmptyView() }
        )
    }
}

struct ScoutRoom: UIViewRepresentable {
    
    @ObservedObject var catcher = Catcher()
    
    @Binding var brightnessStatus: Bool
    @Binding var theEnd: Bool
//    @State var theEnd: Bool = false
//    @Binding var clickSafe:Bool
//    @Binding var secretSpelled:Bool
    
    let arView = ARView(frame: .zero)
    func makeUIView(context: Context) -> ARView {
        arView.addCoaching()
        catcher.sceneLoader()
        catcher.scene.actions.exitGame.onAction = endSession(_:)
        return arView
        
    }
    
        func endSession(_ entity: Entity?){
            theEnd = true
        }
    
    @Environment(\.colorScheme) var colorScheme
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        uiView.scene.anchors.append(catcher.scene)
        if brightnessStatus == true {
            catcher.brightnessNotificationLoader()
        }
        if colorScheme == .dark{
            catcher.darkOnNotificationLoader()
        }else{
            catcher.darkOffNotificationLoader()
        }
        if catcher.secretSpelled == true{
            catcher.secretNotificationLoader()
        }
//        if catcher.theEnd == true{
//            theEnd = true
//        }
        DispatchQueue.main.async {

        }
    }
    
}

#Preview {
    ARView()
}

