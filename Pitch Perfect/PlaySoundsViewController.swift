//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Whidden on 5/14/15.
//  Copyright (c) 2015 SelfEdge Software. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    var recordedAudio: RecordedAudio?
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup audio session for playback
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    @IBAction func playSlowly(sender: AnyObject) {
        playAtRate(0.5)
    }
    
    @IBAction func playFast(sender: AnyObject) {
        playAtRate(1.5)
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        resetAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAtPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAtPitch(-700)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        let echoEffectNode = AVAudioUnitDelay()
        echoEffectNode.delayTime = 1.0
        echoEffectNode.feedback = 30.0
        audioEngine.attachNode(echoEffectNode)
        
        playWithEffect(echoEffectNode)
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        let reverbEffectNode = AVAudioUnitReverb()
        reverbEffectNode.loadFactoryPreset(.LargeHall2)
        reverbEffectNode.wetDryMix = 50.0
        audioEngine.attachNode(reverbEffectNode)
        
        playWithEffect(reverbEffectNode)
    }
    
    
    func playAtPitch(pitch: Float) {
        let pitchEffectNode = AVAudioUnitTimePitch()
        pitchEffectNode.pitch = pitch
        audioEngine.attachNode(pitchEffectNode)
        
        playWithEffect(pitchEffectNode)
    }
    
    func playWithEffect(effect: AVAudioUnit) {
        resetAudio()

        if let url = recordedAudio?.filePathURL {
            let audioFile = AVAudioFile(forReading: url, error: nil)
            
            let audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioPlayerNode)
            
            audioEngine.connect(audioPlayerNode, to: effect, format: audioFile.processingFormat)
            audioEngine.connect(effect, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
            
            audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            audioEngine.startAndReturnError(nil)
            audioPlayerNode.play()
        }
    }
    
    func playAtRate(rate: Float) {
        resetAudio()
        
        if let url = recordedAudio?.filePathURL {
            var error: NSError?
            let player = AVAudioPlayer(contentsOfURL: url, error: &error)
            self.player = player
            if let error = error {
                println(error.description)
            } else {
                player.delegate = self
                player.enableRate = true
                player.rate = rate
                player.volume = 1.0
                player.play()
            }
        }
    }
    
    func resetAudio() {
        player?.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    //MARK: Audio Player delegate methods
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.player = nil
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        println("Interrupted")
    }

}


