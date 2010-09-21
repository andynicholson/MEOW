//
//  MessagesToolBarViewController.m
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "MessagesToolBarViewController.h"
#import "MEOW_UserMessage.h"
#import "MEOW_UserState.h"
#import "MessageThreadViewController.h"

@implementation MessagesToolBarViewController

@synthesize topView;
@synthesize newmsg, groups, publicbtn, personal;
@synthesize refreshTimer;
@synthesize navController;

-(void) userWantsPersonalMessaging {
	
	[self setTitle:@"Personal Messaging"];
	[[MEOW_UserState sharedMEOW_UserState] setViewing_message_types:MSG_PRIVATE];
	[self mvcWantsTableReload];
}


-(void) userWantsPublicMessaging {
	
	[self setTitle:@"Public Messaging"];
	[[MEOW_UserState sharedMEOW_UserState] setViewing_message_types:MSG_PUBLIC];
	[self mvcWantsTableReload];
}


-(void) userWantsGroupsMessaging {
	
	[self setTitle:@"Groups Messaging"];
	[[MEOW_UserState sharedMEOW_UserState] setViewing_message_types:MSG_GROUP];
	[self mvcWantsTableReload];
}


-(void) userWantsToWriteNewMessage {
	
	
	/*
	NSLog(@"Showing thread controller. nav controller %@" , self.navController);
	MessageThreadViewController *detailViewController = [[MessageThreadViewController alloc] initWithNibName:@"MessageThreadViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.
	[self.navController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	*/
	
	
	
}

-(void) mvcWantsTableReload {
	
	[[mvc msgsTable] reloadData];
	
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

		//Add the tableview controller to the view
		[self setTitle:@"Personal Messaging"];
		//Messages View Controller
		mvc = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nibBundleOrNil];
		self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:7.5 target:self selector:@selector(mvcWantsTableReload) userInfo:nil repeats:YES];		
		
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	NSLog(@" frame size of tableview in mvc is %f %f" , mvc.view.frame.size.width, mvc.view.frame.size.height);
	//set to 416 
	CGRect tableviewRect= CGRectMake(0.0, 0.0, mvc.view.frame.size.width, 416);
	[mvc.view setFrame:tableviewRect];
	 //add to view
	[self.topView addSubview:mvc.view];
	[mvc setNavController:[self navController]];

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
	
	[self.refreshTimer invalidate];

}


- (void)dealloc {
    [super dealloc];
	[topView release];
	
	[newmsg release];
	[publicbtn release];
	[groups	release];
	[personal release];
	
	[mvc release];
	[refreshTimer release];
	[navController release];
}


@end
