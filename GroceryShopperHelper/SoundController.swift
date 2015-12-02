//
//  SoundController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 10/27/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit
import AVFoundation

class SoundController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    var soundRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    let filename = "glist.caf"
    var sess = AVAudioSession()
    
    @IBOutlet weak var recordButton: UIButton!
   
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordSound(sender: UIButton) {
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                if (self.soundRecorder?.recording == nil) {
                    self.setupRecorder()
                }
                if (sender.titleLabel?.text == "Record"){
                    self.soundRecorder!.record()
                    sender.setTitle("Stop", forState: .Normal)
                    self.playButton.enabled = false
                } else {
                    self.soundRecorder!.stop()
                    sender.setTitle("Record", forState: .Normal)
                    self.playButton.enabled = true
                }
            } else {
                let alert = UIAlertController(title: "Recording not Enabled",
                    message: "Recording isn't enabled for this app. Please enable it in Settings.",
                    preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK",
                    style: .Default,
                    handler: { (action: UIAlertAction!) in
                        print("Please don't crash...")
            }))
                self.presentViewController(alert, animated: true, completion: nil) }
        })
      /*  if(sess.recordPermission() == AVAudioSessionRecordPermission.Granted){
            if (self.soundRecorder?.recording == nil) {
                setupRecorder()
            }
            if (sender.titleLabel?.text == "Record"){
                soundRecorder!.record()
                sender.setTitle("Stop", forState: .Normal)
                playButton.enabled = false
            } else {
                soundRecorder!.stop()
                sender.setTitle("Record", forState: .Normal)
                playButton.enabled = true
            }
        }
        else{
            let alert = UIAlertController(title: "Recording not Enabled",
                message: "Recording isn't enabled for this app. Please enable it in Settings.",
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    print("Please don't crash...")
            }))
            
            presentViewController(alert, animated: true, completion: nil)          } */
    }
    @IBAction func playSound(sender: UIButton) {
      //  if (self.soundPlayer?.playing == nil) {
      //      preparePlayer()
      //  }
        if (sender.titleLabel?.text == "Play"){
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer?.play()
        } else {
            soundPlayer?.stop()
            sender.setTitle("Play", forState: .Normal)
            recordButton.enabled = true
        }
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true) as [String]
        
        return paths[0]
    }
    
    func getFileURL() -> NSURL? {
        
        let path = getCacheDirectory().stringByAppendingString(filename)
        let filePath = NSURL(fileURLWithPath: path)
        
  //      let pathComponents = [path, filename]
   //     return NSURL.fileURLWithPathComponents(pathComponents)!
        
        return filePath
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            if(set){
                player.prepareToPlay()
                player.play()
            }
        }
    }
    func setupRecorder() {
        
        let recordSettings : [String : AnyObject] =
        [
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue as NSNumber,
            AVEncoderBitRateKey : 320000 as NSNumber,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVSampleRateKey : 44100.0 as NSNumber
        ]
        
        do {
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            //try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            try session.setActive(true)
        
            soundRecorder =  try AVAudioRecorder(URL: getFileURL()!, settings: recordSettings)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        
        }
        catch let error as NSError
        {
            print(error.description)
        }
        
        }
    
    func preparePlayer() {
        if(getFileURL() != nil){
            do {
                soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL()!)
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
            }
            catch let error as NSError
            {
                print(error.description)
            }
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.enabled = true
        recordButton.setTitle("Record", forState: .Normal)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: .Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }

    
}

