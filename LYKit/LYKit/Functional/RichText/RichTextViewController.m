//
//  RichTextViewController.m
//
//  Created by zhouluyao on 5/21/21.
//

#import "RichTextViewController.h"
#import <YYText/YYText.h>
#import <YYModel/YYModel.h>
#import "BrowserImageViewController.h"
#import <Masonry/Masonry.h>
#import "UIView+Frame.h"
#import "OTKMarkUpParseManager.h"
#import "ZGAppInfoUtil.h"
#import "NSString+OTKRegular.h"

@interface RichTextViewController ()

@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableAttributedString *text;
@property (nonatomic, assign) CGFloat labelWidht;
@property (nonatomic, strong) UIFont *labelFont;

@end

@implementation RichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent= NO;
    self.title = @"图文混排";
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.text = [NSMutableAttributedString new];
    self.labelFont = [UIFont systemFontOfSize:15];
    CGFloat labelWidth = [ZGAppInfoUtil screenWidth] - 40;
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"html" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString * htmlString = dict[@"title"];
    NSString * onlyImgTagStr = [htmlString otk_deleteHtmlTagExceptImg];
    NSString * str  = [onlyImgTagStr otk_parseHtmlMarkupToStr];
    
    
    [OTKMarkUpParseManager parseHTMLString:str labelWidth:([ZGAppInfoUtil screenWidth] - 40) font:self.labelFont parseSuccess:^(NSMutableAttributedString * _Nonnull attributedString) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //1、设置属性字符串
            attributedString.yy_paragraphSpacing = 5;
            attributedString.yy_lineSpacing = 5;
            attributedString.yy_font = self.labelFont;
            
            //2、设置label的高度
            CGFloat labelHeight = [OTKMarkUpParseManager heightForYYLabelWithAttributedString:attributedString labelWidth:labelWidth];
            [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(labelHeight));
            }];
            
            //3、设置label
            CGSize introSize = CGSizeMake(labelWidth, CGFLOAT_MAX);
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:attributedString];
            self.label.textLayout = layout;
        });
        
    } parseFailure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@(100));
    }];
}

#pragma mark -event
- (void)broswerImageViewWithImages:(NSArray *)images currentImageIndex:(NSUInteger)imagesIndex {
    BrowserImageViewController *browserImageViewController = [[BrowserImageViewController alloc] initWithImages:images currentIndex:imagesIndex];
    [self.navigationController pushViewController:browserImageViewController animated:NO];
}

#pragma mark -getter
-(YYLabel *)label {
    if (!_label) {
        _label = [YYLabel new];
        _label.userInteractionEnabled = YES;
        _label.numberOfLines = 0;
        _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
        
        __weak typeof(self) weakSelf = self;
        _label.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            if (range.location == NSNotFound) {
                NSLog(@"点击了空白处！！！");
                return;
            }
            
            [text enumerateAttribute:YYTextAttachmentAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(YYTextAttachment *attachment, NSRange range, BOOL *stop) {
                
                // get image
                UIImage *image = nil;
                if ([attachment.content isKindOfClass:[UIImage class]]) {
                    image = attachment.content;
                } else if ([attachment.content isKindOfClass:[UIImageView class]]) {
                    image = ((UIImageView *)attachment.content).image;
                }
                
                if (image) {//点击了图片
                    [weakSelf broswerImageViewWithImages:@[image] currentImageIndex:0];
                } else {//点击了其他区域
                    NSLog(@"点击了文字！！！");
                }
            }];
        };
    }
    return _label;
}
@end
