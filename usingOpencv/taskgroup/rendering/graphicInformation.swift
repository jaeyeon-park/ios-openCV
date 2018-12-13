//
//  graphicInformation.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

import Foundation
struct graphicInformation{
    private var _from : analyzer!
    init(inside : analyzer){
        _from = inside
    }
    func renderCentColor(centColorViewer : UIView?){
        if centColorViewer == nil{
            return
        }
        if let centerColorExtract = _from.unpackColor.getCenterColor() as? Array<Int>{
            if centerColorExtract.count > 0{
                var centColor : Array<CGFloat> = [0,0,0];
                for i in 0...2{
                    centColor[i] = CGFloat((Float((centerColorExtract[i])))/255);
                }
                let cgCentColor = UIColor(red: centColor[0], green: centColor[1], blue: centColor[2], alpha: 1.0);
                centColorViewer?.backgroundColor = cgCentColor
            }
        }
        return
    }
    
    func renderDomiColor(domiColorViewers : Array<UIView>?){
        if domiColorViewers == nil{
            return
        }
        
        if let dominantColorKey : Array<Array<Float>> = _from.unpackColor.getSortedDominantColorKeys() as? Array<Array<Float>>{
            var viewIndex : Int = 5
            if(dominantColorKey.count <= viewIndex){
                viewIndex = dominantColorKey.count - 1
            }
            
            if(viewIndex != -1){
                for i in 0...viewIndex{
                    let domiColor = UIColor(red:CGFloat(dominantColorKey[i][0]/255),green:CGFloat(dominantColorKey[i][1]/255),blue:CGFloat(dominantColorKey[i][2]/255),alpha:1.0);
                    domiColorViewers?[i].backgroundColor = domiColor
                }
            }
        }
    }
    
    func renderSimplifiedFrame(processingViewer : UIImageView?){
        processingViewer?.image = _from.unpackGraphic.getSimplified();
    }
    
    func renderDifferFrame(processingViewer : UIImageView?){
        processingViewer?.image = _from.unpackGraphic.getDiff();
    }
    
    
    func updateDomiColorRatioValue(domiColorValues : Array<UILabel>?){
        if domiColorValues == nil{
            return
        }
        if let dominantColorValues : Array<Int> = _from.unpackColor.getSortedDominantcolorValues() as? Array<Int>{
            var viewIndex : Int = 5;
            if(dominantColorValues.count <= viewIndex){
                viewIndex = dominantColorValues.count - 1;
            }
            if(viewIndex != -1){
                for i in 0...viewIndex{
                    domiColorValues?[i].text = "\(dominantColorValues[i])%"
                }
            }
        }
    }
    func updateSimplicityValue(valueLabel : UILabel?){
        valueLabel?.text = "\(_from.unpackGraphic.getSimplicity()!)";
    }
    
    func updateBrightnessValue(valueLabel : UILabel?){
        let brightnessValue : NSNumber = _from.unpackColor.getBrightness()!;
        valueLabel?.text = "\(brightnessValue)";
        valueLabel?.backgroundColor = UIColor(hue: 1.0, saturation: 0, brightness: CGFloat(brightnessValue.floatValue/1000), alpha: 1.0);
        valueLabel?.textColor = UIColor(hue: 1.0, saturation: 0, brightness: CGFloat(1 - brightnessValue.floatValue/1000), alpha: 1.0);
    }
    
    func updateDifferentialValue(valueLabel : UILabel?){
        if let value = _from.unpackGraphic.getDifference() as? Double {
            valueLabel?.text = "\(value.roundToPlaces(places: 2))"
        }
    }
}
