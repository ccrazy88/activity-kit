//
//  UIImage.swift
//  ActivityKit
//
//  Created by Chrisna Aing on 6/14/16.
//  Copyright © 2016 Chrisna. All rights reserved.
//

import UIKit

// Source/Inspiration:
// https://github.com/marcoarment/FCUtilities/blob/master/FCUtilities/FCOpenInSafariActivity.m

private struct OpenInSafariActivityImageConstants {

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
            colorComponentsSpace: baseSpace,
            components: components,
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

extension UIImage {

    private static func drawOpenInSafariGradient(
        context: CGContext,
        rectangle: CGRect,
        constants: OpenInSafariActivityImageConstants
    ) {
        context.saveGState()
        defer { context.restoreGState() }

        context.addEllipse(inRect: rectangle)
        context.clip()

        guard let gradient = constants.gradient else {
            return
        }

        context.drawLinearGradient(
            gradient,
            start: CGPoint(x: constants.halfLength, y: 0.0),
            end: CGPoint(x: constants.halfLength, y: constants.length),
            options: []
        )
    }

    private static func drawOpenInSafariTickLines(
        context: CGContext,
        constants: OpenInSafariActivityImageConstants
    ) {
        let tickLineColor = UIColor(white: 0.0, alpha: 0.5)
        tickLineColor.setStroke()

        (0..<constants.tickLineCount).forEach { i in
            context.saveGState()
            defer { context.restoreGState() }

            context.setBlendMode(.clear)
            context.translate(x: constants.halfLength, y: constants.halfLength)
            context.rotate(byAngle: constants.angleForTickLineIndex(index: i))
            context.translate(x: -constants.halfLength, y: -constants.halfLength)

            let tickLine = UIBezierPath()
            let tickLineStart = CGPoint(
                x: constants.halfLength - constants.tickMarkHalfWidth,
                y: constants.tickMarkToCircleGap
            )
            let tickLineEnd = CGPoint(
                x: constants.halfLength - constants.tickMarkHalfWidth,
                y: constants.tickMarkToCircleGap + constants.lengthForTickLineIndex(index: i)
            )

            tickLine.move(to: tickLineStart)
            tickLine.addLine(to: tickLineEnd)
            tickLine.lineWidth = constants.tickMarkWidth
            tickLine.stroke()
        }
    }

    private static func drawOpenInSafariTriangles(
        context: CGContext,
        constants: OpenInSafariActivityImageConstants
    ) {
        context.saveGState()
        defer { context.restoreGState() }

        context.translate(x: constants.halfLength, y: constants.halfLength)
        context.rotate(byAngle: .pi + .pi / 4.0)
        context.translate(x: -constants.halfLength, y: -constants.halfLength)

        let triangleColor = UIColor.black()
        triangleColor.setFill()

        let triangleLeftBasePoint = CGPoint(
            x: constants.halfLength - constants.triangleBaseHalfLength,
            y: constants.halfLength
        )
        let triangleRightBasePoint = CGPoint(
            x: constants.halfLength + constants.triangleBaseHalfLength,
            y: constants.halfLength
        )

        let topTriangle = UIBezierPath()
        let topTriangleStart = CGPoint(x: constants.halfLength, y: constants.triangleTipToCircleGap)
        topTriangle.move(to: topTriangleStart)
        topTriangle.addLine(to: triangleLeftBasePoint)
        topTriangle.addLine(to: triangleRightBasePoint)
        topTriangle.close()
        context.setBlendMode(.clear)
        topTriangle.fill()

        let bottomTriangle = UIBezierPath()
        let bottomTriangleStart = CGPoint(
            x: constants.halfLength,
            y: constants.length - constants.triangleTipToCircleGap
        )
        bottomTriangle.move(to: bottomTriangleStart)
        bottomTriangle.addLine(to: triangleLeftBasePoint)
        bottomTriangle.addLine(to: triangleRightBasePoint)
        bottomTriangle.close()
        context.setBlendMode(.normal)
        bottomTriangle.fill()
    }

    @objc(cka_openInSafariActivityImageForWidth:scale:)
    static func openInSafariActivityImage(sideLength length: CGFloat, scale: CGFloat) -> UIImage? {
        let size = CGSize(width: length, height: length)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let origin = CGPoint.zero
        let rectangle = CGRect(origin: origin, size: size)
        let constants = OpenInSafariActivityImageConstants(sideLength: length, scale: scale)

        drawOpenInSafariGradient(context: context, rectangle: rectangle, constants: constants)
        drawOpenInSafariTickLines(context: context, constants: constants)
        drawOpenInSafariTriangles(context: context, constants: constants)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

}
