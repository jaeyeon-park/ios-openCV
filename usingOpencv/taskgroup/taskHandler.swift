//
//  taskHandler.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


/*
 taskHandler class는 taskHandling class 내부에서 인스턴스화 되고 해당 인스턴스를 공유하여 사용하도록 하고 있다.
 taskHandling.shareIt()을 사용하여 클래스 주소를 넘겨, task를 부탁하는 객체와 task 실행, 정지 명령을 내리는 객체들이 어디서든
 동일한 taskHandler instance를 제어하도록 하였다.
 
 taskAsker들(renderingAsker, messageAsker, processingAsker)과 viewController에서 동일한 본 클래스 인스턴스가 호출된다.
 */


import Foundation

class taskHandler:manageTasks, managePatchedTasks, executeTask{
    private var displayLinker : CADisplayLink?
    private var taskQ : Dictionary<taskCategory,Array<(Any)->Void>>
    private var patchedTaskQ : [(Int)->Void]
    private var _taskState : Int
    //public check 용 : debugging용도
    var taskState : Int{
        get{
            return _taskState
        }
    }
    init(stdFps:Int = 5){
        _taskState = 0
        taskQ = Dictionary<taskCategory,Array<(Any)->Void>>()
        patchedTaskQ = [(Int)->Void]()
        displayLinker = CADisplayLink(target: self, selector: #selector(linkerCallback));
        displayLinker?.preferredFramesPerSecond = stdFps
        displayLinker?.add(to: .current, forMode: .common)
        displayLinker?.isPaused = true; //등록 후 일시정지
    }
    
    @objc func linkerCallback(sender : CADisplayLink){
        let signal = sender;
        
        //아래가 제대로 동작할지 의문... 유의할 곳
        //동작한다!!!!!!!
        for (_,tasks) in taskQ{
            for task in tasks{
                task(signal)
            }
        }
        for index in 0..<patchedTaskQ.endIndex{
            patchedTaskQ[index](index)
        }
        //print("current taskState : \(taskState)")
    }
    
    //manageTasks protocol
    func insert(task: @escaping (Any) -> Void, category: taskCategory) {
        if taskQ[category] == nil {
            taskQ[category] = [(Any)->Void]()
        }
        _taskState = _taskState + category.rawValue
        taskQ[category]?.append(task)
    }
    func removeAll(category: taskCategory) {
        if taskQ[category] != nil{
            _taskState = _taskState - category.rawValue*(taskQ[category]?.count)!
            taskQ[category]?.removeAll()
        }
    }
    //managePatchedTask Protocol
    func insert(patchedTask: @escaping (Int) -> Void){
        patchedTaskQ.append(patchedTask)
    }
    func removePatchedTask(atIndex:Int){
        let _ = patchedTaskQ.remove(at: atIndex)
    }
    
    //executeTasks protocol
    func startTasks() {
        print(_taskState)
        print("START")
        if displayLinker != nil && displayLinker?.isPaused != false{
            displayLinker?.isPaused = false
        }else{
            print("displayLinker is nill or already start");
        }
        displayLinker?.isPaused = false;
        if _taskState<=taskCategory.none.rawValue{
            print("no job to start")
        }
    }
    func stopTasks() {
        if displayLinker != nil && displayLinker?.isPaused != true{
            displayLinker?.isPaused = true
        }else{
            print("displayLinker is nil or already stop")
        }
        
        if _taskState<=taskCategory.none.rawValue{
            print("no job to stop")
        }
        print("taks stop")
    }
}

class taskHandling{
    private static var _taskHandlers:[taskSize:taskHandler] = Dictionary<taskSize,taskHandler>()
    static func share(magnitude:taskSize)->taskHandler{
        if _taskHandlers[magnitude] == nil {
            _taskHandlers[magnitude] = taskHandler(stdFps: fps[magnitude]!)
        }
        return _taskHandlers[magnitude]!
    }
    //비상시 사용하기 위해 만들었음
    static func stopALL(){
        for (_,handler) in _taskHandlers{
            handler.stopTasks()
        }
    }
    static func startALL(){
        for (_,handler) in _taskHandlers{
            handler.startTasks()
        }
    }
}
