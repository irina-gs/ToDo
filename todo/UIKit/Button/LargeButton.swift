//
//  LargeButton.swift
//  todo
//
//  Created by admin on 12.12.2023.
//

import UIKit

final class LargeButton: UIButton {
    var minSide: CGFloat = 48

    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let additionalHSide = max(0, max(bounds.width, minSide) - bounds.width)
        let additionalVSide = max(0, max(bounds.height, minSide) - bounds.height)
        let newBound = CGRect(
            x: bounds.origin.x - additionalHSide / 2,
            y: bounds.origin.y - additionalVSide / 2,
            width: bounds.width + additionalHSide,
            height: bounds.height + additionalVSide
        )
        return newBound.contains(point)
    }
}
