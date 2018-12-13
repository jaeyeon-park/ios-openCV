//
//  graphicAnalyzer.mm
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#import "graphicAnalyzer.h"

@implementation graphicAnalyzer
-(id)init{
    self = [super init];

    self->simplicity = 0;
    self->old = NULL;
    self->diffMat=NULL;
    NSLog(@"graphicinfo.mm/graphic info instacne is created");
    return self;
}

- (cv::Mat)getSimplifiedMat{
    return self->simplified;
}
- (cv::Mat)getDiffMat{
    return self->diffMat;
}

- (UIImage*)getSimplified{
    return MatToUIImage(self->simplified);
}
- (UIImage*)getDiff{
    return MatToUIImage(self->diffMat);
}


- (NSNumber*)getSimplicity{
    return [NSNumber numberWithInt:self->simplicity];
}

- (NSNumber*)getDifference{
    return [NSNumber numberWithDouble:self->difference];
}

- (cv::Mat)simplify : (cv::Mat)frame{
    
    if(!self->simplified.empty()){
        self->simplified.release();
    }

    //create matrix variables
    cv::Mat willBeSimplified;
    cv::Mat doneSimplified;
    
    const int width = frame.cols/gConst::underScaler;
    const int height = frame.rows/gConst::underScaler;
    cv::Size smallSize(width,height);
    cv::resize(frame,willBeSimplified,smallSize);

    cv::erode(willBeSimplified, doneSimplified, cv::Mat()); // 갓갓 코드 한 줄
    self->simplified = doneSimplified;
    /*
     개정안 1
     //doneSimplified.copyTo(self->simplified);
     copyTo를 사용해야 한다. 등호를 사용할 경우 doneSimplified가 가리키는 data를 self->simplified가 가리키게 되는데,
     그러면 해당 data에서 세고 있는 포인터 카운트 수는 1개에서 2개가 된다. 2개가 되면, 아래의 doneSimplified에서 release를 하더라도,
     해당 data를 가리키는 포인터, self->simplified가 있으므로 data가 deallocate되지 않는다.
     이후 다시 simplify 함수로 들어오면, self->simplified 는 새로운 data를 가리키게 되고, 이전 data는 접근할 방법이 완전히 없어진다.
     이전 data 를 가리키는 포인터 카운트 수가 0개가 되지만, release 함수 혹은 직접 deallocate를 할 수 없으므로 메모리에 남아있게 된다.
     
     copyTo를 사용하면, doneSimplified가 가리키고 있는, data가 세고 있는 포인터 개수가 변동되지 않고, data를 복사해서 가져가므로,
     함수 종료 직전 release()를 하면 data를 메모리에서 deallocate를 함과 동시에, 함수 destructor를 실행시켜 메모리를 잘 회수할 수 있다.
     */
    
    /*
     개정안 2
     copyTo는 많은 cpu사용량을 점유한다. 포인터만을 움직이는 것이 데이터 관리에 좀 더 효율적일 것이다. 기존 문제는 이전 data를 deallocate를 할 수 없다는 것에 있다.
     따라서 Mat variable이 새로운 data를 가리키기 전에 기존 data를 deallocate 해준다면, 메모리는 회수 되고, data를 copy하지 않아도 될 것이다.
     따라서 Mat type의 private instance variable이 업데이트 되기 전에, release()를 해주고 업데이트를 하도록 하여 cpu 사용량과 메모리 누수를 잡았다.
     */
    
    //release matrix variables
    willBeSimplified.release();
    doneSimplified.release();
    return self->simplified;
}
- (cv::Mat)diffNextFrame:(cv::Mat)src1 withBinary:(bool)binaryOpt{
    //차분효과 테스트
    if(!self->diffMat.empty()){
        self->diffMat.release();
    }
    
    cv::Mat diff;
    if(!self->old.empty()){
        cv::absdiff(self->old, src1, diff);
        if(binaryOpt){
            cv::cvtColor(diff, diff, CV_BGR2GRAY);
            cv::threshold(diff, diff, 50, 255, CV_THRESH_BINARY);
        }else{
            cv::Mat rgb[3];
            cv::split(diff,rgb);
            for(int channel=0;channel<diff.channels();channel++){
                cv::threshold(rgb[channel], rgb[channel], 50, 255, CV_THRESH_BINARY);
            }
            cv::merge(rgb, 3, diff);
            rgb[0].release();
            rgb[1].release();
            rgb[2].release();
        }
        self->old.release();
        self->diffMat = diff;
        
    }
    diff.release();
    self->old = src1;
    return self->diffMat;
}

- (int)computeDifference:(cv::Mat)src withBinary:(bool)binaryOpt{
    //result value : 0 - 1000
    double totalDiffer = 0;
    double frameSize = src.cols*src.rows;
    
    if(binaryOpt){
        totalDiffer = cv::countNonZero(src);
    }else{
        cv::Mat rgb[3];
        cv::split(src, rgb);
        for(int channel = 0; channel<src.channels();channel++){
            totalDiffer = totalDiffer + cv::countNonZero(rgb[channel]);
            rgb[channel].release();
        }
        frameSize = frameSize*src.channels();
    }
    
    totalDiffer = (int)1000*totalDiffer/frameSize;
    //NSLog(@"differnce : %f",totalDiffer);
    
    self->difference = totalDiffer;
    return self->difference;
}

- (int)computeSimplicity:(cv::Mat)simplifiedMat{
    //result value : 0 - 1000
    int totalComplexityValue = 0;
    
    if(!simplifiedMat.empty()){
        cv::Mat sizeChanged;
        
        const int resizeWidth = simplifiedMat.cols/gConst::simpValueScaler;
        const int resizeHeight = simplifiedMat.rows/gConst::simpValueScaler;
        cv::Size smallSize(resizeWidth,resizeHeight);
        cv::resize(simplifiedMat,sizeChanged,smallSize);
        
        cv::Mat diffShiftR, diffShiftD;
        cv::Mat diffRrgb[3], diffDrgb[3];
        cv::Mat diffSum[2];
        int diffRValue, diffDValue;
        
        cv::Mat std = sizeChanged(cv::Rect(0,0,resizeWidth-1,resizeHeight-1));
        cv::Mat shiftR = sizeChanged(cv::Rect(1,0,resizeWidth-1,resizeHeight-1)); //std기준, 오른쪽 1픽셀 shift한 Matrix
        cv::Mat shiftD = sizeChanged(cv::Rect(0,1,resizeWidth-1,resizeHeight-1)); //std기준, 아래 1픽셀 shift한 Matrix

        cv::absdiff(std,shiftR,diffShiftR);
        cv::absdiff(std,shiftD,diffShiftD);
        
        cv::split(diffShiftR, diffRrgb);
        cv::split(diffShiftD, diffDrgb);
        
        // diffSum[0] = diffR[0] + diffR[1] + diffR[2]
        cv::add(diffRrgb[0], diffRrgb[1], diffSum[0]);
        cv::add(diffSum[0], diffRrgb[2], diffSum[0]);
        
        // diffSum[1] = diffD[0] + diffD[1] + diffD[2]
        cv::add(diffDrgb[0],diffDrgb[1],diffSum[1]);
        cv::add(diffSum[1],diffDrgb[2],diffSum[1]);
        
        //근방 픽셀 차이가 10 이하면 1이다.
        //비슷하면 1로 만들어버린다.
        cv::threshold(diffSum[0], diffSum[0], gConst::driftRadius, 1, CV_THRESH_BINARY_INV);
        cv::threshold(diffSum[1], diffSum[1], gConst::driftRadius, 1, CV_THRESH_BINARY_INV);
        
        diffRValue = cv::countNonZero(diffSum[0]);
        diffDValue = cv::countNonZero(diffSum[1]);
        
        totalComplexityValue = (int)1000*((float)(diffRValue + diffDValue))/(2*(resizeWidth-1)*(resizeHeight-1));
        
        //memory release. deallocated
        sizeChanged.release();
        diffShiftR.release();
        diffShiftD.release();
        std.release();
        shiftR.release();
        shiftD.release();
        diffSum[0].release();
        diffSum[1].release();
        diffDrgb[0].release(); diffDrgb[1].release(); diffDrgb[2].release();
        diffRrgb[0].release(); diffRrgb[1].release(); diffRrgb[2].release();
    }
    
    self->simplicity = totalComplexityValue;
    return totalComplexityValue;
}


- (int)computeEntropy : (cv::Mat)simplifiedMat{
    //아래는 엔트로피 계산
    int histSize = 256;
    float ent_Y, ent_Cr, ent_Cb;
    cv::Mat ycrcb[3], hist_y, hist_Cr, hist_Cb;
    cv:: Mat converted_img;
    
    cv::cvtColor(simplifiedMat, converted_img, CV_BGR2HSV);
    split(converted_img, ycrcb);
    //split(simplifiedMat,ycrcb);
    
    hist_y = serialize(ycrcb[0], histSize);
    hist_Cr = serialize(ycrcb[1], histSize);
    hist_Cb = serialize(ycrcb[2], histSize);
    
    ent_Y = getEntropy(hist_y, simplifiedMat.size(), histSize);
    ent_Cr = getEntropy(hist_Cr, simplifiedMat.size(), histSize);
    ent_Cb = getEntropy(hist_Cb, simplifiedMat.size(), histSize);
    
    NSLog(@"ent_Y : %f, ent_Cr : %f, ent_Cb : %f",ent_Y,ent_Cr,ent_Cb);
    NSLog(@"totalEntropy : %f",ent_Y+ent_Cr+ent_Cb);
    self->simplicity = (int)(ent_Y+ent_Cr+ent_Cb);
    return (int)(ent_Y+ent_Cr+ent_Cb);
}





@end
