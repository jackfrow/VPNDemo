//
//  PacketTunnelProvider.m
//  JVpnTunnel
//
//  Created by jackfrow on 2020/3/23.
//Copyright © 2020 jackfrow. All rights reserved.
//

#import "PacketTunnelProvider.h"

@interface PacketTunnelProvider ()
@property (strong) void (^pendingStartCompletion)(NSError *);
@property (strong) void (^pendingStopCompletion)(void);
@end

@implementation PacketTunnelProvider

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler
{
    self.pendingStartCompletion = completionHandler;
    [self setupPacketTunnelNetwork];
    
    
}

-(void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler{
    
    if (completionHandler) {
        completionHandler();
    }
    
}

-(void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData * _Nullable))completionHandler{
    
    NSLog(@"messageData = %@",messageData);
    if (completionHandler) {
        completionHandler(messageData);
    }
    
}

-(void)sleepWithCompletionHandler:(void (^)(void))completionHandler{
    completionHandler();
}

-(void)wake{
     NSLog(@"waking jvpn tunnel...");
}

-(void)setupPacketTunnelNetwork{
    
    NEPacketTunnelNetworkSettings* setting = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"35.1.1.1"];
    
    setting.IPv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"10.8.0.2"] subnetMasks:@[@"255.255.255.0"]];
    setting.IPv4Settings.includedRoutes = @[[NEIPv4Route defaultRoute]];
    setting.MTU = [NSNumber numberWithInt:1400];

    setting.DNSSettings = [[NEDNSSettings alloc] initWithServers:@[@"8.8.8.8",@"8.4.4.4"]];
    
    __weak typeof(self)weakSelf = self;
    [self setTunnelNetworkSettings:setting completionHandler:^(NSError * _Nullable error) {
        
        if (error) {
              NSLog(@"setTunnelNetworkSettings = %@",error);
            
            if (weakSelf.pendingStartCompletion) {
                weakSelf.pendingStartCompletion(error);
            }
            
        }else{
            NSLog(@"setTunnelNetworkSettings success");
            if (weakSelf.pendingStartCompletion) {
                weakSelf.pendingStartCompletion(nil);
            }
        }
      
        
    }];
    
}


@end
