#import <UIKit/UIKit.h>

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(id)allApplications;
@end

@interface LSApplicationProxy : NSObject

@end

@interface PSAppDataUsagePolicyCache : NSObject
+ (id)sharedInstance;
- (id)fetchUsagePolicyFor:(id)arg1;
-(BOOL)setUsagePoliciesForBundle:(id)arg1 cellular:(BOOL)arg2 wifi:(BOOL)arg3 ;
@end

@interface PSAppDataUsagePolicy : NSObject
- (BOOL)wifiDataEnabled;
-(void)setWifiDataEnabled:(BOOL)arg1 ;
@end

@interface AppWirelessDataUsageManager : NSObject
+(id)appWirelessDataOptionForBundleIdentifier:(id)arg1 ;
+(void)setAppWirelessDataOption:(id)arg1 forBundleIdentifier:(id)arg2 completionHandler:(/*^block*/ id)arg3 ;
@end
