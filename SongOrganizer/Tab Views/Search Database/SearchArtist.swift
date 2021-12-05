//
//  SearchArtist.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import CoreData

struct SearchArtist: View {
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var searchFieldValue = ""
    @State private var searchQueryEntered = ""
    
    var body: some View {
        Form {
            Section(header: Text("Search songs with artist name containing the following search query").padding(.top, 50)) {
                HStack {
                    TextField("Enter Search Query", text: $searchFieldValue,
                              onCommit: {
                                // Record entered value after Return key is pressed
                                searchQueryEntered = searchFieldValue
                    }
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    // Button to clear the text field
                    Button(action: {
                        searchFieldValue = ""
                        searchQueryEntered = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }   // End of HStack
                    .padding(.horizontal)
            }
            if !searchQueryEntered.isEmpty {
                Section(header: Text("Show Search Results")) {
                    NavigationLink(destination: showSearchResults()) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Show Found Songs")
                                .font(.headline)
                        }
                    }
                }
            }
            
        }   // End of Form
            .navigationBarTitle(Text("Search Songs by Artist Name"), displayMode: .inline)
        
    }   // End of body
    
    func showSearchResults() -> some View {
        
        //----------------------------
        // ❎ Define the Fetch Request
        //----------------------------
        let fetchRequestArtist = NSFetchRequest<Artist>(entityName: "Artist")
        fetchRequestArtist.sortDescriptors = [NSSortDescriptor(key: "artistName", ascending: true)]
        
        //------------------------------
        // ❎ Define the Search Criteria
        //------------------------------
        // Ingredient name contains the entered search query in case insensitive manner
        fetchRequestArtist.predicate = NSPredicate(format: "artistName CONTAINS[c] %@", searchQueryEntered)
        
        var foundArtists = [Artist]()
        var foundAlbums = [Album]()
        var foundSongs = [Song]()
        
        do {
            //-----------------------------
            // ❎ Execute the Fetch Request
            //-----------------------------
            foundArtists = try managedObjectContext.fetch(fetchRequestArtist)
        } catch {
            print("Artist entity fetch failed!")
        }
        
        if foundArtists.isEmpty {
            return AnyView(SearchResultsEmpty())
        }
        
        for object in foundArtists {
            foundAlbums.append(contentsOf: object.album?.allObjects as! [Album])
        }
        
        let foundAlbumsWithNoDuplicates = foundAlbums.removeDuplicates()
        
        for object in foundAlbumsWithNoDuplicates {
            foundSongs.append(contentsOf: object.song?.allObjects as! [Song])
        }
        
        let foundSongsWithNoDuplicates = foundSongs.removeDuplicates()
        
        return AnyView(SearchDBList(songs: foundSongsWithNoDuplicates))
    }
}

struct SearchArtist_Previews: PreviewProvider {
    static var previews: some View {
        SearchArtist()
    }
}
