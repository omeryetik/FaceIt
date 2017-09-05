//
//  FaceView.swift
//  FaceIt
//
//  Created by Ömer Yetik on 05/09/2017.
//  Copyright © 2017 Ömer Yetik. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    //  Public API
    
    @IBInspectable
    var scale: CGFloat = 0.9    // 1.0 is full smile and -1.0 is full frown
    
    @IBInspectable
    var eyesOpen: Bool = true
    
    @IBInspectable
    var mouthCurvature: Double = 0.5
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    
    @IBInspectable
    var color: UIColor = .blue
    
    //  Private implementation
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width / 2, bounds.size.height / 2) * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += (eye == .left ? 1 : -1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path: UIBezierPath
        if eyesOpen {
            path = UIBezierPath(
                arcCenter: eyeCenter,
                radius: eyeRadius,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: false
            )
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset / 2,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: start.y + smileOffset)

        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: skullCenter,
            radius: skullRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }

    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }

}