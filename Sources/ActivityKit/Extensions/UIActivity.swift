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
            return 60.0
        case .pad:
            return 76.0
        case .carPlay, .TV, .unspecified:
            // Doesn't make sense at this point, so let's just return 60.0.
            return 60.0
        }
    }

}
