//
//  UIActivity.swift
//  ActivityKit
//
//  Created by Chrisna Aing on 6/14/16.
//  Copyright © 2016 Chrisna. All rights reserved.
//

import UIKit

extension UIActivity {
    @objc(cka_lengthInPointsOfActivityImageFor:)
    func lengthInPointsOfActivityImageFor(traitCollection: UITraitCollection) -> CGFloat {
        switch traitCollection.userInterfaceIdiom {
        case .phone:
            // Full length is 60 points.
            return 50.0
        case .pad:
            // Full length is 76 points.
            return 64.0
        case .carPlay, .tv, .unspecified:
            // Doesn't make sense at this point, so return the same number as we do for phone.
            return 50.0
        }
    }
}
