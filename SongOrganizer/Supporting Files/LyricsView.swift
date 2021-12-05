//
//  LyricsView.swift
//  LyricsView
//
//  Created by Jonathan Hyun on 12/4/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct LyricsView: View {
    // Input parameter.
    let songName: String
    let artistName: String

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    getImageFromUrl(url: imageUrl, defaultFilename: "AlbumCoverDefaultImage")
                        .resizable()
                        .frame(width: 250, height: 250)
                    Text("By \(artistName)\n")
                        .bold()
                    Text(lyric)
                } // end of VStack.
            } // end of ScrollView.
            .navigationBarTitle(Text("Lyrics for \(songName)"), displayMode: .inline)
            .font(.system(size: 14))
        }
    }
}

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(songName: "Demo", artistName: "Demo")
    }
}
