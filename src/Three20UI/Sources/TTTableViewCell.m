//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTableViewCell.h"
#import "TTTableView.h"
#import "UIViewAdditions.h"

// UICommon
#import "TTGlobalUICommon.h"

const CGFloat   kTableCellSmallMargin = 6.0f;
const CGFloat   kTableCellSpacing     = 8.0f;
const CGFloat   kTableCellMargin      = 10.0f;
const CGFloat   kTableCellHPadding    = 10.0f;
const CGFloat   kTableCellVPadding    = 10.0f;

const NSInteger kTableMessageTextLineCount = 2;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return TT_ROW_HEIGHT;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
  self.object = nil;
  self.textLabel.text = nil;
  self.detailTextLabel.text = nil;
  [super prepareForReuse];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)object {
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * The cell is not highlighted in case it has a highlighted label
 */
- (void)setHighlighted: (BOOL)highlighted animated: (BOOL)animated
{
    TTTableView* tableView = (TTTableView*)[self ancestorOrSelfWithClass:[TTTableView class]];
    if (!tableView.highlightedLabel) {
	[super setHighlighted:highlighted animated:animated];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * The selection of the cell is also disabled in case it has a highlighted label
 */
- (void)setSelected: (BOOL)selected animated: (BOOL)animated
{
    TTTableView* tableView = (TTTableView*)[self ancestorOrSelfWithClass:[TTTableView class]];
    if (!tableView.highlightedLabel) {
	[super setSelected:selected animated:animated];
    }
}

@end
