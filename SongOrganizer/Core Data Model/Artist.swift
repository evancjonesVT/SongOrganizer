//
//  Artist.swift
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
public class Artist: NSManagedObject, Identifiable {

    @NSManaged public var artistName: String?    // 'Binary Data' type
    @NSManaged public var album: NSSet?
}
