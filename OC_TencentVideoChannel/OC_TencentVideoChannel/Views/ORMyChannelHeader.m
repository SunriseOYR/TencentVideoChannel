//
//  ORMyChannelHeader.m
//  OC_TencentVideoChannel
//
//  Created by OrangesAL on 2018/7/18.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import "ORMyChannelHeader.h"

@implementation ORMyChannelHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sortSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
}

- (IBAction)action_sortSwitch:(UISwitch *)sender {
    if (self.switchChanged) {
        self.switchChanged(sender.isOn);
    }
}


@end
