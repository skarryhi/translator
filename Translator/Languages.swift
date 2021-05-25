//
//  Languages.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation

class Languages {

    var sourseLanguage: Language {
        didSet {
            sourseLanguageText = getTextLanguage(language: self.sourseLanguage)
        }
    }
    var resultLanguage: Language {
        didSet {
            resultLanguageText = getTextLanguage(language: self.resultLanguage)
        }
    }
    
    var sourseLanguageText: String = "English"
    var resultLanguageText: String = "Russian"
    
    init() {
        sourseLanguage = .english
        resultLanguage = .russian
    }
    
    
    private func getTextLanguage(language: Language) -> String {
        switch language {
        case .english:
            return "English"
        case .russian:
            return "Russian"
        case .spanish:
            return "Spanish"
        }
    }
    
    func swipe() {
        let sourse = sourseLanguage
        sourseLanguage = resultLanguage
        resultLanguage = sourse
    }
    
    static func otherLanguages(for language: Language) -> [String] {
        var otherLanguages: [String] = []
        
        switch language {
        case .english:
            otherLanguages.append("Russian")
            otherLanguages.append("Spanish")
        case .russian:
            otherLanguages.append("English")
            otherLanguages.append("Spanish")
        case .spanish:
            otherLanguages.append("English")
            otherLanguages.append("Russian")
        }
        return otherLanguages
    }
}

enum Language {
    case english
    case russian
    case spanish
}

