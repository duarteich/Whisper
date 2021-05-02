//
//  WhisperData.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import Foundation

struct WhisperData: Decodable {
    let popular: [Whisper]
}

struct Whisper: Decodable {
    let me2: Int
    let replies: Int
    let text: String
    let url: String
    let wid: String
}
