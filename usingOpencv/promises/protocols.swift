//
//  protocols.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import Foundation

protocol executeTask{
    func startTasks()
    func stopTasks()
}
protocol hasFrameBuffer {
    func extractFrameBuffer(param:Any)->CVPixelBuffer?
}
protocol hasTasks{
    func register()->Void
    func unregister()->Void
}
protocol makeVideo{
    func attachSrc(from:Any)
    func play(on:UIImageView)
    func stop()
}
protocol managePatchedTasks{
    func insert(patchedTask: @escaping (Int) -> Void)
    func removePatchedTask(atIndex:Int)
}
protocol manageTasks{
    func insert(task:@escaping (Any)->Void,category:taskCategory)
    func removeAll(category:taskCategory)
}
