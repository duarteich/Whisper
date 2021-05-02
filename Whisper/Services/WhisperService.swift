//
//  PixelService.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

import Foundation

enum WhisperError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class WhisperService {
    typealias WhisperDataCompletion = (WhisperData?, WhisperError?) -> ()
    
    private static let host = "prod.whisper.sh"
    private static let popularPath = "/whispers/popular"
    private static let repliesPath = "/whispers/replies"
    private static let limit = "50"
    
    static func getWhispers(completion: @escaping WhisperDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = popularPath
        urlBuilder.queryItems = [URLQueryItem(name: "limit", value: limit)]
        
        let url = urlBuilder.url!
        
        makeDataTask(url: url, completion: completion)
    }
    
    static func makeDataTask(url: URL, completion: @escaping WhisperDataCompletion) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from Whisper: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from Whisper")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process Whisper response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from Whisper: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let whisperData: WhisperData = try JSONDecoder().decode(WhisperData.self, from: data)
                    completion(whisperData, nil)
                } catch {
                    print(error)
                    print("Unable to decode Whisper response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
}
