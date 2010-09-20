//
//  RegisterViewController.m
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import "RegisterViewController.h"
#import "DKDeferred+JSON.h"
#import "MEOW_UserState.h"
#import "MEOW_UserMessage.h"

#define SERVICE_URL @"http://meow.infiniterecursion.com.au/json/"

#define kKeyboardAnimationDuration 0.3

@implementation RegisterViewController

@synthesize username, password, reg_username, reg_password1, reg_password2, reg_email;
@synthesize scrollView;

-(IBAction) doRegister:(id)sender {
	
	NSString *arg1 = [reg_username text];
	NSString *arg2 = [reg_password1 text];
	NSString *arg3 = [reg_email text];
	NSString *arg4 = [reg_password2 text];
	
	if ([arg2 isEqualToString:arg4] == YES) {
		
		//ok can register
		
		[[MEOW_UserState sharedMEOW_UserState] setLogged_in:FALSE];
		
		id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
		DKDeferred* dk2 = [dk registerUser:array_(arg1,arg2,arg3)];
		[dk2 addCallback:callbackTS(self,doRegistrationCompleted:)];
		[dk2 addErrback:callbackTS(self, doRegistrationFailed:)];
		
		
	} else {
		
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Passwords dont match. Please correct this and try to register again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];
		
		
	}
	
	
		
}

- (id)doRegistrationCompleted:(id)result {
    // do something with result
	NSLog(@" Rego Completed! %@ " , result );
	
	NSDictionary *resultdict = [(NSDictionary*)result objectForKey:@"result"];
	NSString *message = @"Registration was a success!";				
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return result;
}

- (id)doRegistrationFailed:(NSError *)err {
    // do something with error
	
	NSDictionary *errors = [err userInfo];
	NSLog(@" FAIL rego %@ " , errors );
	NSString *errormessage = [errors objectForKey:@"NSLocalizedDescription"];					
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:errormessage delegate:nil cancelButtonTitle:@"Oh well" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
}

-(IBAction) doLogin:(id)sender {
	
	NSString *arg1 = [username text];
	NSString *arg2 = [password text];
	
	[[MEOW_UserState sharedMEOW_UserState] setLogged_in:FALSE];
	
	id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
	DKDeferred* dk2 = [dk login:array_(arg1,arg2)];
	[dk2 addCallback:callbackTS(self,doLoginCompleted:)];
	[dk2 addErrback:callbackTS(self, doLoginFailed:)];
	
}

- (id)doLoginCompleted:(id)result {
    // do something with result
	NSLog(@" Login Completed! %@ " , result );
	
	NSArray *resultdict = [(NSDictionary*)result objectForKey:@"result"];
	NSString *message = @"Login was a success!";				
	
	//setup UserSession singleton.
	[[MEOW_UserState sharedMEOW_UserState] setLogged_in:TRUE];
	[[MEOW_UserState sharedMEOW_UserState] setUsername:[username text]];
	[[MEOW_UserState sharedMEOW_UserState] setPassword:[password text]];
	
	//cache inbox messages sent back.
	NSEnumerator *enumerator = [resultdict objectEnumerator];
	id anObject;
	
	while (anObject = [enumerator nextObject]) {
		/* code to act on each element as it is returned */
		NSLog(@"object is %@" , anObject);
		NSArray *msg = (NSArray *) anObject;
		
		[[MEOW_UserState sharedMEOW_UserState] addMessage:[msg objectAtIndex:1] withTitle:[msg objectAtIndex:0]
											   fromSender:[msg objectAtIndex:2] atDateTime:[msg objectAtIndex:3]
												 withType:MSG_PRIVATE];
		
	}
	
	//lets pass self as delegate - auto-pop back to home screen on success.
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Success!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return result;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	//pop back to home screen, since this SHOULD BE the only way this method gets called. ie all other 
	[self.navigationController popViewControllerAnimated:TRUE];
	
	
}


- (id)doLoginFailed:(NSError *)err {
    // do something with error
	
	NSDictionary *errors = [err userInfo];
	NSLog(@" FAIL login %@ " , err );
	NSString *errormessage = [errors objectForKey:@"NSLocalizedDescription"];					
	
	[[MEOW_UserState sharedMEOW_UserState] setLogged_in:FALSE];
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:errormessage delegate:nil cancelButtonTitle:@"Oh well" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self setTitle:@"Login or Register"];
	
	
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:self.view.window];
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:self.view.window];
    keyboardIsShown = NO;
	//make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
	//http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
	// second answer by Shiun
    CGSize scrollContentSize = CGSizeMake(320, 430);
    self.scrollView.contentSize = scrollContentSize;
}


- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
	
    // get the size of the keyboard
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
	
	
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    
    viewFrame.size.height += (keyboardSize.height );
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
	
    keyboardIsShown = NO;
}


- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
	
    NSDictionary* userInfo = [n userInfo];
	
    // get the size of the keyboard
    NSValue* boundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
	
    
    CGRect viewFrame = self.scrollView.frame;
	viewFrame.size.height -= (keyboardSize.height );
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
	
    keyboardIsShown = YES;
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
	
	// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
	
}


- (void)dealloc {
    [super dealloc];
}

@end
