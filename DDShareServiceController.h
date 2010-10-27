//
//  DDShareServiceController.h
//  DDShareViewController
//
//  Created by digdog on 10/16/10.
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

#import <UIKit/UIKit.h>
#import "DDShareViewController.h"
#import "DDReachabilitySupport.h"

@protocol DDShareInternalDelegate;

@interface DDShareServiceController : UIViewController <UITextViewDelegate, DDReachabilitySupport> {
	@protected
	id <DDShareInternalDelegate> delegate_;
	DDShareServiceType type_;
	NSString *shareURL_;
	NSString *shareName_;
	
	UITextView *messageView_;
	UIBarButtonItem *cancelItem_;
	UIBarButtonItem *shareItem_;
	UIBarButtonItem *huhItem_;
	UIControl *backgroundTouchInterceptingControl_;
	UIAlertView *alertView_;
}

@property(nonatomic, assign) id <DDShareInternalDelegate> delegate;
@property(nonatomic, readonly) DDShareServiceType type;
@property(nonatomic, retain) NSString *shareURL;
@property(nonatomic, retain) NSString *shareName;

@property(nonatomic, retain) IBOutlet UITextView *messageView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *cancelItem;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *shareItem;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *huhItem;
@property(nonatomic, retain) IBOutlet UIControl *backgroundTouchInterceptingControl;
@property(nonatomic, retain) UIAlertView *alertView;

- (id)initWithDelegate:(id <DDShareInternalDelegate>)delegate;

- (IBAction)cancelAction;
- (IBAction)shareAction;
- (IBAction)huhAction;
@end

@protocol DDShareInternalDelegate <NSObject>
@required
- (void)shareServiceController:(DDShareServiceController *)controller didFinishWithResult:(DDShareServiceResult)result error:(NSError*)error;
@end