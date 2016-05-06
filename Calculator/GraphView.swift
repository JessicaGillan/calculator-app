//
//  GraphView.swift
//  Calculator
//
//  Created by Jessica Gillan on 5/4/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

// Often called "delegate' instead, but when only use is to provide data since View cant own its own
// data -> call Data Source
// Needs whatever funcs/props required to get this View's data
// GraphViewDataSource can only be implemented by a class, allows weak pointer designation
protocol GraphViewDataSource: class {
    // Ask someone else for data by passing this message, send myself as sender, so you have pointer
    // to sender in case need to ask it for other things, etc
    func yCoordForGraphView(sender: GraphView, x: CGFloat) -> CGFloat? // Optional since data soucre might not be ale to provide
    
}

@IBDesignable
class GraphView: UIView
{
    // Create AxesDrawer instance to access methods, intance variables
    var xyAxesDrawer = AxesDrawer(color: UIColor.darkGrayColor())
    
    var origin: CGPoint? { didSet{ setNeedsDisplay() } }
    
    // setNeedsDisplay anytime change variable that effects layout
    @IBInspectable
    var scale: CGFloat = 50 { didSet{ setNeedsDisplay() } }
    
    // Has anyone set themselves as this variable? as data soure?, weak so view and data source (controller)
    // dont keep each other in memory, this pointer wont keep dataSource in memory, always use weak for delegation
    weak var dataSource: GraphViewDataSource?
    
    private struct Constants {
        static let PanGestureScale: CGFloat = 2
    }
 
    func scaleGraph(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1 // Reset to one so continuously scaling in increments
        }
    }
    
    func panGraph(gesture: UIPanGestureRecognizer){
        switch gesture.state {
            case .Ended: fallthrough
            case .Changed:
                let translation = gesture.translationInView(self)
                let originXchange = translation.x/Constants.PanGestureScale
                let originYchange = translation.y/Constants.PanGestureScale
                if originXchange != 0 || originYchange != 0 {
                    origin?.x += originXchange
                    origin?.y += originYchange
                    // Reset Translation so can do incremental updates, offset does not accrue
                    gesture.setTranslation(CGPointZero, inView: self)
                }
            default: break
        }
    }
    
    func setOrigin(gesture: UITapGestureRecognizer){
        if gesture.state == .Ended {
            origin = gesture.locationInView(self)
        }
    }

    override func drawRect(rect: CGRect) {
        if origin == nil {
            // "center" is View's center in coordinate system of superview, must convert
            origin = convertPoint(center, fromView: superview)
        }
        xyAxesDrawer.contentScaleFactor = UIScreen.mainScreen().scale // content scale factor of screen, Not sure why wont work in initialization, maybe because screen is not set/accessible??
        xyAxesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
        
//        for x dataPoint in 0..window bounds, get y coord, change x/y to window coordinates and draw line (see AxesDrawer for help)
    }


}
