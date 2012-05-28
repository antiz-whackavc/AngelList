//
//  LoginViewController.h
//  Angellist
//
//  Created by Ram Charan on 5/25/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIView *loading;
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *ac;
}

-(IBAction)dismissView:(id)sender;

-(void) closeAction;

@end
