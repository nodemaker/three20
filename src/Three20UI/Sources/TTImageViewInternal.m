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

#import "TTImageViewInternal.h"

// Core
#import "TTCorePreprocessorMacros.h"

// UI
#import "TTImageViewDelegate.h"
#import "UIViewAdditions.h"

// UI (private)
#import "TTImageLayer.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTImageView (TTInternal)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateLayer {
  TTImageLayer* layer = (TTImageLayer*)self.layer;
  if (self.style) {
    layer.override = nil;

  } else {
    // This is dramatically faster than calling drawRect.  Since we don't have any styles
    // to draw in this case, we can take this shortcut.
    layer.override = self;
  }
  [layer setNeedsDisplay];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage*)image {
  if (image != _image) {
    [_image release];
    _image = [image retain];

    [self updateLayer];

    CGRect frame = self.frame;
    CGSize autoresizeBounds = self.autoresizeBounds;
    if (_autoresizesToImage) {

	// If no width or height have been specified, then autoresize to the image.
	if ((!autoresizeBounds.width&&!autoresizeBounds.height)
	    ||!image.size.width||!image.size.height){

	    self.width = image.size.width;
	    self.height = image.size.height;

	} else if (autoresizeBounds.width && !autoresizeBounds.height) {

	    self.width = MIN(image.size.width,autoresizeBounds.width);
	    self.height =  floor((self.width/image.size.width)*image.size.height);

	} else if (!autoresizeBounds.width && autoresizeBounds.height) {

	    self.height = MIN(image.size.height,autoresizeBounds.height);
	    self.width =  floor((self.height/image.size.height)*image.size.width);

	} else {

	    CGFloat hfactor = image.size.width/autoresizeBounds.width;
	    CGFloat vfactor = image.size.height/autoresizeBounds.height;

	    if (hfactor>vfactor){
		self.width = MIN(image.size.width,autoresizeBounds.width);
		self.height =  floor((self.width/image.size.width)*image.size.height);

	    } else {
		self.height = MIN(image.size.height,autoresizeBounds.height);
		self.width =  floor((self.height/image.size.height)*image.size.width);
	    }
	}

    } else {
      // Logical flow:fafa
      // If no width or height have been specified, then autoresize to the image.
      if (!frame.size.width && !frame.size.height) {
        self.width = image.size.width;
        self.height = image.size.height;

      // If a width was specified, but no height, then resize the image with the correct aspect
      // ratio.

      } else if (frame.size.width && !frame.size.height) {
        self.height = floor((image.size.height/image.size.width) * frame.size.width);

      // If a height was specified, but no width, then resize the image with the correct aspect
      // ratio.

      } else if (frame.size.height && !frame.size.width) {
        self.width = floor((image.size.width/image.size.height) * frame.size.height);
      }

      // If both were specified, leave the frame as is.
    }

    if ((nil == _defaultImage || image != _defaultImage)
	&&(nil == _errorImage || image != _errorImage)) {
      // Only send the notification if there's no default image or this is a new image.
      [self imageViewDidLoadImage:image];
      if ([_delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
        [_delegate imageView:self didLoadImage:image];
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStyle:(TTStyle*)style {
  if (style != _style) {
    [super setStyle:style];
    [self updateLayer];
  }
}


@end
