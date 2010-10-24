//
//  DDShareServiceController.m
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

#import "DDShareServiceController.h"

@interface DDShareServiceController ()
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)networkAlertAction:(id)sender;
@end


@implementation DDShareServiceController

@synthesize delegate = delegate_;
@synthesize type = type_;
@synthesize shareURL = shareURL_;
@synthesize messageView = messageView_;
@synthesize cancelItem = cancelItem_;
@synthesize shareItem = shareItem_;
@synthesize huhItem = huhItem_;
@synthesize backgroundTouchInterceptingControl = backgroundTouchInterceptingControl_;
@synthesize alertView = alertView_;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithDelegate:(id <DDShareInternalDelegate>)delegate {	
	if ((self = [super initWithNibName:@"DDShareServiceController" bundle:nil])) {
		self.delegate = delegate;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	

	if ([self conformsToProtocol:@protocol(DDReachabilitySupport)]) {
		if ([self respondsToSelector:@selector(reachabilityChanged:)]) {
			// FIXME: Could miss Reachability notification
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];        
		}
	}	
	
	self.shareItem.title = NSLocalizedString(@"Share", @"Share");
	self.shareItem.enabled = NO; // disable by default, update in -textViewDidChange:
	
	self.navigationItem.rightBarButtonItem = self.shareItem;
	self.navigationItem.leftBarButtonItem = self.cancelItem;
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	
	self.backgroundTouchInterceptingControl.frame = [UIScreen mainScreen].bounds;
	[window addSubview:self.backgroundTouchInterceptingControl];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];        
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];        
		
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Make the keyboard appear when the application launches.
    [super viewWillAppear:animated];
    [self.messageView becomeFirstResponder];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	
	if ([self conformsToProtocol:@protocol(DDReachabilitySupport)]) {
		if ([self respondsToSelector:@selector(reachabilityChanged:)]) {
			[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
		}
	}	

	self.messageView = nil;
	self.cancelItem = nil;
	self.shareItem = nil;
	self.huhItem = nil;
	self.backgroundTouchInterceptingControl = nil;
	self.alertView = nil;
}


- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
	
	[shareURL_ release];
	
	[messageView_ release];
	[cancelItem_ release];
	[shareItem_ release];
	[huhItem_ release];
	[backgroundTouchInterceptingControl_ release];
	[alertView_ release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Accessor

- (DDShareServiceType)type {
	// Overridden in subclass
	return DDShareServiceTypeUndefined;
}

#pragma mark Actions

- (IBAction)shareAction {
	// Overridden in subclass
	return;
}

- (IBAction)huhAction {
	// Overridden in subclass
	return;
}

- (IBAction)cancelAction {
	if ([self.delegate conformsToProtocol:@protocol(DDShareInternalDelegate)]) {
		if ([self.delegate respondsToSelector:@selector(shareServiceController:didFinishWithResult:error:)]) {
			[self.delegate shareServiceController:self didFinishWithResult:DDShareServiceResultCancelled error:nil];
		}
	}					
}

- (void)networkAlertAction:(id)sender {
	if (self.alertView.visible) {
		[self.alertView dismissWithClickedButtonIndex:0 animated:NO];
		self.alertView = nil;
	}	
    self.alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", @"Connection Failed")
												 message:NSLocalizedString(@"Cannot connect to internet, try again when you are back with a valid network connection.", @"Cannot connect to internet, try again when you are back with a valid network connection.") 
												delegate:nil 
									   cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] autorelease];
    [self.alertView show];	
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	self.shareItem.enabled = ([textView.text length]) ? YES : NO;
}

#pragma mark UIKeyboardWillShowNotification & UIKeyboardWillHideNotification

- (void)keyboardWillShow:(NSNotification *)notification {
	CGFloat keyboardHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 216.0f : 162.0f;
	self.messageView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - keyboardHeight);
}

- (void)keyboardWillHide:(NSNotification *)notification {
	self.messageView.frame = self.view.bounds;
}

#pragma mark DDReachabilitySupport

- (void)reachabilityChanged:(NSNotification *)notification {
	Reachability* reachability = [notification object];
    
	if ([reachability currentReachabilityStatus] == NotReachable) {
        [self.navigationItem setRightBarButtonItem:self.huhItem animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:self.shareItem animated:YES];
    }	
}

@end
