//
//  OpenInSafariActivityConstants.swift
//  ActivityKit
//
//  Created by Chrisna Aing on 6/14/16.
//  Copyright © 2016 Chrisna. All rights reserved.
//

import Foundation

struct OpenInSafariActivityConstants {

    let length: CGFloat
    let halfLength: CGFloat
    let triangleTipToCircleGap: CGFloat
    let triangleBaseHalfLength: CGFloat
    let tickMarkToCircleGap: CGFloat
    let tickMarkLengthLong: CGFloat
    let tickMarkLengthShort: CGFloat
    let tickMarkWidth: CGFloat
    let tickMarkHalfWidth: CGFloat
    let tickLineCount = 72

    var gradient: CGGradient? {
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [ 0.0, 0.0, 0.0, 0.25,
                                      0.0, 0.0, 0.0, 0.5 ]
        let gradient = CGGradient(
            colorSpace: baseSpace,
            colorComponents: components,
            locations: nil,
            count: 2
        )
        return gradient
    }

    init(sideLength length: CGFloat, scale: CGFloat) {
        self.length = length

        halfLength = length / 2.0
        triangleTipToCircleGap = ceil(0.012 * length)
        triangleBaseHalfLength = ceil(0.125 * length) / 2.0
        tickMarkToCircleGap = ceil(0.0325 * length)
        tickMarkLengthLong = ceil(0.08 * length)
        tickMarkLengthShort = ceil(0.045 * length)
        tickMarkWidth = 1.0 / scale
        tickMarkHalfWidth = tickMarkWidth / 2.0
    }

    func angleForTickLineIndex(index: Int) -> CGFloat {
        return 2.0 * .pi * CGFloat(index) / CGFloat(tickLineCount)
    }

    func lengthForTickLineIndex(index: Int) -> CGFloat {
        return index % 2 == 1 ? tickMarkLengthShort : tickMarkLengthLong
    }

}
