//
//  ViewController.swift
//  lightSaberApp
//
//  Created by Charlie Trenholm on 11/1/18.
//  Copyright © 2018 team name: String. All rights reserved.
//

import UIKit
import CoreFoundation
import AVFoundation
import CoreMotion

var lightSaberIsOn = false
var acceptMotionFlag = true

var motionAudioFlag = true
var backgroundColor = UIColor.black
var kyloRen = false
var has_timer_started = false

var igniteAudio = AVAudioPlayer()
var offAudio = AVAudioPlayer()
var humAudio = AVAudioPlayer()
var swing1Audio = AVAudioPlayer()
var swing2Audio = AVAudioPlayer()
var swing3Audio = AVAudioPlayer()
var swing4Audio = AVAudioPlayer()
var strike1Audio = AVAudioPlayer()
var strike2Audio = AVAudioPlayer()
var strike3Audio = AVAudioPlayer()
var strike4Audio = AVAudioPlayer()
var strike5Audio = AVAudioPlayer()
var spin1Audio = AVAudioPlayer()
var spin2Audio = AVAudioPlayer()
var spin3Audio = AVAudioPlayer()
var spin4Audio = AVAudioPlayer()



class ParkBenchTimer {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
        has_timer_started = true
    }
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        //        has_timer_started = false
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var maceWinduOutlet: UIButton!
    @IBOutlet weak var obiWanKenobiOutlet: UIButton!
    @IBOutlet weak var lukeSkywalkerOutlet: UIButton!
    @IBOutlet weak var kyloRenOutlet: UIButton!
    @IBOutlet weak var kyloBladeImage: UIImageView!
    @IBOutlet weak var leftBladeCover: UIImageView!
    @IBOutlet weak var rightBladeCover: UIImageView!
    @IBOutlet var kyloBladeCovers: [UIImageView]!
    
    
    @IBOutlet var allJediButtons: [UIButton]!
    
    //motion detector object
    var manager : CMMotionManager?
    
    var timer : ParkBenchTimer?
    

    @IBOutlet weak var handleImage: UIImageView!
    @IBOutlet weak var bladeImage: UIImageView!
    @IBOutlet weak var bladeCover: UIImageView!
    @IBOutlet weak var backgroundFlashColor: UIImageView!
    
    func kyloSideBlades() {
        if lightSaberIsOn == true && kyloRen == true {
            for asset in kyloBladeCovers {
                if asset.isHidden == true {
                    asset.isHidden = false
                }
            }
            self.leftBladeCover.center.x -= self.view.bounds.width
            self.rightBladeCover.center.x += self.view.bounds.width
            for asset in kyloBladeCovers {
                asset.isHidden = false
            }
        } else if lightSaberIsOn == true && kyloRen == false {
            self.leftBladeCover.center.x += self.view.bounds.width
            self.rightBladeCover.center.x -= self.view.bounds.width
            for asset in kyloBladeCovers {
                asset.isHidden = true
            }
        }
    }
    
    func kyloActivated() {
        self.leftBladeCover.center.x += self.view.bounds.width
        self.rightBladeCover.center.x -= self.view.bounds.width
    }
    
    
    @IBAction func lightSaberChoice(_ sender: UIButton) {
        print("lightsaber is being selected")
        if lightSaberIsOn == false {
        handleImage.isHidden = false
        print(sender.tag)
        if sender.tag == 1{
            if kyloRen == true {
                kyloRen = false
                kyloSideBlades()
            }
            handleImage.image = UIImage(named: "maceWinduLightSaber")
            bladeImage.image = UIImage(named: "maceWinduIgnited3")
            backgroundColor = UIColor(red: 0.8, green: 0.1, blue: 0.85, alpha: 1.0)
        }
        else if sender.tag == 2{
            if kyloRen == true {
                kyloRen = false
                kyloSideBlades()
            }
            handleImage.image = UIImage(named: "anakinLightSaber")
            bladeImage.image = UIImage(named: "anakinIgnited3")
            backgroundColor = UIColor(red: 0.9, green: 0.0, blue: 0.2, alpha: 1.0)
        }
        else if sender.tag == 3 {
            if kyloRen == true {
                kyloRen = false
                kyloSideBlades()
            }
            handleImage.image = UIImage(named: "obiWanLightSaber")
            bladeImage.image = UIImage(named: "obiWanIgnited3")
            backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.8, alpha: 1.0)
        }
        else {
            if kyloRen == false {
                kyloRen = true
                for asset in kyloBladeCovers {
                    if asset.isHidden == true {
                        asset.isHidden = false
                    }
                }
                kyloSideBlades()
            }
            handleImage.image = UIImage(named: "kyloRenLightSaber")
            bladeImage.image = UIImage(named: "anakinIgnited3")
            kyloBladeImage.image = UIImage(named: "kyloRenIgnited")
            for cover in kyloBladeCovers{
                cover.backgroundColor = UIColor.black
            }
            backgroundColor = UIColor(red: 0.9, green: 0.0, blue: 0.2, alpha: 1.0)
        }
    }
}
    @IBAction func lightSaberDidIgnite(_ sender: Any) {
        if lightSaberIsOn == false {
            lightSaberIsOn = true
            igniteAudio.play()
            idleHum()
            backgroundFlashColor.backgroundColor = backgroundColor
            backgroundFlashColor.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.bladeCover.center.y -= self.view.bounds.height
                self.backgroundFlashColor.backgroundColor = backgroundColor.withAlphaComponent(0.4)
                if kyloRen == true {
                    self.kyloActivated()
                    for asset in self.kyloBladeCovers {
                        asset.backgroundColor = self.backgroundFlashColor.backgroundColor
                    }
                    self.kyloBladeImage.backgroundColor = UIColor.clear
                }
            }
        } else {
            lightSaberIsOn = false
            for asset in kyloBladeCovers {
                asset.isHidden = true
            }
            humAudio.stop()
            offAudio.play()
            UIView.animate(withDuration: 0.2) {
                self.backgroundFlashColor.backgroundColor = self.backgroundFlashColor.backgroundColor!.withAlphaComponent(1.0)
                self.bladeCover.backgroundColor = self.backgroundFlashColor.backgroundColor
                self.bladeCover.center.y += self.view.bounds.height
            }
            self.bladeCover.backgroundColor = UIColor.black
            self.backgroundFlashColor.isHidden = true
        }
        
    }
    
    func crashAnimate() {
        self.backgroundFlashColor.backgroundColor = self.backgroundFlashColor.backgroundColor!.withAlphaComponent(1.0)
        UIView.animate(withDuration: 0.1) {
            self.backgroundFlashColor.backgroundColor = self.backgroundFlashColor.backgroundColor!.withAlphaComponent(0.4)
        }
    }
    
//    func slashAnimate() {
//        UIView.animate(withDuration: 0.2) {
//            if lightSaberIsOn == true {
//            self.backgroundFlashColor.backgroundColor = self.backgroundFlashColor.backgroundColor!.withAlphaComponent(0.7)
//            }}
//        UIView.animate(withDuration: 0.2) {
//            if lightSaberIsOn == true {
//            self.backgroundFlashColor.backgroundColor = self.backgroundFlashColor.backgroundColor!.withAlphaComponent(0.4)
//        }
//    }
    
    func idleHum() {
        humAudio.numberOfLoops = -1
        humAudio.play()
    }
    
    func spinAudio() {
        if lightSaberIsOn == true && motionAudioFlag == true {
            pauseMotionAudio()
            let rand = Int.random(in: 1...4)
            if rand == 1 {
                spin1Audio.play()
            } else if rand == 2 {
                spin2Audio.play()
            } else if rand == 3 {
                spin3Audio.play()
            } else {
                spin4Audio.play()
            }
        }
    }
    
    func swingAudio() {
        if lightSaberIsOn == true && motionAudioFlag == true {
//            pauseMotionAudio()
            let rand = Int.random(in: 1...4)
            if rand == 1 {
                swing1Audio.play()
            } else if rand == 2 {
                swing2Audio.play()
            } else if rand == 3 {
                swing3Audio.play()
            } else {
                swing4Audio.play()
            }
        }
    }
    
    func strikeAudio() {
        if lightSaberIsOn == true && motionAudioFlag == true {
            pauseMotionAudio()
            let rand = Int.random(in: 1...5)
            if rand == 1 {
                strike1Audio.play()
            } else if rand == 2 {
                strike2Audio.play()
            } else if rand == 3 {
                strike3Audio.play()
            } else if rand == 4 {
                strike4Audio.play()
            } else {
                strike5Audio.play()
            }
        }
    }
    
    func pauseMotionAudio() {
        motionAudioFlag = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            motionAudioFlag = true
        }
    }
    
    func pauseAcceptMotion() {
        acceptMotionFlag = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            acceptMotionFlag = true
        }
    }
    
    
    func detect_swing(_ val_1 : Double, _ val_2 : Double, _ val_3 : Double) -> Bool {
        if (val_1 > 1.0 || val_1 < -1.0)
            ||
            (val_2 > 1.0 || val_2 < -1.0)
            ||
            (val_3 > 1.0 || val_3 < -1.0)
        {
            return true
        }
        return false
    }
    
    func detect_strike(_ val_1 : Double, _ val_2 : Double, _ val_3 : Double) -> Bool {
        if (val_1 > 4.0 || val_1 < -4.0)
            ||
            (val_2 > 4.0 || val_2 < -4.0)
            ||
            (val_3 > 4.0 || val_3 < -4.0)
        {
            return true
        }
        return false
    }
    
    func detect_max_rotation(_ val_1 : Double, _ val_2 : Double, _ val_3 : Double) -> Bool {
        if val_1 > 7.0 || val_1 < -7.0 {
            return true
        }
            
        else if val_2 > 7.0 || val_2 < -7.0 {
            return true
        }
            
        else if val_3 > 7.0 || val_3 < -7.0 {
            return true
        }
        
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Instantiate graphical elements:
        lightSaberIsOn = false
        print("Lightsabre is off")
        
//        leftKyloBladeImage.layer.zPosition = 0
//        rightKyloBladeImage.layer.zPosition = 0
        
        //Instantiate motion manager
        manager = CMMotionManager()
        if let motion_manager = manager {
            if motion_manager.isDeviceMotionAvailable {
                let myqueue = OperationQueue()
                motion_manager.startDeviceMotionUpdates(to: myqueue) { (data :  CMDeviceMotion?, error : Error?) in
                    if let rotation_data = data {
                        
                        let rotate_x = rotation_data.rotationRate.x
                        let rotate_y = rotation_data.rotationRate.y
                        let rotate_z = rotation_data.rotationRate.z
                        
                        if self.detect_max_rotation(rotate_x, rotate_y, rotate_z) && !has_timer_started && acceptMotionFlag {
                            self.timer = ParkBenchTimer()
                        }
                            
                        else if self.detect_max_rotation(rotate_x, rotate_y, rotate_z) && has_timer_started && acceptMotionFlag {
                            let duration = self.timer!.stop()
                            if duration > 0.3 {
                                DispatchQueue.main.async {
                                    strike1Audio.stop()
                                    strike2Audio.stop()
                                    strike3Audio.stop()
                                    strike4Audio.stop()
                                    strike5Audio.stop()
                                    swing1Audio.stop()
                                    swing2Audio.stop()
                                    swing3Audio.stop()
                                    swing4Audio.stop()
                                    self.spinAudio()
                                    self.pauseAcceptMotion()
                                    myqueue.cancelAllOperations()
                                }
                            }
                        }
                            
                        else if !self.detect_max_rotation(rotate_x, rotate_y, rotate_z) && has_timer_started && acceptMotionFlag {
                            has_timer_started = false
                        }
                        
                        let x = rotation_data.userAcceleration.x
                        let y = rotation_data.userAcceleration.y
                        let z = rotation_data.userAcceleration.z
                        
                        if self.detect_swing(x, y, z) && self.detect_strike(x, y, z) && !has_timer_started && acceptMotionFlag{
                            print("strike")
                            DispatchQueue.main.async {
                                self.strikeAudio()
                                self.crashAnimate()
                            }
                        }
                            
                        else if self.detect_swing(x, y, z) && !self.detect_strike(x, y, z) && !has_timer_started && acceptMotionFlag{
                            print("swing")
                            DispatchQueue.main.async {
                                self.swingAudio()
//                                self.slashAnimate()
                            }
                        }
                    }
                }
            }
        }
            
        else {
            print("motion is not available")
        }
        
        
        kyloBladeImage.layer.zPosition = 0
        leftBladeCover.layer.zPosition = 1
        rightBladeCover.layer.zPosition = 1
        handleImage.isHidden = true
        bladeImage.layer.zPosition = 0
        bladeCover.layer.zPosition = 1
        handleImage.layer.zPosition = 2
        
        bladeCover.image = UIImage(named: "black")
        for button in allJediButtons {
            button.layer.cornerRadius = 25
        }
        backgroundFlashColor.isHidden = true
        
        //instantiate audio elements:
        let igniteAudioPath = Bundle.main.path(forResource: "ignite", ofType: "mp3")
        do {
            igniteAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: igniteAudioPath!))
        } catch {
            print(error)
        }
        
        
        let offAudioPath = Bundle.main.path(forResource: "off", ofType: "mp3")
        do {
            offAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: offAudioPath!))
        } catch {
            print(error)
        }
        
        let humAudioPath = Bundle.main.path(forResource: "hum", ofType: "mp3")
        do {
            humAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: humAudioPath!))
        } catch {
            print(error)
        }
        
        let swing1AudioPath = Bundle.main.path(forResource: "swing1", ofType: "mp3")
        do {
            swing1Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swing1AudioPath!))
        } catch {
            print(error)
        }
        
        let swing2AudioPath = Bundle.main.path(forResource: "swing2", ofType: "mp3")
        do {
            swing2Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swing2AudioPath!))
        } catch {
            print(error)
        }
        
        let swing3AudioPath = Bundle.main.path(forResource: "swing3", ofType: "mp3")
        do {
            swing3Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swing3AudioPath!))
        } catch {
            print(error)
        }
        
        let swing4AudioPath = Bundle.main.path(forResource: "swing4", ofType: "mp3")
        do {
            swing4Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: swing4AudioPath!))
        } catch {
            print(error)
        }
        
        let strike1AudioPath = Bundle.main.path(forResource: "strike1", ofType: "mp3")
        do {
            strike1Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strike1AudioPath!))
        } catch {
            print(error)
        }
        
        let strike2AudioPath = Bundle.main.path(forResource: "strike2", ofType: "mp3")
        do {
            strike2Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strike2AudioPath!))
        } catch {
            print(error)
        }
        
        let strike3AudioPath = Bundle.main.path(forResource: "strike3", ofType: "mp3")
        do {
            strike3Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strike3AudioPath!))
        } catch {
            print(error)
        }
        
        let strike4AudioPath = Bundle.main.path(forResource: "strike4", ofType: "mp3")
        do {
            strike4Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strike4AudioPath!))
        } catch {
            print(error)
        }
        
        let strike5AudioPath = Bundle.main.path(forResource: "strike5", ofType: "mp3")
        do {
            strike5Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strike5AudioPath!))
        } catch {
            print(error)
        }
        
        let spin1AudioPath = Bundle.main.path(forResource: "spin1", ofType: "mp3")
        do {
            spin1Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: spin1AudioPath!))
        } catch {
            print(error)
        }
        
        let spin2AudioPath = Bundle.main.path(forResource: "spin2", ofType: "mp3")
        do {
            spin2Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: spin2AudioPath!))
        } catch {
            print(error)
        }
        
        let spin3AudioPath = Bundle.main.path(forResource: "spin3", ofType: "mp3")
        do {
            spin3Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: spin3AudioPath!))
        } catch {
            print(error)
        }
        
        let spin4AudioPath = Bundle.main.path(forResource: "spin4", ofType: "mp3")
        do {
            spin4Audio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: spin4AudioPath!))
        } catch {
            print(error)
        }
    }


}
