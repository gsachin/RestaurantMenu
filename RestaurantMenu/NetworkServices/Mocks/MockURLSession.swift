//
//  MockURLSession.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import Combine
enum MockError: Error {
    case ResouceNotFound
}

class MockURLSession<T:Decodable> {
    let fileExtention:String
    init(fileExtention:String = "json") {
        self.fileExtention = fileExtention
    }
    func dataTaskPublisher(for urlString: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
                return Fail(error: error).eraseToAnyPublisher()
            }
        let stub = url.lastPathComponent
        guard let data = Bundle(for:type(of: self)).url(forResource: stub, withExtension: fileExtention) else {
            return Fail(error: MockError.ResouceNotFound).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for:data)
            .receive(on: RunLoop.main)
            .tryMap {$0.data}
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func downloadImage(for urlString: String, success: @escaping(Data?)->Void, fail:@escaping(Error?)->Void )  {
        guard let url = URL(string: urlString) else {
                let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
                return fail(error)
            }
        let stub = url.lastPathComponent
        guard let data = Bundle(for:type(of: self)).url(forResource: stub, withExtension: fileExtention) else {
            return fail(MockError.ResouceNotFound)
        }
        //URLSession.shared.dataTask(with: url) { data, response, error in
            // do your stuff here...
            DispatchQueue.main.async {
                success(try? Data(contentsOf: data))
                // do something on the main queue
            }
        //}.resume()
    }
}
