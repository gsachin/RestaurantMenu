//
//  MenuItemService.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/20/21.
//

import Foundation
import Combine
struct MenuItemService {
    //let Images = NSCache<AnyObject,NSData>()
    func loadMenuItemImage(url:String, success: @escaping(Data?)->Void, failer:@escaping(Error?)->Void ) {
        let webService:WebService
        switch selectedEnv {
        case .MOCK:
            return MockURLSession<Data>(fileExtention: "").downloadImage(for: url) { (data) in
                success(data)
            } fail: { (error) in
                failer(error)
            }

        default:
            webService = WebService()
            webService.downloadImage(for: url) { (data) in
                success(data)
            } fail: { (error) in
                failer(error)
            }
        }
    }
}
