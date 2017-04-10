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

    public override var activityType: UIActivityType? {
        return UIActivityType(rawValue: UIActivityTypeCKAOpenInSafari)
    }

    public override var activityTitle: String? {
        return NSLocalizedString("Open in Safari", comment: "Open in Safari activity title")
    }

    public override var activityImage: UIImage? {
        let traitCollection = UIScreen.main.traitCollection
        let sideLength = lengthInPointsOfActivityImageFor(traitCollection: traitCollection)
        let screenScale = UIScreen.main.scale
        return UIImage.openInSafariActivityImage(sideLength: sideLength, scale: screenScale)
    }

    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if (item as? URL) != nil {
                return true
            } else if let string = item as? String, URL(string: string) != nil {
                return true
            }
        }
        return false
    }

    public override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let itemURL = item as? URL {
                url = itemURL
            } else if let string = item as? String, let itemURL = URL(string: string) {
                url = itemURL
            }
        }
    }

    public override func perform() {
        guard let url = url else {
            activityDidFinish(false)
            return
        }

        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:]) { success in
                self.activityDidFinish(success)
            }
        } else {
            let didOpenURL = UIApplication.shared.openURL(url)
            activityDidFinish(didOpenURL)
        }
    }
}
