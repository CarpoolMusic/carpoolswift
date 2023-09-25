//
//  SongBrowser.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2023-09-25.
//

//import Alamofire
//
//class SpotifySongBrowser {
//
//    private let accessToken: String
//    private let baseURL = "https://api.spotify.com/v1/search"
//
//    init(accessToken: String) {
//        self.accessToken = accessToken
//    }
//
//    func searchForSong(query: String) {
//        AF.request(baseURL, headers: getHeaders()).response { response in
//            debugPrint(response)
//        }
//    }
//
//    private func getHeaders() -> HTTPHeaders {
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(self.accessToken)"
//        ]
//
//    }
//
//
//}
