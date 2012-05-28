//
//  ViewController.m
//  SampleRest
//
//  Created by Ram Charan on 5/9/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ContainerViewController.h"

@implementation ViewController

BOOL loginFromAL = FALSE;
BOOL loginWithTW = FALSE;
BOOL _loggedIn = FALSE;

@synthesize loginView = _loginView;

ContainerViewController *_containerViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if(_loggedIn)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            _containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPhone" bundle:nil] autorelease];
        }
        else
        {
            _containerViewController = [[[ContainerViewController alloc] initWithNibName:@"ContainerViewController_iPad" bundle:nil] autorelease];
        }
        
        [self.view removeFromSuperview];
        [self.view addSubview:_containerViewController.view];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


-(IBAction) loginFromAngellist:(id) sender
{
    loginFromAL = TRUE;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        _loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPhone" bundle:nil];
        [self presentModalViewController:_loginView animated:YES];
    }
    else
    {
        _loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
        [self presentModalViewController:_loginView animated:YES];

    }
}

-(IBAction) loginWithTwitter:(id) sender
{
    loginWithTW = TRUE;
    _loginView = [[LoginViewController alloc] init];
    [self presentModalViewController:_loginView animated:YES];
}

-(void) dealloc
{
    [_loginView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

@end
