//
//  WebViewController.m
//  SampleRest
//
//  Created by Ram Charan on 5/9/12.
//  Copyright (c) 2012 Antiz Technologies Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewController

NSString *baseString;
NSString *queryString;
NSString *access_token;
BOOL access_token_received = FALSE;

extern BOOL loginFromAL;
extern BOOL loginWithTW;
extern BOOL _loggedIn;

NSString *_angelUserId;
NSString *_angelUserName;

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
    [super viewDidLoad];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    
    [loading.layer setCornerRadius:18.0f];
    
    
    if(loginFromAL)
    {
        NSURL *url = [NSURL URLWithString:@"https://angel.co/api/oauth/authorize?client_id=f91c04a55243218eb588f329ae8bbbb9&response_type=code"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    else if(loginWithTW)
    {
        NSURL *url = [NSURL URLWithString:@"http://angel.co/auth/twitter/with_callback?callback=%2Fsessions%2Fcontinue_after_social_login%3Fprovider%3Dtwitter&sr=login"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;   
}


- (void)webViewDidStartLoad:(UIWebView *)webViewC
{
    loading.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewC
{
    [webView stopLoading];
    loading.hidden = YES;
    if(loginFromAL)
    {
        NSURLRequest *currentrequest = [webViewC request];
        NSURL *currentURL = [currentrequest URL];
        NSString *strFromURL = currentURL.absoluteString;
        
        baseString = [[strFromURL componentsSeparatedByString:@"="] objectAtIndex:0];
        
        if([baseString isEqualToString:@"http://antiztech.com/angellist/?code"])
        {
            queryString = [[strFromURL componentsSeparatedByString:@"="] objectAtIndex:1];
            NSString *urlString = [NSString stringWithFormat:@"https://angel.co/api/oauth/token?client_id=f91c04a55243218eb588f329ae8bbbb9&client_secret=80b56220b6fb722bcb8c85aa6f4996f3&code=%@&grant_type=authorization_code",queryString];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [webView loadRequest:request];
            
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:response
                                  options:kNilOptions 
                                  error:&error];
            
            access_token = [json objectForKey:@"access_token"];
            
            access_token_received = TRUE;
        }
        
        if(access_token_received)
        {
            NSString *urlString = [NSString stringWithFormat:@"https://api.angel.co/1/me?access_token=%@",access_token];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request]; 
            
            
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:response
                                  options:kNilOptions 
                                  error:&error];
            
            _angelUserId = [json objectForKey:@"id"];
            _angelUserName = [json objectForKey:@"name"];
            
            access_token_received = FALSE;
            _loggedIn = TRUE;
            [self closeAction];
        }
    }
    
    if(loginWithTW)
    {
        
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

-(IBAction)dismissView:(id)sender
{
    [self closeAction];
}

-(void) closeAction
{
    loginFromAL = FALSE;
    loginWithTW = FALSE;
    [webView stopLoading];
    [self dismissModalViewControllerAnimated:YES];
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
