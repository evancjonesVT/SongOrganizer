//
//  FavoritesList.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/18/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI

struct FavoritesList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: Song.allSongsFetchRequest()) var allSongs: FetchedResults<Song>

    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the music albums in a dynamic scrollable list.
                 */
                ForEach(allSongs) { aSong in
                    NavigationLink(destination: FavoritesDetails(song: aSong)) {
                        FavoritesItem(song: aSong)
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .navigationBarTitle(Text("My Songs"), displayMode: .inline)
            
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddSong()) {
                    Image(systemName: "plus")
                })
            
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())    }
    
    /*
     ---------------------------------
     MARK: Delete Selected Music Album
     ---------------------------------
     */
    func delete(at offsets: IndexSet) {
        
        let songToDelete = allSongs[offsets.first!]
        
        // ❎ CoreData Delete operation
        managedObjectContext.delete(songToDelete)

        // ❎ CoreData Save operation
        do {
          try managedObjectContext.save()
        } catch {
          print("Unable to delete selected song!")
        }
    }
}

struct FavoritesList_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesList()
    }
}
