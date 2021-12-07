//
//  SearchResultDetails.swift
//  SearchResultDetails
//
//  Created by Ethan Homoroc on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchResultDetails: View {
    
    let taste: Taste
    
    var body: some View {
        Form {
            Section(header: Text("Artist Name")) {
                Text(taste.name)
            }
            Section(header: Text("About Artist")) {
                Text(taste.wTeaser)
            }
            Section(header: Text("Artist Wiki Page")) {
                NavigationLink(destination: WebView(url: taste.wUrl)) {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("See Artist Wiki Page")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
            Section(header: Text("Music Video")) {
                NavigationLink(destination: WebView(url: "https://www.youtube.com/watch?v=\(taste.yID)")) {
                    HStack {
                        Image(systemName: "music.note.tv")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("See Artist Music Video")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
        } // End Form
        .navigationBarTitle(Text("Artist Details"), displayMode: .inline)
        .font(.system(size: 16))
    }
}


