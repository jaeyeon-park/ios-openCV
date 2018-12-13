//
//  processingAsker.swift
//  visionRevision
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


/*
 해당 processingAsker는 해당 전체 프로그램에서 1개의 인스턴스만 있는 analyzer 인스턴스를 호출하여 영상작업을 명령하는 객체이다.
 영상작업을 명령하기 위해서, 프레임 버퍼를 가져오는/추출하는 역할을 한다. 따라서 processingAsker는 hasFrameBuffer protocol을
 만족하는 클래스 내에서 인스턴스화 된다. (여기서는 movieMedia, cameraMedia 이다.)
 
 movieMedia, cameraMedia의 play 에서 register, stop에서 unregister 함수가 호출되어 taskHanler taskQ의 작업을 넣고 빼고 제어한다.
 */

import Foundation

class processingTask:hasTasks{
    private var _analyzer : analyzer = analyzerWrapper.share() //analyzer singleTone
    private var _taskManager : [taskSize:manageTasks] = [taskSize:manageTasks]()
    var hasBuffer : hasFrameBuffer? = nil
    var i : Int = 0
    
    //이미지 버퍼 추출 델리게이트 선정, 객체 생성
    //taskSize, taskCategory fps는 enum에 정의되어 있음
    init(){
        _taskManager[taskSize.heavy] = taskHandling.share(magnitude: taskSize.heavy)
        _taskManager[taskSize.light] = taskHandling.share(magnitude: taskSize.light)
    }
    
    //job 등록
    func register() {
        self.unregister()
        _taskManager[taskSize.heavy]?.insert(task: multiFactorAnalyze, category: taskCategory.processing)
        _taskManager[taskSize.light]?.insert(task: singleFactorAnalyze, category: taskCategory.processing)
    }
    
    //등록된 job 모두 제거
    func unregister() {
        hasBuffer = nil
        
        _taskManager[taskSize.heavy]?.removeAll(category: taskCategory.processing)
        _taskManager[taskSize.light]?.removeAll(category: taskCategory.processing)
    }
    
    
    //functions doing TASKS, JOBS
    private func multiFactorAnalyze(signal:Any){
        if let pixelBuffer = self.hasBuffer?.extractFrameBuffer(param: signal){
            self._analyzer.heavyTaskProcess(pixelBuffer)
            if self._analyzer.unpackColor.getSortedDominantColorKeys().count != 6 {
            }
        }
    }
    
    private func singleFactorAnalyze(signal:Any){
        if let pixelBuffer = self.hasBuffer?.extractFrameBuffer(param: signal){
            self._analyzer.lightTaskProcess(pixelBuffer)
        }
    }
    
    
}
