//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jessica Gillan on 5/4/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource
{
    // When sequed  to get data from model (calculatorBrain) and interpret it for UI (graph it), updateUI
    
    // make new instance of a calculator brain and load it with program set in memory
    // use brains evaluate() to evaluate equation for each x? give it each x by setting value of M (memory
    // location m) to new x value, and re-evaluate.

    
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            graphView.dataSource = self // Set controller as graphView data source
            
            graphView.addGestureRecognizer( UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.scaleGraph)) )
            graphView.addGestureRecognizer( UIPanGestureRecognizer(target: graphView, action: #selector(graphView.panGraph)) )
            
            let doubleTapGesture = UITapGestureRecognizer(target: graphView, action: #selector(graphView.setOrigin))
            doubleTapGesture.numberOfTapsRequired = 2
            graphView.addGestureRecognizer( doubleTapGesture )

        }
    }
    
    
    
    // UpdateUI if the model changes (should be triggered by segue?
    private func updateUI(){
        graphView.setNeedsDisplay()
    }

    // Interpret model for view
    func yCoordForGraphView(sender: GraphView, x: CGFloat) -> CGFloat? {
        <#code#>
    }
}
