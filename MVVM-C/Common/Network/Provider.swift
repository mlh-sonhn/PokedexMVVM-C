//
//  Provider.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift

let pluginsProvider = [NetworkLoggerPlugin()]
let provider = PokeProvider<PokeAPI>(plugins: [])

class PokeProvider<PokeAPI>: MoyaProvider<PokeAPI> where PokeAPI: TargetType {
    var apiSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        configuration.timeoutIntervalForRequest = 30
        var session = Session(configuration: configuration)
        return session
    }()
    
    override init(endpointClosure: @escaping MoyaProvider<PokeAPI>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<PokeAPI>.RequestClosure = MoyaProvider<PokeAPI>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<PokeAPI>.StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil, session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = [], trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure,
                   stubClosure: stubClosure, callbackQueue: callbackQueue, session: apiSession,
                   plugins: plugins, trackInflights: trackInflights)
    }
}
