//
//  ThermometerView.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit


private let lineWidth: CGFloat = 4


@IBDesignable final class ThermometerView: UIView {

    override var bounds: CGRect {
        didSet {

            setupMaskLayer()
            setupFillLayerPath()
            setupThermometerLayerPath()
        }
    }

    @IBInspectable var fillPercentage: CGFloat {
        get {
            return percentage
        }
        set {
            if isAnimating {
                return
            }
            percentage = newValue
            setupFillLayerPath()
        }
    }

    @IBInspectable var fillColor: UIColor = .red {
        didSet {
            setupFillLayer()
        }
    }

    private var isAnimating = false
    private var percentage: CGFloat = 0.5
    private var fillLayer = CAShapeLayer()
    private var thermometerLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setup()
    }

    func animate() {
        isAnimating = true
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = fillPath(forPerctentage: 0.4)
        animation.toValue = fillPath(forPerctentage: 0.6)
        animation.duration = 1
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.autoreverses = true
        animation.fillMode = kCAFillModeForwards
        fillLayer.add(animation, forKey: nil)
    }

    func stopAnimating() {
        fillLayer.removeAllAnimations()
        percentage = (fillLayer.path?.boundingBoxOfPath.height ?? 0) / bounds.height
        isAnimating = false
    }

    func animateFill(toPercentage percentage: CGFloat) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "path")
        let newPath = fillPath(forPerctentage: percentage)
        animation.toValue = newPath
        animation.duration = Double(2.5 * abs(fillPercentage - percentage))
        //animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        isAnimating = true
        CATransaction.setCompletionBlock {
            self.percentage = percentage
            self.isAnimating = false
            self.fillLayer.path = newPath
        }
        fillLayer.add(animation, forKey: nil)
        CATransaction.commit()
    }

    private func setup() {
        layer.addSublayer(fillLayer)
        layer.addSublayer(thermometerLayer)

        setupMaskLayer()
        setupFillLayer()
        setupFillLayerPath()
        setupThermometerLayer()
        setupThermometerLayerPath()
    }

    private func setupMaskLayer() {

        let maskLayer = CAShapeLayer()
        let width = bounds.width - lineWidth
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: width / 2).cgPath
        layer.mask = maskLayer
    }

    private func setupThermometerLayer() {
        thermometerLayer.lineWidth = lineWidth
        thermometerLayer.strokeColor = UIColor.black.cgColor
        thermometerLayer.fillColor = nil
    }

    private func setupThermometerLayerPath() {

        let height = bounds.height - lineWidth
        let width = bounds.width - lineWidth
        let thermometerRect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let thermometerPath = UIBezierPath(roundedRect: thermometerRect, cornerRadius: width / 2)
        thermometerPath.lineWidth = lineWidth

        guard width > 0 else {
            return
        }
        let numberOfScaleLines = Int(round(height / width * 2)) - 1

        guard numberOfScaleLines > 1 else {
            return
        }
        let graduationDistance = (height - width) / CGFloat(numberOfScaleLines - 1)
        let scaleLineLength = width / 2

        for i in 0..<numberOfScaleLines {
            let y = lineWidth / 2 + width / 2 + CGFloat(i) * graduationDistance
            let x = lineWidth / 2 + width
            thermometerPath.move(to: CGPoint(x: x - scaleLineLength, y: y))
            thermometerPath.addLine(to: CGPoint(x: x, y: y))
        }
        thermometerLayer.path = thermometerPath.cgPath
    }

    private func setupFillLayer() {
        fillLayer.fillColor = fillColor.cgColor
    }

    private func setupFillLayerPath() {
        fillLayer.path = fillPath(forPerctentage: fillPercentage)
    }

    private func fillPath(forPerctentage perctentage: CGFloat) -> CGPath {
        let notFilledY = bounds.height * (1 - perctentage)
        var fillRect = bounds
        fillRect.origin.y = notFilledY
        fillRect.size.height -= notFilledY
        return CGPath(rect: fillRect, transform: nil)
    }
}
