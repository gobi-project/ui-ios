//
//  GOGraphView.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 17.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGraphHeight 180.0
#define kDefaultGraphWidth 300.0
#define kOffsetX 30.0
#define kOffsetY 15.0
#define kGraphBottom 200.0
#define kGraphTop 0.0
#define kCircleRadius 2.
#define kMaxHorizontalLineAmount    4.0

#define kWeeksInYear        52
#define kMonthInYear        12

#define kTempAbsoluteZeroPoint  (-273.15)
#define kTempMaxPoint           100.0

typedef NS_ENUM(NSInteger, GOGraphTimeInterval) {
    GOGraphTimeIntervalRecentDay,
    GOGraphTimeIntervalRecentWeek,
    GOGraphTimeIntervalRecentMonth,
    GOGraphTimeIntervalRecentHalfYear,
    GOGraphTimeIntervalRecentYear
};

@interface GOGraphView : UIView

@property (nonatomic) NSMutableArray *measurements;
@property (nonatomic) GOGraphTimeInterval pickedGraphTimeInterval;

- (void)drawForGraphTimeInterval:(GOGraphTimeInterval)interval;

@end
