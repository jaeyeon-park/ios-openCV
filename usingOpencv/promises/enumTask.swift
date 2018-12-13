//
//  enumTask.swift
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


import Foundation

//task rate standard : frames per second
/*
 cvErode 사용시. taskSize.big의 fps max 값은 24
 아이폰 6 플러스 기준 taskSize.big fps 최대값 24 기준일 때 cpu 점유율 88~90%를 상회함.
 권장 fps 값은 10 ~ 12를 권장하는 바임. 60 ~ 65% 점유율을 보임. 이 또한 아이폰 6 플러스 기준
 */

let fps : [taskSize:Int] = [
    taskSize.heavy : 10,
    taskSize.light : 24
] //frame per second matching to size of task

enum taskSize{
    case heavy
    case light
}

//int는 taskState를 알아내기 위하여 사용
enum taskCategory:Int{
    case none = 0
    case rendering = 1
    case message = 10
    case processing = 100
    case whispering = 1000
}
