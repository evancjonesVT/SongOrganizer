//
//  RecordingsDetails.swift
//  RecordingsDetails
//
//  Created by Jonathan Hyun on 12/6/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct RecordingsDetails: View {
    // Input Parameter passed by value
    let voiceMemo: VoiceMemo
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var audioPlayer: AudioPlayer
    
    var body: some View {
        Form {
            Section(header: Text("Voice Memo Title")) {
                Text(voiceMemo.title)
            }
            Section(header: Text("Voice Memo Category")) {
                HStack {
                    Image(voiceMemo.category)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0)
                    Text(voiceMemo.category)
                }
            }
            Section(header: Text("Play Voice Memo")) {
                Button(action: {
                    if audioPlayer.isPlaying {
                        audioPlayer.pauseAudioPlayer()
                    } else {
                        audioPlayer.startAudioPlayer()
                    }
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.blue)
                        .font(Font.title.weight(.regular))
                    }
            }
            Section(header: Text("Voice Memo Duration Time")) {
                Text(voiceMemo.duration)
            }
            Section(header: Text("Voice Memo Date and Time")) {
                Text(voiceMemo.dateTime)
            }
        }   // End of Form
        .font(.system(size: 14))
        .navigationBarTitle(Text("Voice Memo Details"), displayMode: .inline)
        .onAppear() {
            createPlayer()
        }
        .onDisappear() {
            audioPlayer.stopAudioPlayer()
        }
    }   // End of body
    
    /*
    -------------------------
    MARK: Create Audio Player
    -------------------------
    */
    func createPlayer() {
        let voiceMemoFileUrl = documentDirectory.appendingPathComponent(voiceMemo.audioFullFilename)
        audioPlayer.createAudioPlayer(url: voiceMemoFileUrl)
    }
}

struct RecordingsDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsDetails(voiceMemo: voiceMemoStructList[0])
    }
}
