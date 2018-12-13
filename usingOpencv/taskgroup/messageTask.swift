//
//  messageTask.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

/*
 messageAsker는 processing된 analyzer의 값을 다른 클래스 인스턴스로 넘기는 역할을 갖는다.
 영상처리된 값들을 다른 모듈에서 활용할 수 있을 거라 생각하며 제작하였다.
 messageAsker class의 instance는 하나만 생성되고 사용되기를 상정하고 만들었다.
 본 meessageTalk instance는 영상처리 값이 필요한 instance에서 생성되고, connectTo에 영상처리 값이 필요한 instanc self를 할당하면 된다.
 이때 영상처리 값이 필요한 instance는 messageTaskDelegate를 구현해야한다.
 아래 영상처리 값을 사용하려면 register, 영상처리 값들이 더 필요하지 않으면 unregister를 해주면 된다.
 */


import Foundation
class messageTask:hasTasks{
    private var _analyzer : analyzer = analyzerWrapper.share()
    private var _taskManager : [taskSize:manageTasks] = [taskSize:manageTasks]()
    var connectTo : messageTaskDelegate?
    
    init(){
        _taskManager[taskSize.heavy] = taskHandling.share(magnitude: taskSize.heavy)
        _taskManager[taskSize.light] = taskHandling.share(magnitude: taskSize.light)
    }
    
    func register() {
        self.unregister()
        _taskManager[taskSize.heavy]?.insert(task: heavyTask, category: taskCategory.message)
        _taskManager[taskSize.light]?.insert(task: lightTask, category: taskCategory.message)
    }
    
    func unregister() {
        _taskManager[taskSize.heavy]?.removeAll(category: taskCategory.message)
        _taskManager[taskSize.light]?.removeAll(category: taskCategory.message)
    }
    
    private func heavyTask(param:Any){
        connectTo?.afterHeavyTask(colorResult: _analyzer.unpackColor, graphicResult: _analyzer.unpackGraphic)
    }
    private func lightTask(param:Any){
        connectTo?.afterLightTask(colorResult: _analyzer.unpackColor, graphicResult: _analyzer.unpackGraphic)
    }
}

protocol messageTaskDelegate{
    func afterHeavyTask(colorResult:colorAnalyzer, graphicResult:graphicAnalyzer)
    func afterLightTask(colorResult:colorAnalyzer, graphicResult:graphicAnalyzer)
    func startInitialProcessing()
    func endInitialProcessing()
}
