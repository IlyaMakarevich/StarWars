//
//  ReachabilityService.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation
import Alamofire

class ReachabilityService {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
