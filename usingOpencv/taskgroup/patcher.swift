//
//  patcher.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


/*
 임의의 순간에 잡무를 집어넣기 위해 만든 class
 */
import Foundation
class patcher{
    private var _taskManager : [taskSize:managePatchedTasks] = [taskSize:managePatchedTasks]()
    init(){
        _taskManager[taskSize.heavy] = taskHandling.share(magnitude: taskSize.heavy) as managePatchedTasks
        _taskManager[taskSize.light] = taskHandling.share(magnitude: taskSize.light) as managePatchedTasks
    }
    func whisper(taskManagerSize:taskSize,startJob:(()->Void)?,afterNumOfFrame:Int,endJob:(()->Void)?){
        var frameCount = 0
        let patchedJob : (Int)->Void = {
            (indexPosition:Int)->Void in
            if frameCount == 1 {
                if let job = startJob{
                    job()
                }
            }
            if frameCount == afterNumOfFrame{
                if let job = endJob{
                    job()
                    self._taskManager[taskManagerSize]?.removePatchedTask(atIndex: indexPosition)
                }
            }
            if frameCount <= afterNumOfFrame{
                frameCount = frameCount + 1
            }
        }
        _taskManager[taskManagerSize]?.insert(patchedTask: patchedJob)
    }
}
