//
//  SearchTasteDive.swift
//  SearchTasteDive
//
//  Created by Ethan Homoroc on 11/28/21.
//  Copyright © 2021 Evan Jones. All rights reserved.
//

import Foundation
import SwiftUI
/*
 The TasteDive API allows for the user to search for
 similar songs. To access that data, you need an API key.
 
 Obtain your own API key at https://tastedive.com/read/api
 See API documentation at   https://tastedive-api-documentation.readthedocs.io/en/latest/
 */
let myApiKey = "427840-SongOrga-77ZYQQKF"
 
// Declare nationalParkFound as a global mutable variable accessible in all Swift files
//var tasteStructList = [Taste]()
var tasteList = [Taste]()

var tasteFound = Taste(name: "", type: "", wTeaser: "", wUrl: "", yID: "", yUrl: "")
 
fileprivate var previousTaste = ""

public func getApiDataBySongName(artistName: String) {
   
    // Avoid executing this function if already done for the same song name
    // replace occurences of spaces with %20 for artist name
    let artistName = artistName.replacingOccurrences(of: " ", with: "%20")
    if artistName == previousTaste {
        return
    } else {
        previousTaste = artistName
    }
    tasteList.removeAll()
    /*
     Create an empty instance of Taste struct defined in TasteStruct.swift
     Assign its unique id to the global variable tasteFound
     */
    tasteFound = Taste(name: "", type: "", wTeaser: "", wUrl: "", yID: "", yUrl: "")
   
    /*
     *************************
     *   API Documentation   *
     *************************
     
     # Basic pattern
     https://tastedive.com/api/similar?{query}={value}&k=YOUR API-KEY&info=1

     # Example query
     https://tastedive.com/api/similar?info=1&q=Thor: Ragnarok&k=YOUR API-KEY
     
     {
     "Similar": {
         "Info": [
             {
                 "Name": "Thor: Ragnarok",
                 "Type": "movie",
                 "wTeaser": "\n\n\nThor: Ragnarok is a 2017 American superhero film based on the Marvel Comics character Thor, produced by Marvel Studios and distributed by Walt Disney Studios Motion Pictures. It is the sequel to 2011's Thor and 2013's Thor: The Dark World, and the seventeenth film in the Marvel Cinematic Universe (MCU). The film is directed by Taika Waititi from a screenplay by Eric Pearson and the writing team of Craig Kyle and Christopher Yost, and stars Chris Hemsworth as Thor alongside Tom Hiddleston, Cate Blanchett, Idris Elba, Jeff Goldblum, Tessa Thompson, Karl Urban, Mark Ruffalo, and Anthony Hopkins. In Thor: Ragnarok, Thor must escape the alien planet Sakaar in time to save Asgard from Hela and the impending Ragnarök.\n",
                 "wUrl": "https://en.wikipedia.org/wiki/Thor:_Ragnarok",
                 "yUrl": "https://www.youtube-nocookie.com/embed/ue80QwXMRHg",
                 "yID": "ue80QwXMRHg"
             }
         ],
         "Results": [
             {
                 "Name": "Avengers: Infinity War",
                 "Type": "movie",
                 "wTeaser": "\n\n\n\nAvengers: Infinity War is a 2018 American superhero film based on the Marvel Comics superhero team the Avengers, produced by Marvel Studios and distributed by Walt Disney Studios Motion Pictures. It is the sequel to 2012's The Avengers and 2015's Avengers: Age of Ultron, and the nineteenth film in the Marvel Cinematic Universe (MCU). It was directed by Anthony and Joe Russo, written by Christopher Markus and Stephen McFeely, and features an ensemble cast including Robert Downey Jr., Chris Hemsworth, Mark Ruffalo, Chris Evans, Scarlett Johansson, Benedict Cumberbatch, Don Cheadle, Tom Holland, Chadwick Boseman, Paul Bettany, Elizabeth Olsen, Anthony Mackie, Sebastian Stan, Danai Gurira, Letitia Wright, Dave Bautista, Zoe Saldana, Josh Brolin, and Chris Pratt. In the film, the Avengers and the Guardians of the Galaxy attempt to stop Thanos from collecting the all-powerful Infinity Stones.\n",
                 "wUrl": "https://en.wikipedia.org/wiki/Avengers:_Infinity_War",
                 "yUrl": "https://www.youtube-nocookie.com/embed/QwievZ1Tx-8",
                 "yID": "QwievZ1Tx-8"
             }
         ]
     }
     }
     */
    
    /*
     # Basic pattern
     https://tastedive.com/api/similar?{query string}

     # Example query - recommendations of movie Guardians Of The Galaxy Vol. 2.
     https://tastedive.com/api/similar?q=Guardians Of The Galaxy Vol. 2
     */
    
    let apiSearchQuery = "https://tastedive.com/api/similar?info=1&q=\(artistName)&k=\(myApiKey)"

    /*
    *********************************************
    *   Obtaining API Search Query URL Struct   *
    *********************************************
    */
   
    var apiQueryUrlStruct: URL?
   
     if let urlStruct = URL(string: apiSearchQuery) {
         apiQueryUrlStruct = urlStruct
     } else {
         return
     }
   
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
 
    let headers = [
        "x-api-key": myApiKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "tastedive.com"
    ]
   
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
   
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
 
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
            //-----------------------
            // Obtain Data JSON Array
            //-----------------------
            var dataJsonArray = [String: Any]()
            if let jArray = jsonDataDictionary["Similar"] as? [String: Any] {
                dataJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray.isEmpty {
                semaphore.signal()
                return
            }
            let dataArray = dataJsonArray["Results"] as! [Any]
            
            // Iterate over all the songs returned
            for taste in dataArray {

                let tastes = taste as! [String: Any]
               
                //----------------
                // Initializations
                //----------------
     
                var name = "", type = "", wTeaser = "", wUrl = "", yID = "", yUrl = ""
     
                //-----------------
                // Obtain Name
                //-----------------
     
                if let nameObtained = tastes["Name"] as? String {
                    name = nameObtained
                }
                
                // Continue only for the song name searched for
               
                //-------------------
                // Obtain Type
                //-------------------
               
                if let typeObtained = tastes["Type"] as? String {
                    type = typeObtained
                }
                
                //-------------------
                // Obtain Description
                //-------------------
               
                if let description = tastes["wTeaser"] as? String {
                    wTeaser = description
                }
               
                //---------------------------------
                // Obtain Wiki URL
                //---------------------------------
                
                if let rawUrlWiki = tastes["wUrl"] as? String {
                    
                    let cleanedUrl = rawUrlWiki.replacingOccurrences(of: "\\", with: "")
                    wUrl = cleanedUrl
                }
                
                if let ytID = tastes["yID"] as? String {
                    yID = ytID
                }
                //---------------------------------
                // Obtain Youtube URL
                //---------------------------------
                
                if let rawUrlYT = tastes["yUrl"] as? String {

                    let cleanedUrl = rawUrlYT.replacingOccurrences(of: "\\", with: "")
                    yUrl = cleanedUrl
                }
                   
                /*
                 Create an instance of TasteDive struct, dress it up with the values obtained from the API,
                 and set its id to the global variable tasteFound
                 */
                tasteFound = Taste(name: name, type: type, wTeaser: wTeaser, wUrl: wUrl, yID: yID, yUrl: yUrl)
                
                tasteList.append(tasteFound)
                
            }   // End of the for loop
                 
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
     The waiting ends when .signal() fires or timeout period of 60 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 60)
       
}
