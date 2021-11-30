//
//  FavoritesDetails.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct FavoritesDetails: View {
    
    let song: Song
    
    var body: some View {
        Form {
            Section(header: Text("Song Title")) {
                Text(song.songTitle ?? "")
            }
            Section(header: Text("Artist Name")) {
                Text(song.album!.artist!.artistName ?? "")
            }
            Section(header: Text("Album Name")) {
                Text(song.album!.albumName ?? "")
            }
            Section(header: Text("Album Photo")) {
                getImageFromBinaryData(binaryData: song.album!.photo!.photo!, defaultFilename: "AlbumCoverDefaultImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Release Year")) {
                Text(song.releaseYear!.stringValue)
            }
            Section(header: Text("Length")) {
                Text(song.length ?? "")
            }
            Section(header: Text("Music Video")) {
                NavigationLink(destination:
                                WebView(url: song.youtube ?? "https://www.youtube.com")
                                .navigationBarTitle(Text("Play Music Video"), displayMode: .inline)
                ){
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.red)
                        Text("Play YouTube Music Video")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
            Section(header: Text("Apple Music Link")) {
                Link(destination: URL(string: song.appleLink ?? "https://www.apple.com/apple-music/")!, label: {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.pink)
                        Text("Apple Music Link")
                            .font(.system(size: 16))
                            .foregroundColor(.pink)
                    }
                })
            }
            Section(header: Text("Spotify Link")) {
                Link(destination: URL(string: song.spotifyLink ?? "https://www.spotify.com/us/")!, label: {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.green)
                        Text("Spotify Link")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                    }
                })
            }
        } // End Form
        .navigationBarTitle(Text("Song Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
}

