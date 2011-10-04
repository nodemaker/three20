//
//  TTTableViewCellBackgroundView.m
//  Three20UI
//
//  Created by samyzee on 10/4/11.
//

// UI
#import "Three20UI/TTTableViewCellBackgroundView.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTStyleSheet.h"
#import "Three20Style/TTDefaultStyleSheet.h"

#define ROUND_SIZE 10.0f

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableViewCellBackgroundView

@synthesize fillColor = _fillColor;
@synthesize position = _position;
@synthesize borderColor = _borderColor;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isOpaque {
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)drawRect:(CGRect)rect
{
    // Drawing code

    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [self.fillColor CGColor]);
    CGContextSetStrokeColorWithColor(c, [self.borderColor CGColor]);
    CGContextSetLineWidth(c, 2);

    if (self.position == TTTableViewCellPositionTop) {

	CGFloat midx = CGRectGetMidX(rect);
	CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
	minx = minx + 1;
	miny = miny + 1;

	maxx = maxx - 1;
	maxy = maxy ;

	CGContextMoveToPoint(c, minx, maxy);
	CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
	CGContextAddArcToPoint(c, maxx, miny, maxx, maxy, ROUND_SIZE);
	CGContextAddLineToPoint(c, maxx, maxy);

	// Close the path
	CGContextClosePath(c);
	// Fill & stroke the path
	CGContextDrawPath(c, kCGPathFillStroke);
	return;

    } else if (self.position == TTTableViewCellPositionBottom) {

	CGFloat minx = CGRectGetMinX(rect);
	CGFloat midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect) ;

	minx = minx + 1;
	miny = miny ;

	maxx = maxx - 1;
	maxy = maxy - 1;

	CGContextMoveToPoint(c, minx, miny);
	CGContextAddArcToPoint(c, minx, maxy, midx, maxy, ROUND_SIZE);
	CGContextAddArcToPoint(c, maxx, maxy, maxx, miny, ROUND_SIZE);
	CGContextAddLineToPoint(c, maxx, miny);
	// Close the path
	CGContextClosePath(c);
	// Fill & stroke the path
	CGContextDrawPath(c, kCGPathFillStroke);
	return;

    } else if (self.position == TTTableViewCellPositionMiddle) {
	CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
	minx = minx + 1;
	miny = miny ;

	maxx = maxx - 1;
	maxy = maxy ;

	CGContextMoveToPoint(c, minx, miny);
	CGContextAddLineToPoint(c, maxx, miny);
	CGContextAddLineToPoint(c, maxx, maxy);
	CGContextAddLineToPoint(c, minx, maxy);

	CGContextClosePath(c);
	// Fill & stroke the path
	CGContextDrawPath(c, kCGPathFillStroke);
	return;

    } else if (self.position == TTTableViewCellPositionSingle) {

	CGFloat minx = CGRectGetMinX(rect);
	CGFloat midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect);
	CGFloat midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);

	minx = minx + 1;
	miny = miny + 1;

	maxx = maxx - 1;
	maxy = maxy - 1;

	CGContextMoveToPoint(c, minx, midy);
	CGContextAddArcToPoint(c, minx, miny, midx, miny, ROUND_SIZE);
	CGContextAddArcToPoint(c, maxx, miny, maxx, midy, ROUND_SIZE);
	CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, ROUND_SIZE);
	CGContextAddArcToPoint(c, minx, maxy, minx, midy, ROUND_SIZE);

	// Close the path
	CGContextClosePath(c);
	// Fill & stroke the path
	CGContextDrawPath(c, kCGPathFillStroke);
	return;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_fillColor);
    [super dealloc];
}

@end
