//
//  Spotify.swift
//  Spotify
//
//  Created by Jonathan Hyun on 12/4/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import Foundation
import SwiftUI

var imageUrl = ""

public func getAlbumCover(query1: String) {
    imageUrl = ""
    let searchQuery1 = query1.replacingOccurrences(of: " ", with: "%20")
    
    let apiUrl = "https://api.spotify.com/v1/search?q=\(searchQuery1)&type=track&limit=1"
    
    print(apiUrl)
    
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
    
    // authorization token expires so if the API no longer works you must get a new token here: https://developer.spotify.com/console/get-search-item/
    // Scroll to the bottom and click GET TOKEN to get your new token. Replace the old token with the new one in the format
    // Bearer "ENTER TOKEN HERE"
    
    let headers = [
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": "Bearer BQBNUeGiyMPEnGoN8MSLkkRHVej-GIP0lSVXsSnqWflD0BpV3qhez1Cy1ANhVvktuH4oI-2xuE7q2CkNnI3VCnOJiC1S4irKqODKe9CbsGrM17azqOYiTXK5qWKwLE7qb8pB8RsASwytwA0",
        "host": "api.spotify.com"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: apiUrl)! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)

    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)

    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */

        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
        
        /*
         ----------------------------------------------------
         🔴 Any 'return' used within the completionHandler
         exits the completionHandler; not the public function
         ----------------------------------------------------
         */

        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }

        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }

        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                               options: JSONSerialization.ReadingOptions.mutableContainers)
            //print(jsonResponse)
            
            if let jsonArray = jsonResponse as? [String: Any] {
                //print(jsonArray)
                if let trackArray = jsonArray["tracks"] as? [String: Any] {
                    //print(trackArray)
                    
                    if let itemsArray = trackArray["items"] as? [Any] {
                        //print(itemsArray)
                        
                        if let albumArray = itemsArray[0] as? [String: Any] {
                            //print(albumArray)
                            
                            if let album2Array = albumArray["album"] as? [String: Any] {
                                //print(album2Array)
                                
                                if let imagesArray = album2Array["images"] as? [Any] {
                                    //print(imagesArray)
                                    
                                    if let images2Array = imagesArray[0] as? [String: Any] {
                                        //print(images2Array)
                                        
                                        if let imageUrlObject = images2Array["url"] as? String {
                                            //print(imageUrlObject)
                                            imageUrl = imageUrlObject
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print("track failed")
                }
            } else {
                print("array failed")
            }
            
        } catch {
            semaphore.signal()
            return
        }

        semaphore.signal()
    }).resume()

    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.

     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 10 seconds expires.
    */

    _ = semaphore.wait(timeout: .now() + 10)
    
}
