//
//  WallViewController.m
//  SampleRest
//
//  Created by Ram Charan on 5/10/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "ContainerViewController.h"
#import "ActivityViewController.h"
#import "StartUpViewController.h"
#import "InboxViewController.h"

@implementation ContainerViewController

@synthesize tabBarController = _tabBarController;

extern NSString *_angelUserId;
extern NSString *_angelUserName;

BOOL _transitFromActivity = FALSE;
BOOL _transitFromStartUps = FALSE;

NSString *_currUserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.tabBarController.delegate = self;
    _currUserId = [[NSString alloc] initWithFormat:@"%@",_angelUserId];
    UIViewController *viewController1, *viewController2, *viewController3;
    UINavigationController *navigationcontroller1,*navigationcontroller2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        viewController1 = [[[ActivityViewController alloc] initWithNibName:@"ActivityViewController_iPhone" bundle:nil] autorelease];
        navigationcontroller1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
        
        viewController2 = [[[StartUpViewController alloc] initWithNibName:@"StartUpViewController_iPhone" bundle:nil] autorelease];
        navigationcontroller2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
        
        viewController3 = [[[InboxViewController alloc] initWithNibName:@"InboxViewController_iPhone" bundle:nil] autorelease];
    }
    else
    {
        viewController1 = [[[ActivityViewController alloc] initWithNibName:@"ActivityViewController_iPad" bundle:nil] autorelease];
        navigationcontroller1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
        
        viewController2 = [[[StartUpViewController alloc] initWithNibName:@"StartUpViewController_iPad" bundle:nil] autorelease];
        navigationcontroller2 = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
        
        viewController3 = [[[InboxViewController alloc] initWithNibName:@"InboxViewController_iPad" bundle:nil] autorelease];
    }
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationcontroller1, navigationcontroller2, viewController3, nil];
    [self.view addSubview:self.tabBarController.view];
    
    [[[[[self tabBarController] viewControllers] objectAtIndex:2] tabBarItem] setEnabled:false]; 
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{

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
