//
//  SecondViewController.m
//  SampleTabbar
//
//  Created by Ram Charan on 5/16/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "StartUpViewController.h"
#import "DetailsViewController.h"
#import "AsyncImageView.h"

@implementation StartUpViewController

NSMutableArray *startUpNameArray;
NSMutableArray *startUpAngelUrlArray;
NSMutableArray *startUpLogoUrlArray;
NSMutableArray *startUpProductDescArray;
NSMutableArray *startUpHighConceptArray;
NSMutableArray *startUpFollowerCountArray;
NSMutableArray *startUpLocationArray;
NSMutableArray *startUpMarketArray;

NSMutableArray *displayStartUpIdsArray;
NSMutableArray *displayStartUpNameArray;
NSMutableArray *displayStartUpAngelUrlArray;
NSMutableArray *displayStartUpLogoUrlArray;
NSMutableArray *displayStartUpProductDescArray;
NSMutableArray *displayStartUpHighConceptArray;
NSMutableArray *displayStartUpFollowerCountArray;
NSMutableArray *displayStartUpLocationArray;
NSMutableArray *displayStartUpMarketArray;



extern BOOL _transitFromStartUps;
extern BOOL _transitFromActivity;

extern NSString *_angelUserId;
extern NSString *_currUserId;

BOOL _filterFollow = FALSE;
BOOL _showFilterMenuInStartUps = FALSE;

int _rowNumberInStartUps = 0;
NSArray *_filterStartUpNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"StartUps";
    }
    return self;
}


//---insert individual row into the table view---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    
    //---try to get a reusable cell--- 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    //---create new cell if no reusable cell is available---
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else 
    {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    
    //---set the text to display for the cell---
    NSString *cellNameValue = [displayStartUpNameArray objectAtIndex:indexPath.row]; 
    NSString *cellHighConceptValue = [displayStartUpHighConceptArray objectAtIndex:indexPath.row]; 
    NSString *cellLocationValue = [displayStartUpLocationArray objectAtIndex:indexPath.row]; 
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(85, 8, 240, 20)] autorelease];
        cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellNameLabel.text = cellNameValue;
        cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        [cell.contentView addSubview:cellNameLabel];
        
        UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(85, 26, 240, 30)] autorelease];
        cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellHighConceptLabel.numberOfLines = 5;
        cellHighConceptLabel.text = cellHighConceptValue;
        cellHighConceptLabel.backgroundColor = [UIColor clearColor];
        cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        [cell.contentView addSubview:cellHighConceptLabel];
        
        UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(82, 61, 240, 30)] autorelease];
        cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellLocationLabel.text = cellLocationValue;
        cellLocationLabel.textColor = [UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:76.0/255.0 alpha:1.0f];
        cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        [cell.contentView addSubview:cellLocationLabel];
        
        cell.imageView.frame = CGRectMake(7, 8, 44, 44);
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [displayStartUpLogoUrlArray objectAtIndex:indexPath.row];
        [asyncImage loadImageFromURL:url];
        
        [cell.contentView addSubview:asyncImage];
    }
    else
    {
        UILabel *cellNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*7)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellNameLabel.text = cellNameValue;
        cellNameLabel.textColor = [UIColor colorWithRed:63.0/255.0 green:103.0/255.0 blue:160.0/255.0 alpha:1.0f];
        cellNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:32];
        [cell.contentView addSubview:cellNameLabel];
        
        UILabel *cellHighConceptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*39)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellHighConceptLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellHighConceptLabel.numberOfLines = 5;
        cellHighConceptLabel.text = cellHighConceptValue;
        cellHighConceptLabel.backgroundColor = [UIColor clearColor];
        cellHighConceptLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        [cell.contentView addSubview:cellHighConceptLabel];
        
        UILabel *cellLocationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*85)/320), ((1024*71)/480), ((768*240)/320), ((1024*30)/480))] autorelease];
        cellLocationLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellLocationLabel.text = cellLocationValue;
        cellLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
        [cell.contentView addSubview:cellLocationLabel];
        
        cell.imageView.frame = CGRectMake(((768*7)/320), ((1024*7)/480), ((768*70)/320), ((1024*70)/480));
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [displayStartUpLogoUrlArray objectAtIndex:indexPath.row];
        [asyncImage loadImageFromURL:url];
        
        [cell.contentView addSubview:asyncImage];
    }
    
    
    return cell; 
}

//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [displayStartUpNameArray count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _transitFromStartUps = TRUE;
    _transitFromActivity = FALSE;
    _rowNumberInStartUps = indexPath.row;
    
    [[[[[self tabBarController] viewControllers] objectAtIndex:0] tabBarItem] setEnabled:false];
    
    DetailsViewController *detailsViewController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        detailsViewController = [[[DetailsViewController alloc] initWithNibName:@"DetailsViewController_iPhone" bundle:nil] autorelease];
    }
    else
    {
        detailsViewController = [[[DetailsViewController alloc] initWithNibName:@"DetailsViewController_iPad" bundle:nil] autorelease];
    }
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[[[[self tabBarController] viewControllers] objectAtIndex:0] tabBarItem] setEnabled:true];
    [super viewWillAppear:animated];
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
    startUpNameArray = [[NSMutableArray alloc] init];
    startUpAngelUrlArray = [[NSMutableArray alloc] init];
    startUpLogoUrlArray = [[NSMutableArray alloc] init];
    startUpProductDescArray = [[NSMutableArray alloc] init];
    startUpHighConceptArray = [[NSMutableArray alloc] init];
    startUpFollowerCountArray = [[NSMutableArray alloc] init];
    startUpLocationArray = [[NSMutableArray alloc] init];
    startUpMarketArray = [[NSMutableArray alloc] init];
    
    displayStartUpIdsArray = [[NSMutableArray alloc] init];
    displayStartUpNameArray = [[NSMutableArray alloc] init];
    displayStartUpAngelUrlArray = [[NSMutableArray alloc] init];
    displayStartUpLogoUrlArray = [[NSMutableArray alloc] init];
    displayStartUpProductDescArray = [[NSMutableArray alloc] init];
    displayStartUpHighConceptArray = [[NSMutableArray alloc] init];
    displayStartUpFollowerCountArray = [[NSMutableArray alloc] init];
    displayStartUpLocationArray = [[NSMutableArray alloc] init];
    displayStartUpMarketArray = [[NSMutableArray alloc] init];
    
    
    _filterStartUpNames = [[NSArray arrayWithObjects:@"Following", @"Trending", @"Matching", @"All", nil] retain];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    //Add image to navigation bar button
    UIImage* image = [UIImage imageNamed:@"filter.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton* filterButton = [[UIButton alloc] initWithFrame:frame];
    [filterButton setBackgroundImage:image forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonSelected:) forControlEvents:UIControlStateHighlighted];
    
    UIBarButtonItem* filterButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    self.navigationItem.rightBarButtonItem = filterButtonItem;
    [filterButtonItem release];
    [filterButton release];
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.angel.co/1/startups/batch?ids=6702,445,87,97,117,127,147,166,167,179,193,203,223,227,289,292,303,304,312,319,321,323"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:response //1
                          options:kNilOptions 
                          error:&error];
    
    NSArray* startUpNames = [json valueForKey:@"name"]; //2
    NSArray* startUpAngelUrl = [json valueForKey:@"angellist_url"]; //2
    NSArray* startUpLogoUrl = [json valueForKey:@"thumb_url"]; //2
    NSArray* startUpProductDesc = [json valueForKey:@"product_desc"]; //2
    NSArray* startUpHighConcept = [json valueForKey:@"high_concept"]; //2
    NSArray* startUpFollowerCount = [json valueForKey:@"follower_count"]; //2
    
    NSArray* startUpLocation = [[json valueForKey:@"locations"] valueForKey:@"display_name"]; //2
    
    NSArray* startUpMarket = [[json valueForKey:@"markets"] valueForKey:@"display_name"]; //2
    
    for(int i=0; i<[startUpNames count]; i++)
    {
        [startUpNameArray addObject:[startUpNames objectAtIndex:i]];
        [displayStartUpNameArray addObject:[startUpNames objectAtIndex:i]];
        
        [startUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
        [displayStartUpAngelUrlArray addObject:[startUpAngelUrl objectAtIndex:i]];
        
        [startUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
        [displayStartUpLogoUrlArray addObject:[startUpLogoUrl objectAtIndex:i]];
        
        [startUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
        [displayStartUpProductDescArray addObject:[startUpProductDesc objectAtIndex:i]];
        
        [startUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
        [displayStartUpHighConceptArray addObject:[startUpHighConcept objectAtIndex:i]];
        
        [startUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
        [displayStartUpFollowerCountArray addObject:[startUpFollowerCount objectAtIndex:i]];
        
        if([startUpLocation objectAtIndex:i] == (NSString*)[NSNull null])
        {
            [startUpLocationArray addObject:@"NA"];
            [displayStartUpLocationArray addObject:@"NA"];
        }
        else
        {
            NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpLocation objectAtIndex:i]]];
            for(int j=0; j<[[startUpLocation objectAtIndex:i] count]; j++)
            {
                [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            }
            [startUpLocationArray addObject:theMutableString];
            [displayStartUpLocationArray addObject:theMutableString];
            [theMutableString release];
        } 
        
        NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpMarket objectAtIndex:i]]];
        for(int j=0; j<[[startUpMarket objectAtIndex:i] count]; j++)
        {
            [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
            
        }
        [startUpMarketArray addObject:theMutableString];
        [displayStartUpMarketArray addObject:theMutableString];
        [theMutableString release];
        
    }
    
    for(int k=0; k<[startUpMarketArray count]; k++)
    {
        NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[startUpMarketArray objectAtIndex:k]];
        if([checkStr rangeOfString:@"("].location != NSNotFound)
        {
            [startUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
            [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
        }
        [checkStr release];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)filterButtonSelected:(id)sender 
{
    UIView *filtersList;
    
    if(_showFilterMenuInStartUps == FALSE)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 150, 120)];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = 5;
            
            for (int i=1; i<=4; i++) 
            {
                UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [filterButton setBackgroundImage:image forState:UIControlStateNormal];
                [filterButton setTitle:[NSString stringWithFormat:@"%@",[_filterStartUpNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [filterButton addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                filterButton.frame = CGRectMake(14, _yPos, 120, 25);
                filterButton.tag = i;
                [filtersList addSubview:filterButton];
                
                if(i==2 || i==3)
                {
                    filterButton.enabled = NO;
                }
                
                _yPos = _yPos + 27;
            }
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenuInStartUps = TRUE;
        }
        else
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(((768*165)/320), 0, ((768*150)/320), ((1024*120)/480))];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = ((1024*5)/480);
            
            for (int i=1; i<=4; i++) 
            {
                UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [filterButton setBackgroundImage:image forState:UIControlStateNormal];
                [filterButton setTitle:[NSString stringWithFormat:@"%@",[_filterStartUpNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [filterButton addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                filterButton.frame = CGRectMake(((768*14)/320), _yPos, ((768*120)/320), ((1024*25)/480));
                filterButton.tag = i;
                [filtersList addSubview:filterButton];
                
                if(i==2 || i==3)
                {
                    filterButton.enabled = NO;
                }
                
                _yPos = _yPos + ((1024*27)/480);
            }
            
            
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenuInStartUps = TRUE;
        }    
    }
    else
    {
        [[self.view viewWithTag:1000] removeFromSuperview];
        [[self.view viewWithTag:1001] removeFromSuperview];
        _showFilterMenuInStartUps = FALSE;
    }
}

-(void)getFilteredList:(id)sender
{
    //    [displayStartUpIdsArray removeAllObjects];
    [displayStartUpNameArray removeAllObjects];
    [displayStartUpAngelUrlArray removeAllObjects];
    [displayStartUpLogoUrlArray removeAllObjects];
    [displayStartUpProductDescArray removeAllObjects];
    [displayStartUpHighConceptArray removeAllObjects];
    [displayStartUpFollowerCountArray removeAllObjects];
    [displayStartUpLocationArray removeAllObjects];
    [displayStartUpMarketArray removeAllObjects];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 1 : _filterFollow = TRUE;
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            [self getDetailsOfFollowing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [table reloadData];               
            });
            break;
            
            //Implement Trending    
        case 2 : 
            
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            break;
            
            //Implement Matching 
        case 3 :  
            
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview]; 
            break;
            
            //Implement All    
        case 4 : _filterFollow = FALSE; 
            [self getDetailsOfAll];
            [table reloadData];
            
            _showFilterMenuInStartUps = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            break;    
    }
}

-(void) getDetailsOfFollowing
{
    [displayStartUpIdsArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/users/%@/following?type=startup",_currUserId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:response //1
                          options:kNilOptions 
                          error:&error];
    
    NSArray* startUpFollowing = [json objectForKey:@"startups"]; //2
    
    
    
    for(int k=0; k<[startUpFollowing count]; k++)
    {
        NSDictionary *following = [startUpFollowing objectAtIndex:k];
        
        NSString* startUpFollowIds = [following valueForKey:@"id"];
        [displayStartUpIdsArray addObject:startUpFollowIds];
        
        NSString* startUpFollowNames = [following valueForKey:@"name"];
        [displayStartUpNameArray addObject:startUpFollowNames];
        
        NSString* startUpFollowAngelUrl = [following valueForKey:@"angellist_url"]; //2
        [displayStartUpAngelUrlArray addObject:startUpFollowAngelUrl];
        
        NSString* startUpFollowLogoUrl = [following valueForKey:@"thumb_url"]; //2
        [displayStartUpLogoUrlArray addObject:startUpFollowLogoUrl];
        
        NSString* startUpFollowProductDesc = [following valueForKey:@"product_desc"]; //2
        [displayStartUpProductDescArray addObject:startUpFollowProductDesc];
        
        NSString* startUpFollowHighConcept = [following valueForKey:@"high_concept"]; //2
        [displayStartUpHighConceptArray addObject:startUpFollowHighConcept];
        
        NSString* startUpFollowFollowerCount = [following valueForKey:@"follower_count"]; //2
        [displayStartUpFollowerCountArray addObject:startUpFollowFollowerCount];
        
    }
    
    
    for(int i=0; i<[displayStartUpIdsArray count]; i++)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.angel.co/1/startups/%@",[displayStartUpIdsArray objectAtIndex:i]]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod: @"GET"];
        
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:response //1
                              options:kNilOptions 
                              error:&error];
        
        NSArray* startUpFollowingLocations = [[json valueForKey:@"locations"] valueForKey:@"display_name"]; //2
        NSString* startUpFollowingMarkets = [[json valueForKey:@"markets"] valueForKey:@"display_name"]; //2
        
        for(int j=0; j<[startUpFollowingLocations count]; j++)
        {
            if([startUpFollowingLocations objectAtIndex:j] == (NSString*)[NSNull null])
            {
                [displayStartUpLocationArray addObject:@"NA"];
            }
            else
            {
                NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",[startUpFollowingLocations objectAtIndex:j]]];
                
                [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
                
                [displayStartUpLocationArray addObject:theMutableString];
                [theMutableString release];
            } 
        }
        
        NSMutableString * theMutableString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",startUpFollowingMarkets]];
        [theMutableString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
        [theMutableString replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
        [theMutableString replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
        [theMutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[theMutableString length]}];
        [displayStartUpMarketArray addObject:theMutableString];
        [theMutableString release];
    }
    
    for(int k=0; k<[displayStartUpMarketArray count]; k++)
    {
        NSString *checkStr = [[NSString alloc] initWithFormat:@"%@",[displayStartUpMarketArray objectAtIndex:k]];
        if([checkStr rangeOfString:@"("].location != NSNotFound)
        {
            [displayStartUpMarketArray replaceObjectAtIndex:k withObject:@"No data"];
        }
        [checkStr release];
    }
}

-(void) getDetailsOfAll
{
    [displayStartUpNameArray addObjectsFromArray:startUpNameArray];
    [displayStartUpAngelUrlArray addObjectsFromArray:startUpAngelUrlArray];
    [displayStartUpLogoUrlArray addObjectsFromArray:startUpLogoUrlArray];
    [displayStartUpProductDescArray addObjectsFromArray:startUpProductDescArray];
    [displayStartUpHighConceptArray addObjectsFromArray:startUpHighConceptArray];
    [displayStartUpFollowerCountArray addObjectsFromArray:startUpFollowerCountArray];
    [displayStartUpLocationArray addObjectsFromArray:startUpLocationArray];
    [displayStartUpMarketArray addObjectsFromArray:startUpMarketArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [startUpNameArray release];
    [startUpAngelUrlArray release];
    [startUpLogoUrlArray release];
    [startUpProductDescArray release];
    [startUpHighConceptArray release];
    [startUpFollowerCountArray release];
    [startUpLocationArray release];
    [startUpMarketArray release];
    
    [displayStartUpIdsArray release];
    [displayStartUpNameArray release];
    [displayStartUpAngelUrlArray release];
    [displayStartUpLogoUrlArray release];
    [displayStartUpProductDescArray release];
    [displayStartUpHighConceptArray release];
    [displayStartUpFollowerCountArray release];
    [displayStartUpLocationArray release];
    [displayStartUpMarketArray release];
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
