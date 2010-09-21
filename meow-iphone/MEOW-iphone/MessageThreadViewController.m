//
//  MessageThreadViewController.m
//  MEOW-iphone
//
//  Created by andycat on 21/09/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "MessageThreadViewController.h"
#import "MEOW_UserMessage.h"
#import "MEOW_UserState.h"
#import "DKDeferred+JSON.h"
#import "MEOW_iphoneAppDelegate.h"
#import "SendMessageViewController.h"

@implementation MessageThreadViewController

@synthesize threadText;
@synthesize threadString;
@synthesize navController;
@synthesize msgid;
@synthesize threadSender;

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
	
	[self setTitle:@"Messaging"];
	//setup threadtext
	
	[threadText loadHTMLString:[self threadString] baseURL:nil];
	
	//retrieve the thread
	[self doGetThread:[self msgid]];
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
	[threadText release];
	[threadSender release];
}



-(void) doGetThread:(int) msgid {
	NSLog(@" get Thread Called! ");
	
	NSNumber *msgid_num = [NSNumber numberWithInt:msgid];
	id dk = [DKDeferred jsonService:SERVICE_URL name:@"meow"];
	DKDeferred* dk2 = [dk getThread:array_([MEOW_UserState sharedMEOW_UserState].username, [MEOW_UserState sharedMEOW_UserState].password, [msgid_num intValue])];
	[dk2 addCallback:callbackTS(self,doThreadCompleted:)];
	[dk2 addErrback:callbackTS(self, doThreadFailed:)];
	
}

-(id) doThreadCompleted:(id) result {
	// do something with result
	NSLog(@" Thread Completed! %@ " , result );
	
	NSArray *thread_worked = [(NSDictionary*)result objectForKey:@"result"];
	//check it worked
	
	if ([thread_worked count] != 0) {
		NSMutableString *threadsStr = [[NSMutableString alloc] init];
					
		//cache inbox messages sent back.
		NSEnumerator *enumerator = [thread_worked objectEnumerator];
		id anObject;
			
		[self setThreadSender:@""];
		
		while (anObject = [enumerator nextObject]) {
			/* code to act on each element as it is returned */
			NSLog(@"object is %@" , anObject);
			NSArray *msg = (NSArray *) anObject;
				
			//find the latest thread sender not the user
			if ([threadSender isEqualToString:@""] && ! [[msg objectAtIndex:3] isEqualToString:[MEOW_UserState sharedMEOW_UserState].username]) {
				[self setThreadSender:[msg objectAtIndex:3]];
			}
			
			[threadsStr appendFormat:@"<p><b>%@ %@</b><br/><i>sent by %@ on %@</i></p>" ,[msg objectAtIndex:1], [msg objectAtIndex:2],
																		[msg objectAtIndex:3], [msg objectAtIndex:4]
			 ];
			/*	[[MEOW_UserState sharedMEOW_UserState] addMessage:[msg objectAtIndex:2] withTitle:[msg objectAtIndex:1]
													   fromSender:[msg objectAtIndex:3] atDateTime:[msg objectAtIndex:4]
														 withType:MSG_PRIVATE withID:[msg objectAtIndex:0]];
			*/	
			NSLog(@" thread string is %@" , threadsStr);
		}
		
		//set the text
		
		[threadText loadHTMLString:threadsStr baseURL:nil];
		
	}
	
	return result;
}

-(id) doThreadFailed:(NSError *)err {
	// do something with error
	
	NSDictionary *errors = [err userInfo];
	NSLog(@" FAIL thread %@ " , errors );
	//NSString *errormessage = [errors objectForKey:@"NSLocalizedDescription"];					
	
	
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldnt show thread. Sorry :-(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
	[alertview show];
	[alertview release];
	
    return err;
	
}

-(IBAction) doReply:(id) sender {
	
	NSLog(@"Do Reply!");
	
	NSLog(@"Showing send message controller. nav controller %@" , self.navController);
	SendMessageViewController *sendMsgViewController = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
	[sendMsgViewController setNavController:[self navController]];
	
	//set the recipient 
	[sendMsgViewController setInitialRecipient:[self threadSender]];
	//set the thread ID
	[sendMsgViewController setThreadId:msgid];
	
	[self.navController pushViewController:sendMsgViewController animated:YES];
	[sendMsgViewController release];
	
	
	
}

-(IBAction) doTrash:(id) sender {
	
	NSLog(@"Do Trash!");
}

@end
