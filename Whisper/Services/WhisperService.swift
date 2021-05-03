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
    typealias RepliesDataCompletion = (RepliesData?, WhisperError?) -> ()
    
    private static let host = "prod.whisper.sh"
    private static let popularPath = "/whispers/popular"
    private static let repliesPath = "/whispers/replies"
    private static let limit = "200"
    
    static func getWhispers(completion: @escaping WhisperDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = popularPath
        urlBuilder.queryItems = [URLQueryItem(name: "limit", value: limit)]
        
        let url = urlBuilder.url!
        
        makeDataTask(url: url, type: WhisperData.self, completion: completion)
    }
    
    static func getReplies(parentWid: String, completion: @escaping RepliesDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = repliesPath
        urlBuilder.queryItems = [
            URLQueryItem(name: "limit", value: limit),
            URLQueryItem(name: "wid", value: parentWid)
        ]
        
        let url = urlBuilder.url!
        
        makeDataTask(url: url, type: RepliesData.self, completion: completion)
    }
    
    static func makeDataTask<T: Decodable>(url: URL, type: T.Type, completion: @escaping (T?, WhisperError?) -> ()) {
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
                    let data = try JSONDecoder().decode(type, from: data)
                    completion(data, nil)
                } catch {
                    print(error)
                    print("Unable to decode Whisper response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
}
