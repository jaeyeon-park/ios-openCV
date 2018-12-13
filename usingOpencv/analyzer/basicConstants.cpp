//
//  basicConstants.cpp
//  usingOpencv
//
//  Created by jaeyeon-park on 11/12/2018.
//  Copyright © 2018 jaeyeon-park. All rights reserved.
//

#include "basicConstants.hpp"


//cvConst
const int cvConst::width = 640;
const int cvConst::height = 480;


/*simplfy 함수의 상수들*/
/*
 underScaler,
 
 
 undrScaler에 따라 아래의 상수들로 대응된다.
 underScaler	4		8		16
 maxSimplicity	37288	9048	2128
 width			160		80		40
 height			120		60		30
 totalPixel		19200	4800	1200
 */
const int gConst::underScaler = 8;
const int gConst::simpValueScaler = 2;
const int gConst::driftRadius = 30;

const int cConst::centWidth = 2;
const int cConst::centHeight = 2;
const int cConst::underScaler = 2;
//kmeans 평가에 들어갈 픽셀의 개수를 결정. 높을수록 도미넌트 컬러 정확성이 떨어지고, 씨피유 점유율도 떨어진다.

const int cConst::paletteCount = 6; // 도미넌트 컬러 개수
const int cConst::kmeansLevel = 1;  //kemans 평가 횟수. 높을수록 정확성이 올라간다. 씨피유 점유율도 올라간다.
int cConst::maxValue = 255*cvConst::width*cvConst::height;
