//
//  AudioEngine.swift
//  PlayPiano
//
//  Created by blue ken on 2024/08/10.
//

import UIKit
import AVFoundation
import PianoKeyboard

class AudioEngine {
    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()
    private let reverb = AVAudioUnitReverb()
    private let delay = AVAudioUnitDelay()
    
    private let soundFontFile: String
    init(soundFontFile: String) {
        self.soundFontFile = soundFontFile
    }
    
    func loadSoundFont() {
        guard let url = Bundle.main.url(forResource: soundFontFile, withExtension: "sf2") else { return }
        try? sampler.loadSoundBankInstrument(
            at: url, program: 0,
            bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
            bankLSB: UInt8(kAUSampler_DefaultBankLSB)
        )
    }

    func start() {
        engine.attach(sampler)
        engine.attach(reverb)
        engine.attach(delay)
        
        loadSoundFont()

        engine.connect(sampler, to: delay, format: nil)
        engine.connect(delay, to: reverb, format: nil)
        engine.connect(reverb, to: engine.mainMixerNode, format: nil)

        // Reverb
        reverb.loadFactoryPreset(.mediumHall)
        reverb.wetDryMix = 10.0

        // Delay
        delay.wetDryMix = 10.0
        delay.delayTime = 0.10
        delay.feedback = 50.0
        delay.lowPassCutoff = 16000.0

        let audioSession = AVAudioSession.sharedInstance()

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("Error: AudioSession couldn't set category")
        }

        do {
            try audioSession.setActive(true)
        } catch {
            print("Error: AudioSession couldn't set category active")
        }

        if engine.isRunning {
            print("Audio engine already running")
            return
        }

        do {
            try engine.start()
            print("Audio engine started")
        } catch {
            print("Error: couldn't start audio engine")
            return
        }
    }
}

extension AudioEngine: PianoKeyboardDelegate {
    func pianoKeyDown(_ keyNumber: Int) {
        sampler.startNote(UInt8(keyNumber), withVelocity: 64, onChannel: 0)
    }

    func pianoKeyUp(_ keyNumber: Int) {
        sampler.stopNote(UInt8(keyNumber), onChannel: 0)
    }
}

