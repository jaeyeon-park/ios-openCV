//
//  colorAnalyzer.h
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencv2/videoio/cap_ios.h"
#import "internalFunctions.hpp"
#import "colorPalette.hpp"

#ifndef basicConstants_hpp
#import "basicConstants.hpp"
#endif

#endif
/*
 하는 일 : 중앙 색상, 주요 색상 (RGB :255,255,255), 주요 색상 비율 추출
 특징
 : processing 함수와 getter 함수가 나뉘어져 있음.
 : graphicInfo interface와 묶이기 위해 상위 analyzer interface에서 호출되어 인스턴스를 만듦
 : 실제 프로세싱 작업이 이루어지는 곳.
 
 */

#define COLORINFO
@interface colorAnalyzer : NSObject{
    NSNumber* brightness;
    
    NSMutableArray* centerColor;
    NSMutableArray* domiColorKey;
    NSMutableArray* domiColorValue;
}
-(id) init;

#ifdef __cplusplus
-(NSArray*)processCenterColorWith : (cv::Mat)frame;
-(NSNumber*)processBrightnessWith : (cv::Mat)frame;
-(void)processDominantColorWith : (cv::Mat)frame colorCount:(int)paletteCount; // return Array의 0 번이 keys들 1번이 values이다
#endif
-(NSMutableArray*)getCenterColor;
-(NSMutableArray*)getSortedDominantColorKeys;
-(NSMutableArray*)getSortedDominantcolorValues;
-(NSNumber*)getBrightness;


@end
