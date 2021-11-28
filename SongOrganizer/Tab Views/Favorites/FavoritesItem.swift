//
//  FavoritesItem.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct FavoritesItem: View {
    
    let song: Song
    
    @FetchRequest(fetchRequest: Song.allSongsFetchRequest()) var allSongs: FetchedResults<Song>
    
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

