//
//  SearchAlbum.swift
//  SongOrganizer
//
//  Created by Evan Jones on 12/5/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import CoreData

struct SearchAlbum: View {
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var searchFieldValue = ""
    @State private var searchQueryEntered = ""
    
    var body: some View {
        Form {
            Section(header: Text("Search songs with album name containing the following search query").padding(.top, 50)) {
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
            .navigationBarTitle(Text("Search Songs by Album Name"), displayMode: .inline)
        
    }   // End of body
    
    func showSearchResults() -> some View {
        
        //----------------------------
        // ❎ Define the Fetch Request
        //----------------------------
        let fetchRequestAlbum = NSFetchRequest<Album>(entityName: "Album")
        fetchRequestAlbum.sortDescriptors = [NSSortDescriptor(key: "albumName", ascending: true)]
        
        //------------------------------
        // ❎ Define the Search Criteria
        //------------------------------
        // Ingredient name contains the entered search query in case insensitive manner
        fetchRequestAlbum.predicate = NSPredicate(format: "albumName CONTAINS[c] %@", searchQueryEntered)
        
        var foundAlbums = [Album]()
        var foundSongs = [Song]()
        
        do {
            //-----------------------------
            // ❎ Execute the Fetch Request
            //-----------------------------
            foundAlbums = try managedObjectContext.fetch(fetchRequestAlbum)
        } catch {
            print("Album entity fetch failed!")
        }
        
        if foundAlbums.isEmpty {
            return AnyView(SearchResultsEmpty())
        }
        
        for object in foundAlbums {
            foundSongs.append(contentsOf: object.song?.allObjects as! [Song])
        }
        
        let foundSongsWithNoDuplicates = foundSongs.removeDuplicates()
        
        return AnyView(SearchDBList(songs: foundSongsWithNoDuplicates))
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

struct SearchAlbum_Previews: PreviewProvider {
    static var previews: some View {
        SearchAlbum()
    }
}
