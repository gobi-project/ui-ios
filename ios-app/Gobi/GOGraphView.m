//
//  GOGraphView.m
//  Gobi
//
//  Created by Wojtek Kordylewski on 17.02.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import "GOGraphView.h"
#import "GOMeasurementObject.h"

@interface GOGraphView ()
@property (nonatomic) NSMutableArray *graphItemValues;
@property (nonatomic) float stepX;
@property (nonatomic) float highestValue;
@property (nonatomic) float lowestValue;

@property (nonatomic) NSMutableArray *graphLabelStrings;
@end

@implementation GOGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawForGraphTimeInterval:(GOGraphTimeInterval)interval {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int currentValue;
    self.highestValue = kTempAbsoluteZeroPoint;
    self.lowestValue = kTempMaxPoint;
    NSInteger startIndex;
    
    switch (interval) {
        case GOGraphTimeIntervalRecentDay: {
            self.graphLabelStrings = [[NSMutableArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", nil];
            self.graphItemValues = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, nil];
            
            NSDateComponents *maxHourComps = [calendar components:NSCalendarUnitHour fromDate:((GOMeasurementObject *)[self.measurements firstObject]).date];
            
            NSLog(@"max hour: %i", maxHourComps.hour);
            currentValue = 24;
            for (GOMeasurementObject *measurement in self.measurements) {
                NSDateComponents *dateCompsEvent = [calendar components:NSCalendarUnitHour fromDate:measurement.date];
                NSLog(@"Match, date comps hour: %i", dateCompsEvent.hour);
                
                if (measurement.value > self.highestValue) {
                    self.highestValue = measurement.value;
                }
                if (measurement.value < self.lowestValue) {
                    self.lowestValue = measurement.value;
                }
                NSLog(@"VAL: %f highest val: %f, lowest: %f", measurement.value,  self.highestValue, self.lowestValue);
                
                [self.graphItemValues replaceObjectAtIndex:dateCompsEvent.hour withObject:@(measurement.value)];
            }
            
            startIndex = maxHourComps.hour;
            if (startIndex < 23) {
                [self reorderGraphLabelsAndValuesForStartIndex:startIndex];
            }
            break;
        }
        case GOGraphTimeIntervalRecentWeek: {
            self.graphLabelStrings = [[NSMutableArray alloc] initWithObjects:@"Su", @"Mo", @"Tu", @"Wed", @"Thu", @"Fr", @"Sa", nil];
            self.graphItemValues = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, nil];
            
            NSDateComponents *maxDayComps = [calendar components:NSCalendarUnitWeekday fromDate:((GOMeasurementObject *)[self.measurements firstObject]).date];
            
            NSLog(@"max day: %i", maxDayComps.weekday);
            currentValue = 7.0;
            
            for (GOMeasurementObject *measurement in self.measurements) {
                NSDateComponents *dateCompsEvent = [calendar components:NSCalendarUnitWeekday fromDate:measurement.date];
                NSLog(@"Match, date comps day: %i", dateCompsEvent.weekday);
                
                if (measurement.value > self.highestValue) {
                    self.highestValue = measurement.value;
                }
                if (measurement.value < self.lowestValue) {
                    self.lowestValue = measurement.value;
                }
                NSLog(@"VAL: %f highest val: %f, lowest: %f", measurement.value,  self.highestValue, self.lowestValue);
                
                [self.graphItemValues replaceObjectAtIndex:dateCompsEvent.weekday-1 withObject:@(measurement.value)];
            }
            
            startIndex = (maxDayComps.weekday);
            if (startIndex < 6) {
                [self reorderGraphLabelsAndValuesForStartIndex:startIndex];
            }
            break;
        }
            /*
             case GOGraphTimeIntervalRecentMonth: {
             self.graphItemValues = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @0.0, nil];
             componentsWithOffset.month = -1;
             NSDate *now = [[NSDate alloc] init];
             minDate = [calendar dateByAddingComponents:componentsWithOffset toDate:now options:0];
             NSDateComponents *maxDayComps = [calendar components:NSCalendarUnitWeekOfYear fromDate:now];
             NSLog(@"max week: %i", maxDayComps.weekOfYear);
             currentValue = 4.0;
             
             self.graphLabelStrings = [[NSMutableArray alloc] init];
             for (int x = currentValue - 1; x >= 0; x--) {
             NSInteger calcWeek = maxDayComps.weekOfYear - x;
             if (calcWeek < 0) {
             calcWeek += kWeeksInYear;
             }
             [self.graphLabelStrings addObject:[NSString stringWithFormat:@"%i", (int)calcWeek]];
             }
             
             for (GOMeasurementObject *measurement in self.measurements) {
             if ([measurement.date compare:minDate] == NSOrderedAscending) {
             NSLog(@"No match Skip");
             break;
             }
             NSDateComponents *dateCompsEvent = [calendar components:NSCalendarUnitWeekOfYear fromDate:measurement.date];
             NSLog(@"Match, date comps week of year: %i", dateCompsEvent.weekOfYear);
             
             for (int i = 0; i < currentValue; i++) {
             NSLog(@"currentValue check: %i", i + 1);
             NSInteger calcWeek = maxDayComps.weekOfYear - i;
             if (calcWeek <= 0) {
             calcWeek += kWeeksInYear;
             }
             if (dateCompsEvent.weekOfYear == calcWeek) {
             int insertIndex = currentValue - i - 1;
             
             NSNumber *currentNumber = [self.graphItemValues objectAtIndex:insertIndex];
             float currentFloat = [currentNumber floatValue];
             currentFloat++;
             if (currentFloat > self.highestValue) {
             self.highestValue = currentFloat;
             }
             [self.graphItemValues replaceObjectAtIndex:insertIndex withObject:@(currentFloat)];
             NSLog(@"match for day: %i current int: %0.2f insertIndex: %i", i + 1, currentFloat, insertIndex);
             NSLog(@"value observer: %f", [currentNumber floatValue]);
             
             break;
             }
             }
             }
             break;
             }
             case GOGraphTimeIntervalRecentHalfYear: {
             self.graphItemValues = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @0.0, @0.0, @0.0, nil];
             componentsWithOffset.month = -6;
             NSDate *now = [[NSDate alloc] init];
             minDate = [calendar dateByAddingComponents:componentsWithOffset toDate:now options:0];
             NSDateComponents *maxDayComps = [calendar components:NSCalendarUnitMonth fromDate:now];
             NSLog(@"max halfyear: %i", maxDayComps.month);
             currentValue = 6.0;
             
             self.graphLabelStrings = [[NSMutableArray alloc] init];
             for (int x = currentValue - 1; x >= 0; x--) {
             NSInteger calcMonth = maxDayComps.month - x;
             if (calcMonth <= 0) {
             calcMonth += kMonthInYear;
             }
             [self.graphLabelStrings addObject:[self getMonthLabelForMonthNumber:calcMonth]];
             }
             
             for (GOMeasurementObject *measurement in self.measurements) {
             if ([measurement.date compare:minDate] == NSOrderedAscending) {
             NSLog(@"No match Skip");
             break;
             }
             NSDateComponents *dateCompsEvent = [calendar components:NSCalendarUnitMonth fromDate:measurement.date];
             NSLog(@"Match, date comps week of year: %i", dateCompsEvent.month);
             
             for (int i = 0; i < currentValue; i++) {
             NSLog(@"currentValue check: %i", i + 1);
             NSInteger calcMonth = maxDayComps.month - i;
             if (calcMonth < 0) {
             calcMonth += kMonthInYear;
             }
             if (dateCompsEvent.month == calcMonth) {
             int insertIndex = currentValue - i - 1;
             
             NSNumber *currentNumber = [self.graphItemValues objectAtIndex:insertIndex];
             float currentFloat = [currentNumber floatValue];
             currentFloat++;
             if (currentFloat > self.highestValue) {
             self.highestValue = currentFloat;
             }
             [self.graphItemValues replaceObjectAtIndex:insertIndex withObject:@(currentFloat)];
             NSLog(@"match for day: %i current int: %0.2f insertIndex: %i", i + 1, currentFloat, insertIndex);
             NSLog(@"value observer: %f", [currentNumber floatValue]);
             
             break;
             }
             }
             }
             break;
             }
             default: {
             self.graphItemValues = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, @0.0, nil];
             componentsWithOffset.year = -1;
             NSDate *now = [[NSDate alloc] init];
             minDate = [calendar dateByAddingComponents:componentsWithOffset toDate:now options:0];
             NSDateComponents *maxDayComps = [calendar components:NSCalendarUnitMonth fromDate:now];
             NSLog(@"max halfyear: %i", maxDayComps.month);
             currentValue = 12;
             
             self.graphLabelStrings = [[NSMutableArray alloc] init];
             for (int x = currentValue - 1; x >= 0; x--) {
             NSInteger calcMonth = maxDayComps.month - x;
             if (calcMonth <= 0) {
             calcMonth += kMonthInYear;
             }
             [self.graphLabelStrings addObject:[self getMonthLabelForMonthNumber:calcMonth]];
             }
             
             for (GOMeasurementObject *measurement in self.measurements) {
             if ([measurement.date compare:minDate] == NSOrderedAscending) {
             NSLog(@"No match Skip");
             break;
             }
             NSDateComponents *dateCompsEvent = [calendar components:NSCalendarUnitMonth fromDate:measurement.date];
             NSLog(@"Match, date comps week of year: %i", dateCompsEvent.month);
             
             for (int i = 0; i < currentValue; i++) {
             NSLog(@"currentValue check: %i", i + 1);
             NSInteger calcMonth = maxDayComps.month - i;
             if (calcMonth < 0) {
             calcMonth += kMonthInYear;
             }
             if (dateCompsEvent.month == calcMonth) {
             int insertIndex = currentValue - i - 1;
             
             NSNumber *currentNumber = [self.graphItemValues objectAtIndex:insertIndex];
             float currentFloat = [currentNumber floatValue];
             currentFloat++;
             if (currentFloat > self.highestValue) {
             self.highestValue = currentFloat;
             }
             [self.graphItemValues replaceObjectAtIndex:insertIndex withObject:@(currentFloat)];
             NSLog(@"match for day: %i current int: %0.2f insertIndex: %i", i + 1, currentFloat, insertIndex);
             NSLog(@"value observer: %f", [currentNumber floatValue]);
             
             break;
             }
             }
             }
             break;
             }
             */
        default:
            currentValue = 0;
            break;
    }
    
    //in case that not all measurements are set TODO: ueberarbeiten
    if ([self.measurements count] < currentValue) {
        if (0.0 > self.highestValue) {
            self.highestValue = 0.0;
        }
        if (0.0 < self.lowestValue) {
            self.lowestValue = 0.0;
        }
        
    }
    NSLog(@"Final highest val: %f, lowest: %f", self.highestValue, self.lowestValue);
    
    self.stepX = (kDefaultGraphWidth - kOffsetX) / currentValue;
    self.pickedGraphTimeInterval = interval;
    
    [self setNeedsDisplay];
}

- (void)reorderGraphLabelsAndValuesForStartIndex:(NSInteger)graphStartIndex {
    for (int j = 0; j <= graphStartIndex; j++) {
        id firstObject = [self.graphLabelStrings firstObject];
        [self.graphLabelStrings removeObjectAtIndex:0];
        [self.graphLabelStrings addObject:firstObject];
        
        firstObject = [self.graphItemValues firstObject];
        [self.graphItemValues removeObjectAtIndex:0];
        [self.graphItemValues addObject:firstObject];
    }
}

- (NSString *)getMonthLabelForMonthNumber:(NSInteger)month {
    switch (month) {
        case 1:
            return @"Jan";
        case 2:
            return @"Feb";
        case 3:
            return @"Mar";
        case 4:
            return @"Apr";
        case 5:
            return @"May";
        case 6:
            return @"Jun";
        case 7:
            return @"Jul";
        case 8:
            return @"Aug";
        case 9:
            return @"Sep";
        case 10:
            return @"Oct";
        case 11:
            return @"Nov";
        default:
            return @"Dec";
    }
}

- (void)drawRect:(CGRect)rect {
    
    if (self.graphItemValues && [self.graphItemValues count] > 0 && self.stepX > 0.0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, 0.6);
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        
        int maxGraphHeight = kGraphHeight - kOffsetY;
        
        for (int i = 0; i < [self.graphLabelStrings count]; i++) {
            CGFloat x = kOffsetX + i * self.stepX;
            CGContextMoveToPoint(context, x , kGraphTop + kOffsetY);
            CGContextAddLineToPoint(context, x, kGraphHeight);
            
            int skips = 0;
            if (self.pickedGraphTimeInterval == GOGraphTimeIntervalRecentDay) {
                skips = 3;
            }
            else if (self.pickedGraphTimeInterval == GOGraphTimeIntervalRecentYear) {
                skips = 2;
            }
            
            if (skips == 0 || i % skips == 1) {
                NSString *graphLabelString = [self.graphLabelStrings objectAtIndex:i];
                UIFont *labelFont = [UIFont systemFontOfSize:12.0];
                CGSize labelSize = [graphLabelString sizeWithAttributes:@{NSFontAttributeName: labelFont}];
                [graphLabelString drawAtPoint:CGPointMake(x - (labelSize.width / 2), kGraphHeight + 5) withAttributes:@{NSFontAttributeName: labelFont}];
                
            }
        }
        
        for (int i = 0; i < 6; i++) {
            float y = kGraphHeight - maxGraphHeight * i * 0.2;
            float maxX = kOffsetX + (self.graphItemValues.count - 1) * self.stepX;
            //NSLog(@"YYYY: %f uff: %i",y, horizontalLines);
            CGContextMoveToPoint(context, kOffsetX, y);
            CGContextAddLineToPoint(context, maxX, y);
            
            float valueInterval = self.highestValue - self.lowestValue;
            float moduloOffset = 5.0 - fmodf(valueInterval, 5.0);
            
            float newInterval = valueInterval + moduloOffset;
            
            float representedValue = (i * 0.2) * newInterval + self.lowestValue;
            NSString *graphYString = [NSString stringWithFormat:@"%.1f", representedValue];
            UIFont *labelFont = [UIFont systemFontOfSize:12.0];
            CGSize labelSize = [graphYString sizeWithAttributes:@{NSFontAttributeName: labelFont}];
            [graphYString drawAtPoint:CGPointMake(0.0, y - (labelSize.height / 2)) withAttributes:@{NSFontAttributeName: labelFont}];
        }
        
        CGContextStrokePath(context);
        
        [self drawLineGraphWithContext:context];
    }
}

- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:169.0/255.0 green:41.0/255.0 blue:30.0/255.0 alpha:1.0] CGColor]);
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    CGContextBeginPath(ctx);
    
    float valueInterval = self.highestValue - self.lowestValue;
    float moduloOffset = 5.0 - fmodf(valueInterval, 5.0);
    float actualValue = ([((NSNumber *)[self.graphItemValues firstObject]) floatValue] - self.lowestValue) / (valueInterval + moduloOffset);
    
    NSLog(@"Value intervale: %f, moduloOffset YOYO: %f, actual : %f", valueInterval, moduloOffset, actualValue);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * actualValue);
    //TODO: beide for-schleifen zusammenfassen?
    for (int i = 0; i < [self.graphItemValues count]; i++) {
        NSLog(@"item: %i, value: %f", i, [((NSNumber *)[self.graphItemValues objectAtIndex:i]) floatValue]);
        float actualValue = ([((NSNumber *)[self.graphItemValues objectAtIndex:i]) floatValue] - self.lowestValue) / (valueInterval + moduloOffset);
        CGContextAddLineToPoint(ctx, kOffsetX + i * self.stepX, kGraphHeight - maxGraphHeight * actualValue);
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:169.0/255.0 green:41.0/255.0 blue:30.0/255.0 alpha:1.0] CGColor]);
    for (int i = 0; i < [self.graphItemValues count]; i++) {
        float actualValue = ([((NSNumber *)[self.graphItemValues objectAtIndex:i]) floatValue] - self.lowestValue) / (valueInterval + moduloOffset);
        
        float x = kOffsetX + i * self.stepX;
        float y = kGraphHeight - maxGraphHeight * actualValue;
        NSLog(@"Drawing point: %i on x: %f, y:%f STEPx: %f", i, x, y, self.stepX);
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
}

@end
