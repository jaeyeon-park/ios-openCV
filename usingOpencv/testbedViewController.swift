//
//  testbedViewController.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import UIKit

class testbedViewController: UIViewController {
    
    private let clip = mediaClip()
    @IBOutlet var labelStack: UIStackView!
    
    @IBOutlet var processingValueLabels : [UILabel]?
    @IBOutlet var differenceView: UIImageView?
    @IBOutlet var simplifiedView: UIImageView?
    @IBOutlet var cameraView: UIImageView?
    @IBOutlet var dominantColors : [UILabel]?
    @IBOutlet var centerColorView : UIView?
    
    @IBAction func cameraOnOff(_ sender: UISwitch) {
        if(sender.isOn){
            clip.camera.stop()
            if let view = cameraView{
                clip.camera.attachSrc(from: 0)
                clip.camera.play(on: view)
            }
        }else{
            clip.camera.stop()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view load")
        // Do any additional setup after loading the view, typically from a nib.
        labelStack.addBackground(color: UIColor(white: 1.0, alpha: 0.8))
        
        clip.renderer.simplicityValueLabel = processingValueLabels?[0]
        clip.renderer.brightnessValueLabel = processingValueLabels?[1]
        clip.renderer.differentialValueLabel = processingValueLabels?[2]
        clip.renderer.simplifiedImageView = simplifiedView
        clip.renderer.differentialImageView = differenceView
        clip.renderer.centerColorView = centerColorView
        clip.renderer.dominantColorViews = dominantColors
        clip.renderer.dominantColorRatioLabels = dominantColors
    }


}

