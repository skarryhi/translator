//
//  Languages.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation

enum Language {
    case english
    case russian
    case spanish
}

func getTextLanguage(language: Language) -> String {
    switch language {
    case .english:
        return "English"
    case .russian:
        return "Russian"
    case .spanish:
        return "Spanish"
    }
}
