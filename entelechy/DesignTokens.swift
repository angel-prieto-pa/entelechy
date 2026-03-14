//
//  DesignTokens.swift
//  entelechy
//
//  Created by Angel Prieto on 03/12/26.
//

import SwiftUI

enum AppColors {
    static let accent = Color(red: 154 / 255, green: 154 / 255, blue: 235 / 255)
    static let inputShadow = Color.black.opacity(0.08)
}

enum AppLayout {
    static let pageSpacing: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let titleTopPadding: CGFloat = 30

    static let buttonVerticalPadding: CGFloat = 10
    static let buttonCornerRadius: CGFloat = 14

    static let inputCornerRadius: CGFloat = 28
    static let inputHeight: CGFloat = 112
    static let inputFontSize: CGFloat = 56
    static let inputShadowRadius: CGFloat = 10
    static let inputShadowYOffset: CGFloat = 6

    static let calendarDaySize: CGFloat = 38
    static let calendarGridSpacing: CGFloat = 14
    static let calendarRowSpacing: CGFloat = 8
    static let calendarDayContentSpacing: CGFloat = 4
    static let calendarDayStrokeWidth: CGFloat = 2
}
