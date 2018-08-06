//
//  ORMyChannelHeader.h
//  OC_TencentVideoChannel
//
//  Created by OrangesAL on 2018/7/18.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORMyChannelHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *sortDescriptionL;
@property (weak, nonatomic) IBOutlet UISwitch *sortSwitch;

@property (nonatomic, copy) void(^switchChanged)(BOOL isOn);

@end
