//
//  DDShareFacebookController.h
//  DDShareViewController
//
//  Created by digdog on 10/18/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//  http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Using Facebook Graph API: "Post" 
//  http://developers.facebook.com/docs/reference/api/post

#import <UIKit/UIKit.h>
#import "DDShareServiceController.h"
#import "FBConnect.h"

@interface DDShareFacebookController : DDShareServiceController <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {

	@protected
	NSString *shareCaption_;
	NSString *shareDescription_;
	NSString *sharePictureURL_;
	NSString *shareSourceURL_;
	
	@private
	UITapGestureRecognizer *tapGesture_;
	UIButton *privacyButton_;
	
	Facebook *facebook_;
	NSInteger selectedPrivacyOptionIndex_;	
}


@property(nonatomic, retain) NSString *shareCaption;
@property(nonatomic, retain) NSString *shareDescription;
@property(nonatomic, retain) NSString *sharePictureURL;
@property(nonatomic, retain) NSString *shareSourceURL;
@end
