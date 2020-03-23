//
//  JVpnManager.m
//  JVpn
//
//  Created by jackfrow on 2020/3/23.
//  Copyright © 2020 jackfrow. All rights reserved.
//

#import "JVpnManager.h"

NSString* const JVpnTunnelBundleId = @"test.psk4h6snx9.ppx.tunnel";

@interface JVpnManager ()

@property (nonatomic, strong) NETunnelProviderManager *vpnManager;

@end

@implementation JVpnManager

+(instancetype)sharedManager{
    
    static JVpnManager* __instance__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        __instance__ = [[JVpnManager alloc] init];
        
    });
    return __instance__;
    
    
}

-(void)loadVpn{
 
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        
        if (managers.count > 0) {
            self.vpnManager = managers[0];
        }
//        NEVPNErrorDomain
        //configure
        NETunnelProviderProtocol* protocol = [[NETunnelProviderProtocol alloc] init];
        protocol.serverAddress = @"127.0.0.1";
        protocol.providerBundleIdentifier = JVpnTunnelBundleId;
        
        self.vpnManager.localizedDescription = @"Jvpn";
        self.vpnManager.protocolConfiguration = protocol;
        
        
        self.vpnManager.enabled = true;
        
        __weak typeof(self)weakSelf = self;
        
        [self.vpnManager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"saveToPreferences = %@",error.localizedDescription);
            }else{
                [weakSelf.vpnManager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    
                    if (error) {
                        NSLog(@"loadFromPreferences = %@",error.localizedDescription);
                    }else{
                        NSLog(@"loadFromPreferencesSuccess.");
                    }
                    
                }];
            }
            
        }];
        
        
    }];
    
}


#pragma mark - API
-(void)startVPN{
    
      if (self.vpnManager.connection.status == NEVPNStatusDisconnected) {
            NSError *error;
            [self.vpnManager.connection startVPNTunnelAndReturnError:&error];
            
            if (error) {
                const char *errorInfo = [NSString stringWithFormat:@"%@",error].UTF8String;
                NSLog(@"XDXVPNManager, Start VPN Failed - %s !",errorInfo);
            }else {
                NSLog(@"XDXVPNManager, Start VPN Success !");
            }
        }else {
            NSLog(@"XDXVPNManager, Start VPN - The current connect status isn't NEVPNStatusDisconnected !");
        }
}

-(void)stopVPN{
    
    if (self.vpnManager.connection.status == NEVPNStatusConnected) {
         [self.vpnManager.connection stopVPNTunnel];
         NSLog(@"XDXVPNManager, StopVPN Success - The current connect status is Connected.");
     }else  if (self.vpnManager.connection.status == NEVPNStatusConnecting) {
         [self.vpnManager.connection stopVPNTunnel];
         NSLog(@"XDXVPNManager,StopVPN Success - The current connect status is Connecting.");
     }else {
         NSLog(@"XDXVPNManager, StopVPN Failed - The current connect status isn't Connected or Connecting !");
     }
}

#pragma mark - lazy

-(NETunnelProviderManager *)vpnManager{
    if (_vpnManager == nil) {
        _vpnManager = [[NETunnelProviderManager alloc] init];
    }
    return _vpnManager;
}



@end
