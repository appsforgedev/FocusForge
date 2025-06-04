//
//  Font+Forge.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 26.05.2025.
//

import SwiftUI

extension Font {
    
    // Заголовки
    static var forgeTitle: Font {
        .custom("Montserrat-SemiBold", size: 20)
    }
    
    // Подписи / основной текст
    static var forgeBody: Font {
        .custom("Inter-Regular", size: 13)
    }
    
    // Second
    static var forgeSecond: Font {
        .custom("Inter-Regular", size: 12)
    }
    
    // Small
    static var forgeSmall: Font {
        .custom("Inter-Regular", size: 10)
    }

    // Цифровой таймер
    static var forgeTimer: Font {
        .custom("JetBrainsMono-Medium", size: 40)
    }
}
