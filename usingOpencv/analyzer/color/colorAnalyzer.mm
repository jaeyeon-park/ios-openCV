//
//  colorAnalyzer.m
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#import "colorAnalyzer.h"

@implementation colorAnalyzer
-(id) init{
    self = [super init];
    self->brightness = [NSNumber numberWithInt:0];
    self->centerColor = [NSMutableArray array];
    self->domiColorKey = [NSMutableArray array];
    self->domiColorValue = [NSMutableArray array];

    NSLog(@"colorInfo.mm/colorInfo instance is created");
    return self;
}

-(NSMutableArray*)getCenterColor{
    return self->centerColor;
}
-(NSMutableArray*)getSortedDominantColorKeys{
    return self->domiColorKey;
}
-(NSMutableArray*)getSortedDominantcolorValues{
    return self->domiColorValue;
}
-(NSNumber*)getBrightness{
    return self->brightness;
}



-(NSArray*)processCenterColorWith : (cv::Mat)frame{
    int intensity[3] = {0,0,0};
    const int centerX = frame.cols/2;
    const int centerY = frame.rows/2;
    
    std::vector<cv::Mat> rgbPlane;
    cv::split(frame,rgbPlane);
    
    for(int channel = 0 ;channel < 3; channel++){
        for(int x = centerX - cConst::centWidth/2; x<centerX + cConst::centWidth/2;x++){
            for(int y = centerY - cConst::centHeight/2; y<centerY + cConst::centHeight/2;y++){
                intensity[channel] = intensity[channel]+(int)(*rgbPlane[channel].col(x).row(y).data);
            }
        }
        intensity[channel] = ((float)intensity[channel])/(cConst::centWidth*cConst::centHeight);
        
        rgbPlane[channel].release(); // rgbPlane[channel] variable을 다른 Mat type variable에 대입한 적이 없으므로, release시 data도 deallocate 된다.
    }
    self->centerColor = @[[NSNumber numberWithInt:(int)intensity[0]],[NSNumber numberWithInt:(int)intensity[1]],[NSNumber numberWithInt:(int)intensity[2]]];
    return self->centerColor;
}


-(NSNumber*)processBrightnessWith : (cv::Mat)frame{
    //result value : 0 - 1000
    cv::Mat YCrCb;
    cv::cvtColor(frame, YCrCb, CV_BGR2YCrCb);
    cv::Scalar pixelSum;
    float total = 0;
    
    if(cvConst::width != frame.cols){
        cConst::maxValue = 255*frame.cols*frame.rows; // RGB Value 255/255/255 -> YCrCb로 변환시 Y값.
    }
    
    pixelSum = cv::sum(YCrCb);
    total = (float)pixelSum[0]; // Y값이 필요하기 때문.
    
    total = (100.0*total/cConst::maxValue)+0.5;
    self->brightness = [NSNumber numberWithInt:(int)total];
    return self->brightness;
}

-(void)processDominantColorWith : (cv::Mat)frame colorCount:(int)paletteCount{
    cv::Mat sizeDown;
    int width, height;
    
    if(frame.cols == cvConst::width){
        // matFromFrame에 대응
        width = frame.cols/(cConst::underScaler*gConst::underScaler);
        height = frame.rows/(cConst::underScaler*gConst::underScaler);
    }else{
        //simplifiedMat에 대응
        width = frame.cols/cConst::underScaler;
        height = frame.rows/cConst::underScaler;
    }
    //사이즈 규격화
    cv::Size smallSize(width,height);
    cv::resize(frame,sizeDown,smallSize);

    cv::Mat3b reduced;
    
    /*reducing colorSpace*/ //색깔 수 줄이기
    
    //reduceColor_Quantization(frame, reduced);
    //reduceColor_Stylization(frame, reduced);
    //reduceColor_EdgePreserving(frame, reduced);
    reduceColor_kmeans(sizeDown,reduced,paletteCount);

    std::map<cv::Vec3b, int, lessVec3b> palette = getPalette(reduced);
    std::map<cv::Vec3b, int, lessVec3b>::iterator color;
    
    NSMutableArray* colorCode = [NSMutableArray array];
    NSMutableArray* colorRatio = [NSMutableArray array];
    float areaRatio = 0;
    for(color = palette.begin(); color != palette.end(); color++){
        NSMutableArray *colorKey = [NSMutableArray array];
        for(int channel = 0; channel < 3; channel++){
            [colorKey addObject:[NSNumber numberWithInt:(int)color->first[channel]]];
        }
        areaRatio = ((float)color->second)/(width*height); // 색깔 영역 비율 계산
        [colorCode addObject:colorKey];
        [colorRatio addObject:[NSNumber numberWithInt:(int)100*areaRatio]]; //percentage 로 변환
    }
    self->domiColorKey = [colorCode copy]; //색깔 종류 RGB 컬러 집합
    self->domiColorValue = [colorRatio copy]; // 색상당 컬러 비율 집합
    reduced.release();
}
@end
