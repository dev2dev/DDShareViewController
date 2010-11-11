//
//  DemoViewController.m
//  Demo
//
//  Created by digdog on 10/24/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//

#import "DemoViewController.h"

@implementation DemoViewController

@synthesize demoToolbar;

#pragma mark public methods

- (void)presentShareViewController {
	DDShareViewController *shareViewController = [[DDShareViewController alloc] initWithType:DDShareServiceTypeFacebook];
	shareViewController.shareViewControllerDelegate = self;
	
	[shareViewController setShareURL:@"http://digdog.tumblr.com/qremoji"];
	[shareViewController setShareName:@"QR+Emoji for iPhone and iPod touch"];
	[shareViewController setShareCaption:@"digdog software"];
	[shareViewController setShareDescription:@"A unique and elegant QR Code utility for iPhone & iPod touch. Create QR Code with Emoji icon as visual hints, and scan QR Codes through camera or saved photos."];
	
	[self presentModalViewController:shareViewController animated:YES];
	
	[shareViewController release];	
}

- (IBAction)demoAction:(id)sender {
	[self presentShareViewController];
}

- (IBAction)bringUpAlertSheetAction:(id)sender {
	UIActionSheet *alertSheet = [[UIActionSheet alloc] initWithTitle:@"Sharing through UIAlertSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"DDShareViewController" otherButtonTitles:nil];
	
	[alertSheet showFromToolbar:self.demoToolbar];
	[alertSheet release];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self presentShareViewController];
	}	
}

#pragma mark DDShareViewControllerDelegate

- (void)shareViewController:(DDShareViewController *)controller didFinishWithResult:(DDShareServiceResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BarButtonItem" style:UIBarButtonItemStyleBordered target:self action:@selector(presentShareViewController)];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.demoToolbar = nil;
}


- (void)dealloc {
	[demoToolbar release];
    [super dealloc];
}

@end
