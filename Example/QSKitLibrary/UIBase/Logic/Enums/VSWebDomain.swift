//
//  VSWebDomain.swift
//  QuasiDemo
//
//  Created by Soul on 2022/9/2.
//  Copyright © 2022 Quasi Inc. All rights reserved.
//

import Foundation

/**
 枚举不同ipa时适用的h5根域名
 */
public enum VSWebDomain: String {
    case  WEB_DOMAIN_TEST = "https://test.quasi.com"
    case  WEB_DOMAIN_PRE_RELEASE = "https://pre.quasi.com"
    case  WEB_DOMAIN_PRODUCT = "https://quasi.com"
}

public enum VSWebPath: String {
    case  H5_ABOUT_US = "/help/about-us"                //  关于我们
    case  H5_DIYKIT_HELP = "/help/about-diy-pools"      //  自选池帮助页面
    case  H5_POINTS_HELP = "/help/about-points"         //  积分帮助页面
    case  H5_PRIVACY_POLICY = "/help/privacy-policy"    //  服务条款(用户协议)
    case  H5_USER_TERM = "/help/terms-of-service"       //  隐私政策
    case  H5_GROW_GUIDE = "/technical-guide"            //  IoT首页种植教程Banner
}
