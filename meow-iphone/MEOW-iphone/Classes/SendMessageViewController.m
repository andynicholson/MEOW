//
//  SendMessageViewController.m
//  MEOW-iphone
//
//  Created by andycat on 21/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "SendMessageViewController.h"
#import "MEOW_UserMessage.h"
#import "MEOW_UserState.h"
#import "DKDeferred+JSON.h"
#import "MEOW_iphoneAppDelegate.h"

#import "XMPPUserCoreDataStorage.h"

@implementation SendMessageViewController

@synthesize recipient, subject, message, navController;
@synthesize scrollView;
@synthesize threadId;
@synthesize initialRecipient;
@synthesize xmpp_recipient;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

		
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self setTitle:@"Send Message"];
	
	if ([[self initialRecipient] length] != 0) {
		
		[[self recipient] setText:initialRecipient];
	}

	
	
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textViewShouldReturn:) 
												 name:UITextViewTextDidEndEditingNotification
											   object:self.view.window];
	
	
    keyboardIsShown = NO;
	
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


- (void)textViewShouldReturn:(NSNotification *)notif {
	
	UITextView *textView = [notif object];
	[textView resignFirstResponder];
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
	
}

-(IBAction) sendMessage:(id)sender {
	
	if ([[[self recipient] text] length] == 0) {
				
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please specifiy a recipient. Please correct this and try to send again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];
		
		return;
	}
	
	if ([[[self subject] text] length] == 0) {
				
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please specifiy a subject. Please correct this and try to send again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];
		
		return;
	}
	
	
	NSLog(@"Send the message!");
	
	[self doSendMessage:[[self subject] text] withBody:[[self message] text] toRecipient:[[self recipient] text]];
	
}

-(void) sendXMPPmessage:(NSString *)strmessage toXMPPUser:(XMPPUserCoreDataStorage *)user {
	
	NSLog(@"Send the message via XMPP!");
	
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	[body setStringValue:strmessage];
	
	NSXMLElement *xmppmessage = [NSXMLElement elementWithName:@"message"];
    [xmppmessage addAttributeWithName:@"type" stringValue:@"chat"];
	[xmppmessage addAttributeWithName:@"to" stringValue:[user.jid full]];
	
	[xmppmessage addChild:body];
	
	
	MEOW_iphoneAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	[delegate.xmppStream sendElement:xmppmessage];
	
	
	
}


-(void) doSendMessage:(NSString *)msgtitle withBody:(NSString *)body toRecipient:(NSString *) recipientstr {
	NSLog(@" send Message Called! ");
	
	if ([self threadId] == 0) {
		
		//This is the AVAILABLE section 
		//delivery via XMPP 
		if ([[xmpp_recipient sectionNum] intValue] == 0) {
			[self sendXMPPmessage:[NSString stringWithFormat:@"%@ %@", msgtitle, body] toXMPPUser:xmpp_recipient];
		}
		
		id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
		DKDeferred* dk2 = [dk sendMsg:array_([MEOW_UserState sharedMEOW_UserState].username, [MEOW_UserState sharedMEOW_UserState].password, body, msgtitle, recipientstr)];
		[dk2 addCallback:callbackTS(self,doSendCompleted:)];
		[dk2 addErrback:callbackTS(self, doSendFailed:)];
		
	} else {
		NSNumber *msgid_num = [NSNumber numberWithInt:[self threadId]];
		id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
		DKDeferred* dk2 = [dk sendMsgReply:array_([MEOW_UserState sharedMEOW_UserState].username, [MEOW_UserState sharedMEOW_UserState].password, body, msgtitle, recipientstr, [msgid_num intValue])];
		[dk2 addCallback:callbackTS(self,doSendCompleted:)];
		[dk2 addErrback:callbackTS(self, doSendFailed:)];
		
	}
		
	
}

-(id) doSendCompleted:(id) result {
	// do something with result
	NSLog(@" send Message Completed! %@ " , result );
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Thanks" message:@"Message was sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
	//go back
	[self.navController popViewControllerAnimated:YES];
	
	return result;
}

-(id) doSendFailed:(NSError *)err {
	// do something with error
	
	NSDictionary *errors = [err userInfo];
	NSLog(@" FAIL send message %@ " , errors );
	//NSString *errormessage = [errors objectForKey:@"NSLocalizedDescription"];					
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldnt send Message. Sorry :-(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[navController release];
	[recipient release];
	[subject release];
	[message release];
	[scrollView release];
	[initialRecipient release];
}
@end
