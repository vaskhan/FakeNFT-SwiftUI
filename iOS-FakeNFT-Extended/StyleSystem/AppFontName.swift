//
//  AppFontName.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//

/*
 Пример использования
 Text("Заголовок")
    .font(.appBold22)

 Text("Описание")
    .font(.appRegular15)

 Text("Мелкий текст")
    .font(.appMedium10)
 */

import SwiftUI

extension Font {

    /// Medium 10
    static var appMedium10: Font {
        .system(size: 10, weight: .medium)
    }

    /// Bold 22 (22/28)
    static var appBold22: Font {
        .system(size: 22, weight: .bold)
    }

    /// Bold 17 (17/22)
    static var appBold17: Font {
        .system(size: 17, weight: .bold)
    }

    /// Regular 13 (13/18)
    static var appRegular13: Font {
        .system(size: 13, weight: .regular)
    }

    /// Regular 15 (15/20)
    static var appRegular15: Font {
        .system(size: 15, weight: .regular)
    }

    /// Regular 17 (17/22)
    static var appRegular17: Font {
        .system(size: 17, weight: .regular)
    }

    /// Bold 34 (34/41)
    static var appBold34: Font {
        .system(size: 34, weight: .bold)
    }

    /// Bold 32 (32/41)
    static var appBold32: Font {
        .system(size: 32, weight: .bold)
    }
}
