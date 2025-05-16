//
//  MovieDataModel.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 15/05/25.
//


import Foundation
import UIKit
import CoreData

class GalleryDataModel: NSObject {
    // Parameters.
    var section: String
    var id: Int
    var voteAverage: Double
    var title: String
    var overview : String
    var posterPath : Data
    var releaseDate : String
    var youtube : URL
    var crew : String
    var casting : String
    var youtube1 : URL
    var youtube2 : URL
    //    var isEdited: Bool = false
    
    override init() {
        section  = ""
         id = 0
        voteAverage = 0.0
         title = ""
         overview  = ""
         posterPath  = Data()
         releaseDate  = ""
        youtube = URL(fileURLWithPath: "")
        youtube1 = URL(fileURLWithPath: "")
        youtube2 = URL(fileURLWithPath: "")
        crew = ""
        casting = ""
        
    }
    func initWithData(galleryList: NSManagedObject) ->GalleryDataModel {
        section = galleryList.value(forKey: "section") as? String ?? ""
        id = galleryList.value(forKey: "id") as? Int ?? 0
        voteAverage = galleryList.value(forKey: "voteAverage") as? Double ?? 0.0
        title = galleryList.value(forKey: "title") as? String ?? ""
        overview = galleryList.value(forKey: "overview") as? String ?? ""
        posterPath = galleryList.value(forKey: "posterPath") as? Data ?? Data()
        releaseDate = galleryList.value(forKey: "releaseDate") as? String ?? ""
        youtube = galleryList.value(forKey: "youtube") as? URL ?? URL(fileURLWithPath: "")
        youtube1 = galleryList.value(forKey: "youtube1") as? URL ?? URL(fileURLWithPath: "")
        youtube2 = galleryList.value(forKey: "youtube2") as? URL ?? URL(fileURLWithPath: "")
        casting =  galleryList.value(forKey: "crew") as? String ?? ""
        casting = galleryList.value(forKey: "casting") as? String ?? ""
        return self
    }
    
}
