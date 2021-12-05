//
//  SearchSongsResultsList.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct SearchSongsResultsList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Song.filteredSongsFetchRequest(searchCategory: searchCategory, searchQuery: searchQuery)) var filteredSongs: FetchedResults<Song>
    
    
    
    var body: some View {
        if filteredSongs.isEmpty {
            SearchResultsEmpty()
        } else {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Recipes in a dynamic scrollable list.
                 */
                ForEach(filteredSongs) { aSong in
                    NavigationLink(destination: SearchDBDetails(song: aSong)) {
                        SearchDBItem(song: aSong)
                    }
                }
                
            }   // End of List
            .navigationBarTitle(Text("Songs Found"), displayMode: .inline)
        }   // End of if
    }
}

struct SearchSongsResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchSongsResultsList()
    }
}
