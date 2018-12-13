//
//  basicConstants.hpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//


#ifndef basicConstants_hpp
#define basicConstants_hpp

#include <stdio.h>
#include <opencv2/opencv.hpp>

namespace cvConst {
    extern const int width;
    extern const int height;
}

//simplify Constants
//graphic constants
namespace gConst{
    extern const int underScaler;
    extern const int simpValueScaler;
    extern const int driftRadius;
}

//color constants
namespace cConst {
    extern const int centWidth;
    extern const int centHeight;
    extern const int underScaler;
    extern const int paletteCount;
    extern const int kmeansLevel;
    
    extern int maxValue;
}



#endif /* basicConstants_hpp */
