//
//  GraphView.swift
//  Calculator
//
//  Created by Jessica Gillan on 5/4/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView
{
    // Create AxesDrawer instance to access methods, intance variables
    var xyAxesDrawer = AxesDrawer()
    
    var origin: CGPoint {
        set{
            
            
        } get{
            // "center" is View's center in coordinate system of superview, must convert
            return convertPoint(center, fromView: superview)
        }
    }
    // setNeedsDisplay anytime change variable that effects layout
    @IBInspectable
    var scale: CGFloat = 50 { didSet{ setNeedsDisplay() } }
 
    func scaleGraph(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1 // Reset to one so continuously scaling in increments
        }
    }
    
    private struct Constants {
        static let PanGestureScale: CGFloat = 4
    }
    
    func panGraph(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            let originXchange = translation.x/Constants.PanGestureScale
            let originYchange = translation.y/Constants.PanGestureScale
            origin.x += originXchange
            origin.y += originYchange
        default: break
        }
    }

    override func drawRect(rect: CGRect) {
        xyAxesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
    }


}
