

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
@protocol LocationViewDelegate <NSObject>

-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
@end

@interface LocationViewController : BaseViewController

@property (nonatomic, assign) id<LocationViewDelegate> delegate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end
