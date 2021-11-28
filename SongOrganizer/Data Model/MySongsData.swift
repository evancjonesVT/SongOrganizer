//
//  MySongsData.swift
//  SongOrganizer
//
//  Created by Evan Jones on 11/28/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import SwiftUI
import CoreData

// Array of MySongs structs for use only in this file
fileprivate var mySongsStructList = [MySong]()

/*
 ***********************************
 MARK: Create Song Database
 ***********************************
 */
public func createMySongsDatabase() {

    mySongsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "SongData.json", fileLocation: "Main Bundle")
    
    populateDatabase()
}

/*
*********************************************
MARK: Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
    
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = PersistenceController.shared.persistentContainer.viewContext
    
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
    fetchRequest.sortDescriptors = [
        NSSortDescriptor(key: "songTitle", ascending: true),
        NSSortDescriptor(key: "releaseYear", ascending: true)
    ]
    
    var listOfAllSongEntitiesInDatabase = [Song]()
    
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllSongEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
    
    if listOfAllSongEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
    
    print("Database will be populated!")
    
    for aSong in mySongsStructList {
        /*
         ======================================================
         Create an instance of the Song Entity and dress it up
         ======================================================
        */
        
        // ❎ Create an instance of the Song entity in CoreData managedObjectContext
        let songEntity = Song(context: managedObjectContext)
        
        // ❎ Dress it up by specifying its attributes
        songEntity.songTitle = aSong.title
        songEntity.length = aSong.length
        songEntity.releaseYear = NSNumber(value: aSong.releaseYear)
        songEntity.appleLink = aSong.appleMusic
        songEntity.spotifyLink = aSong.spotify
        songEntity.youtube = aSong.youtube

        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
        
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
        
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: aSong.photo)
        
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
        
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.photo = photoData!
        
        /*
         ======================================================
         Create an instance of the Album Entity and dress it up
         ======================================================
         */
        
        let albumEntity = Album(context: managedObjectContext)
        
        albumEntity.albumName = aSong.album
        
        /*
         ======================================================
         Create an instance of the Artist Entity and dress it up
         ======================================================
         */
        
        let artistEntity = Artist(context: managedObjectContext)
        
        artistEntity.artistName = aSong.artist
        
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
        
        songEntity.album = albumEntity //A song can only have one album
        albumEntity.song!.adding(songEntity) //An album can have many songs
        albumEntity.artist = artistEntity//An album can have one artist
        albumEntity.photo = photoEntity//An album can have one photo
        photoEntity.album = albumEntity//A photo can have one album
        artistEntity.album!.adding(albumEntity)//An artist can have many albums
        
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
        
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
        
    }   // End of for loop

}

