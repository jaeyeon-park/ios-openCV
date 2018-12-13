//
//  captuerer2.m
//  usingOpencv
//
//  Created by keun-jaeyeon on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#import "capturer.h"

@implementation capturer
-(id)init:(cv::Mat*)bufferPointer{
    self = [super init];
    if(self){
        self->srcPointer = bufferPointer;
    }
    return self;
}

-(cv::Mat)getThisTimeCVMatBuffer{
    return *(self->srcPointer);
}

@end
