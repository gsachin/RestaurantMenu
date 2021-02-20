//
//  MockURLSession.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import Combine
class MockURLSession<T:Decodable> {
    func dataTaskPublisher(for urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
                return Fail(error: error).eraseToAnyPublisher()
            }
        let stub = url.lastPathComponent
        return URLSession.shared.dataTaskPublisher(for: Bundle(for:type(of: self)).url(forResource: stub, withExtension: "json")!)
            .receive(on: RunLoop.main)
            .tryMap {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
