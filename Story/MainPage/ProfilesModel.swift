//
//  ProfilesModel.swift
//  Story
//
//  Created by Onur Can Avcı on 18.10.2020.
//

import Foundation
import ObjectMapper

class ProfilesModel: Mappable {

    var profiles: [Profile] = []
    
    func mapping(map: Map) {
        profiles  <- map["profiles"]
    }
    
    required init(map: Map) {
        
    }
    
    
}

class Profile: Mappable {
    
    var userName: String?
    var userPp: String?
    var stories: [Story]?
    var snapVisitedCount = 0
    
    func mapping(map: Map) {
        userName   <- map["username"]
        userPp     <- map["user_pp"]
        stories    <- map["stories"]
    }
    
    required init(map: Map) {
        
    }
    
}

class Story: Mappable {
    
    var storyId: Int?
    var storyTime: String?
    var url: String?
    var contentType: Int?

    func mapping(map: Map) {
        storyId     <- map["story_id"]
        storyTime   <- map["story_time"]
        url         <- map["url"]
        contentType <- map["content_type"]
    }


    required init(map: Map) {
        
    }
}
