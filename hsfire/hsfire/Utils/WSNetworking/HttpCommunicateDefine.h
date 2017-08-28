//
//  HttpCommunicateDefine.h
//  MumMum
//
//  Created by shlity on 16/6/16.
//  Copyright © 2016年 Moresing Inc. All rights reserved.
//

#ifndef GoddessClock_HttpCommunicateDefine_h
#define GoddessClock_HttpCommunicateDefine_h

typedef NS_ENUM (NSInteger , HttpResponseCode)
{
    HttpResponseOk = 0,
    HttpResponseError,
    HttpResponseLoginError,
    HttpResponseCnout
};

#define URL_BASE          @"http://10yue.hsdcw.com/fireyun/api/socket.php?action="

//http后缀
typedef NS_ENUM(NSInteger,HTTP_COMMAND_LIST){
    //获取验证码
    GetYzm,
    //修改密码
    FindPassword,
    //取用户列表
    selectUser,
    //获取活动详情
    GetPartyShow,
    //上传头像接口
    up,
    //获取用户信息
    GetUserMore,
    //用户注册第一步
    Register,
    //用户注册第二步
    Register2,
    //获取地区
    GetArea,
    //获取基础信息
    GetBase,
    //用户登陆
    appLogin,
    //发送信息
    sandinfo,
    //获取用户消息
    GetGbook,
    //获取活动数据
    GetPartyList,
    //获取用户相册
    GetPhotoList,
    //提交报名
    SandParty,
    //获取认证、服务页面
    GetInfo,
    //验证活动是否报名
    chk_party_user,
    //获取广告接口
    GetInfolist,
    //发送消息
    SandGbookUser,
    //获取用户消息
    GetGbookUser,
    //发送用户设备码
    SandUmcode,
    //收藏好友
    Sand_Friend,
    //收藏好友列表
    Get_Friend_list,
    //拉黑/删除好友
    Sand_Friend_del,
    //删除消息记录
    DelGbook,
    //检验是否拉入消息黑名单
    chk_Friend_isblack,
    //demo
    HTTP_UPDATE_AVATA,
    /*******************/
    HTTP_METHOD_RESERVE,
    HTTP_METHOD_COUNT
};

//#ifdef __ONLY_FOR_HTTP_COMMUNICATE__
//****************************************************************************/

static char cHttpMethod[HTTP_METHOD_COUNT][64] = {
    "GetYzm",
    "FindPassword",
    "selectUser",
    "GetPartyShow",
    "up",
    "GetUserMore",
    "Register",
    "Register2",
    "GetArea",
    "GetBase",
    "appLogin",
    "sandinfo",
    "GetGbook",
    "GetPartyList",
    "GetPhotoList",
    "SandParty",
    "GetInfo",
    "chk_party_user",
    "GetInfolist",
    "SandGbookUser",
    "GetGbookUser",
    "SandUmcode",
    "Sand_Friend",
    "Get_Friend_list",
    "Sand_Friend_del",
    "DelGbook",
    "chk_Friend_isblack",
    "toutiao/avatar",
};

/*****************************************************************************/

typedef NS_ENUM(NSUInteger,ServiceStatusTypeDefine) {
    ServiceStatusTypeWaitingDefine = 1,
    ServiceStatusTypeWorkingDefine,
    ServiceStatusTypeFinishedDefine,
    ServiceStatusTypeDefineCount,
};

#endif
