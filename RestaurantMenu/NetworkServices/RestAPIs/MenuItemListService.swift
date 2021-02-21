//
//  MenuItemsService.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/11/21.
//

import Foundation
import Combine

struct MenuItemListService {
    
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
//    func loadMenuItemImage(url:String)->AnyPublisher<Data,Error> {
//        let webService:WebService
//        let resource = Resource<Data>(url:url , httpMethod: .GET)
//        switch selectedEnv {
//        case .MOCK:
//            return MockURLSession<Data>(fileExtention: "png").dataTaskPublisher(for: url).eraseToAnyPublisher()
//        default:
//            webService = WebService()
//        }
//        return webService.APIRequest(resource: resource)
//    }
}
