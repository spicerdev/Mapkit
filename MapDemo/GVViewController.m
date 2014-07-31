//
//  GVViewController.m
//  MapDemo
//
//  Created by X Code User on 7/16/14.
//  Copyright (c) 2014 Joshua Spicer, Fabio Germann. All rights reserved.

//

#import "GVViewController.h"
#import "DataSource.h"

#define kMetersPerSecondToMilesPerHour 2.2369362920544
@interface GVViewController ()
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geocoder;
@end

@interface GVViewController () {
    NSMutableArray *_objects;
}
@end

@implementation GVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.geocoder = [[CLGeocoder alloc] init];
    self.mapView.delegate = self;
    
    DataSource *ds = [[DataSource alloc] init];
    (void) ds.parseConactListFromFile;
    self->_objects = [ds.companylist mutableCopy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for(NSArray *point in _objects) {
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        
        NSString *astring = point[2];
        NSArray *asplit = [astring componentsSeparatedByString:@","];
        
        
        myAnnotation.coordinate = CLLocationCoordinate2DMake([asplit[0] floatValue], [asplit[1] floatValue] );
        myAnnotation.title = point[0];
        myAnnotation.subtitle = point[1];
        [self.mapView addAnnotation:myAnnotation];
    }
    
//    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

}


#pragma mark CLLocationManagerDelegate methods

//-(void) locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
//{
//    self.speedLabel.text = @"??";
//    self.locationLabel.text = @"Location Unknown";
//}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLLocation *location = [locations lastObject];
//    NSString *speedString = [NSString stringWithFormat:@"%d", [@(location.speed * kMetersPerSecondToMilesPerHour) intValue]];
//    self.speedLabel.text = speedString;
//    
//    //    NSString *locationString = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
//    //    self.locationLabel.text = locationString;
//    
//    if(![self.geocoder isGeocoding]) {
//        [self.geocoder reverseGeocodeLocation:location
//            completionHandler:^(NSArray *placemarks, NSError *error) {
//                if(placemarks && [placemarks count] > 0 && error == nil) {
//                    CLPlacemark *placemark = [placemarks lastObject];
//                    NSString *locationString = [NSString stringWithFormat:@"%@,%@",
//                                                placemark.subLocality,
//                                                placemark.administrativeArea];
//                    self.locationLabel.text = locationString;
//                }
//            }];
//    }
    
}

#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //7
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //8
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinView)
    {
        //9
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
    }else {
        pinView.annotation = annotation;
    }
    
    // Add a disclosure button.
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    // Add a left image on callout bubble.
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"octocat.png"]];

    iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    iconView.frame = CGRectMake(0, 0, 30, 30);
    iconView.center = iconView.superview.center;
    iconView.clipsToBounds = YES;
    
    pinView.leftCalloutAccessoryView = iconView;
    return pinView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked an Annotation");
    }
    [NSString stringWithFormat:@"%@",[annotation subtitle]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Phone Contact" message:[NSString stringWithFormat:@"Phone number is: %@",[annotation subtitle]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
-(BOOL) shoudAutorotate {
    return YES;
}
-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"honeybee.png"];
            pinView.calloutOffset = CGPointMake(-10, 10);
            
            // add a button to the annotations.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
*/
//- (IBAction)toggleMap:(id)sender {
//    [self.mapView setHidden:![self.mapView isHidden]];
//}

@end
















