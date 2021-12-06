//
//  SearchAPIResults.swift
//  SearchAPIResults
//
//  Created by Ethan Homoroc on 11/28/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchAPIResults: View {
    var body: some View {
        List {
            ForEach(tasteList, id: \.self) { anArtist in
                NavigationLink(destination: SearchResultDetails(taste: anArtist)) {
                    Text(anArtist.name)
                }
            }
        }   // End of List
        .navigationBarTitle(Text("Similar Artists Found"), displayMode: .inline)
    }   // End of body
    
}
