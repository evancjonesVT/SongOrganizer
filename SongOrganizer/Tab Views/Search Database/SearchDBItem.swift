//
//  SearchDBItem.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchDBItem: View {
    let song: Song
    
    var body: some View {
        
        HStack {
            getImageFromBinaryData(binaryData: song.album!.photo!.photo, defaultFilename: "AlbumCoverDefaultImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
            VStack(alignment: .leading) {
                Text(song.songTitle ?? "")
                Text(song.album!.albumName ?? "")
                Text(song.album!.artist!.artistName ?? "")
            }
        }
        .font(.system(size: 14))
    }
}
