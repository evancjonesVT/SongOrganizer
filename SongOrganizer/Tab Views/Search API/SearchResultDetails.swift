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
                Text(taste.wUrl)
            }
            Section(header: Text("Artist Name")) {
                NavigationLink("Music Video", destination: WebView(url: "https://www.youtube.com/watch?v=i\(taste.yID)"))
            }
        } // End Form
        .navigationBarTitle(Text("Artist Details"), displayMode: .inline)
        .font(.system(size: 14))
    }
}


