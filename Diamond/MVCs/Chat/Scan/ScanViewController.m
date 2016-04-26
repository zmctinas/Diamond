//
//  ScanViewController.m
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ScanViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <ZXingObjC/ZXingObjC.h>
#import "UserDetailViewController.h"
#import "SearchFriendModel.h"
#import "Friend.h"

@interface ScanViewController ()<ZXCaptureDelegate>
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *backgroundViews;

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) SearchFriendModel *model;


@property (nonatomic) BOOL isJump;
@end

@implementation ScanViewController

- (void)dealloc {
    [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addLeftBarButtonItem];
    [self.view.layer addSublayer:self.capture.layer];
    [self.view bringSubviewToFront:self.scanView];
    [self.view bringSubviewToFront:self.tipsLabel];
    for (UIView *view  in self.backgroundViews)
    {
        [self.view bringSubviewToFront:view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[SCAN_AGAIN_NOTIFICATION,SEARCH_FRIEND_NOTIFICATION]];
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.capture start];
    });
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanView.frame, captureSizeTransform);
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SCAN_AGAIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEARCH_FRIEND_NOTIFICATION object:nil];

    [self.capture stop];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        [self hideHUD];
        [self performSegueWithIdentifier:[UserDetailViewController description] sender:notification.object];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.isJump = NO;
        });
        return;
    }
    if ([notification.name isEqualToString:SCAN_AGAIN_NOTIFICATION])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.isJump = NO;
            [self.capture start];
        });

    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[UserDetailViewController description]])
    {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.buddy = self.model.buddy;
        vc.detailType = [self isFriend:self.model.buddy] ? UserDetailTypeFriend : UserDetailTypeStranger;
    }
}

- (BOOL)isFriend:(Buddy *)buddy;
{
    for (Friend *f in [UserInfo info].friends) {
        if ([buddy.easemob isEqualToString:f.friends_easemob])
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark - ZXCaptureDelegate

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    
    [self.capture stop];
    if (!result)
    {
        [self showtips:@"格式不正确的二维码"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.isJump = NO;
            [self.capture start];
        });
    }
    else
    {
        if (!self.isJump)
        {
            [self showHUDWithTitle:@"扫描成功,正在搜索好友..."];
            [self.model searchBuddyWithPhone:result.text];
            
            // Vibrate
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            self.isJump = YES;
        }
    }
}

#pragma mark - Getter and setter
- (ZXCapture *)capture
{
    if (!_capture)
    {
        _capture = [[ZXCapture alloc] init];
        _capture.camera = self.capture.back;
        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        _capture.rotation = 90.0f;
        _capture.layer.frame = self.view.bounds;
    }
    return _capture;
}

- (SearchFriendModel *)model
{
    if (!_model)
    {
        _model = [SearchFriendModel new];
    }
    return _model;
}
@end
