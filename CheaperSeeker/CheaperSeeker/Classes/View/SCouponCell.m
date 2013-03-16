//
//  SCouponCell.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-8-30.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "SCouponCell.h"
#import "SCouponTypeView.h"
#import "SCouponCardView.h"
#import "SCouponsTableView.h"

@interface SCouponCell()
@property (nonatomic, readonly) NSString *couponURLPath;
@property (nonatomic, assign) UIImageView *couponCover;
@property (nonatomic, assign) UILabel *couponTitle;
@property (nonatomic, assign) UILabel *couponContent;
@property (nonatomic, assign) UILabel *couponExpire;
@property (nonatomic, assign) SCouponTypeView *couponType;
@property (nonatomic, assign) SCouponCanDoView *canDo;
@property (nonatomic, assign) SCouponCanDoView *canntDo;
@property (nonatomic, assign) SCouponCanDoView *comment;
@property (nonatomic, assign) SCouponCardView *cardView;
@property (nonatomic, assign) UIView *actionsToolBar;

@property (nonatomic, retain) SCouponLayout *couponLayout;
@property (nonatomic, retain) SCouponStyle *couponStyle;
- (void)reStyleWith:(SCouponStyle *)style;
- (void)reLayoutWith:(SCouponLayout *)layout;
- (void)reContent;

- (void)showActionBar;
- (void)hideActionBar;
@end

@implementation SCouponCell
@synthesize coupon, couponLayout, couponStyle;
@synthesize couponURLPath;
@synthesize couponCover, couponContent, couponExpire, couponTitle, couponType, canDo, canntDo, comment, cardView;
@synthesize customBackgroundView, customSelectedBackgroundView;
@synthesize couponsTableView;
@synthesize actionsToolBar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [SUtil setCustomCellBGView:self];
        
        UIColor *_bgcolor = [UIColor clearColor];
        
        SCouponCardView *_cardv = [[SCouponCardView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_cardv];
        self.cardView = _cardv;
        [_cardv release];
        
        UIImageView *_imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgv.backgroundColor = _bgcolor;
        _imgv.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgv];
        self.couponCover = _imgv;
        [_imgv release];
        
        UILabel *_ttl = [[UILabel alloc] initWithFrame:CGRectZero];
        _ttl.backgroundColor = _bgcolor;
        _ttl.numberOfLines = 20;
        [self.contentView addSubview:_ttl];
        self.couponTitle = _ttl;
        [_ttl release];
        
        UILabel *_cnt = [[UILabel alloc] initWithFrame:CGRectZero];
        _cnt.backgroundColor = _bgcolor;
        _cnt.numberOfLines = 20;
        [self.contentView addSubview:_cnt];
        self.couponContent = _cnt;
        [_cnt release];
        
        UILabel *_exp = [[UILabel alloc] initWithFrame:CGRectZero];
        _exp.backgroundColor = _bgcolor;
        _exp.numberOfLines = 20;
        [self.contentView addSubview:_exp];
        self.couponExpire = _exp;
        [_exp release];
        
        SCouponTypeView *_tpv = [[SCouponTypeView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tpv];
        self.couponType = _tpv;
        [_tpv release];
        
        SCouponCanDoView *_cdv = [[SCouponCanDoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_cdv];
        self.canDo = _cdv;
        [_cdv release];
        
        SCouponCanDoView *_cndv = [[SCouponCanDoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_cndv];
        self.canntDo = _cndv;
        [_cndv release];
        
        SCouponCanDoView *_cmt = [[SCouponCanDoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_cmt];
        self.comment = _cmt;
        [_cmt release];
        
        UIView *_tool = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.bounds.size.height-k_coupon_cell_tool_bar_height, self.contentView.bounds.size.width, k_coupon_cell_tool_bar_height)];
        _tool.backgroundColor = SRGBCOLOR(62, 87, 129);
        _tool.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_tool];
        self.actionsToolBar = _tool;
        [_tool release];
    }
    return self;
}
- (void)dealloc {
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
    self.coupon = nil;
    self.couponLayout = nil;
    self.couponStyle = nil;
    [super dealloc];
}
- (TCustomCellBGView *)customBackgroundView {
    return [self.backgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.backgroundView : nil;
}
- (TCustomCellBGView *)customSelectedBackgroundView {
    return [self.selectedBackgroundView isKindOfClass:[TCustomCellBGView class]] ? (TCustomCellBGView *)self.selectedBackgroundView : nil;
}
+ (CGFloat)cellHeight {
    return 44.0;
}
- (NSString *)couponURLPath {
    NSString *resutl = nil;
    resutl = [self.coupon objectForKey:k_coupon_image];
    if ([Util isEmptyString:resutl]) {
        resutl = [[self.coupon objectForKey:k_coupon_merchant] objectForKey:k_merchant_banner_image];
    }
    return resutl;
}
- (void)refreshWithCoupon:(id)cpn Layout:(SCouponLayout *)layout Style:(SCouponStyle *)style {
    self.coupon = cpn;
    self.couponLayout = layout;
    self.couponStyle = style;
    
    [self hideActionBar];
    
    [self reStyleWith:style];
    [self reLayoutWith:layout];
    [self reContent];
}
- (void)reLayoutWith:(SCouponLayout *)layout {
    self.couponCover.frame = layout.icon;
    self.couponTitle.frame = layout.title;
    self.couponContent.frame = layout.content;
    self.couponExpire.frame = layout.expire;
    self.couponType.frame = layout.type;
    self.canDo.frame = layout.can_do.view;
    self.canntDo.frame = layout.cannt_do.view;
    self.comment.frame = layout.comment.view;
    [self.cardView relayout:layout.card];
}
- (void)reContent {
    self.couponCover.image = nil;
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:self.couponURLPath] delegate:self];
    self.couponTitle.text = [self.coupon objectForKey:k_coupon_title];
    self.couponContent.text = [self.coupon objectForKey:k_coupon_excerpt_description];
    self.couponExpire.text = [SUtil couponExpireDescription:self.coupon];
    self.couponType.text = [SUtil descriptionWithCouponType:[SUtil couponType:self.coupon]];
    [self.couponType setNeedsDisplay];
    [self.canDo refreshWithText:[SUtil couponCanDoNumString:self.coupon] Image:nil Layout:self.couponLayout.can_do];
    [self.canntDo refreshWithText:[SUtil couponCanntDoNumString:self.coupon] Image:nil Layout:self.couponLayout.cannt_do];
    [self.comment refreshWithText:[SUtil couponCommentNumString:self.coupon] Image:nil Layout:self.couponLayout.comment];
    [self.cardView recontent:[SUtil couponCardTitle:self.coupon]];
}
- (void)reStyleWith:(SCouponStyle *)style {
    self.couponTitle.font = style.titleFont;
    self.couponTitle.textColor = style.titleColor;
    self.couponContent.font = style.contentFont;
    self.couponContent.textColor = style.contentColor;
    self.couponExpire.font = style.expireFont;
    self.couponExpire.textColor = [SUtil isCouponExpire:self.coupon] ? style.didExpireColor : style.unExpireColor;
    [self.cardView restyle:style.cardStyle];
}

#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info {
    if ([[url absoluteString] isEqualToString:self.couponURLPath]) {
        self.couponCover.image = image;
    }
}

#pragma mark actions
- (void)closeCellAction:(id)sender {
    [self.couponsTableView tableView:self.couponsTableView didSelectRowAtIndexPath:[self.couponsTableView indexPathForCell:self]];
}
- (void)copyCodeAction:(id)sender {
    UIPasteboard *_pasteboard = [UIPasteboard generalPasteboard];
    _pasteboard.string = [self.coupon objectForKey:k_coupon_code];
    
    [self.couponsTableView.couponsTableViewDelegate showMessageHUD:[self.coupon objectForKey:k_coupon_code] Message:k_text_copy_coupon_code_success Animated:YES];
}
- (void)showCouponWebDetailAction:(id)sender {
    if (self.couponsTableView.couponsTableViewDelegate && [self.couponsTableView.couponsTableViewDelegate respondsToSelector:@selector(couponsTableView:didSelectCoupon:atIndexPath:)]) {
        [self.couponsTableView.couponsTableViewDelegate couponsTableView:self.couponsTableView didSelectCoupon:self.coupon atIndexPath:[self.couponsTableView indexPathForCell:self]];
    }
}
- (void)emailMeLaterAction:(id)sender {
    if (self.couponsTableView.couponsTableViewDelegate && [self.couponsTableView.couponsTableViewDelegate respondsToSelector:@selector(couponsTableView:EmailMeLater:)]) {
        [self.couponsTableView.couponsTableViewDelegate couponsTableView:self.couponsTableView EmailMeLater:self.coupon];
    }
}
- (void)showActionBar {
    self.actionsToolBar.hidden = NO;
    
    UIView *_tline = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.actionsToolBar.bounds.size.width, 1)];
    _tline.backgroundColor = [UIColor whiteColor];
    _tline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.actionsToolBar addSubview:_tline];
    [_tline release];
    
    CGFloat _w = 60.0;
    CGFloat _h = 40.0;
    CGFloat _y = ceilf((self.actionsToolBar.bounds.size.height - _h)/2);
    UIViewAutoresizing _autoresizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    if ([SUtil hasCouponCode:self.coupon]) {
        CGFloat _space = ceilf((self.actionsToolBar.bounds.size.width - _w*4)/5);
        SButton *_close = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_space, _y, _w, _h)];
        _close.autoresizingMask = _autoresizing;
        [_close setBGImage:[Util imageWithName:@"btn_coupon_close_cell_normal"] forState:UIControlStateNormal];
        [_close setNeedsDisplay];
        [_close addTarget:self action:@selector(closeCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_close];
        [_close release];
        
        SButton *_code = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_close.frame.origin.x+_close.frame.size.width+_space, _y, _w, _h)];
        _code.autoresizingMask = _autoresizing;
        [_code setBGImage:[Util imageWithName:@"btn_coupon_save_code_normal"] forState:UIControlStateNormal];
        [_code setNeedsDisplay];
        [_code addTarget:self action:@selector(copyCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_code];
        [_code release];
        
        SButton *_email = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_code.frame.origin.x+_code.frame.size.width+_space, _y, _w, _h)];
        _email.autoresizingMask = _autoresizing;
        [_email setBGImage:[Util imageWithName:@"btn_coupon_email_me_later_normal"] forState:UIControlStateNormal];
        [_email setNeedsDisplay];
        [_email addTarget:self action:@selector(emailMeLaterAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_email];
        [_email release];
        
        SButton *_detail = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_email.frame.origin.x+_email.frame.size.width+_space, _y, _w, _h)];
        _detail.autoresizingMask = _autoresizing;
        [_detail setBGImage:[Util imageWithName:@"btn_coupon_web_link_normal"] forState:UIControlStateNormal];
        [_detail setNeedsDisplay];
        [_detail addTarget:self action:@selector(showCouponWebDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_detail];
        [_detail release];
    } else {
        CGFloat _space = ceilf((self.actionsToolBar.bounds.size.width - _w*3)/4);
        SButton *_close = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_space, _y, _w, _h)];
        _close.autoresizingMask = _autoresizing;
        [_close setBGImage:[Util imageWithName:@"btn_coupon_close_cell_normal"] forState:UIControlStateNormal];
        [_close setNeedsDisplay];
        [_close addTarget:self action:@selector(closeCellAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_close];
        [_close release];
        
        SButton *_email = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_close.frame.origin.x+_close.frame.size.width+_space, _y, _w, _h)];
        _email.autoresizingMask = _autoresizing;
        [_email setBGImage:[Util imageWithName:@"btn_coupon_email_me_later_normal"] forState:UIControlStateNormal];
        [_email setNeedsDisplay];
        [_email addTarget:self action:@selector(emailMeLaterAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_email];
        [_email release];
        
        SButton *_detail = [[SCouponCellButton alloc] initWithFrame:CGRectMake(_email.frame.origin.x+_email.frame.size.width+_space, _y, _w, _h)];
        _detail.autoresizingMask = _autoresizing;
        [_detail setBGImage:[Util imageWithName:@"btn_coupon_web_link_normal"] forState:UIControlStateNormal];
        [_detail setNeedsDisplay];
        [_detail addTarget:self action:@selector(showCouponWebDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionsToolBar addSubview:_detail];
        [_detail release];
    }
}
- (void)hideActionBar {
    self.actionsToolBar.hidden = YES;
    for (UIView *sv in self.actionsToolBar.subviews) {
        [sv removeFromSuperview];
    }
}

@end


@implementation SCouponCell (OpenClose)

- (void)openWithAnimated:(BOOL)animated {
    [self startOpenAnimation:animated];
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.couponCover.frame = self.couponLayout.icon_open;
                             self.couponTitle.frame = self.couponLayout.title_open;
                             self.couponContent.frame = self.couponLayout.content_open;
                             self.couponExpire.frame = self.couponLayout.expire_open;
                             self.couponType.frame = self.couponLayout.type_open;
                             self.canDo.frame = self.couponLayout.can_do_open.view;
                             self.canntDo.frame = self.couponLayout.cannt_do_open.view;
                             self.comment.frame = self.couponLayout.comment_open.view;
                         }
                         completion:^(BOOL finished){
                             [self finishOpenAnimation:animated];
                         }];
    } else {
        self.couponCover.frame = self.couponLayout.icon_open;
        self.couponTitle.frame = self.couponLayout.title_open;
        self.couponContent.frame = self.couponLayout.content_open;
        self.couponExpire.frame = self.couponLayout.expire_open;
        self.couponType.frame = self.couponLayout.type_open;
        self.canDo.frame = self.couponLayout.can_do_open.view;
        self.canntDo.frame = self.couponLayout.cannt_do_open.view;
        self.comment.frame = self.couponLayout.comment_open.view;
        [self finishOpenAnimation:animated];
    }
}
- (void)closeWithAnimated:(BOOL)animated {
    [self startCloseAnimation:animated];
    SCouponLayout *layout = self.couponLayout;
    if (animated) {
        [UIView animateWithDuration:k_coupons_table_cell_animation_duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.couponCover.frame = layout.icon;
                             self.couponTitle.frame = layout.title;
                             self.couponContent.frame = layout.content;
                             self.couponExpire.frame = layout.expire;
                             self.couponType.frame = layout.type;
                             self.canDo.frame = layout.can_do.view;
                             self.canntDo.frame = layout.cannt_do.view;
                             self.comment.frame = layout.comment.view;
                         }
                         completion:^(BOOL finished){
                             [self finishCloseAnimation:animated];
                         }];
    } else {
        self.couponCover.frame = layout.icon;
        self.couponTitle.frame = layout.title;
        self.couponContent.frame = layout.content;
        self.couponExpire.frame = layout.expire;
        self.couponType.frame = layout.type;
        self.canDo.frame = layout.can_do.view;
        self.canntDo.frame = layout.cannt_do.view;
        self.comment.frame = layout.comment.view;
        [self finishCloseAnimation:animated];
    }
}
- (void)finishOpenAnimation:(BOOL)animated {
    [self showActionBar];
}
- (void)finishCloseAnimation:(BOOL)animated {
    self.cardView.hidden = NO;
}
- (void)startOpenAnimation:(BOOL)animated {
    self.cardView.hidden = YES;
}
- (void)startCloseAnimation:(BOOL)animated {
    [self hideActionBar];
}

@end