//
//  AudioHelper.swift
//  Kinetic Rush
//
//  Created by Wahid Hidayat on 24/04/24.
//

import Foundation
import AVFoundation

struct AudioHelper {
    static var backsound: AVAudioPlayer?
    static var sfx: AVAudioPlayer?
    
    static func playBacksound() {
        stopBacksound()
        if let path = Bundle.main.path(forResource: "backsound_game", ofType: "m4a") {
            do {
                backsound = try AVAudioPlayer(contentsOf: URL(filePath: path))
                backsound?.play()
                backsound?.numberOfLoops = -1
            } catch {
                print("error")
            }
        }
    }
    
    static func playSfx() {
        if let path = Bundle.main.path(forResource: "sfx", ofType: "m4a") {
            do {
                sfx = try AVAudioPlayer(contentsOf: URL(filePath: path))
                sfx?.play()
            } catch {
                print("error")
            }
        }
    }
    
    static func stopBacksound() {
        backsound?.stop()
        backsound = nil
    }
}
