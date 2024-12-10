//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Aykut Türkyılmaz on 8.12.2024.
//

import Foundation

struct YoutubeSearchResponse : Codable {
    let items : [VideoElement]
    
}

struct VideoElement : Codable {
    let id : IdVideoElement
    
}

struct IdVideoElement : Codable {
    let kind : String
    let videoId : String
}
