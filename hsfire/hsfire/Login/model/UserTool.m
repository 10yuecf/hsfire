//
//  UserTool.m
//  数据库Demo
//
//  Created by 刘亚飞 on 16/6/10.
//  Copyright © 2016年 刘亚飞. All rights reserved.
//

#import <sqlite3.h>
#import "UserTool.h"
#import "User.h"
#import "BaseInfo.h"

@implementation UserTool

static sqlite3 *_db;

+(void)initialize {
    char *error;
    // 0、创建路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filename = [path stringByAppendingPathComponent:@"hsfireyun.sqlite"];
    
    // 1、打开数据库
    if (sqlite3_open(filename.UTF8String, &_db) == SQLITE_OK) {
        NSLog(@"打开成功");
    }
    
    //数据库路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSLog(@"-ios app local database path-%@",documentPath);
    
    // 2、创建数据库user
    NSString *sql = @"create table t_user (id integer primary key autoincrement,userID interger,devicetoken text,name text, account text, status text DEFAULT '1',zw text DEFAULT ' ',bz text DEFAULT ' ',createtime text DEFAULT ' ',groupid text DEFAULT ' ',tagid text DEFAULT ' ',tagname text DEFAULT ' ',dwtype text DEFAULT ' ',tel text DEFAULT ' ',dwname text DEFAULT ' ',dwid text DEFAULT ' ',loginstatus text DEFAULT '0')";
    
    // 3、创建数据库base
    NSString *sqlb = @"create table t_base (id integer primary key autoincrement,strname text,keyname text, keyvalue text)";
    
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"创建user成功");
    }
    
    if (sqlite3_exec(_db, sqlb.UTF8String, NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"创建base成功");
    }
    
}

+(NSMutableArray *)userWithSql:(NSString *)sql {
    NSMutableArray *arr = [NSMutableArray array];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {

            NSString *ID = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
            
            NSString *userID = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
            
            NSString *devicetoken = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
            
            NSString *name = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
            
            NSString *account = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
            
            NSString *status = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
            
            NSString *zw = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];
            
            NSString *bz = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,7) encoding:NSUTF8StringEncoding];
            
            NSString *createtime = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,8) encoding:NSUTF8StringEncoding];
            
            NSString *groupid = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,9) encoding:NSUTF8StringEncoding];
            
            NSString *tagid = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,10) encoding:NSUTF8StringEncoding];
            
            NSString *tagname = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,11) encoding:NSUTF8StringEncoding];
            
            NSString *dwtype = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,12) encoding:NSUTF8StringEncoding];
            
            NSString *tel = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,13) encoding:NSUTF8StringEncoding];
            
            NSString *dwname = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,14) encoding:NSUTF8StringEncoding];
            
            NSString *dwid = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,15) encoding:NSUTF8StringEncoding];
            
            NSString *loginstatus = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,16) encoding:NSUTF8StringEncoding];
            
            User *user = [User userWithName:ID userID:userID devicetoken:devicetoken name:name account:account status:status zw:zw bz:bz createtime:createtime groupid:groupid tagid:tagid tagname:tagname dwtype:dwtype tel:tel dwname:dwname dwid:dwid loginstatus:loginstatus];
            [arr addObject:user];
        }
        
    }
    return arr;
}

+(NSMutableArray *)baseWithSql:(NSString *)sql {
    NSMutableArray *arr = [NSMutableArray array];
    sqlite3_stmt *stmt;
    
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *ID = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
            
            NSString *strName = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            
            NSString *keyName = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            
            NSString *keyValue = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            
            BaseInfo *base = [BaseInfo baseWithName:ID strName:strName keyName:keyName keyValue:keyValue];
            [arr addObject:base];
        }
    }
    
    return arr;
}

+(NSArray *)users {
    return [self userWithSql:@"select * from t_user"];
}

+(NSArray *)base {
    return [self baseWithSql:@"select * from t_base"];
}

@end
