//
//  WhisperViewModel.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import Foundation

public class WhisperViewModel {
    let whispers = Box([Whisper]())
    
    func fetchWhispers(parentWip: String? = nil) {
        WhisperService.getWhispers() { [weak self] (whisperData, error) in
            guard
                let self = self,
                let whisperData = whisperData
            else {
                return
            }
            self.whispers.value = whisperData.popular
        }
    }
}
