//
//  LoadingViewController.swift
//  Cinemagic
//
//  Created by Nik Burnt on 5/28/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import UIKit

import ARSLineProgress
import GradientAnimator


// MARK: - LoadingViewController

class LoadingViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = GradientAnimator(frame: self.view.frame, theme: GradientThemes.SolidStone, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
        self.view.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()

        ARSLineProgressConfiguration.backgroundViewStyle = .blur
        ARSLineProgress.ars_showOnView(self.view)
        // Do any additional setup after loading the view.
    }


}

