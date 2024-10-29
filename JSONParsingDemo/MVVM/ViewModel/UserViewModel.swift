//
//  UserViewModel.swift
//  JSONParsingDemo
//
//  Created by Yashwant Kumar on 29/10/24.
//

import Foundation

class UserViewModel {
    var matchedData: [MatchedData] = []
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchData() {
        
        let group = DispatchGroup()
        
        var users: [User] = []
        var posts: [Post] = []
        
        group.enter()
        fetchUsers { result in
            switch result {
            case .success(let fetchedUsers):
                users = fetchedUsers
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        fetchPosts { result in
            switch result {
            case .success(let fetchedPosts):
                posts = fetchedPosts
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main){
            self.matchData(users: users, posts: posts)
            self.onDataUpdate?()
        }
    }
    
    private func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch users:", error)
                return completion(.failure(error))
                
            }
            
            guard let data = data else {
                print("No data received for users")
                return completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "NO data found"])))
                
            }
            
            let result = Result {
                try JSONDecoder().decode([User].self, from: data)
            }

            switch result {
            case .success(let users):
                print("Fetched users:", users)
            case .failure(let decodingError):
                print("Failed to decode users:", decodingError)
            }
            
            completion(result)
        }.resume()
    }
    
    //Fetching posts from API
    private func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found" ])))
            }
            
            let result = Result {
                try JSONDecoder().decode([Post].self, from: data)
            }
            
            switch result {
            case .success(let posts):
                print("Fetched posts:", posts)
            case .failure(let decodingError):
                print("Failed to decode posts", decodingError)
            }
            
            /*completion(Result {
                try JSONDecoder().decode([Post].self, from: data)
            })*/
            completion(result)
        }.resume()
    }
    
    private func matchData(users: [User], posts: [Post]) {
        matchedData = posts.compactMap { post in
            guard let user = users.first(where: { $0.id == post.id }) else { return nil }
            
            return MatchedData(
                companyName: user.company.name,
                lat: user.address.geo.lat,
                lng: user.address.geo.lng,
                title: post.title,
                body: post.body
            )
        }
        print("Matched data:", matchedData)
    }
    
}
