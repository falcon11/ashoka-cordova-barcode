//
//  ASCDVBarCodeViewController.h
//  Tutorial
//
//  Created by Ashoka on 2019/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCDVBarCodeViewController : UIViewController

@property (nonatomic, copy) void (^callback)(NSError *error, NSArray *results);

@end

NS_ASSUME_NONNULL_END
