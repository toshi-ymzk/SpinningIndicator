
//
//  SpinningIndicator.swift
//  origami
//
//  Created by Toshihiro Yamazaki on 2019/04/26.
//  Copyright © 2018 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

public class SpinningIndicator: UIView {
    
    public let size = CGSize(width: 24, height: 24)
    
    private let innerLayer = CAShapeLayer()
    private let outerLayer = CAShapeLayer()
    private lazy var shapeLayers: [CAShapeLayer] = [innerLayer, outerLayer]
    
    private let rotationAnimKey = "rotation"
    private let strokeEndAnimKey = "strokeEnd"
    
    private var isAnimating = false
    private var strokeEnd: Double = 0.8
    private lazy var radius = self.size.width / 2 + 4
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        createCircle()
    }
    
    func createCircle() {
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = startAngle + 2.0 * CGFloat(Double.pi)
        let innerPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let outerPath = UIBezierPath(arcCenter: center, radius: radius + 3, startAngle: startAngle + CGFloat(Double.pi), endAngle: endAngle + CGFloat(Double.pi), clockwise: true)
        
        innerLayer.frame = CGRect(origin: .zero, size: size)
        innerLayer.fillColor = UIColor.clear.cgColor
        innerLayer.strokeColor = UIColor.init(red: 255/255, green: 91/255, blue: 25/255, alpha: 1).cgColor
        innerLayer.lineWidth = 2
        innerLayer.lineCap = kCALineCapRound
        innerLayer.backgroundColor = UIColor.clear.cgColor
        innerLayer.path = innerPath.cgPath
        innerLayer.strokeEnd = CGFloat(strokeEnd)
        layer.addSublayer(innerLayer)
        
        outerLayer.frame = CGRect(origin: .zero, size: size)
        outerLayer.fillColor = UIColor.clear.cgColor
        outerLayer.strokeColor = UIColor.orange.withAlphaComponent(1).cgColor
        outerLayer.lineWidth = 2
        outerLayer.lineCap = kCALineCapRound
        outerLayer.backgroundColor = UIColor.clear.cgColor
        outerLayer.path = outerPath.cgPath
        outerLayer.strokeEnd = CGFloat(strokeEnd)
        layer.addSublayer(outerLayer)
    }
    
    public func beginAnimating() {
        isAnimating = true
        let min = CGFloat(0.02)
        let max = CGFloat(strokeEnd)
        DispatchQueue.main.async {
            if self.layer.animation(forKey: self.rotationAnimKey) == nil {
                self.layer.add(self.rotationAnimation, forKey: self.rotationAnimKey)
            }
            self.shapeLayers.forEach { $0.add(
                self.keyFrameRotationAnimation(
                    duration: 2,
                    times: [0, 0.3, 0.7, 1],
                    values: [0, 0.15, 0.85, 1],
                    timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    repeatCount: Float.infinity),
                forKey: self.rotationAnimKey)
            }
            self.shapeLayers.forEach { $0.add(
                self.keyFrameStrokeEndAnimation(
                    duration: 2,
                    times: [0, 0.2, 0.3, 0.7, 1],
                    values: [min, max, max, min, min],
                    timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    repeatCount: Float.infinity),
                forKey: self.strokeEndAnimKey)
            }
        }
    }
    
    public func endAnimating() {
        isAnimating = false
        DispatchQueue.main.async {
            self.layer.removeAllAnimations()
            self.shapeLayers.forEach { $0.removeAllAnimations() }
            self.shapeLayers.forEach { $0.strokeEnd = 0 }
        }
    }
}

extension SpinningIndicator {
    
    func beginAnimatingFromShrink() {
        isAnimating = true
        DispatchQueue.main.async {
            if self.layer.animation(forKey: self.rotationAnimKey) == nil {
                self.layer.add(self.rotationAnimation, forKey: self.rotationAnimKey)
            }
            self.shrink()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                self.shapeLayers.forEach { $0.removeAllAnimations() }
                self.beginAnimating()
            })
        }
    }
    
    func shrink() {
        let min = CGFloat(0.02)
        let max = CGFloat(strokeEnd)
        self.shapeLayers.forEach { $0.strokeEnd = min }
        self.shapeLayers.forEach { $0.add(
            self.keyFrameRotationAnimation(
                duration: 0.4,
                times: [0, 1],
                values: [0, 0.66],
                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)),
            forKey: self.rotationAnimKey)
        }
        self.shapeLayers.forEach { $0.add(
            self.keyFrameStrokeEndAnimation(
                duration: 0.4,
                times: [0, 1],
                values: [max, min],
                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)),
            forKey: self.strokeEndAnimKey)
        }
    }
}

/**
 * Animation Utility
 */
extension SpinningIndicator {
    
    private var rotationAnimation: CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = CGFloat.pi * 1
        anim.duration = 2
        anim.repeatCount = MAXFLOAT
        anim.isCumulative = true
        return anim
    }
    
    private func keyFrameRotationAnimation(duration: Double, times: [NSNumber], values: [CGFloat], timingFunction: CAMediaTimingFunction, repeatCount: Float = 0) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.isCumulative = true
        anim.duration = duration
        anim.keyTimes = times
        anim.values = values.compactMap({ $0 * 3 * CGFloat.pi })
        anim.timingFunction = timingFunction
        anim.repeatCount = repeatCount
        return anim
    }
    
    private func keyFrameStrokeEndAnimation(duration: Double, times: [NSNumber], values: [CGFloat], timingFunction: CAMediaTimingFunction, repeatCount: Float = 0) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "strokeEnd")
        anim.duration = duration
        anim.keyTimes = times
        anim.values = values
        anim.timingFunction = timingFunction
        anim.repeatCount = repeatCount
        return anim
    }
}
