//
//  DDShareViewController.h
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

#import <UIKit/UIKit.h>

#define kFacebookAppId @"123456789012345"

enum DDShareServiceType {
	DDShareServiceTypeUndefined,
	DDShareServiceTypeFacebook
};
typedef enum DDShareServiceType DDShareServiceType;

enum DDShareServiceResult {
	DDShareServiceResultCancelled,
	DDShareServiceResultShared,
	DDShareServiceResultFailed
};
typedef enum DDShareServiceResult DDShareServiceResult;


@protocol DDShareViewControllerDelegate;

@interface DDShareViewController : UINavigationController {
	@private
	id <DDShareViewControllerDelegate> shareViewControllerDelegate_;
}
@property(nonatomic, assign) id /*<DDShareViewControllerDelegate>*/ shareViewControllerDelegate; // weak reference
@property(nonatomic, readonly) DDShareServiceType type;

- (id)initWithType:(DDShareServiceType)type;

- (void)setShareURL:(NSString *)shareURL;
- (void)setShareName:(NSString *)shareNameshareName;
- (void)setShareCaption:(NSString *)shareCaption;
- (void)setShareDescription:(NSString *)shareDescription;
- (void)setSharePictureURL:(NSString *)sharePictureURL;
- (void)setShareSourceURL:(NSString *)shareSourceURL;
@end


@protocol DDShareViewControllerDelegate <NSObject>
@required
- (void)shareViewController:(DDShareViewController *)controller didFinishWithResult:(DDShareServiceResult)result error:(NSError*)error;
@end
