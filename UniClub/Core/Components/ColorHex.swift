//
//  ColorHex.swift
//  UniClub
//
//  Created by 제욱 on 11/4/25.
//

import Foundation
import SwiftUI

// hex 코드를 사용하기 위한 Color Extension

extension Color {
    /// HEX 문자열로부터 Color 생성 (예: "#FF7600", "FF7600")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RRGGBB
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // fallback: 흰색
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
