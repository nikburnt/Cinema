//
//  UITableView+Dequeue.swift
//  Cinemagic
//
//  Created by Nik Burnt on 6/11/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit


// MARK: - UITableView+Dequeue

extension UITableView {

    // MARK: - Public Methods

    func dequeue<T>(for indexPath: IndexPath) -> T? where T: UITableViewCell {
        dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }

}
