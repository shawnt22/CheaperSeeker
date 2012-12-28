//
//  SConfiger.h
//  TSApplication
//
//  Created by 松 滕 on 12-6-26.
//  Copyright (c) 2012年 shawnt22@gmail.com . All rights reserved.
//
#pragma mark - Import
#import "SUtil.h"
#import "Util.h"
#import "SDefine.h"

#pragma mark - Error
#define kErrorDomain    @"SErrorDomain"
typedef enum {
    SErrorInvalide = 0,         //  无效的
    SErrorResponseParserFail,   //  response 数据解析失败
}SErrorCode;

#pragma mark - Layout
#define kMarginLeft 10.0
#define kMarginTop 5.0

#define k_coupons_table_cell_animation_duration 0.4

#define kCustomCellBGLineColor          SRGBCOLOR(195, 195, 195)
#define kCustomCellBGFillColor          SRGBCOLOR(228, 228, 228)
#define kCustomCellBGInnerShadowColor   SRGBCOLOR(250, 250, 250)
#define kCustomCellBGDropShadowColor    SRGBCOLOR(250, 250, 250)
#define kCustomCellSelectedBGLineColor  kCustomCellBGLineColor
#define kCustomCellSelectedBGFillColor  SRGBCOLOR(30, 110, 181)

#define kCustomCellBGLineColor2         SRGBCOLOR(25, 25, 27)
#define kCustomCellBGFillColor2         SRGBCOLOR(38, 40, 42)
#define kCustomCellBGInnerShadowColor2  SRGBCOLOR(49, 50, 52)
#define kCustomCellBGFillColor3         SRGBCOLOR(33, 34, 36)

#define kSiderCellBGLineColor           SRGBCOLOR(52, 53, 57)
#define kSiderCellBGFillColor           SRGBCOLOR(84, 84, 84)
#define kSiderCellSelectedBGFillColor   SRGBCOLOR(54, 54, 54)

#define kTextColor                      SRGBCOLOR(255, 255, 255)
#define kTextShadowColor                SRGBCOLOR(6, 6, 6)
#define kTextShadowOffset               CGSizeMake(0.0, -1.0)

#pragma mark - Notification


#pragma mark - Global
#define kPullTablePullDown2Refresh      @"Pull down to refresh ..."
#define kPullTableRelease2Refresh       @"Release to refresh ..."
#define kPullTablePullUp2Loadmore       @"Pull up to load more ..."
#define kPullTableRelease2Loadmore      @"Release to load more ..."
#define kPullTableLoading               @"Loading ..."
#define kPullTableNoMoreData            @"No more data"

#define kViewControllerHomeTitle        @"Home"
#define kViewControllerStoreTitle       @"Store"
#define kViewControllerCategoryTitle    @"Category"
#define kViewControllerAboutTitle       @"About"
#define kHomeSearchBarPlaceHolder       @"search coupons"
#define kNavigationBarSplitItemTitle    @"Menu"

#define k_text_about_desc_version       @"version : "
#define k_text_about_cell_star               @"Evaluate in AppStore"
#define k_text_about_cell_site               @"About us"
#define k_text_about_cell_advice             @"Contact us"

#define k_coupon_web_viewcontroller_bar_buttion_show_code   @"Code"
#define k_coupon_web_viewcontroller_bar_buttion_copy_code   @"Copy"

#define k_text_coupon_date_description_expired  @"Expired"
#define k_text_coupon_date_nature_description   @"Expire in"
#define k_text_coupon_date_nature_description_too_long  @"year"
#define k_text_coupon_date_nature_description_too_short @"hour"
#define k_text_coupon_date_nature_description_months    @"months"
#define k_text_coupon_date_nature_description_weeks     @"weeks"
#define k_text_coupon_date_nature_description_days      @"days"
#define k_text_coupon_date_nature_description_hours     @"hours"

#define k_text_merchant_coupons_segment_item_common     @"Common"
#define k_text_merchant_coupons_segment_item_featured   @"Featured"
#define k_text_merchants_segment_item_all            @"All"
#define k_text_merchants_segment_item_fetured           @"Featured"

#define k_text_about_row_description                    @"Description"
#define k_text_about_row_email                          @"Email"
#define k_text_about_row_address                        @"Address"
#define k_text_about_row_site                           @"WebSite"
#define k_text_about_privacy                            @"Privacy"
#define k_text_about_terms                              @"Terms"

#define k_text_coupon_type_sale                         @"SALE"
#define k_text_coupon_type_code                         @"CODE"

#define k_text_email_me_later_controller_title          @"Email Me Later"
#define k_text_email_me_later_txtfield_placeholder      @"Enter Your Email Here"
#define k_text_email_me_later_post_success              @"Email Me Later Success"
#define k_text_error_email_me_empty_email               @"Please Enter Your Email"

