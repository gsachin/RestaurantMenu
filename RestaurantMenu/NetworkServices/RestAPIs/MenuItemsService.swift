//
//  MenuItemsService.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import Combine

struct MenuItemsService {
    
    func loadMenuItems()->AnyPublisher<[MenuItem],Error> {
        let webService:WebService
        let resource = Resource<[MenuItem]>(url:ApiEndPoints.getMenuItems.rawValue , httpMethod: .GET)
        switch selectedEnv {
        case .MOCK:
            return MockURLSession<[MenuItem]>().dataTaskPublisher(for: ApiEndPoints.getMenuItems.rawValue).eraseToAnyPublisher()
        default:
            webService = WebService()
        }
       
        return webService.APIRequest(resource: resource)
    }
    
//    func getMenuItemsMockObject()->[MenuItem] {
//        var item = MenuItem()
//        item.categories = [.vegan, .glutenfree]
//        return [item]
//    }
}
//final class GetMenuItemsURLProtocol: URLProtocol {
//
//    static var lastTriedRequest: [URLRequest] = []
//
//    override class func canInit(with request: URLRequest) -> Bool {
//        lastTriedRequest.append(request)
//        return false
//    }
//
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//
//    override func startLoading() {
//        //do nothing
//    }
//
//    override func stopLoading() {
//        //do nothing
//    }
//
//}
