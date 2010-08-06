//
//  MEOW_iphoneViewController.m
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import "MEOW_iphoneViewController.h"

#import "DKDeferred+JSON.h"

#define SERVICE_URL @"http://meow.infiniterecursion.com.au/json";
#define METHOD_NAME @"meow.register"

@implementation MEOW_iphoneViewController

@synthesize username, password, reg_username, reg_password1, reg_password2, reg_email;

-(IBAction) doRegister:(id)sender {
	
	NSString *arg1 = [reg_username text];
	NSString *arg2 = [reg_password1 text];
	NSString *arg3 = [reg_email text];
	
	id dk = [DKDeferred jsonService:@"http://meow.infiniterecursion.com.au/json/" name:@"meow"];
	DKDeferred* dk2 = [dk registerUser:array_(arg1,arg2,arg3)];
	[dk2 addCallback:callbackTS(self,doRegistrationCompleted:)];
	//[dk2 addCallback:callbackTS(self,doRegistrationFailed:)];
	[dk2 addErrback:callbackTS(self, doRegistrationFailed:)];
	
	[arg1 release];
	[arg2 release];
}

- (id)doRegistrationCompleted:(id)result {
    // do something with result
	NSLog(@" Completed! %@ " , result );
	
	NSDictionary *resultdict = [(NSDictionary*)result objectForKey:@"result"];
	NSString *message = @"Registration was a success!";				
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return result;
}

- (id)doRegistrationFailed:(NSError *)err {
    // do something with error
	NSLog(@" FAIL %@ " , err );
	NSDictionary *errors = [[err userInfo] objectForKey:@"error"];
	NSString *errormessage = [errors objectForKey:@"message"];					
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:errormessage delegate:self cancelButtonTitle:@"Oh well" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
}

-(IBAction) doLogin:(id)sender {
	
	
	
}

/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
	
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}




/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
}


- (void)dealloc {
    [super dealloc];
}

@end
