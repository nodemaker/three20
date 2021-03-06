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

#import "TTSearchDisplayController.h"

// UI
#import "TTTableViewController.h"
#import "TTTableViewDataSource.h"

// UICommon
#import "TTGlobalUICommon.h"

// Core
#import "TTCorePreprocessorMacros.h"

const int kTTSearchBarBackgroundTag = 18942;

static const NSTimeInterval kPauseInterval = 0.4;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTSearchDisplayController

@synthesize searchResultsViewController    = _searchResultsViewController;
@synthesize pausesBeforeSearching          = _pausesBeforeSearching;
@synthesize hidesNavigationBarOnActivation = _hidesNavigationBarOnActivation;
@synthesize pausesTimerInterval            = _pauseTimerInterval;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSearchBar:(UISearchBar*)searchBar contentsController:(UIViewController*)controller {
	self = [super initWithSearchBar:searchBar contentsController:controller];
  if (self) {
    self.delegate = self;
    self.hidesNavigationBarOnActivation = YES;
    self.pausesTimerInterval = kPauseInterval;
  }

  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_INVALIDATE_TIMER(_pauseTimer);
  TT_RELEASE_SAFELY(_searchResultsDelegate2);
  TT_RELEASE_SAFELY(_searchResultsViewController);

  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resetResults {
  if (_searchResultsViewController.model.isLoading) {
    [_searchResultsViewController.model cancel];
  }
  [_searchResultsViewController.dataSource search:nil];
  [_searchResultsViewController viewWillDisappear:NO];
  [_searchResultsViewController viewDidDisappear:NO];
  _searchResultsViewController.tableView = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)restartPauseTimer {
  TT_INVALIDATE_TIMER(_pauseTimer);
  _pauseTimer = [NSTimer scheduledTimerWithTimeInterval:self.pausesTimerInterval target:self
                         selector:@selector(searchAfterPause) userInfo:nil repeats:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchAfterPause {
  _pauseTimer = nil;
  [_searchResultsViewController.dataSource search:self.searchBar.text];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UISearchDisplayDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController*)controller {
  self.searchContentsController.navigationItem.rightBarButtonItem.enabled = NO;
  UIView* backgroundView = [self.searchBar viewWithTag:kTTSearchBarBackgroundTag];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
  if (backgroundView) {
    backgroundView.alpha = 0;
  }
  _searchResultsViewController.tableOverlayView.alpha = 1;
  [UIView commitAnimations];
//  if (!self.searchContentsController.navigationController) {
//    [UIView beginAnimations:nil context:nil];
//    self.searchBar.superview.top -= self.searchBar.screenY - TTStatusHeight();
//    [UIView commitAnimations];
//  }
    if ([self.searchDisplayDelegate
         respondsToSelector:@selector(searchDisplayControllerWillBeginSearch:)]){
        [self.searchDisplayDelegate searchDisplayControllerWillBeginSearch:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController*)controller {
  [_searchResultsViewController updateView];
  if ([self.searchDisplayDelegate
       respondsToSelector:@selector(searchDisplayControllerDidBeginSearch:)]){
    [self.searchDisplayDelegate searchDisplayControllerDidBeginSearch:self];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController*)controller {
  self.searchContentsController.navigationItem.rightBarButtonItem.enabled = YES;

  UIView* backgroundView = [self.searchBar viewWithTag:kTTSearchBarBackgroundTag];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
  if (backgroundView) {
    backgroundView.alpha = 1;
  }
  _searchResultsViewController.tableOverlayView.alpha = 0;
  [UIView commitAnimations];

//  if (!self.searchContentsController.navigationController) {
//    [UIView beginAnimations:nil context:nil];
//    self.searchBar.superview.top += self.searchBar.top - TTStatusHeight();
//    [UIView commitAnimations];
//  }
    if ([self.searchDisplayDelegate
         respondsToSelector:@selector(searchDisplayControllerWillEndSearch:)]){
        [self.searchDisplayDelegate searchDisplayControllerWillEndSearch:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
  if (self.active == visible) return;

  if (self.hidesNavigationBarOnActivation){
    [super setActive:visible animated:animated];

  } else {

    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];

    if (visible) {
      [self.searchBar becomeFirstResponder];

    } else {
      [self.searchBar resignFirstResponder];
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController*)controller {
    [self resetResults];
    if ([self.searchDisplayDelegate
         respondsToSelector:@selector(searchDisplayControllerDidEndSearch:)]){
        [self.searchDisplayDelegate searchDisplayControllerDidEndSearch:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayController:(UISearchDisplayController *)controller
        didLoadSearchResultsTableView:(UITableView *)tableView {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayController:(UISearchDisplayController *)controller
        willUnloadSearchResultsTableView:(UITableView *)tableView {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayController:(UISearchDisplayController *)controller
        didShowSearchResultsTableView:(UITableView *)tableView {
  _searchResultsViewController.tableView = tableView;
  [_searchResultsViewController viewWillAppear:NO];
  [_searchResultsViewController viewDidAppear:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchDisplayController:(UISearchDisplayController*)controller
        willHideSearchResultsTableView:(UITableView*)tableView {
  [self resetResults];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)searchDisplayController:(UISearchDisplayController*)controller
        shouldReloadTableForSearchString:(NSString*)searchString {
  if (_pausesBeforeSearching) {
    [self restartPauseTimer];

  } else {
    [_searchResultsViewController.dataSource search:searchString];
  }
  return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)searchDisplayController:(UISearchDisplayController*)controller
        shouldReloadTableForSearchScope:(NSInteger)searchOption {
  //[_searchResultsViewController invalidateModel];
  [_searchResultsViewController.dataSource search:self.searchBar.text];
  return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSearchResultsDelegate:(id<UITableViewDelegate>)searchResultsDelegate {
  [super setSearchResultsDelegate:searchResultsDelegate];
  if (_searchResultsDelegate2 != searchResultsDelegate) {
    [_searchResultsDelegate2 release];
    _searchResultsDelegate2 = [searchResultsDelegate retain];
  }
}

@end
