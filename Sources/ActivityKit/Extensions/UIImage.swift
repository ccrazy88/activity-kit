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

extension UIImage {
    // MARK: - Activity Images

    @objc(cka_openInSafariActivityImageForWidth:scale:)
    static func openInSafariActivityImage(sideLength length: CGFloat, scale: CGFloat) -> UIImage? {
        let size = CGSize(width: length, height: length)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let origin = CGPoint.zero
        let rectangle = CGRect(origin: origin, size: size)
        let constants = OpenInSafariActivityConstants(sideLength: length, scale: scale)

        drawOpenInSafariGradient(context: context, rectangle: rectangle, constants: constants)
        drawOpenInSafariTickLines(context: context, constants: constants)
        drawOpenInSafariTriangles(context: context, constants: constants)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    // MARK: - Helpers

    private static func drawOpenInSafariGradient(context: CGContext,
                                                 rectangle: CGRect,
                                                 constants: OpenInSafariActivityConstants) {
        context.saveGState()
        defer { context.restoreGState() }

        context.addEllipse(in: rectangle)
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

    private static func drawOpenInSafariTickLines(context: CGContext,
                                                  constants: OpenInSafariActivityConstants) {
        let tickLineColor = UIColor(white: 0.0, alpha: 0.5)
        tickLineColor.setStroke()

        (0 ..< constants.tickLineCount).forEach { index in
            context.saveGState()
            defer { context.restoreGState() }

            context.setBlendMode(.clear)
            context.translateBy(x: constants.halfLength, y: constants.halfLength)
            context.rotate(by: constants.angleForTickLineIndex(index: index))
            context.translateBy(x: -constants.halfLength, y: -constants.halfLength)

            let tickLine = UIBezierPath()
            let tickLineStart = CGPoint(
                x: constants.halfLength - constants.tickMarkHalfWidth,
                y: constants.tickMarkToCircleGap
            )
            let tickLineEnd = CGPoint(
                x: constants.halfLength - constants.tickMarkHalfWidth,
                y: constants.tickMarkToCircleGap + constants.lengthForTickLineIndex(index: index)
            )

            tickLine.move(to: tickLineStart)
            tickLine.addLine(to: tickLineEnd)
            tickLine.lineWidth = constants.tickMarkWidth
            tickLine.stroke()
        }
    }

    private static func drawOpenInSafariTriangles(context: CGContext,
                                                  constants: OpenInSafariActivityConstants) {
        context.saveGState()
        defer { context.restoreGState() }

        context.translateBy(x: constants.halfLength, y: constants.halfLength)
        context.rotate(by: .pi + .pi / 4.0)
        context.translateBy(x: -constants.halfLength, y: -constants.halfLength)

        let triangleColor = UIColor.black
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
        let bottomTriangleStart = CGPoint(x: constants.halfLength,
                                          y: constants.length - constants.triangleTipToCircleGap)
        bottomTriangle.move(to: bottomTriangleStart)
        bottomTriangle.addLine(to: triangleLeftBasePoint)
        bottomTriangle.addLine(to: triangleRightBasePoint)
        bottomTriangle.close()
        context.setBlendMode(.normal)
        bottomTriangle.fill()
    }
}
