//
//  HomeViewController.m
//  MEOW-iphone
//
//  Created by andycat on 26/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "RegisterViewController.h"
#import "MessagesToolBarViewController.h"
#import "MEOW_UserState.h"
#import "ContactsViewController.h"

@implementation HomeViewController

@synthesize groups, contacts, about, messages, login, register_btn;
@synthesize welcomeMsg;

-(IBAction) doRegisterScreen:(id)sender {
	NSLog(@"do Register in homeviewcontroller!");
	RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	[self.navigationController pushViewController:rvc animated:TRUE];
	[rvc release];
	
}


-(IBAction) doLoginScreen:(id)sender {
	NSLog(@"do Login in homeviewcontroller!");
	
	//if NOT logged in
	if ( ! [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		
		RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		[self.navigationController pushViewController:rvc animated:TRUE];
		[rvc release]; 
		
	} else {
		
		//Simulate logout
		NSString *message = @"Catch ya later bro!";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Seeya" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
		
		//reset button to original state
		[login setTitle:@"Login" forState:UIControlStateNormal];
		[[MEOW_UserState sharedMEOW_UserState] setLogged_in:FALSE];
		[[MEOW_UserState sharedMEOW_UserState] initialisation];
		
		
		[register_btn setEnabled:YES];
		[register_btn setBackgroundColor:[UIColor whiteColor]];
		
		//Logout of the XMPP session.
		[[MEOW_UserState sharedMEOW_UserState] xmppLogout];
	}
	
}

-(IBAction) doMessagesScreen:(id)sender {
	NSLog(@"do Messages in homeviewcontroller!");
	
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		MessagesToolBarViewController *mtbvc = [[MessagesToolBarViewController alloc] initWithNibName:@"MessagesToolBarViewController" bundle:nil];
		[mtbvc setNavController:self.navigationController];
		
		//show it
		[self.navigationController pushViewController:mtbvc animated:TRUE];
		[mtbvc release];		
	} else {
		NSString *message = @"To retreive your messages, please login first.";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Messages" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
	}

	
	
}


-(IBAction) doContactsScreen:(id)sender {
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		
		ContactsViewController *cvc = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
		[self.navigationController pushViewController:cvc animated:YES];
		[cvc release];
		
		
	} else {
		NSString *message = @"To see your online contacts, please login first.";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Contacts" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
	}
	
	
	
}
-(IBAction) doGroupsScreen:(id)sender {
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		
	
		
	} else {
		NSString *message = @"To see the list of groups, please login first.";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Groups" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
	}
	
	
	
}
-(IBAction) doAboutScreen:(id)sender {
	
	NSString *message = @"Developed by Andy Nicholson.\n Copyright 2010.\nReleased under the GNU GPL v3. See http://github.com/andycat/MEOW for source code.";	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"About MEOW" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];	
	
	
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) viewWillAppear:(BOOL)animated {
	
	//start with the gruops etc button disabled, until login
	if ([[MEOW_UserState sharedMEOW_UserState] logged_in]) {
		[login setTitle:@"Logout" forState:UIControlStateNormal];
		
		[register_btn setEnabled:NO];
		[register_btn setBackgroundColor:[UIColor grayColor]];
		
		NSString *welcomeMsgCustom = [NSString stringWithFormat:@"Welcome %@", [MEOW_UserState sharedMEOW_UserState].username];
		
		[welcomeMsg setText:welcomeMsgCustom];
		
	} else {
		[login setTitle:@"Login" forState:UIControlStateNormal];
		
		[register_btn setEnabled:YES];
		[register_btn setBackgroundColor:[UIColor whiteColor]];
	}
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	
	 
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
	[welcomeMsg release];
	[groups release];
	
	[contacts release];
	[about release];
	[messages release];
	[login release];
	[register_btn release];
	
	
}


@end
