//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Christopher Whidden on 5/12/15.
//  Copyright (c) 2015 SelfEdge Software. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var recorder: AVAudioRecorder?
    var recordedAudio: RecordedAudio?
    var isPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord, withOptions: AVAudioSessionCategoryOptions.allZeros, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopAndReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(sender: AnyObject) {
        recordButton.enabled = false
        recordingLabel.text = "Recording..."
        recordingLabel.sizeToFit()
        pauseResumeButton.hidden = false
        stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask , true).last as! String
        let currentDateTime = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hhMMyyyy-HHmmss"
        let recordingName = dateFormatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let fileURL = NSURL.fileURLWithPathComponents(pathArray)
        
        
        recorder = AVAudioRecorder(URL: fileURL, settings: nil, error: nil)
        if let _recorder = recorder {
            _recorder.delegate = self
            _recorder.meteringEnabled = true
            _recorder.prepareToRecord()
            _recorder.record()
        }
    }

    @IBAction func stopRecording(sender: AnyObject) {
        stopAndReset()
    }
    
    @IBAction func pauseResumeRecording(sender: AnyObject) {
        if isPaused {
            recorder?.record()
            isPaused = false
            recordingLabel.text = "Recording..."
            pauseResumeButton.setImage(UIImage(named: "pause"), forState: .allZeros)
        } else {
            recorder?.pause()
            isPaused = true
            recordingLabel.text = "Paused"
            pauseResumeButton.setImage(UIImage(named: "unpause"), forState: .allZeros)
        }
    }
    
    func stopAndReset() {
        recorder?.stop()
        recordButton.enabled = true
        recordingLabel.text = "Tap to Record"
        recordingLabel.sizeToFit()
        stopButton.hidden = true
        pauseResumeButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(URL: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording not successfull")
            recordButton.enabled = true
            recordingLabel.hidden = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "stopRecording":
                let playSoundsViewController = segue.destinationViewController as! PlaySoundsViewController
                playSoundsViewController.recordedAudio = recordedAudio
            default:
                return
            }
        }
    }
}

