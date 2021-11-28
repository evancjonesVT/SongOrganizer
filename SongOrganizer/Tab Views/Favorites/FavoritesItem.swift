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
        Text(song.songTitle ?? "song title unwrapfailed")
    }
}

