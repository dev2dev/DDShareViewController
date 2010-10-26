//
//  DDShareFacebookController.m
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


#import "DDShareFacebookController.h"

@interface DDShareFacebookController () 
@property(nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property(nonatomic, retain) UIButton *privacyButton;
@property(nonatomic, retain) Facebook *facebook;
@property(nonatomic, assign) NSInteger selectedPrivacyOptionIndex;

- (void)switchPrivacyPicker;
- (void)switchPrivacyPickerAction;
@end


@implementation DDShareFacebookController

@synthesize shareName = shareName_;
@synthesize shareCaption = shareCaption_;
@synthesize shareDescription = shareDescription_;
@synthesize sharePictureURL = sharePictureURL_;
@synthesize shareSourceURL = shareSourceURL_;
@synthesize tapGesture = tapGesture_;
@synthesize privacyButton = privacyButton_;
@synthesize facebook = facebook_;
@synthesize selectedPrivacyOptionIndex = selectedPrivacyOptionIndex_;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"keepFacebookSigned"]) {
		[self.facebook logout:self];
	}
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1.000];
	
	self.title = NSLocalizedString(@"Facebook", @"Facebook");
		
	self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.privacyButton addTarget:self action:@selector(switchPrivacyPicker) forControlEvents:UIControlEventTouchUpInside];
	[self.privacyButton setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
	[self.privacyButton setImage:[UIImage imageNamed:@"lockHighlighted"] forState:UIControlStateHighlighted];
	[self.privacyButton setImage:[UIImage imageNamed:@"lockSelected"] forState:UIControlStateSelected];
	self.privacyButton.opaque = NO;
	self.privacyButton.frame = CGRectMake(self.messageView.frame.size.width - 34.0f - 10.0f, 2.0f, 34.0f, 32.0f);
	self.privacyButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

	self.tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchPrivacyPicker)] autorelease];
	self.tapGesture.delegate = self;	
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
	self.tapGesture.delegate = nil;
	self.tapGesture = nil;	
	self.privacyButton = nil;
	self.facebook = nil;
}


- (void)dealloc {
	
	[shareName_ release];
	[shareCaption_ release];
	[shareDescription_ release];
	[sharePictureURL_ release];
	[shareSourceURL_ release];
	
	tapGesture_.delegate = nil;
	[tapGesture_ release];
	[privacyButton_ release];
	[facebook_ release];
    [super dealloc];
}

#pragma mark Adjusting messageView positions

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// FIXME: This is a workaround. Hardcode inputView size since UIPickerView won't autoresizing correctly.
	if ([self.messageView isFirstResponder] && self.messageView.inputView) {
		CGSize inputViewSize = (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) ? CGSizeMake(320.0f, 216.0f) : CGSizeMake(480.0f, 162.0f);
		self.messageView.inputView.frame = CGRectMake(0.0f, 0.0f, inputViewSize.width, inputViewSize.height);
	}					
}

#pragma mark Accessor

- (DDShareServiceType)type {
	return DDShareServiceTypeFacebook;
}

#pragma mark Actions

- (IBAction)shareAction {
	[self.messageView resignFirstResponder];
		
	if (self.messageView.inputView) {
		self.messageView.inputView = nil;
		[self.messageView removeGestureRecognizer:self.tapGesture];
		self.privacyButton.selected = NO;		
	}
	
	// Start Facebook	
	[self.facebook authorize:kFacebookAppId permissions:[NSArray arrayWithObjects:@"publish_stream", nil] delegate:self];
	
	[UIView animateWithDuration:0.2 
					 animations:^{
						 self.backgroundTouchInterceptingControl.alpha = 1.0f;
					 }];	
}

- (void)switchPrivacyPicker {
	
	if (self.privacyButton.isSelected) {		
		self.messageView.inputView = nil;
		
		[self.messageView removeGestureRecognizer:self.tapGesture];
		
		self.privacyButton.selected = NO;
	} else {		
		UIPickerView *privacyPicker = [[UIPickerView alloc] init];
		privacyPicker.showsSelectionIndicator = YES;
		privacyPicker.delegate = self;
		privacyPicker.dataSource = self;
		[privacyPicker selectRow:self.selectedPrivacyOptionIndex inComponent:0 animated:NO];
		self.messageView.inputView = privacyPicker;
		[privacyPicker release];
		
		[self.messageView addGestureRecognizer:self.tapGesture];

		self.privacyButton.selected = YES;
	}

	[self.messageView reloadInputViews];
}

- (void)switchPrivacyPickerAction {
	
	if (self.privacyButton.isSelected) {
		[self switchPrivacyPicker];
	}
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
	if (textView.inputAccessoryView == nil) {
		UIControl *privacyButtonHolderView = [[UIControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
		privacyButtonHolderView.opaque = NO;
		privacyButtonHolderView.backgroundColor = [UIColor clearColor];
		[privacyButtonHolderView addTarget:self action:@selector(switchPrivacyPickerAction) forControlEvents:UIControlEventTouchUpInside];

		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.view.frame.size.width - 64.0f, 34.0f)];
		titleLabel.text = self.shareName;
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		titleLabel.textColor = [UIColor lightGrayColor];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.opaque = NO;
		[privacyButtonHolderView addSubview:titleLabel];		
		[titleLabel release];

		[privacyButtonHolderView addSubview:self.privacyButton];
		
		textView.inputAccessoryView = privacyButtonHolderView;
		[privacyButtonHolderView release];
	}
	
	return YES;
}

#pragma mark UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

	switch (row) {
		case 0:
			return NSLocalizedString(@"Everyone", @"Everyone");
			break;
		case 1:
			return NSLocalizedString(@"Friends and Networks", @"Friends and Networks");
			break;
		case 2:
			return NSLocalizedString(@"Friends of Friends", @"Friends of Friends");
			break;
		case 3:
			return NSLocalizedString(@"Only Friends", @"Only Friends");
			break;
	}
	
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedPrivacyOptionIndex = row;
}

#pragma mark -
#pragma mark Facebook getter

- (Facebook *)facebook {
	if (!facebook_) {
		facebook_ = [[Facebook alloc] init];
	}
	
	return facebook_;
}

#pragma mark FBSessionDelegate

- (void)fbDidLogin {	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *privacyJSON;
	switch (self.selectedPrivacyOptionIndex) {
		case 0: // Everyone
			privacyJSON = @"{'value':'EVERYONE'}";
			break;
		case 1: // Friends and Networks
			privacyJSON = @"{'value':'NETWORKS_FRIENDS'}";
			break;
		case 2: // Friends of Friends
			privacyJSON = @"{'value':'FRIENDS_OF_FRIENDS'}";
			break;
		case 3: // Only Friends
			privacyJSON = @"{'value':'ALL_FRIENDS'}";
			break;
		default:
			break;
	}
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   self.shareURL, @"link",
								   self.messageView.text, @"message",
								   privacyJSON, @"privacy",
								   nil];
	
	if ([self.shareName length]) {
		[params setObject:self.shareName forKey:@"name"];
	}
	
	if ([self.shareCaption length]) {
		[params setObject:self.shareCaption forKey:@"caption"];
	}
	
	if ([self.shareDescription length]) {
		[params setObject:self.shareDescription forKey:@"description"];
	}

	if ([self.sharePictureURL length]) {
		[params setObject:self.sharePictureURL forKey:@"picture"];
	}
	
	if ([self.shareSourceURL length]) {
		[params setObject:self.shareSourceURL forKey:@"source"];
	}
		
	[self.facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
	[UIView animateWithDuration:0.2 
					 animations:^{
						 self.backgroundTouchInterceptingControl.alpha = 0.0f;
					 }];
	
	[self.messageView becomeFirstResponder];
}

#pragma mark FBRequestDelegate

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.backgroundTouchInterceptingControl.alpha = 0.0f;
                     }];
		
	if ([self.delegate conformsToProtocol:@protocol(DDShareInternalDelegate)]) {
		if ([self.delegate respondsToSelector:@selector(shareServiceController:didFinishWithResult:error:)]) {
			[self.delegate shareServiceController:self didFinishWithResult:DDShareServiceResultShared error:nil];
		}
	}				
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    [UIView animateWithDuration:0.2 
                     animations:^{
                         self.backgroundTouchInterceptingControl.alpha = 0.0f;
                     }];
		
	if ([self.delegate conformsToProtocol:@protocol(DDShareInternalDelegate)]) {
		if ([self.delegate respondsToSelector:@selector(shareServiceController:didFinishWithResult:error:)]) {
			[self.delegate shareServiceController:self didFinishWithResult:DDShareServiceResultFailed error:error];
		}
	}					
}

@end
