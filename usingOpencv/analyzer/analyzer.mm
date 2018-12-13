//
//  analyzer.mm
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#import "analyzer.h"

@implementation analyzer
-(id)init{
    self = [super init];
    if(self){
        self.unpackColor = [[colorAnalyzer alloc] init];
        self.unpackGraphic = [[graphicAnalyzer alloc]init];
        self.unpackMoment = [[capturer alloc]init:&(self->matFromFrame)];
    }
    NSLog(@"debug : analyzer.mm/analyzer instance is created");
    return self;
}

-(void)makeMatFromBuffer:(id)ffr{
    if(!self->matFromFrame.empty()){
        self->matFromFrame.release();
    }
    
    CVPixelBufferRef frame = CVPixelBufferRetain((__bridge CVPixelBufferRef)ffr);
    CVPixelBufferLockBaseAddress(frame, 0);
    int bufferWidth = CVPixelBufferGetWidth(frame);
    int bufferHeight = CVPixelBufferGetHeight(frame);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(frame);
    void *pixel = CVPixelBufferGetBaseAddress(frame);;
    
    cv::Mat target0;
    cv::Mat target;
    
    target0.create(bufferHeight, bufferWidth, CV_8UC4);
    memcpy(target0.data, pixel, bytesPerRow*bufferHeight);
    // buferWidth -> bytesPerRow로 변경함. pixel pointer가 가리키는 데이터 내용을 target0.data로 복사해온다. 임의의 ios system이 메모리 관리하면서 포인터를 무력화시키는 에러들을 제거함.
    
    if(target0.empty()){                                // 프레임 로딩 실패 에러 체크
        NSLog(@"debug : cvVideo.mm/loading frame failed");
        return;
    }
    
    cv::Size sizeBox(cvConst::width,cvConst::height);     //이미지 사이즈 규격화
    cv::resize(target0,target,sizeBox);
    
    if(target.type()==CV_8UC1 || target.type()==CV_8UC2){
        cv::cvtColor(target, target, cv::COLOR_GRAY2RGB);
    }
    if(target.type() == CV_8UC4){
        cv::cvtColor(target, target, CV_BGRA2RGB);
    }
    
    //cv::transpose(target,target); //90도 회전시키기 -> 느려어어어
    self->matFromFrame = target;
    
    target.release();
    target0.release();
    CVPixelBufferRelease(frame);
    CVPixelBufferUnlockBaseAddress(frame, 0);
}

-(void)heavyTaskProcess:(id)ffr{
    [self makeMatFromBuffer:ffr];
    
    //실제 프로세싱 시작
    [self.unpackGraphic simplify:self->matFromFrame];
    [self.unpackColor processBrightnessWith:self->matFromFrame];
    [self.unpackGraphic computeSimplicity:[self.unpackGraphic getSimplifiedMat]];
    [self.unpackColor processDominantColorWith:self->matFromFrame colorCount:cConst::paletteCount]; //matFromFrame사용
    //[self.unpackColor processDominantColorWith:[self.unpackGraphic getSimplifiedMat]]; // simplifiedMat  사용
    
    [self.unpackGraphic diffNextFrame:[self.unpackGraphic getSimplifiedMat] withBinary:true];
    [self.unpackGraphic computeDifference:[self.unpackGraphic getDiffMat] withBinary:true];
    
    //실제 프로세싱 끝
    return;
}

-(void)lightTaskProcess:(id)ffr{
    [self makeMatFromBuffer:ffr];
    
    //실제 프로세싱 시작
    [self.unpackColor processCenterColorWith:self->matFromFrame];
    //실제 프로세싱 끝
}

@end
