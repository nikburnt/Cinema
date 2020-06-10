//
//  AnimatedFieldFormat+Styles.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/31/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import AnimatedField


// MARK: - AnimatedFieldFormat+Styles

extension AnimatedFieldFormat {

    // MARK: - Public Variables

    static var common: AnimatedFieldFormat {
        var format = AnimatedFieldFormat()

        format.textFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        format.titleFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        format.alertFont = UIFont.systemFont(ofSize: 11, weight: .regular)
        format.counterFont = format.titleFont

        format.titleColor = #colorLiteral(red: 0.3254901961, green: 0.537254902, blue: 0.6901960784, alpha: 1)
        format.lineColor = #colorLiteral(red: 0.3254901961, green: 0.537254902, blue: 0.6901960784, alpha: 1)
        format.textColor = #colorLiteral(red: 0.168627451, green: 0.2745098039, blue: 0.3490196078, alpha: 1)
        format.highlightColor = #colorLiteral(red: 0.168627451, green: 0.2745098039, blue: 0.3490196078, alpha: 1)

        format.alertColor = #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        format.titleAlwaysVisible = false
        format.alertEnabled = true
        format.alertFieldActive = true
        format.alertLineActive = true
        format.alertTitleActive = true
        format.alertPosition = .bottom

        return format
    }

}
