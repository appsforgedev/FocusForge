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
    
    // Кнопки
    static var forgeButton: Font {
        .custom("Inter-Regular", size: 12)
    }

    // Цифровой таймер
    static var forgeTimer: Font {
        .custom("JetBrainsMono-Medium", size: 40)
    }
}
