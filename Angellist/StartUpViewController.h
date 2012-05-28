//
//  StartUpViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartUpViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
{
     IBOutlet UITableView *table;
}

-(void) getDetailsOfFollowing;
-(void) getDetailsOfAll;

@end
