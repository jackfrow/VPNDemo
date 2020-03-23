//
//  JVpnManager.h
//  JVpn
//
//  Created by jackfrow on 2020/3/23.
//  Copyright © 2020 jackfrow. All rights reserved.
//

#import <Foundation/Foundation.h>
@import NetworkExtension;

NS_ASSUME_NONNULL_BEGIN

@interface JVpnManager : NSObject

+(instancetype)sharedManager;

@property (nonatomic, strong,readonly) NETunnelProviderManager *vpnManager;

-(void)loadVpn;


-(void)startVPN;

-(void)stopVPN;

@end

NS_ASSUME_NONNULL_END
