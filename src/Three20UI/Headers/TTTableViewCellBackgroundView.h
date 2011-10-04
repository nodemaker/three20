//
//  TTTableViewCellBackgroundView.h
//  Three20UI
//
//  Created by samyzee on 10/4/11.
//

#import <UIKit/UIKit.h>

typedef enum  {
    TTTableViewCellPositionTop,
    TTTableViewCellPositionMiddle,
    TTTableViewCellPositionBottom,
    TTTableViewCellPositionSingle
} TTTableViewCellPosition;

@interface  TTTableViewCellBackgroundView : UIView {

    UIColor* _fillColor;
    TTTableViewCellPosition _position;
    UIColor* _borderColor;
}

@property (nonatomic, retain) UIColor* fillColor;
@property (nonatomic, retain) UIColor* borderColor;
@property (nonatomic, assign) TTTableViewCellPosition position;
@end
