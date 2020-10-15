//
//  PokeAPITargetType.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import Moya

extension PokeAPI: TargetType {
    
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        switch self {
        case .pokemons:
            return URL(string: AppConstants.baseURL)!
        case .detailPokemon(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .pokemons:
            return "pokemon"
        case .detailPokemon:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var paramaters: [String: String] {
        switch self {
        case .pokemons(let offset, let limit):
            return ["offset": "\(offset)", "limit": "\(limit)"]
        default:
            return [:]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: paramaters, encoding: parameterEncoding)
    }
    
}
