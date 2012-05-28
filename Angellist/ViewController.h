//
//  ViewController.h
//  SampleRest
//
//  Created by Ram Charan on 5/9/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface ViewController : UIViewController
{
    LoginViewController *loginView;
}

@property(nonatomic, retain)LoginViewController *loginView;

-(IBAction) loginFromAngellist:(id) sender;
-(IBAction) loginWithTwitter:(id) sender;

@end
