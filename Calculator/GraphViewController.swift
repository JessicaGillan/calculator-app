//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jessica Gillan on 5/4/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController
{
    // When sequed  to get data from model (calculatorBrain) and interpret it for UI (graph it), updateUI
    
    @IBOutlet weak var graphView: GraphView! {
        didSet{
            graphView.addGestureRecognizer( UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.scaleGraph)) )
            graphView.addGestureRecognizer( UIPanGestureRecognizer(target: graphView, action: #selector(graphView.panGraph)) )
        }
    }
    
    
    func updateUI(){
    
    }


    
    

}
