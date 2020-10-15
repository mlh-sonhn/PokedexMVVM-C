//
//  PokemonColor.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

struct HexColor {
    static var white: UIColor = UIColor().colorFromHex(hex: "faffff")
    static var lightGrey: UIColor = UIColor().colorFromHex(hex: "D3D3D3")
}

struct PokemonColor {
    var background: UIColor
    var text: UIColor
    var type: UIColor
}

enum PokemonType: String, CaseIterable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
    
    var color: PokemonColor {
        switch self {
        case .normal:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        case .fighting:
            return PokemonColor(background: UIColor().colorFromHex(hex: "C03028"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "C03028"))
        case .flying:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        case .poison:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A040A0"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A040A0"))
        case .ground:
            return PokemonColor(background: UIColor().colorFromHex(hex: "E0C068"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "E0C068"))
        case .rock:
            return PokemonColor(background: UIColor().colorFromHex(hex: "B8A038"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "B8A038"))
        case .bug:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8B820"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8B820"))
        case .ghost:
            return PokemonColor(background: UIColor().colorFromHex(hex: "705890"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "705890"))
        case .steel:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        case .fire:
            return PokemonColor(background: UIColor().colorFromHex(hex: "F08030"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "F08030"))
        case .water:
            return PokemonColor(background: UIColor().colorFromHex(hex: "6890F0"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "6890F0"))
        case .grass:
            return PokemonColor(background: UIColor().colorFromHex(hex: "78C850"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "78C850"))
        case .electric:
            return PokemonColor(background: UIColor().colorFromHex(hex: "F8D030"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "F8D030"))

        case .psychic:
            return PokemonColor(background: UIColor().colorFromHex(hex: "F85888"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "F85888"))
        case .ice:
            return PokemonColor(background: UIColor().colorFromHex(hex: "98D8D8"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "98D8D8"))
        case .dragon:
            return PokemonColor(background: UIColor().colorFromHex(hex: "7038F8"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "7038F8"))
        case .dark:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        case .fairy:
            return PokemonColor(background: UIColor().colorFromHex(hex: "EE99AC"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "EE99AC"))
        case .unknown:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        case .shadow:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "A8A878"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A8A878"))
        }
    }
    
    var url: String {
        let baseURL = "https://pokeapi.co/api/v2/type/"
        var id = 0
        switch self {
        case .normal:
            id = 1
        case .fighting:
            id = 2
        case .flying:
            id = 3
        case .poison:
            id = 4
        case .ground:
            id = 5
        case .rock:
            id = 6
        case .bug:
            id = 7
        case .ghost:
            id = 8
        case .steel:
            id = 9
        case .fire:
            id = 10
        case .water:
            id = 11
        case .grass:
            id = 12
        case .electric:
            id = 13
        case .psychic:
            id = 14
        case .ice:
            id = 15
        case .dragon:
            id = 16
        case .dark:
            id = 17
        case .fairy:
            id = 18
        case .unknown:
            id = 10001
        case .shadow:
            id = 10002
        }
        return baseURL + "\(id)"
    }
    
    static func type(from string: String?) -> PokemonType {
        guard let string = string else { return .normal }
        if let index = allCases.map({$0.rawValue}).firstIndex(of: string) {
            return allCases[index]
        }
        return .normal
    }
}
