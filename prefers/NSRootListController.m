#include "NSRootListController.h"
#include "Classes.h"
#import <CoreServices/CoreServices.h>
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>

#define SYS_VERSION [[UIDevice currentDevice] systemVersion]

@implementation NSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	//标签
	PSSpecifier *groupLabel = [PSSpecifier preferenceSpecifierNamed:@"NetSwitch" target:self set:NULL get:NULL detail:nil cell:PSGroupCell edit:nil];
	[groupLabel setProperty:@"NetSwitch" forKey:@"label"];
	[_specifiers addObject:groupLabel];

	//获取应用列表->Dic(id:displayname)
	NSMutableDictionary *appDic = [NSMutableDictionary dictionary];
	LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
	NSArray *apps = [workspace allApplications];
	for (LSApplicationProxy *appProxy in apps) {
		[appDic setObject:[appProxy performSelector:@selector(localizedName)] forKey:[appProxy performSelector:@selector(applicationIdentifier)]];
	}

	//去掉不需要的系统App等
	NSDictionary *usefullAppDic = [self trimDataSourece:[appDic copy]];

	//每个应用对应的specifier
	for (NSString *appID in usefullAppDic.allKeys) {
		PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:usefullAppDic[appID]
                              target:self
                                 set:@selector(setWifiUsageValue:forSpecifier:)
                                 get:@selector(wifiUsageValueForSpecifier:)
                              detail:nil
                                cell:PSSwitchCell
                                edit:nil];
        [specifier setProperty:appID forKey:@"appIDForLazyIcon"];
        [specifier setProperty:@YES forKey:@"useLazyIcons"];
        [_specifiers addObject:specifier];
	}

	return _specifiers;
}

- (NSDictionary *)trimDataSourece:(NSDictionary *)dataSourece {
    NSMutableDictionary *mutableDict = [dataSourece mutableCopy];
    NSArray *bannedIdentifiers = [[NSArray alloc] initWithObjects:
                                  @"com.apple.AdSheet",
                                  @"com.apple.AdSheetPhone",
                                  @"com.apple.AdSheetPad",
                                  @"com.apple.DataActivation",
                                  @"com.apple.DemoApp",
                                  @"com.apple.fieldtest",
                                  @"com.apple.iosdiagnostics",
                                  @"com.apple.iphoneos.iPodOut",
                                  @"com.apple.TrustMe",
                                  @"com.apple.WebSheet",
                                  @"com.apple.springboard",
                                  @"com.apple.purplebuddy",
                                  @"com.apple.datadetectors.DDActionsService",
                                  @"com.apple.FacebookAccountMigrationDialog",
                                  @"com.apple.iad.iAdOptOut",
                                  @"com.apple.ios.StoreKitUIService",
                                  @"com.apple.TextInput.kbd",
                                  @"com.apple.MailCompositionService",
                                  @"com.apple.mobilesms.compose",
                                  @"com.apple.quicklook.quicklookd",
                                  @"com.apple.ShoeboxUIService",
                                  @"com.apple.social.remoteui.SocialUIService",
                                  @"com.apple.WebViewService",
                                  @"com.apple.gamecenter.GameCenterUIService",
                                  @"com.apple.appleaccount.AACredentialRecoveryDialog",
                                  @"com.apple.CompassCalibrationViewService",
                                  @"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
                                  @"com.apple.PassbookUIService",
                                  @"com.apple.uikit.PrintStatus",
                                  @"com.apple.Copilot",
                                  @"com.apple.MusicUIService",
                                  @"com.apple.AccountAuthenticationDialog",
                                  @"com.apple.MobileReplayer",
                                  @"com.apple.SiriViewService",
                                  @"com.apple.TencentWeiboAccountMigrationDialog",
                                  @"com.apple.AskPermissionUI",
                                  @"com.apple.Diagnostics",
                                  @"com.apple.GameController",
                                  @"com.apple.HealthPrivacyService",
                                  @"com.apple.InCallService",
                                  @"com.apple.mobilesms.notification",
                                  @"com.apple.PhotosViewService",
                                  @"com.apple.PreBoard",
                                  @"com.apple.PrintKit.Print-Center",
                                  @"com.apple.SharedWebCredentialViewService",
                                  @"com.apple.share",
                                  @"com.apple.CoreAuthUI",
                                  @"com.apple.webapp",
                                  @"com.apple.webapp1",
                                  @"com.apple.family",
                                  @"com.apple.ScreenSharingViewService",
                                  @"com.apple.FunCamera.TextPicker",
                                  @"com.apple.SIMSetupUIService",
                                  @"com.apple.SharingViewService",
                                  @"com.apple.AuthKitUIService",
                                  @"com.apple.carkit.DNDBuddy",
                                  @"com.apple.ScreenTimeUnlock",
                                  @"com.apple.StoreDemoViewService",
                                  @"com.apple.ActivityMessageApp",
                                  @"com.apple.FunCamera.EmojiStickers",
                                  @"com.apple.AppSSOUIService",
                                  @"com.apple.icloud.spnfcurl",
                                  @"com.apple.VSViewService",
                                  @"com.apple.AXUIViewService",
                                  @"com.apple.CheckerBoard",
                                  @"com.apple.FunCamera.ShapesPicker",
                                  @"com.apple.TVAccessViewService",
                                  @"com.apple.CloudKit.ShareBear",
                                  @"com.apple.BusinessChatViewService",
                                  @"com.apple.iMessageAppsViewService",
                                  @"com.apple.ScreenshotServicesService",
                                  @"com.apple.icloud.apps.messages.business",
                                  @"com.apple.CTNotifyUIService",
                                  @"com.apple.CarPlaySplashScreen",
                                  @"com.apple.SafariViewService",
                                  @"com.apple.siri.parsec.HashtagImagesApp",
                                  @"com.apple.CTCarrierSpaceAuth",
                                  @"com.apple.DiagnosticsService",
                                  @"com.apple.social.SLYahooAuth",
                                  @"com.apple.VoiceMemos",
                                  @"com.apple.Animoji.StickersApp",
                                  @"com.apple.Spotlight",
                                  @"com.apple.ActivityMessagesApp",
                                  @"com.apple.susuiservice",
                                  nil];
    for (NSString *key in bannedIdentifiers) {
        [mutableDict removeObjectForKey:key];
    }
    return [mutableDict copy];
}

- (void)setWifiUsageValue:(id)value forSpecifier:(PSSpecifier *)specifier {
    if (SYS_VERSION.doubleValue >=12.0) {
        PSAppDataUsagePolicyCache *psAppDataUsagePolicyCache = [NSClassFromString(@"PSAppDataUsagePolicyCache") sharedInstance];
        NSString *appID = [specifier propertyForKey:@"appIDForLazyIcon"];
        PSAppDataUsagePolicy *psAppDataUsagePolicy = [psAppDataUsagePolicyCache fetchUsagePolicyFor:appID];
        if (psAppDataUsagePolicy) {
            bool switchValue = [value boolValue];
            [psAppDataUsagePolicy setWifiDataEnabled:switchValue];
            NSString *appID = [specifier propertyForKey:@"appIDForLazyIcon"];
            // bool cellularEnabled = [usagePolicy cellularDataEnabled];
            [psAppDataUsagePolicyCache setUsagePoliciesForBundle:appID cellular:(switchValue ? YES : NO) wifi:switchValue];
        }
    }else {
        /* ＜iOS12 */
        //检查是否开启蜂窝数据
        // BOOL allowed = NO;
        // NSNumber *cellularData = [NSClassFromString(@"AppWirelessDataUsageManager") appCellularDataEnabledForBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"] modificationAllowed:&allowed];
        // BOOL cellularEnabled = [cellularData isEqual:@YES];
        
        // NSLog(@"allowed:%d",allowed);
        // NSLog(@"cellularEnabled:%d",cellularEnabled);
        
        if ([value isEqual:@YES]) {
            // NSLog(@"1");
            // if (cellularEnabled) {
            //同时开启WIFI、蜂窝
            // [NSClassFromString(@"AppWirelessDataUsageManager") setAppWirelessDataOption:@3 forBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"] completionHandler:nil];
            // }else {
            //     //仅WIFI
                [NSClassFromString(@"AppWirelessDataUsageManager") setAppWirelessDataOption:@1 forBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"] completionHandler:nil];
            // }
        }else {
            // NSLog(@"2");
            // if (cellularEnabled)
            // {
            //     //仅蜂窝
            //     [NSClassFromString(@"AppWirelessDataUsageManager") setAppWirelessDataOption:@2 forBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"] completionHandler:nil];
            // }else {
            //同时关闭
            [NSClassFromString(@"AppWirelessDataUsageManager") setAppWirelessDataOption:@0 forBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"] completionHandler:nil];
            // }
        }
    }
}

- (id)wifiUsageValueForSpecifier:(PSSpecifier *)specifier {
    if (SYS_VERSION.doubleValue >=12.0) {
        PSAppDataUsagePolicyCache *psApp = [NSClassFromString(@"PSAppDataUsagePolicyCache") sharedInstance];
        NSString *appID = [specifier propertyForKey:@"appIDForLazyIcon"];
        PSAppDataUsagePolicy *usagePolicy = [psApp fetchUsagePolicyFor:appID];
        BOOL flag = !usagePolicy || (unsigned int)[usagePolicy wifiDataEnabled];
        return [NSNumber numberWithBool:flag];
    }else {
        NSNumber *wirelessOption = [NSClassFromString(@"AppWirelessDataUsageManager") appWirelessDataOptionForBundleIdentifier:[specifier propertyForKey:@"appIDForLazyIcon"]];
        if ([wirelessOption isEqual:@3] || [wirelessOption isEqual:@1]) {
            return @YES;
        }else {
            return @NO;
        }
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"NetSwitch";
}

@end
