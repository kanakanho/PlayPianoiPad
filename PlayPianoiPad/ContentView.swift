//
//  ContentView.swift
//  PlayPiano
//
//  Created by blue ken on 2024/08/10.
//

import SwiftUI
import PianoKeyboard

struct ContentView: View {
    @ObservedObject private var pianoKeyboardViewModel: PianoKeyboardViewModel
    private let audioEngine: AudioEngine
    
    init(
        pianoKeyboardViewModel: PianoKeyboardViewModel = PianoKeyboardViewModel(),
        audioEngine: AudioEngine = AudioEngine(soundFontFile: "soundfont")
    ) {
        self.pianoKeyboardViewModel = pianoKeyboardViewModel
        self.audioEngine = audioEngine
        
        pianoKeyboardViewModel.showLabels = true
        pianoKeyboardViewModel.numberOfKeys = 84
        pianoKeyboardViewModel.noteOffset = 24
    }
    var body: some View {
        VStack {
            PianoKeyboardView(viewModel: pianoKeyboardViewModel, style: ClassicStyle(sfKeyWidthMultiplier: 0.55))
                .frame(height: 400)
        }
        .padding()
                .onAppear() {
            pianoKeyboardViewModel.delegate = audioEngine
            audioEngine.start()
        }
    }
}

#Preview() {
    ContentView()
}
