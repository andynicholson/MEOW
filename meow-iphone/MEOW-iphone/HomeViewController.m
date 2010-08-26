//
//  HomeViewController.m
//  MEOW-iphone
//
//  Created by andycat on 26/08/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "RegisterViewController.h"

@implementation HomeViewController


-(IBAction) doRegister:(id)sender {
	NSLog(@"do Register in homeviewcontroller!");
	//RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	//[navController pushViewController:rvc animated:TRUE];
	//[rvc release];
	
}


-(IBAction) doLogin:(id)sender {
	NSLog(@"do Login in homeviewcontroller!");

	//RegisterViewController *rvc = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
	//[navController pushViewController:rvc animated:TRUE];
	//[rvc release];
	
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
