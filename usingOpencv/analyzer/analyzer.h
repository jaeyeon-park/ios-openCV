//
//  analyzer.h
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

/*
 # To do
 - swift 상위 객체(analyzer instance를 만드는 객체)와 image processing 사이를 연결해주는 역할
 
 # Feature
 - 다중 작업(오래 걸리는 작업)들을 호출하는 함수와 단일작업(빨리 끝나는 작업)들을 호출하는 함수가 나뉘어져 있음.
 - heavyTaskProcess, lightTaskProcess 함수는 swift class에서 실행되는 함수들.
 - 외부에서 직접 호출이 불가능한 함수 : makeMatFromBuffer
    - makeMatFromBuffer에 대한 명시 및 구현은 analyzer.mm파일에만 명시되어 있음
    - interface에 명시되어 있지 않아 swift에서 쓸 수 없는 함수임.
 */


#ifdef __cplusplus

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv2/videoio/cap_ios.h"

#ifndef basicConstants_hpp
#import "basicConstants.hpp"
#endif

#endif
#import <Foundation/Foundation.h>

#import "colorAnalyzer.h"
#import "graphicAnalyzer.h"
#import "capturer.h"


NS_ASSUME_NONNULL_BEGIN

@interface analyzer : NSObject
{
#ifdef __cplusplus
    cv::Mat matFromFrame;
#endif
}
@property colorAnalyzer* unpackColor;
@property graphicAnalyzer* unpackGraphic;
@property capturer* unpackMoment;
-(id)init;
-(void)heavyTaskProcess:(id)frame;
-(void)lightTaskProcess:(id)frame;

@end

NS_ASSUME_NONNULL_END
