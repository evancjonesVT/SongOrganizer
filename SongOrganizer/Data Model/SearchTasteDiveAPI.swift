////
////  SearchTasteDiveAPI.swift
////  SearchTasteDiveAPI
////
////  Created by Ethan Homoroc on 11/29/21.
////  Copyright © 2021 Evan Jones. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//
//let myApiKey = "427840-SongOrga-77ZYQQKF"
//// Global array of Star structs
//var searchSongsList = [Taste]()
//
//
///*
// -----------------------------------------------------
// MARK: - Get Songs Data from API for the Given Query
// -----------------------------------------------------
// */
//public func searchSongs(apiQueryUrl: String) {
//    
//    // Clear out previous content in the global array
//    searchSongsList = [Taste]()
//    
//    guard let jsonDataFromApi = getJsonDataFromApi(apiUrl:
//                                                    "http://api.themoviedb.org/3/search/movie?api_key=d39bc7e173ea29938445089447e8e6dd&query=\(apiQueryUrl)") else { return }
//            
//
//        //------------------------------------------------
//        // JSON data is obtained from the API. Process it.
//        //------------------------------------------------
//        do {
//                  /*
//                   Foundation framework’s JSONSerialization class is used to convert JSON data
//                   into Swift data types such as Dictionary, Array, String, Number, or Bool.
//                   */
//                  let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: JSONSerialization.ReadingOptions.mutableContainers)
//                  
//                  //------------------------------------------
//                  // Obtain Top Level JSON Object (Dictionary)
//                  //------------------------------------------
//                  var topLevelDictionary = Dictionary<String, Any>()
//                  
//                  if let jsonObject = jsonResponse as? [String: Any] {
//                      topLevelDictionary = jsonObject
//                  } else {
//
//                      return
//                  }
//                  
//                  //------------------------------------
//                  // Obtain Array of "hits" JSON Objects
//                  //------------------------------------
//                  var arrayOfHitsJsonObjects = Array<Any>()
//                  
//                  if let jsonArray = topLevelDictionary["results"] as? [Any] {
//                      arrayOfHitsJsonObjects = jsonArray
//                  } else {
//
//                      return
//                      
//                      
//                  }
//                  for index in 0..<arrayOfHitsJsonObjects.count {
//                      
//                      //-------------------------
//                      // Obtain Star Dictionary
//                      //-------------------------
//                      var movieDictionary = Dictionary<String, Any>()
//                      
//                      if let jsonDictionary = arrayOfHitsJsonObjects[index] as? [String: Any] {
//                          
//                          movieDictionary = jsonDictionary
//                          }
//                     else {
//
//                          return
//                      }
//                      
//                      //----------------
//                      // Initializations
//                      //----------------
//                      
//                      var title = "", posterFileName = "", overview = "",
//                          genres = "", releaseDate = "", runtime = 0, director = "", actors = "", mpaaRating = "",
//                                  imdbRating = "", youTubeTrailerId = "",
//                      tmdbID = 0.0, imdb_id = ""
//                      
//                      //-------------------
//                      // Obtain Star Name
//                      //-------------------
//                      
//                      /*
//                       IF starDictionary["label"] has a value AND the value is of type String THEN
//                       unwrap the value and assign it to local variable starName
//                       ELSE leave starName as set to ""
//                       */
//                      if let t = movieDictionary["original_title"] as? String {
//                          title = t
//                      }
//
//                    
//                    
//                    
//                    if let p = movieDictionary["poster_path"] as? String
//                    {
//                        posterFileName = p
//                    }
//                    else {
//                        posterFileName = ""
//                    }
//                    
//                      if let o = movieDictionary["overview"] as! String? {
//                          overview = o
//                      }
//                      if let r = movieDictionary["release_date"] as! String? {
//                          releaseDate = r
//                      }
//                      if let i = movieDictionary["id"] as! Double? {
//                          tmdbID = i
//                      }
//                      
//                      
//                      let jsonDataFromApi = getJsonDataFromApi(apiUrl: "https://api.themoviedb.org/3/movie/\(tmdbID)?api_key=9130acef02325a467bb2808b39e5e341&append_to_response=videos")
//                      
//                      
//                      
//                      do {
//                                /*
//                                 Foundation framework’s JSONSerialization class is used to convert JSON data
//                                 into Swift data types such as Dictionary, Array, String, Number, or Bool.
//                                 */
//                                let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi!,
//                                                                                    options: JSONSerialization.ReadingOptions.mutableContainers)
//                                
//                                //------------------------------------------
//                                // Obtain Top Level JSON Object (Dictionary)
//                                //------------------------------------------
//                                var topLevelDictionary = Dictionary<String, Any>()
//                                
//                                if let jsonObject = jsonResponse as? [String: Any] {
//                                    topLevelDictionary = jsonObject
//                                } else {
//                            
//                                    // foundStarsList will be empty
//                                    return
//                                }
//                          
//
//                          
//                                  if let id = topLevelDictionary["imdb_id"] as? String {
//                                      imdb_id = id
//                                  }else
//                                  {
//                                    imdb_id = ""
//                        }
//                          
//                                  if let r = topLevelDictionary["runtime"] as! Int? {
//                                      runtime = r
//                                  }
//
//                                //------------------------------------
//                                // Obtain Array of "hits" JSON Objects
//                                //------------------------------------
//                                var bottomLevelDictionary = Dictionary<String, Any>()
//                                
//                                if let jsonObject2 = topLevelDictionary["videos"] as? [String : Any] {
//                                   bottomLevelDictionary = jsonObject2
//                                } else {
//                             
//                                    // foundStarsList will be empty
//                                    return
//                                }
//                                
//                                
//                                var arrayOfHitsJsonObjects = Array<Any>()
//                                
//                                if let jsonArray = bottomLevelDictionary["results"] as? [Any] {
//                                    arrayOfHitsJsonObjects = jsonArray
//                                } else {
//                                  
//                                    // foundStarsList will be empty
//                                    return
//                                    
//                                    
//                                }
//                          
//                                    
//                                    //-------------------------
//                                    // Obtain Star Dictionary
//                                    //-------------------------
//                                    var starDictionary = Dictionary<String, Any>()
//                                    
//                        if (arrayOfHitsJsonObjects.count > 0 ){
//                                    if let jsonDictionary = arrayOfHitsJsonObjects[0] as? [String: Any] {
//                                        
//                                        starDictionary = jsonDictionary
//                                        }
//                                   else {
//                            
//                                        // foundStarsList will be empty
//                                        return
//                                    }
//
//                                    
//
//
//                                    if let y = starDictionary["key"] as? String
//                                    {
//                                        youTubeTrailerId = y
//                                    }
//                                    else {
//                                        youTubeTrailerId = ""
//                                    }
//                        
//                        }
//                             
//                                
//                            } catch {
//
//                                return
//                            }
//                      
//                      
//                      let jsonDataFromApi2 = getJsonDataFromApi(apiUrl: "http://www.omdbapi.com/?apikey=9f67dd7a&i=\(imdb_id)&plot=full&r=json")
//                      
//                      do {
//                            /*
//                             Foundation framework’s JSONSerialization class is used to convert JSON data
//                             into Swift data types such as Dictionary, Array, String, Number, or Bool.
//                             */
//                            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi2!,
//                                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
//                            
//                            //------------------------------------------
//                            // Obtain Top Level JSON Object (Dictionary)
//                            //------------------------------------------
//                            var topLevelDictionary = Dictionary<String, Any>()
//                            
//                            if let jsonObject = jsonResponse as? [String: Any] {
//                                topLevelDictionary = jsonObject
//                            } else {
//                        
//                                // foundStarsList will be empty
//                                return
//                            }
//                      
//
//                      
//                              if let r = topLevelDictionary["Rated"] as! String? {
//                                  mpaaRating = r
//                              }
//                      
//                              if let g = topLevelDictionary["Genre"] as! String? {
//                                  genres = g
//                              }
//                          
//                              if let d = topLevelDictionary["Director"] as! String? {
//                                  director = d
//                              }
//                          
//                              if let a = topLevelDictionary["Actors"] as! String? {
//                                  actors = a
//                              }
//                              
//                              if let i = topLevelDictionary["imdbRating"] as! String? {
//                                  imdbRating = i
//                              }
//
//                        } catch {
//
//                            return
//                        }
//                      
//        
//                      //*************************************************************
//                      // Construct a New Star Struct and Add it to foundStars
//                      //*************************************************************
//                      
//                      let foundMovie = Movies(id: UUID(), title: title, posterFileName: posterFileName, overview: overview, genres: genres, releaseDate: releaseDate, runtime: runtime, director: director, actors: actors, mpaaRating: mpaaRating, imdbRating: imdbRating, youTubeTrailerId: youTubeTrailerId, tmdbID: tmdbID)
//                      
//                      searchSongsList.append(foundMovie)
//                      
//                  }   // End of the for loop
//                  
//              } catch {
//
//                  return
//              }
//
//          }
