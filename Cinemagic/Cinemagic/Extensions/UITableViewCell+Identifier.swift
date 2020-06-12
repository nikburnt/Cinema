//
//  UITableViewCell+Identifier.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit


// MARK: - UITableViewCell+Identifier

extension UITableViewCell {

    static var identifier: String { String(NSStringFromClass(Self.self).split(separator: ".").last ?? "") }

}
