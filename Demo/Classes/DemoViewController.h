//
//  DemoViewController.h
//  Demo
//
//  Created by digdog on 10/24/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDShareViewController.h"

@interface DemoViewController : UIViewController <DDShareViewControllerDelegate, UIActionSheetDelegate> {
	UIToolbar *demoToolbar;
}
@property(nonatomic, retain) IBOutlet UIToolbar *demoToolbar;

- (void)presentShareViewController;
- (IBAction)demoAction:(id)sender;
- (IBAction)bringUpAlertSheetAction:(id)sender;
@end

