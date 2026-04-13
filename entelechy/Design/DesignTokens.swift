//
//  DesignTokens.swift
//  entelechy
//
//  Created by Angel Prieto on 03/12/26.
//

import SwiftUI

enum AppColors {
    static let accent = Color(red: 154 / 255, green: 154 / 255, blue: 235 / 255)
    static let inputShadow = Color.black.opacity(0.18)
    static let floatingButtonBackground = Color(UIColor { traits in
        let base = UIColor.systemBackground
        let tint = UIColor(red: 154 / 255, green: 154 / 255, blue: 235 / 255, alpha: 1)
        let amount: CGFloat = traits.userInterfaceStyle == .dark ? 0.16 : 0.12
        return blend(base: base, tint: tint, amount: amount)
    })
}

private func blend(base: UIColor, tint: UIColor, amount: CGFloat) -> UIColor {
    var br: CGFloat = 0
    var bg: CGFloat = 0
    var bb: CGFloat = 0
    var ba: CGFloat = 0
    var tr: CGFloat = 0
    var tg: CGFloat = 0
    var tb: CGFloat = 0
    var ta: CGFloat = 0

    base.getRed(&br, green: &bg, blue: &bb, alpha: &ba)
    tint.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)

    let r = br + (tr - br) * amount
    let g = bg + (tg - bg) * amount
    let b = bb + (tb - bb) * amount
    let a = ba + (ta - ba) * amount

    return UIColor(red: r, green: g, blue: b, alpha: a)
}

enum AppLayout {
    static let pageSpacing: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let titleTopPadding: CGFloat = 50
    
    static let titleSpacer: CGFloat = 25

    static let buttonVerticalPadding: CGFloat = 10
    static let buttonCornerRadius: CGFloat = 14


    static let inputShadowRadius: CGFloat = 10
    static let inputShadowYOffset: CGFloat = 6

    static let calendarDaySize: CGFloat = 40
    static let calendarGridSpacing: CGFloat = 14
    static let calendarRowSpacing: CGFloat = 8
    static let calendarDayContentSpacing: CGFloat = 4
    static let calendarDayStrokeWidth: CGFloat = 2
    static let calendarTodayUnderlineWidth: CGFloat = 18
    static let calendarTodayUnderlineHeight: CGFloat = 2

    static let floatingButtonSize: CGFloat = 55
    static let floatingButtonInset: CGFloat = 50
    
    static let contentHorizontalInset: CGFloat = 0.75 * AppLayout.floatingButtonInset
    static let contentVerticalPadding: CGFloat = 5.0
//    static let floatingButtonBottomInset: CGFloat = 8
    static let floatingButtonShadowRadius: CGFloat = 8
    static let floatingButtonShadowYOffset: CGFloat = 4
    static let floatingButtonIndicatorSize: CGFloat = 10
}
