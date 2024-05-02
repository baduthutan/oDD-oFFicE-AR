//
//  BackgroundMusic.swift
//  nano1
//
//  Created by Dixon Willow on 01/05/24.
//

import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var tapAudioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        
        guard let url = Bundle.main.url(forResource: "BGM", withExtension: "mp3") else {return}
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.play()
        } catch {
            print("BGM Error: \(error.localizedDescription)")
        }
    }
    
    func playBriefing() {
        
        guard let url = Bundle.main.url(forResource: "Briefing", withExtension: "mp3") else {return}
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = 0
            backgroundMusicPlayer?.play()
        } catch {
            print("BGM Error: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func playTapSound() {
        guard let url = Bundle.main.url(forResource: "ArrowClicked", withExtension: "mp3") else { return }
        
        do {
            tapAudioPlayer = try AVAudioPlayer(contentsOf: url)
            tapAudioPlayer?.play()
        } catch {
            print("Error playing tap sound: \(error.localizedDescription)")
        }
    }
    
    func enterDoorSound() {
        guard let url = Bundle.main.url(forResource: "DoorClicked", withExtension: "mp3") else { return }
        
        do {
            tapAudioPlayer = try AVAudioPlayer(contentsOf: url)
            tapAudioPlayer?.play()
        } catch {
            print("Error playing door sound: \(error.localizedDescription)")
        }
        
    }
    
}
