//
//  mediaClip.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import Foundation

class mediaClip:mediaDelegate{
    private var _camera  = cameraMedia()
    private var _movie = movieMedia()
    private var _taskExecutor : [taskSize:executeTask] = [taskSize:executeTask]()
    private let _patch = patcher()
    
    let processor = processingTask()
    let messenger = messageTask()
    let renderer = renderingTask()
    
    var camera : makeVideo {
        get{
            return _camera
        }
    }
    var movie : makeVideo {
        get{
            return _movie
        }
    }
    init(){
        processor.register()
        messenger.register()
        renderer.register()
        
        _taskExecutor[taskSize.heavy] = taskHandling.share(magnitude: taskSize.heavy)
        _taskExecutor[taskSize.light] = taskHandling.share(magnitude: taskSize.light)
        _camera.delegateMedia = self
        _movie.delegateMedia = self
    }
    //mediaDelegate
    func willStartVideoProcessing(with:hasFrameBuffer) {
        processor.hasBuffer = with
        _patch.whisper(taskManagerSize: taskSize.heavy, startJob: messenger.connectTo?.startInitialProcessing, afterNumOfFrame: 12, endJob: messenger.connectTo?.endInitialProcessing)
    }
    func didEndVideoProcessing() {
        processor.hasBuffer = nil
    }
    func notifyVideoFlowStart() {
        taskHandling.startALL()
    }
    func notifyVideoFlowEnd(){
        taskHandling.stopALL()
    }
}

protocol mediaDelegate{
    func willStartVideoProcessing(with:hasFrameBuffer)
    func didEndVideoProcessing()
    func notifyVideoFlowStart()
    func notifyVideoFlowEnd()
}
