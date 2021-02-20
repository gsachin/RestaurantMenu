//
//  WebService.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/7/21.
//

import Foundation
import Combine

enum Environment {
    case TEST
    case MOCK
    case DEV
    case UAT
}
var selectedEnv:Environment = .MOCK

enum HttpMethod : String{
    case GET
    case POST
}

struct Resource<T> {
    var url:String
    var httpMethod:HttpMethod
}

struct WebService {
    let urlSession : URLSession
    init(urlSession : URLSession = .shared) {
        self.urlSession = urlSession
    }
    func APIRequest<T:Decodable>(resource : Resource<T>)->AnyPublisher<T,Error> {
       
        guard let url = URL(string: resource.url) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: resource.url])
                return Fail(error: error).eraseToAnyPublisher()
            }
        let urlRequest = URLRequest(url:url )
        return urlSession.dataTaskPublisher(for:urlRequest)
            .receive(on: RunLoop.main)
            .tryMap {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    
}
