//
//  ViewController.m
//  JVpn
//
//  Created by jackfrow on 2020/3/23.
//  Copyright © 2020 jackfrow. All rights reserved.
//

#import "ViewController.h"
#import "JVpnManager.h"
@import NetworkExtension;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connetBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[JVpnManager sharedManager] loadVpn];
    [self configVpn];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpnStatusChange:) name:NEVPNStatusDidChangeNotification object:nil];
    
}


- (IBAction)connetVpn:(UIButton*)sender {
    
    
    if ([sender.currentTitle isEqualToString:@"Connect"]) {
        

        [[JVpnManager sharedManager] startVPN];
        
        }else {
            
        [[JVpnManager sharedManager] stopVPN];
          
        }
    
}


-(void)vpnStatusChange:(NSNotification*)notif{
    
   
    [self configVpn];
}

-(void)configVpn{
     NEVPNStatus status = [JVpnManager sharedManager].vpnManager.connection.status;
    switch (status) {
        case NEVPNStatusConnecting:
        {
            NSLog(@"Connecting...");
            [self.connetBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
        }
            break;
        case NEVPNStatusConnected:
        {
            NSLog(@"Connected...");
            [self.connetBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
            
        }
            break;
        case NEVPNStatusDisconnecting:
        {
            NSLog(@"Disconnecting...");
            
        }
            break;
        case NEVPNStatusDisconnected:
        {
            NSLog(@"Disconnected...");
            [self.connetBtn setTitle:@"Connect" forState:UIControlStateNormal];
            
        }
            break;
        case NEVPNStatusInvalid:
            
            NSLog(@"Invliad");
            break;
        case NEVPNStatusReasserting:
            NSLog(@"Reasserting...");
            break;
    }
}

@end
