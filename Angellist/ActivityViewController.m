//
//  FirstViewController.m
//  SampleTabbar
//
//  Created by Ram Charan on 5/16/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ActivityViewController.h"
#import "DetailsViewController.h"
#import "AsyncImageView.h"

@implementation ActivityViewController

NSMutableArray *feedDescArray;
NSMutableArray *feedDescDisplayArray;
NSMutableArray *feedImageArray;

NSMutableArray *actorNameArray;
NSMutableArray *actorUrlArray;
NSMutableArray *actorTaglineArray;

NSMutableArray *completeActorNameArray;
NSMutableArray *completeActorUrlArray;
NSMutableArray *completeActorTaglineArray;

NSMutableArray *completeFeedDescDisplayArray;
NSMutableArray *completeFeedImageArray;

NSMutableArray *filterDescArray;
NSMutableArray *filterImageArray;

NSMutableArray *filterNameArray;
NSMutableArray *filterUrlArray;
NSMutableArray *filterTaglineArray;

NSArray *_filterNames;

int _rowNumberInActivity = 0;

BOOL _showFilterMenu = FALSE;

extern BOOL _transitFromActivity;
extern BOOL _transitFromStartUps;

extern NSString *_angelUserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Recent Activity";
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
    NSString *cellValue = [feedDescDisplayArray objectAtIndex:indexPath.row]; 
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(80, 7, 240, 75)] autorelease];
        cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellTextLabel.numberOfLines = 50;
        cellTextLabel.text = cellValue;
        cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cell.contentView addSubview:cellTextLabel];
        
        cell.imageView.frame = CGRectMake(7, 7, 70, 70);
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [feedImageArray objectAtIndex:indexPath.row];
        [asyncImage loadImageFromURL:url];
        [cell.contentView addSubview:asyncImage];
    }
    else
    {
        UILabel *cellTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(((768*80)/320), ((1024*7)/480), ((768*240)/320), ((1024*75)/480))] autorelease];
        cellTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cellTextLabel.numberOfLines = 50;
        cellTextLabel.text = cellValue;
        cellTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        [cell.contentView addSubview:cellTextLabel];
        
        cell.imageView.frame = CGRectMake(((768*7)/320), ((1024*7)/480), ((768*70)/320), ((1024*70)/480));
        AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        asyncImage.tag = 999;
        NSURL* url = [feedImageArray objectAtIndex:indexPath.row];
        [asyncImage loadImageFromURL:url];
        [cell.contentView addSubview:asyncImage];
    }
    
    return cell; 
}

//---set the number of rows in the table view---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [feedDescDisplayArray count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _rowNumberInActivity = indexPath.row;
    _transitFromActivity = TRUE;
    _transitFromStartUps = FALSE;
    
    [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setEnabled:false]; 
    
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
    [[[[[self tabBarController] viewControllers] objectAtIndex:1] tabBarItem] setEnabled:true];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 45);
    }
    else
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, 768, 45);
    }
    
    [boundsView.layer setCornerRadius:8.0f];
    
    _filterNames = [[NSArray arrayWithObjects:@"Followed", @"Invested", @"New Status", @"Took Intro", @"All", nil] retain];
    
    //Add background image to navigation title bar
    UIImage *backgroundImage = [UIImage imageNamed:@"navigationbar.png"];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.title = @"Activity";
    
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
    
    
    
    feedDescArray = [[NSMutableArray alloc] init];
    feedDescDisplayArray = [[NSMutableArray alloc] init];
    feedImageArray = [[NSMutableArray alloc] init];
    
    completeActorNameArray = [[NSMutableArray alloc] init];
    completeActorUrlArray = [[NSMutableArray alloc] init];
    completeActorTaglineArray = [[NSMutableArray alloc] init];
    
    actorNameArray = [[NSMutableArray alloc] init];
    actorUrlArray = [[NSMutableArray alloc] init];
    actorTaglineArray = [[NSMutableArray alloc] init];
    
    completeFeedDescDisplayArray = [[NSMutableArray alloc] init];
    completeFeedImageArray = [[NSMutableArray alloc] init];
    
    filterDescArray = [[NSMutableArray alloc] init];
    filterImageArray = [[NSMutableArray alloc] init];
    
    filterNameArray = [[NSMutableArray alloc] init];
    filterUrlArray = [[NSMutableArray alloc] init];
    filterTaglineArray = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.angel.co/1/feed"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"GET"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:response //1
                          options:kNilOptions 
                          error:&error];
    NSArray* feeds = [json objectForKey:@"feed"]; //2
    
    for(int i=0; i<[feeds count]; i++)
    {
        NSDictionary *feedDict = [feeds objectAtIndex:i];
        NSString *description = [feedDict objectForKey:@"description"];
        [feedDescArray addObject:description];
        
        NSString *feedImages = [[feedDict objectForKey:@"actor"] valueForKey:@"image"];
        [feedImageArray addObject:feedImages];
        [completeFeedImageArray addObject:feedImages];
        
        NSString *actorNames = [[feedDict objectForKey:@"actor"] valueForKey:@"name"];
        if(actorNames == (NSString *)[NSNull null])
        {
            [actorNameArray addObject:@"Name not found!"];
            [completeActorNameArray addObject:@"Name not found!"];
        }
        else
        {
            [actorNameArray addObject:actorNames];
            [completeActorNameArray addObject:actorNames];
        }
        
        
        NSString *actorUrl = [[feedDict objectForKey:@"actor"] valueForKey:@"angellist_url"];
        [actorUrlArray addObject:actorUrl];
        [completeActorUrlArray addObject:actorUrl];
        
        NSString *actorTagline = [[feedDict objectForKey:@"actor"] valueForKey:@"tagline"];
        if(actorTagline == (NSString *)[NSNull null])
        {
            [actorTaglineArray addObject:@"Information not available !"];
            [completeActorTaglineArray addObject:@"Information not available !"];
        }
        else
        {
            [actorTaglineArray addObject:actorTagline];
            [completeActorTaglineArray addObject:actorTagline];
        }
    }
    
    
    for(int z=0; z<[feedDescArray count]; z++)
    {
        NSString *desc = [feedDescArray objectAtIndex:z]; 
        NSArray *str = [desc componentsSeparatedByString:@">"];
        
        int k=0;
        NSString *concatStr = @"";
        for(int j=0; j<[str count]; j++)
        {
            if(k%2 == 1)
            {
                NSString *strName1 = [str objectAtIndex:j];
                NSArray *str1 = [strName1 componentsSeparatedByString:@"</a"];
                concatStr = [concatStr stringByAppendingFormat:@"%@",[str1 objectAtIndex:0]];
                k++;
            }
            else
            {
                NSString *strName2 = [str objectAtIndex:j];
                NSArray *str2 = [strName2 componentsSeparatedByString:@"<"];
                concatStr = [concatStr stringByAppendingFormat:@"%@",[str2 objectAtIndex:0]];
                k++;
            }
        }
        [feedDescDisplayArray addObject:concatStr];
        [completeFeedDescDisplayArray addObject:concatStr];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)filterButtonSelected:(id)sender {
    // whatever needs to happen when button is tapped
    UIView *filtersList;
    
    if(_showFilterMenu == FALSE)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 150, 145)];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = 5;
            
            for (int i=1; i<=5; i++) 
            {
                UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [filterButton setBackgroundImage:image forState:UIControlStateNormal];
                [filterButton setTitle:[NSString stringWithFormat:@"%@",[_filterNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [filterButton addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                filterButton.frame = CGRectMake(14, _yPos, 120, 25);
                filterButton.tag = i;
                [filtersList addSubview:filterButton];
                
                _yPos = _yPos + 27;
            }
            
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenu = TRUE;
        }
        else
        {
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
            [filterView  setBackgroundColor: [UIColor blackColor]];
            [filterView setAlpha:0.6f];
            filterView.tag = 1000;
            [self.view addSubview:filterView];
            
            filtersList = [[UIView alloc] initWithFrame:CGRectMake(((768*165)/320), 0, ((768*150)/320), ((1024*145)/480))];
            [filtersList  setBackgroundColor: [UIColor blackColor]];
            [filtersList.layer setCornerRadius:18.0f];
            [filtersList setAlpha:1.0f];
            filtersList.tag = 1001;
            [self.view addSubview:filtersList];
            
            UIImage* image = [UIImage imageNamed:@"navigationbar.png"];
            
            int _yPos = ((1024*5)/480);
            
            for (int i=1; i<=5; i++) 
            {
                UIButton *following = [UIButton buttonWithType:UIButtonTypeCustom];
                [following setBackgroundImage:image forState:UIControlStateNormal];
                [following setTitle:[NSString stringWithFormat:@"%@",[_filterNames objectAtIndex:(i-1)]] forState:UIControlStateNormal];
                [following setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [following addTarget:self action:@selector(getFilteredList:) forControlEvents:UIControlStateHighlighted];
                following.frame = CGRectMake(((768*14)/320), _yPos, ((768*120)/320), ((1024*25)/480));
                following.tag = i;
                [filtersList addSubview:following];
                
                _yPos = _yPos + ((1024*27)/480);
            }
            
            
            [filtersList release];
            [filterView release];
            
            _showFilterMenu = TRUE;
        }
        
        
    }
    else
    {
        [[self.view viewWithTag:1000] removeFromSuperview];
        [[self.view viewWithTag:1001] removeFromSuperview];
        _showFilterMenu = FALSE;
    }
    
}

-(void)getFilteredList:(id)sender
{
    [filterDescArray removeAllObjects];
    [filterImageArray removeAllObjects];
    [filterNameArray removeAllObjects];
    [filterUrlArray removeAllObjects];
    [filterTaglineArray removeAllObjects];
    
    [feedDescDisplayArray removeAllObjects];
    [feedDescDisplayArray addObjectsFromArray:completeFeedDescDisplayArray];
    [feedImageArray removeAllObjects];
    [feedImageArray addObjectsFromArray:completeFeedImageArray];
    
    [actorNameArray removeAllObjects];
    [actorNameArray addObjectsFromArray:completeActorNameArray];
    [actorUrlArray removeAllObjects];
    [actorUrlArray addObjectsFromArray:completeActorUrlArray];
    [actorTaglineArray removeAllObjects];
    [actorTaglineArray addObjectsFromArray:completeActorTaglineArray];
    
    int _tagID = [sender tag];
    
    switch(_tagID)
    {
            //Implement Following
        case 1 : for(int k=0; k<[feedDescDisplayArray count];k++)
        {
            NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
            if([checkStr rangeOfString:@"followed"].location != NSNotFound)
            {
                [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
            }
        }
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterDescArray];
            [feedImageArray removeAllObjects];
            [feedImageArray addObjectsFromArray:filterImageArray];
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterNameArray];
            [actorUrlArray removeAllObjects];
            [actorUrlArray addObjectsFromArray:filterUrlArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            _showFilterMenu = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            [table reloadData];
            
            
            break;
            
            //Implement Invested    
        case 2 : for(int k=0; k<[feedDescDisplayArray count];k++)
        {
            NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
            if([checkStr rangeOfString:@"invested"].location != NSNotFound)
            {
                [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
            }
        } 
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterDescArray];
            [feedImageArray removeAllObjects];
            [feedImageArray addObjectsFromArray:filterImageArray];
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterNameArray];
            [actorUrlArray removeAllObjects];
            [actorUrlArray addObjectsFromArray:filterUrlArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [table reloadData];
            
            _showFilterMenu = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            break;
            
            //Implement Updated    
        case 3 : for(int k=0; k<[feedDescDisplayArray count];k++)
        {
            NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
            if([checkStr rangeOfString:@"updated"].location != NSNotFound)
            {
                [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
            }
        } 
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterDescArray];
            [feedImageArray removeAllObjects];
            [feedImageArray addObjectsFromArray:filterImageArray];
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterNameArray];
            [actorUrlArray removeAllObjects];
            [actorUrlArray addObjectsFromArray:filterUrlArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [table reloadData]; 
            
            _showFilterMenu = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview]; 
            break;
            
            //Implement Took Intro    
        case 4 : for(int k=0; k<[feedDescDisplayArray count];k++)
        {
            NSString *checkStr = [feedDescDisplayArray objectAtIndex:k];
            if([checkStr rangeOfString:@"took intro"].location != NSNotFound)
            {
                [filterDescArray addObject:[feedDescDisplayArray objectAtIndex:k]];
                [filterImageArray addObject:[feedImageArray objectAtIndex:k]];
                [filterNameArray addObject:[actorNameArray objectAtIndex:k]];
                [filterUrlArray addObject:[actorUrlArray objectAtIndex:k]];
                [filterTaglineArray addObject:[actorTaglineArray objectAtIndex:k]];
            }
        } 
            [feedDescDisplayArray removeAllObjects];
            [feedDescDisplayArray addObjectsFromArray:filterDescArray];
            [feedImageArray removeAllObjects];
            [feedImageArray addObjectsFromArray:filterImageArray]; 
            
            [actorNameArray removeAllObjects];
            [actorNameArray addObjectsFromArray:filterNameArray];
            [actorUrlArray removeAllObjects];
            [actorUrlArray addObjectsFromArray:filterUrlArray];
            [actorTaglineArray removeAllObjects];
            [actorTaglineArray addObjectsFromArray:filterTaglineArray];
            
            [table reloadData];
            
            _showFilterMenu = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            break; 
            
            //Implement All    
        case 5 : [table reloadData];
            
            _showFilterMenu = FALSE;
            [[self.view viewWithTag:1000] removeFromSuperview];
            [[self.view viewWithTag:1001] removeFromSuperview];
            break;    
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) dealloc
{
    [feedDescArray release];
    [feedDescDisplayArray release];
    [feedImageArray release];
    
    [completeActorNameArray release];
    [completeActorUrlArray release];
    [completeActorTaglineArray release];
    
    [actorNameArray release];
    [actorUrlArray release];
    [actorTaglineArray release];
    
    [completeFeedDescDisplayArray release];
    [completeFeedImageArray release];
    
    [filterDescArray release];
    [filterImageArray release];
    
    [filterNameArray release];
    [filterUrlArray release];
    [filterTaglineArray release];
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
