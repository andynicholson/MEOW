//
//  MessagesViewController.m
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "MessagesViewController.h"
#import "MEOW_UserMessage.h"
#import "MEOW_UserState.h"
#import "DKDeferred+JSON.h"
#import "MEOW_iphoneAppDelegate.h"
#import "MessageThreadViewController.h"

@implementation MessagesViewController


#pragma mark -
#pragma mark View lifecycle

@synthesize msgsTable;
@synthesize indexpathDeleting;
@synthesize navController;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	deleting = FALSE;
	
	if (! [MEOW_UserState sharedMEOW_UserState].delayTimer) {
		NSLog(@"Scheduling a auto refresh of inbox every 15 seconds");
		
		//timer on the shared object -- calling refreshInbox
		
		[MEOW_UserState sharedMEOW_UserState].delayTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(doRefreshInbox) userInfo:nil repeats:YES];		
		
	}
	
}
 

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	
}
*/


/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
    return [[[MEOW_UserState sharedMEOW_UserState] userMessages] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.msgsTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
	MEOW_UserMessage *msg = [[[MEOW_UserState sharedMEOW_UserState] userMessages] objectAtIndex:indexPath.row];
	
	
	NSString *subtitle = [NSString stringWithFormat:@"sent by %@ on %@" , [msg sender], [msg datetime]];
	NSString *header = [NSString stringWithFormat:@"%@" , [msg title]];
						
	[cell.textLabel setText:header];
	[cell.detailTextLabel setText:subtitle];
	
	
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


//JSON-RPC calls

-(void) doDeleteMsg:(int) msgid {
	
	id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
	NSNumber *msgid_num = [NSNumber numberWithInt:msgid];
	DKDeferred* dk2 = [dk deleteMsg:array_([MEOW_UserState sharedMEOW_UserState].username, [MEOW_UserState sharedMEOW_UserState].password, [msgid_num intValue] )];
	[dk2 addCallback:callbackTS(self,doDeleteCompleted:)];
	[dk2 addErrback:callbackTS(self, doDeleteFailed:)];
	
	
}


-(void) doRefreshInbox {
	NSLog(@" Refresh Inbox Called! " );
	
	//NSLog(@"self is %@ table is %@ " , self, [self msgsTable]);
	
	id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
	DKDeferred* dk2 = [dk inbox:array_([MEOW_UserState sharedMEOW_UserState].username, [MEOW_UserState sharedMEOW_UserState].password)];
	[dk2 addCallback:callbackTS(self,doRefreshCompleted:)];
	[dk2 addErrback:callbackTS(self, doRefreshFailed:)];
	
	//not reliable
	//[[self msgsTable] reloadData];
}





//JSON-RPC call backs

-(id) doRefreshCompleted:(id) result {
	//NSLog(@" Refresh Inbox Completed! %@  self is %@ table is %@" , result , self, [self msgsTable]);
	
	NSArray *resultdict = [(NSDictionary*)result objectForKey:@"result"];
	
	//clear out the shared instance's current messages
	[[MEOW_UserState sharedMEOW_UserState] initialisation];
	
	[MEOW_UserState processReturnedInbox:resultdict];
	
	//Remove it from the UITableView
	if (deleting) {
		[self.msgsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexpathDeleting] withRowAnimation:YES];
		deleting = FALSE;
	}
	
	
	
	return result;
}

-(id) doRefreshFailed:(NSError *)err {
	NSLog(@" Refresh Inbox Failed! %@ " , err );
	
	return err;
}

-(id) doDeleteCompleted:(id) result {
	// do something with result
	NSLog(@" Delete Completed! %@ " , result );
	
	NSNumber *delete_worked = [(NSDictionary*)result objectForKey:@"result"];
	//check it worked
	if ([delete_worked intValue] == 1) {
		
		[self doRefreshInbox];
		
	}
	
	return result;
}

-(id) doDeleteFailed:(NSError *)err {
	// do something with error
	
	NSDictionary *errors = [err userInfo];
	NSLog(@" FAIL delete %@ " , errors );
	//NSString *errormessage = [errors objectForKey:@"NSLocalizedDescription"];					
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldnt delete message. Sorry :-(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
	
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		// it all happens later..
		deleting = TRUE;
	
		MEOW_UserMessage *msg = [[[MEOW_UserState sharedMEOW_UserState] userMessages] objectAtIndex:indexPath.row];
		[self setIndexpathDeleting:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section ]];
		[self doDeleteMsg:[msg msgid]];
		NSLog(@" Wants to delete msgid %@ on row %d section %d" , [msg msgid] , [self indexpathDeleting].row , [self indexpathDeleting].section);
		
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	MEOW_UserMessage *msg = [[[MEOW_UserState sharedMEOW_UserState] userMessages] objectAtIndex:indexPath.row];

	NSLog(@" Wants to see thread %@" , [msg msgid]);
	
	
	
	//push view controller etc
	NSLog(@"Showing thread controller. nav controller %@" , self.navController);
	MessageThreadViewController *threadViewController = [[MessageThreadViewController alloc] initWithNibName:@"MessageThreadViewController" bundle:nil];
	[threadViewController setThreadString:@"Thread loading..."];
	[threadViewController setNavController:[self navController]];
	[threadViewController setMsgid:[msg msgid]];
	
	[self.navController pushViewController:threadViewController animated:YES];
	[threadViewController release];
	
	
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	NSLog(@" Stopping inbox refresh timers");
	[[MEOW_UserState sharedMEOW_UserState].delayTimer invalidate];
	[MEOW_UserState sharedMEOW_UserState].delayTimer = nil;
	
		
}


- (void)dealloc {
    [super dealloc];
	[msgsTable release];
	[indexpathDeleting release];
	[navController release];
	
}


@end

