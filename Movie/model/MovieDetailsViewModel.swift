//
//  MovieDetailsViewModel.swift
//  Movie
//
//  Created by KHJ on 2023/09/13.
//

import SwiftUI

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    @Published var movieCredits: MovieCredits?
    @Published var movieCast: [MovieCredits.Cast] = []
    @Published var castProfiles: [CastProfile] = []
    
    @Published var recommendations: [Recommendation] = []
    
    
    
    func getMovieCredits(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(MovieCredits.self, from: data)
            self.movieCredits = decodedData
            //MovieCredits struct의 Cast array를 정렬하기.
           #warning("the meaning of order")
            self.movieCast = decodedData.cast.sorted { $0.order < $1.order}
            print("done")
        } catch {
            
        }
    }
    
    //인물 더 자세한 정보 받아오기. ( 인물 이미지 때문에 받아와야 함)
    //이렇게 하면 MovieCredit.Cast에서는 id랑 order만 받아와도 될듯?..
    func getCastProfiles() async {
        for member in movieCast {
            let url = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let decoder = JSONDecoder()
            //            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decodedData = try decoder.decode(CastProfile.self, from: data)
                castProfiles.append(decodedData)
                
            } catch {
                print("Error \(error)")
                
            }
            
        }
        
    }
    
    
    
    func getRecommendations(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations?api_key=\(MovieDiscoverViewModel.apiKey)&language=en-US")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try decoder.decode(RecommendationsResponses.self, from: data)
            recommendations = decodedData.results
            
        } catch {
            
        }
        
        
    }
    
}
struct CastProfile: Decodable, Identifiable {
    let id: Int
    let name: String
    let profile_path: String?
    
    var photoUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/original")
        return baseURL?.appending(path: profile_path ?? "")
    }
    
    
    static var preview: CastProfile {
        return CastProfile(id: 3, name: "Harrison Ford", profile_path: "/5M7oN3sznp99hWYQ9sX0xheswWX.jpg")
        
    }

}

struct MovieCredits: Decodable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Decodable, Identifiable {
        let id: Int
        let name: String
        let character: String
        let order: Int
    }
}



struct RecommendationsResponses: Decodable {
    let results: [Recommendation]
}

struct Recommendation: Decodable, Identifiable {
    let title: String
    let id: Int
    let poster_path: String?
    
    
    var posterUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/original")
        return baseURL?.appending(path: poster_path ?? "")
    }
    
}
