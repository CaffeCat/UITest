//
//  LocationManager.m
//  iCamSee
//
//  Created by caffe on 2019/8/15.
//  Copyright © 2019 Macrovideo. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "XYSAlertController.h"

static LocationManager *_shareInstance = nil;

@interface LocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation LocationManager

// MARK: - 外部使用的APIs
+ (void) startLocationService{
    [[LocationManager shareInstance] requestLocation];
}

// MARK: - 内部使用的APIs
+ (instancetype) shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[LocationManager alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void) requestLocation{
    
    /* 检测系统是否已经开启定位权限 */
    if ([CLLocationManager locationServicesEnabled]) {

        self.manager.distanceFilter = 1000.0f;                              //距离过滤
        self.manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;  //设置精度,最低精度,节省资源
        self.manager.delegate = self;                                       //设置代理
        
        [self.manager requestWhenInUseAuthorization];                       //申请定位权限: 使用期间需要使用
        [self.manager startUpdatingLocation];                               //开始定位
    }else{
        
        [self showAuthorizationOrPrivacyTips:@"[CAFFE]系统定位尚未打开，请到【设置-隐私-定位服务】中手动打开"];  //提示隐私设置
    }
}

- (void) showAuthorizationOrPrivacyTips:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        XYSAlertController *alertController = [[XYSAlertController alloc] init];
        [alertController showAlertWithType:XYSAlertControllerTypeOneAction title:@"[CAFFE]好的" message:message handel:^{}];
    });
}

// MARK: - CLLocationManagerDelegate 代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    // 检查定位权限问题
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:   //没有有申请过授权
        case kCLAuthorizationStatusRestricted:      //被用户禁止
            [self.manager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:                              //此时使用主动获取方法也不能申请定位权限
            if ([CLLocationManager locationServicesEnabled] == NO) {    //判断是否开启定位服务
                [self showAuthorizationOrPrivacyTips:@"[CAFFE]系统定位尚未打开，请到【设置-隐私-定位服务】中手动打开"];
            }else {
                [self showAuthorizationOrPrivacyTips:@"[CAFFE]定位权限未打开, 请到【设置-V380 Pro】中手动打开"];
            }
            break;
        
        case kCLAuthorizationStatusAuthorizedAlways:    //前后台权限
        case kCLAuthorizationStatusAuthorizedWhenInUse: //前台权限
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 实现位置更新方法
    // locations是一个数组提供了一连串的用户定位，所以在这里我们只取最后一个（当前最后的定位）
    CLLocation * newLocation = [locations lastObject];
    // 判空处理
    if (newLocation.horizontalAccuracy < 0) {
        XYSAlertController *alertController = [[XYSAlertController alloc] init];
        [alertController showAlertWithType:XYSAlertControllerTypeOneAction title:@"[CAFFE] 提示" message:@"[CAFFE] 定位错误，请检查手机网络以及定位" handel:^{
            // nothing needs to do
        }];
        return;
    }
    
    // 获取定位经纬度
    CLLocationCoordinate2D coor2D = newLocation.coordinate;
    NSLog(@"纬度为:%f, 经度为:%f", coor2D.latitude, coor2D.longitude);
    
    // 获取定位海拔高度
    CLLocationDistance altitude = newLocation.altitude;
    NSLog(@"高度为:%f", altitude);
    
    // 获取定位水平精确度, 垂直精确度
    CLLocationAccuracy horizontalAcc = newLocation.horizontalAccuracy;
    CLLocationAccuracy verticalAcc = newLocation.verticalAccuracy;
    NSLog(@"%f, %f", horizontalAcc, verticalAcc);
    
    // 停止更新位置
    //[self.manager stopUpdatingLocation];
}
@end
