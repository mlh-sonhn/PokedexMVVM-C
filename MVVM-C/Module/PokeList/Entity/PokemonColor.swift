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
            return PokemonColor(background: UIColor().colorFromHex(hex: "6D6D4E"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "6D6D4E"))
        case .fighting:
            return PokemonColor(background: UIColor().colorFromHex(hex: "7D1F1A"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "7D1F1A"))
        case .flying:
            return PokemonColor(background: UIColor().colorFromHex(hex: "6D5E9C"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "6D5E9C"))
        case .poison:
            return PokemonColor(background: UIColor().colorFromHex(hex: "682A68"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "682A68"))
        case .ground:
            return PokemonColor(background: UIColor().colorFromHex(hex: "927D44"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "927D44"))
        case .rock:
            return PokemonColor(background: UIColor().colorFromHex(hex: "786824"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "786824"))
        case .bug:
            return PokemonColor(background: UIColor().colorFromHex(hex: "6D7815"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "6D7815"))
        case .ghost:
            return PokemonColor(background: UIColor().colorFromHex(hex: "493963"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "493963"))
        case .steel:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "787887"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "787887"))
        case .fire:
            return PokemonColor(background: UIColor().colorFromHex(hex: "9C531F"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "9C531F"))
        case .water:
            return PokemonColor(background: UIColor().colorFromHex(hex: "445E9C"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "445E9C"))
        case .grass:
            return PokemonColor(background: UIColor().colorFromHex(hex: "4E8234"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "4E8234"))
        case .electric:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A1871F"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A1871F"))

        case .psychic:
            return PokemonColor(background: UIColor().colorFromHex(hex: "A13959"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "A13959"))
        case .ice:
            return PokemonColor(background: UIColor().colorFromHex(hex: "638D8D"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "638D8D"))
        case .dragon:
            return PokemonColor(background: UIColor().colorFromHex(hex: "4924A1"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "4924A1"))
        case .dark:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "49392F"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "49392F"))
        case .fairy:
            return PokemonColor(background: UIColor().colorFromHex(hex: "9B6470"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "9B6470"))
        case .unknown:
            //CHUACO
            return PokemonColor(background: UIColor().colorFromHex(hex: "44685E"),
                                text: .white,
                                type: UIColor().colorFromHex(hex: "44685E"))
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
