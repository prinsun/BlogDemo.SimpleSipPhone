//
//  IncomingCallViewController.m
//  SimpleSipPhone
//
//  Created by MK on 15/5/23.
//  Copyright (c) 2015年 Makee. All rights reserved.
//

#import <pjsua-lib/pjsua.h>
#import "IncomingCallViewController.h"

@interface IncomingCallViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation IncomingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.phoneNumberLabel.text = self.phoneNumber;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCallStatusChanged:)
                                                 name:@"SIPCallStatusChangedNotification"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleCallStatusChanged:(NSNotification *)notification {
    pjsua_call_id call_id = [notification.userInfo[@"call_id"] intValue];
    pjsip_inv_state state = [notification.userInfo[@"state"] intValue];
    
    if(call_id != self.callId) return;
    
    if (state == PJSIP_INV_STATE_DISCONNECTED) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if(state == PJSIP_INV_STATE_CONNECTING){
        NSLog(@"连接中...");
    } else if(state == PJSIP_INV_STATE_CONFIRMED) {
        NSLog(@"接听成功！");
    }
}

- (IBAction)answerButtonTouched:(id)sender {
    pjsua_call_answer((pjsua_call_id)self.callId, 200, NULL, NULL);
}

- (IBAction)hangupButtonTouched:(id)sender {
    pjsua_call_hangup((pjsua_call_id)self.callId, 0, NULL, NULL);
}

@end
