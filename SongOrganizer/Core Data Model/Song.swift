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
