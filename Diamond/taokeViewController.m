
//
//  taokeViewController.m
//  Diamond
//
//  Created by daimangkeji on 16/4/27.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "taokeViewController.h"

@interface taokeViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation taokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self addLeftBarButtonItem];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if (navigationType == UIWebViewNavigationTypeBackForward) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    switch (navigationType) {
        case UIWebViewNavigationTypeBackForward:
            NSLog(@"clickbackforward");
            break;
        case UIWebViewNavigationTypeOther:
            NSLog(@"clickother");
            break;
            
        default:
            break;
    }
    return YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    
//    self.currentURL = webView.request.URL.absoluteString;
//    NSLog(@"title-%@--url-%@--",self.title,self.currentURL);
    
    NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    NSString* str = [webView stringByEvaluatingJavaScriptFromString:lJs];
    NSLog(@"%@",str);
    
}

@end
