//
//  FourthViewController.m
//  SampleRest
//
//  Created by Ram Charan on 5/17/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "DetailsViewController.h"
#import "WebDetailsController.h"
#import "AsyncImageView.h"

@implementation DetailsViewController

extern NSMutableArray *actorNameArray;
extern NSMutableArray *actorUrlArray;
extern NSMutableArray *actorTaglineArray;
extern NSMutableArray *feedImageArray;


extern NSMutableArray *displayStartUpNameArray;
extern NSMutableArray *displayStartUpAngelUrlArray;
extern NSMutableArray *displayStartUpLogoUrlArray;
extern NSMutableArray *displayStartUpProductDescArray;
extern NSMutableArray *displayStartUpHighConceptArray;
extern NSMutableArray *displayStartUpFollowerCountArray;
extern NSMutableArray *displayStartUpLocationArray;
extern NSMutableArray *displayStartUpMarketArray;


extern int _rowNumberInActivity;
extern int _rowNumberInStartUps;

extern BOOL _transitFromActivity;
extern BOOL _transitFromStartUps;

extern BOOL _filterFollow;


NSMutableArray *displayImageArray;

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
    displayImageArray = [[NSMutableArray alloc] init];
    
    [displayImageArray removeAllObjects];
    if(_transitFromActivity)
    {
        [displayImageArray addObjectsFromArray:feedImageArray];
    }
    else if(_transitFromStartUps)
    {
        [displayImageArray addObjectsFromArray:displayStartUpLogoUrlArray];
    }
    
    UIImage* image = [UIImage imageNamed:@"back.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* backButton = [[UIButton alloc] initWithFrame:frame];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    [backButton release];
    
    if(_transitFromActivity)
    {   
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:logoImage.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [displayImageArray objectAtIndex:_rowNumberInActivity];
        [asyncImage loadImageFromURL:url];
        [logoImage addSubview:asyncImage];
        
        actorName.text = [actorNameArray objectAtIndex:_rowNumberInActivity];
        actorName.lineBreakMode = UILineBreakModeWordWrap;
        actorName.numberOfLines = 3;
        
        logoDesc.text = [actorTaglineArray objectAtIndex:_rowNumberInActivity];
        logoDesc.editable = FALSE;
    }
    
    if(_transitFromStartUps)
    {
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:logoImage.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [displayImageArray objectAtIndex:_rowNumberInStartUps];
        [asyncImage loadImageFromURL:url];
        [logoImage addSubview:asyncImage];
        
        startUpName.text = [displayStartUpNameArray objectAtIndex:_rowNumberInStartUps];
        startUpName.lineBreakMode = UILineBreakModeWordWrap;
        
        startUpMarket.text = [NSString stringWithFormat:@"Markets - %@",[displayStartUpMarketArray objectAtIndex:_rowNumberInStartUps]];
        startUpMarket.lineBreakMode = UILineBreakModeWordWrap;
        
        startUpLocation.text = [NSString stringWithFormat:@"Locations - %@",[displayStartUpLocationArray objectAtIndex:_rowNumberInStartUps]];
        startUpLocation.lineBreakMode = UILineBreakModeWordWrap;
        
        startUpFollowers.text = [NSString stringWithFormat:@"Followers %@",[displayStartUpFollowerCountArray objectAtIndex:_rowNumberInStartUps]];
        startUpFollowers.lineBreakMode = UILineBreakModeWordWrap;
        
        logoDesc.text = [displayStartUpProductDescArray objectAtIndex:_rowNumberInStartUps];
        logoDesc.editable = FALSE;
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)actorDetails:(id)sender
{
    WebDetailsController *webDetailsController;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        webDetailsController = [[WebDetailsController alloc] initWithNibName:@"WebDetailsController_iPhone" bundle:nil]; 
    }
    else
    {
        webDetailsController = [[WebDetailsController alloc] initWithNibName:@"WebDetailsController_iPad" bundle:nil]; 
    }
    
    [self.navigationController pushViewController:webDetailsController animated:YES];
    [webDetailsController release];
}

-(void) backAction:(id)sender
{
    _transitFromActivity = FALSE;
    _transitFromStartUps = FALSE;
    [displayImageArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
