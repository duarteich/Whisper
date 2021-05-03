//
//  WhisperData.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import Foundation

class WhisperData: Decodable {
    let popular: [Whisper]
}

class RepliesData: Decodable {
    let replies: [Whisper]
}

class Whisper: Decodable, CustomStringConvertible {
    let me2: Int
    let replies: Int
    let text: String
    let url: String
    let wid: String
    
    var children: [Whisper]?
    
    var description: String {
        if replies > 0, let children = children {
            return "\(me2) [\(children)]"
        } else {
            return "\(me2)"
        }
    }
}
