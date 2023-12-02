import UIKit

// MARK: - LoadingIndicatorImageView

final class LoadingIndicatorImageView: UIImageView {
    // MARK: Internal

    let kLoadingAnimationDuration: Double = 1.7
    let kRotationAnimationKey: String = "rotation"

    override var isHidden: Bool {
        didSet {
            configureAnimation()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureAnimation()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureAnimation()
    }

    // MARK: Private

    private func configureAnimation() {
        guard !isHidden else {
            return
        }

        layer.removeAnimation(forKey: kRotationAnimationKey)
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: Double.pi * 2.0)
        animation.duration = kLoadingAnimationDuration
        animation.isCumulative = true
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(animation, forKey: kRotationAnimationKey)
    }
}
