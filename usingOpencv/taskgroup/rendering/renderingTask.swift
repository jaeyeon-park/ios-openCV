//
//  renderingTask.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

import Foundation
class renderingTask : hasTasks{
    private var _graphicRendering : graphicInformation
    private var _statusRendering : statusInformation
    private var _taskManager : [taskSize:manageTasks]
    
    var simplifiedImageView : UIImageView?
    var simplicityValueLabel : UILabel?
    var dominantColorViews : Array<UIView>?
    var dominantColorRatioLabels : Array<UILabel>?
    var brightnessValueLabel : UILabel?
    var differentialValueLabel : UILabel?
    var differentialImageView : UIImageView?
    var centerColorView : UIView?
    
    init(){
        _graphicRendering = graphicInformation(inside: analyzerWrapper.share())
        _statusRendering = statusInformation()
        _taskManager = [taskSize:manageTasks]()
        _taskManager[taskSize.heavy] = taskHandling.share(magnitude: taskSize.heavy)
        _taskManager[taskSize.light] = taskHandling.share(magnitude: taskSize.light)
    }
    
    func register(){
        self.unregister()
        _taskManager[taskSize.heavy]?.insert(task: bigSizeTask, category: taskCategory.rendering)
        _taskManager[taskSize.light]?.insert(task: smallSizeTask, category: taskCategory.rendering)
    }
    
    func unregister() {
        _taskManager[taskSize.heavy]?.removeAll(category: taskCategory.rendering)
        _taskManager[taskSize.light]?.removeAll(category: taskCategory.rendering)
    }
    
    
    private func bigSizeTask(param: Any) {
        _graphicRendering.renderDifferFrame(processingViewer: differentialImageView)
        _graphicRendering.updateDifferentialValue(valueLabel: differentialValueLabel)
        _graphicRendering.renderDomiColor(domiColorViewers: dominantColorViews)
        _graphicRendering.updateDomiColorRatioValue(domiColorValues: dominantColorRatioLabels)
        _graphicRendering.renderSimplifiedFrame(processingViewer: simplifiedImageView)
        _graphicRendering.updateSimplicityValue(valueLabel: simplicityValueLabel)
    }
    
    private func smallSizeTask(param: Any) {
        _graphicRendering.renderCentColor(centColorViewer: centerColorView)
        _graphicRendering.updateBrightnessValue(valueLabel: brightnessValueLabel)
        
    }
}
