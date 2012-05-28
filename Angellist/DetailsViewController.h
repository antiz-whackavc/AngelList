//
//  DetailsViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
{
    IBOutlet UIImageView *logoImage;
    IBOutlet UILabel *actorName;
    IBOutlet UITextView *logoDesc;
    
    IBOutlet UILabel *startUpName;
    IBOutlet UILabel *startUpMarket;
    IBOutlet UILabel *startUpLocation;
    IBOutlet UILabel *startUpFollowers;
}

-(IBAction)actorDetails:(id)sender;

@end
