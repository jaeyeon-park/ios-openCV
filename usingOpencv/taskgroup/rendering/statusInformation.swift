//
//  statusInformation.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import Foundation
struct statusInformation{
    private var _fpsOldTime : Double = 0
    private var _lastFrameTime : CFTimeInterval? = nil
    private var _deltaTime : Double = 0
    mutating func updateProcessingFPSValue(fpsLabel : UILabel?){
        if fpsLabel == nil{
            return
        }
        let thisFrameTime : CFTimeInterval = CFAbsoluteTimeGetCurrent()
        var fps : Double! = 0
        
        if let lastFT = _lastFrameTime{
            _deltaTime = thisFrameTime - lastFT
        }else{
            _lastFrameTime = thisFrameTime
            _deltaTime = 0
        }
        if(_deltaTime != 0){
            fps = (1.0/_deltaTime).roundToPlaces(places: 3)
        }
        _lastFrameTime = thisFrameTime
        fpsLabel!.text = "\(fps!)"
    }
}
