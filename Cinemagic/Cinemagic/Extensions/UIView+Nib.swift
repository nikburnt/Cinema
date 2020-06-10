//
//  UIView+Nib.swift
//  Meditations
//
//  Created by Nik Burnt on 25.09.2017.
//  Copyright © 2017 grinasys. All rights reserved.
//

import UIKit


// MARK: - NibBasedView

protocol NibBasedView {

    static var nibName: String { get }
    static var nib: UINib { get }

    static func instantiateFromNib() -> Self?

}


// MARK: - NibBasedView+UIView

extension NibBasedView where Self: UIView {

    // MARK: - NibBasedView Properties

    static var nibName: String { "\(self)" }

    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }


    // MARK: - NibBasedView Methods

    static func instantiateFromNib() -> Self? {
        nib.instantiate(withOwner: nil, options: nil).first { $0 is Self } as? Self
    }

}
