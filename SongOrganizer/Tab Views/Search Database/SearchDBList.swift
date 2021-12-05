//
//  SearchDBList.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchDBList: View {
    // Input Parameter
    let songs: [Song]
    
    var body: some View {
        List {
            /*
             Each NSManagedObject has internally assigned unique ObjectIdentifier
             used by ForEach to display the Recipes in a dynamic scrollable list.
             */
            ForEach(songs) { aSong in
                NavigationLink(destination: SearchDBDetails(song: aSong)) {
                    SearchDBItem(song: aSong)
                }
            }
            
        }   // End of List
            .navigationBarTitle(Text("Songs Found"), displayMode: .inline)
    }
}
