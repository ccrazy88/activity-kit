//
//  OpenInSafariActivity.swift
//  ActivityKit
//
//  Created by Chrisna Aing on 6/14/16.
//  Copyright © 2016 Chrisna. All rights reserved.
//

import UIKit

public let UIActivityTypeCKAOpenInSafari = "UIActivityTypeCKAOpenInSafari"

public final class OpenInSafariActivity: UIActivity {

    private var url: URL?

    override public func activityType() -> String? {
        return UIActivityTypeCKAOpenInSafari
    }

    override public func activityTitle() -> String? {
        let title = NSLocalizedString("Open in Safari", comment: "Open in Safari activity title")
        return title
    }

    override public func activityImage() -> UIImage? {
        let traitCollection = UIScreen.main().traitCollection
        let sideLength = lengthInPointsOfActivityImageFor(traitCollection: traitCollection) - 10.0
        let screenScale = UIScreen.main().scale
        return UIImage.openInSafariActivityImage(sideLength: sideLength, scale: screenScale)
    }

    override public func canPerform(withActivityItems activityItems: [AnyObject]) -> Bool {
        for item in activityItems {
            if let _ = item as? NSURL {
                return true
            } else if let string = item as? String, _ = NSURL(string: string) {
                return true
            }
        }
        return false
    }

    override public func prepare(withActivityItems activityItems: [AnyObject]) {
        for item in activityItems {
            if let itemURL = item as? URL {
                url = itemURL
            } else if let string = item as? String, itemURL = URL(string: string) {
                url = itemURL
            }
        }
    }

    override public func perform() {
        if let url = url {
            if #available(iOS 10, *) {
                UIApplication.shared().open(url, options: [:]) { success in
                    self.activityDidFinish(success)
                }
            } else {
                let didOpenURL = UIApplication.shared().openURL(url)
                activityDidFinish(didOpenURL)
            }

        } else {
            activityDidFinish(false)
        }
    }

}
