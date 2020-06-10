//
//  UIView+SwiftEntryKit.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/4/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import Foundation

import SwiftEntryKit


// MARK: - UIView+SwiftEntryKit

extension UIView {

    // MARK: - Pubic Methods

    func showAsAuthentication() {
        SwiftEntryKit.display(entry: self, using: .authenticationAttributes)
    }

}
