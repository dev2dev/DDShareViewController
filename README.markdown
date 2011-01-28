# DDShareViewController for iPhone and iPod touch

DDShareViewController is designed to share Facebook [Post][1]s rapidly on small iOS devices.

![](https://github.com/digdog/DDShareViewController/raw/master/Screenshots/Screenshot1.png)

## Features

1. Easy to use, just like <code>MFMailComposeViewController</code>.
2. Allow to change privacy options with single tap.
3. Support orientations, allow to rotate with keyboard or privacy options picker on.
4. Support retina display, both iPhone 4 and 4th generation iPod touch.
5. Use Facebook [Application ID][2], no more Facebook API Key and Application Secret.
6. Use Facebook Graphic API.
7. DDShareServiceController is designed to support other web services, like Twitter. Just subclass it, then you can start to create your own DDShareViewController.

## Requirement

1. iOS SDK 4 and LLVM compiler. (Sorry, no GCC 4.x) Demo project uses 4.2b3 SDK with LLVM compiler 1.6.
2. Facebook iOS SDK, included in the project as git submodule.
3. Apple's Reachability 2.2, inlcuded in the project.

## Usage

Very similar to MFMailComposeViewController, initialize with <code>DDShareServiceType</code>, fill the arguments with methods, then bring it up by calling <code>-presentModalViewController:animated:</code>

	#import "DDShareViewController.h"

	DDShareViewController *shareViewController = [[DDShareViewController alloc] initWithType:DDShareServiceTypeFacebook];
	shareViewController.shareViewControllerDelegate = self;
	
	[shareViewController setShareURL:@"http://digdog.tumblr.com/qremoji"];
	[shareViewController setShareName:@"QR+Emoji for iPhone and iPod touch"];
	[shareViewController setShareCaption:@"digdog software"];
	[shareViewController setShareDescription:@"A unique and elegant QR Code utility for iPhone & iPod touch. Create QR Code with Emoji icon as visual hints, and scan QR Codes through camera or saved photos."];
	
	[self presentModalViewController:shareViewController animated:YES];
	
	[shareViewController release];
	
And setup <code>DDShareViewControllerDelegate</code>. Unlike <code>MFMailComposeViewControllerDelegate</code>, this is required:

	- (void)shareViewController:(DDShareViewController *)controller didFinishWithResult:(DDShareServiceResult)result error:(NSError*)error {
		[self dismissModalViewControllerAnimated:YES];
	}

Also, don't forget use your own <code>kFacebookAppId</code>, it's defined in DDShareViewController.h. 

## Screenshots

![](https://github.com/digdog/DDShareViewController/raw/master/Screenshots/Screenshot2.png)  

![](https://github.com/digdog/DDShareViewController/raw/master/Screenshots/Screenshot3.png)  

![](https://github.com/digdog/DDShareViewController/raw/master/Screenshots/Screenshot4.png)  

## License

DDSocialViewController is released under MIT License.

[1]: http://developers.facebook.com/docs/reference/api/post
[2]: http://www.facebook.com/developers/apps.php