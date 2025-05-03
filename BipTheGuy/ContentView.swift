//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Pavel Pacák on 30.04.2025.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isFullSize = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    isFullSize = false
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        isFullSize = true
                    }
                }
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    do {
                        if let data = try await selectedPhoto?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                bipImage = Image(uiImage: uiImage)
                            }
                        }
                    } catch {
                        print("😡 ERROR: loading failed \(error.localizedDescription)")
                    }
                }
            }
            
        }
        .padding()
        
    }
        
        func playSound(soundName: String) {
            if audioPlayer != nil && audioPlayer.isPlaying {
                audioPlayer.stop()
            }
            guard let soundFile = NSDataAsset(name: soundName) else {
                print("😡 Could not read file named \(soundName)")
                return
            }
            do {
                audioPlayer = try AVAudioPlayer(data: soundFile.data)
                audioPlayer.play()
            } catch {
                print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
            }
        }
       
    
    }
    
    #Preview {
        ContentView()
    }
