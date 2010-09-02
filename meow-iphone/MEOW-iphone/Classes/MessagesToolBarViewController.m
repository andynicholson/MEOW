//
//  MessagesToolBarViewController.m
//  MEOW-iphone
//
//  Created by andycat on 28/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "MessagesToolBarViewController.h"

@implementation MessagesToolBarViewController

@synthesize topView;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

		//Add the tableview controller to the view
		[self setTitle:@"Messaging"];
		//Messages View Controller
		mvc = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:nil];
	
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//NSLog(@" frame size of tableview in mvc is %f %f" , mvc.view.frame.size.width, mvc.view.frame.size.height);
	[mvc.view setFrame:self.topView.frame];
	[self.topView addSubview:mvc.view];
	
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
	[topView release];
	[mvc release];
}


@end
