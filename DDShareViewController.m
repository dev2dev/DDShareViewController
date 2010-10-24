//
//  DDShareViewController.m
//  DDShareViewController
//
//  Created by digdog on 10/19/10.
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

#import "DDShareViewController.h"
#import "DDShareServiceController.h"
#import "DDShareFacebookController.h"

@interface DDShareViewController () <DDShareInternalDelegate>
@end

@implementation DDShareViewController

@synthesize shareViewControllerDelegate = shareViewControllerDelegate_;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithType:(DDShareServiceType)type {

	DDShareServiceController *rootViewController = nil;
	
	switch (type) {
		case DDShareServiceTypeFacebook:
			rootViewController = [[DDShareFacebookController alloc] initWithDelegate:self];
			break;
		default:
			break;
	}
	
	if (rootViewController && (self = [super initWithRootViewController:rootViewController])) {
		rootViewController.delegate = self;
		[rootViewController release];
	}
	return self;
}

#pragma mark -
#pragma mark Public methods

- (void)setShareURL:(NSString *)shareURL {
	
	if ([self.topViewController isKindOfClass:[DDShareServiceController class]]) {
		DDShareServiceController *rootViewController = (DDShareServiceController *)self.topViewController;
		rootViewController.shareURL = shareURL;
	}
}

- (void)setShareName:(NSString *)shareName {
	
	if ([self.topViewController isKindOfClass:[DDShareFacebookController class]]) {
		DDShareFacebookController *rootViewController = (DDShareFacebookController *)self.topViewController;
		rootViewController.shareName = shareName;
	}
}

- (void)setShareCaption:(NSString *)shareCaption {
	
	if ([self.topViewController isKindOfClass:[DDShareFacebookController class]]) {
		DDShareFacebookController *rootViewController = (DDShareFacebookController *)self.topViewController;
		rootViewController.shareCaption = shareCaption;
	}
}

- (void)setShareDescription:(NSString *)shareDescription {
	
	if ([self.topViewController isKindOfClass:[DDShareFacebookController class]]) {
		DDShareFacebookController *rootViewController = (DDShareFacebookController *)self.topViewController;
		rootViewController.shareDescription = shareDescription;
	}	
}

- (void)setSharePictureURL:(NSString *)sharePictureURL {
	
	if ([self.topViewController isKindOfClass:[DDShareFacebookController class]]) {
		DDShareFacebookController *rootViewController = (DDShareFacebookController *)self.topViewController;
		rootViewController.sharePictureURL = sharePictureURL;
	}
}

- (void)setShareSourceURL:(NSString *)shareSourceURL {
	
	if ([self.topViewController isKindOfClass:[DDShareFacebookController class]]) {
		DDShareFacebookController *rootViewController = (DDShareFacebookController *)self.topViewController;
		rootViewController.shareSourceURL = shareSourceURL;
	}	
}

#pragma mark Accessors

- (DDShareServiceType)type {
	
	if ([self.topViewController isKindOfClass:[DDShareServiceController class]]) {
		DDShareServiceController *rootViewController = (DDShareServiceController *)self.topViewController;
		return rootViewController.type;
	}
	
	return DDShareServiceTypeUndefined;
}

- (void)setDelegate:(id <UINavigationControllerDelegate, DDShareViewControllerDelegate>)newDelegate {
	
	if ([newDelegate conformsToProtocol:@protocol(DDShareViewControllerDelegate)]) {
		self.shareViewControllerDelegate = newDelegate;
	}
	
	if ([newDelegate conformsToProtocol:@protocol(UINavigationControllerDelegate)]) {
		self.delegate = newDelegate;
	}
}

#pragma mark -
#pragma mark DDShareInternalDelegate

- (void)shareServiceController:(DDShareServiceController *)controller didFinishWithResult:(DDShareServiceResult)result error:(NSError*)error {
	
	if ([self.shareViewControllerDelegate conformsToProtocol:@protocol(DDShareViewControllerDelegate)]) {
        if ([self.shareViewControllerDelegate respondsToSelector:@selector(shareViewController:didFinishWithResult:error:)]) {
			[self.shareViewControllerDelegate shareViewController:self didFinishWithResult:result error:error];
		}
	}	
}

@end
