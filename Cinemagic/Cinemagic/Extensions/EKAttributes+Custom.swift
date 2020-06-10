//
//  EKAttributes+Custom.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/4/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import SwiftEntryKit


// MARK: - EKAttributes+Custom


extension EKAttributes {

    // MARK: - Public Methods

    static var authenticationAttributes: EKAttributes {
        var attributes = EKAttributes.centerFloat

        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .warning
        attributes.entryInteraction = .forward
        attributes.screenInteraction = .forward
        attributes.scroll = .disabled
        attributes.screenInteraction = .absorbTouches

        attributes.entranceAnimation = .init(translate: .init(duration: 0.4, anchorPosition: .bottom),
                                             scale: .init(from: 0.8, to: 1, duration: 0.4),
                                             fade: .init(from: 0.6, to: 1, duration: 0.2))

        attributes.exitAnimation = .init( translate: .init(duration: 0.4, anchorPosition: .top),
                                          scale: .init(from: 1, to: 0.8, duration: 0.4),
                                          fade: .init(from: 1, to: 0.6, duration: 0.2))

        attributes.roundCorners = .all(radius: 16)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.positionConstraints.size = .init(width: .offset(value: 20), height: .intrinsic)
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 20, screenEdgeResistance: nil))

        return attributes
    }

}
