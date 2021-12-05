//
//  Song.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/23/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import Foundation
import CoreData

/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Photo, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/

// ❎ CoreData Photo entity public class
public class Song: NSManagedObject, Identifiable {

    @NSManaged public var songTitle: String?
    @NSManaged public var length: String?
    @NSManaged public var releaseYear: NSNumber?
    @NSManaged public var appleLink: String?
    @NSManaged public var spotifyLink: String?
    @NSManaged public var youtube: String?
    @NSManaged public var album: Album?
}


extension Song {
    
    static func allSongsFetchRequest() -> NSFetchRequest<Song> {
        
        let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "songTitle", ascending: true),
            NSSortDescriptor(key: "releaseYear", ascending: true)
        ]
        return fetchRequest
    }
    
    static func filteredSongsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Song> {
        
        let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
    
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "songTitle", ascending: true),
            NSSortDescriptor(key: "releaseYear", ascending: true)
        ]
        
        /*
         Created NSPredicate object represents a condition or a compound condition with
         AND/OR logical operators, which is used to filter fetching from the database.
         */
        switch searchCategory {
        case "Song Title":
            fetchRequest.predicate = NSPredicate(format: "songTitle CONTAINS[c] %@", searchQuery)
        case "Release Year":
            fetchRequest.predicate = NSPredicate(format: "releaseYear CONTAINS[c] %@", searchQuery)
        default:
            print("Search category is out of range")
        }
        
        return fetchRequest
    }
    
}
