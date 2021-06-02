//
//  StructResponse.swift
//  Translator
//
//  Created by Saturn Karry on 5/29/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation

struct Result: Codable {
    var text : String
}

struct Translations: Codable {
    var translations : [Result]
}
