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


@implementation HomeViewController

@synthesize groups, contacts, about, messages, login, register_btn;

-(IBAction) doRegisterScreen:(id)sender {
	NSLog(@"do Register in homeviewcontroller!");
	RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	[self.navigationController pushViewController:rvc animated:TRUE];
	[rvc release];
	
}


-(IBAction) doLoginScreen:(id)sender {
	NSLog(@"do Login in homeviewcontroller!");

	RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	[self.navigationController pushViewController:rvc animated:TRUE];
	[rvc release];
	
}

-(IBAction) doMessagesScreen:(id)sender {
	NSLog(@"do Messages in homeviewcontroller!");
	
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		MessagesToolBarViewController *rvc = [[MessagesToolBarViewController alloc] initWithNibName:@"MessagesToolBarViewController" bundle:nil];
		[self.navigationController pushViewController:rvc animated:TRUE];
		[rvc release];		
	} else {
		NSString *message = @"To retreive your messages, please login first.";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Messages" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
	}

	
	
}


-(IBAction) doContactsScreen:(id)sender {
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		MessagesToolBarViewController *rvc = [[MessagesToolBarViewController alloc] initWithNibName:@"MessagesToolBarViewController" bundle:nil];
		[self.navigationController pushViewController:rvc animated:TRUE];
		[rvc release];		
	} else {
		NSString *message = @"To see your online contacts, please login first.";	
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Contacts" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];	
	}
	
	
	
}
-(IBAction) doGroupsScreen:(id)sender {
	if ( [[MEOW_UserState sharedMEOW_UserState] logged_in] ) {
		MessagesToolBarViewController *rvc = [[MessagesToolBarViewController alloc] initWithNibName:@"MessagesToolBarViewController" bundle:nil];
		[self.navigationController pushViewController:rvc animated:TRUE];
		[rvc release];		
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//start with the gruops etc button disabled, until login
	/*
	[groups setEnabled:NO];
	[messages setEnabled:NO];
	[contacts setEnabled:NO];
	 */
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
}


@end
