//
//  DateScrollPickerFormat+Styles.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/14/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import DateScrollPicker


// MARK: - DateScrollPickerFormat+Styles

extension DateScrollPickerFormat {

    // MARK: - Public Variables

    static var common: DateScrollPickerFormat {
        var format = DateScrollPickerFormat()

        format.topTextColor = #colorLiteral(red: 0.9411764706, green: 0.9764705882, blue: 1, alpha: 1)
        format.mediumTextColor = format.topTextColor
        format.bottomTextColor = format.topTextColor

        format.topTextSelectedColor = #colorLiteral(red: 0.9411764706, green: 0.9764705882, blue: 1, alpha: 1)
        format.mediumTextSelectedColor = format.topTextSelectedColor
        format.bottomTextSelectedColor = format.topTextSelectedColor

        format.dayBackgroundColor = #colorLiteral(red: 0.2901960784, green: 0.462745098, blue: 0.5882352941, alpha: 1)
        format.dayBackgroundSelectedColor = #colorLiteral(red: 0.2039215686, green: 0.3294117647, blue: 0.4196078431, alpha: 1)

        format.animatedSelection = true
        format.separatorEnabled = false

        return format
    }

}
