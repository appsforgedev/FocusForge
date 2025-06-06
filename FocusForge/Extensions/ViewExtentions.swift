//
//  ViewExtentions.swift
//  FocusForge
//
//  Created by Shcherbinin Andrey on 06.06.2025.
//
import SwiftUI

extension View {
    @ViewBuilder
    func debugOverlay<Overlay: View>(
        @ViewBuilder _ overlay: () -> Overlay,
        alignment: Alignment = .topTrailing
    ) -> some View {
#if DEBUG
        ZStack(alignment: alignment) {
            self
            overlay()
        }
#else
        self
#endif
    }
}
