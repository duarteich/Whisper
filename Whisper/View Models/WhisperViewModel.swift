//
//  WhisperViewModel.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import Foundation

public class WhisperViewModel {
    let whispers = Box([Whisper]())
    
    let repliesGroup = DispatchGroup()
    
    func fetchWhispers() {
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
    
    func fetchReplies(whisper: Whisper, completion: (() -> Void)? = nil) {
        WhisperService.getReplies(parentWid: whisper.wid) { [weak self] (repliesData, error) in
            guard
                let self = self,
                let repliesData = repliesData
            else {
                return
            }
            whisper.children = repliesData.replies
            print(whisper)
            guard let children = whisper.children else { return }
            for whisper in children {
                self.repliesGroup.enter()
                self.fetchReplies(whisper: whisper) {
                    self.repliesGroup.leave()
                }
            }
            if let completion = completion {
                completion()
            }
            self.repliesGroup.notify(queue: .main) {
                print("All children retrieved")
            }
        }
    }
    
    func findHighestThread(replies: [Whisper]) {
        
    }
}
