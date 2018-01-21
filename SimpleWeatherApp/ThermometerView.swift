//
//  ThermometerView.swift
//  SimpleWeatherApp
//
//  Created by Justyna Dolińska on 21/01/2018.
//  Copyright © 2018 Justyna Dolińska. All rights reserved.
//

import UIKit

@IBDesignable class ThermometerView: UIView {

    override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    var fillPercentage: CGFloat = 0.75
    var fillColor: UIColor = .red

    override func draw(_ rect: CGRect) {

        let lineWidth: CGFloat = 4
        let margin = lineWidth / 2.0
        let width = bounds.width - lineWidth
        let height = bounds.height - lineWidth

        let notFilledY = bounds.height * (1 - fillPercentage)
        var fillRect = bounds
        fillRect.origin.y = notFilledY
        fillRect.size.height -= notFilledY
        let fillPath = UIBezierPath(rect: fillRect)
        fillColor.setFill()
        fillPath.fill()

        let thermometerRect = bounds.insetBy(dx: margin, dy: margin)
        let rectanglePath = UIBezierPath(roundedRect: thermometerRect, cornerRadius: width / 2)
        UIColor.black.setStroke()
        rectanglePath.lineWidth = lineWidth
        rectanglePath.stroke()

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: width / 2).cgPath
        layer.mask = maskLayer

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
            let bezierPath = UIBezierPath()
            let y = margin + width / 2 + CGFloat(i) * graduationDistance
            let x = margin + width
            bezierPath.move(to: CGPoint(x: x - scaleLineLength, y: y))
            bezierPath.addLine(to: CGPoint(x: x, y: y))
            bezierPath.lineWidth = lineWidth
            bezierPath.stroke()
        }
    }
}
