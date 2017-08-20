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
    NSString *filename = [path stringByAppendingPathComponent:@"hsjhb.sqlite"];
    
    // 1、打开数据库
    if (sqlite3_open(filename.UTF8String, &_db) == SQLITE_OK) {
        NSLog(@"打开成功");
    }
    
    //数据库路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSLog(@"=============%@",documentPath);
    
    // 2、创建数据库
    NSString *sql = @"create table t_user (id integer primary key autoincrement,userID interger,usertoken text,username text, nickname text DEFAULT ' ', photo_s text DEFAULT ' ',sex text DEFAULT ' ',bir text DEFAULT ' ',area text DEFAULT ' ',heigh text DEFAULT ' ',edu text DEFAULT ' ',pay text DEFAULT ' ',love text DEFAULT ' ',loginstatus text DEFAULT '0',degree text DEFAULT '10')";
    
    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"创建成功");
    }
}

+(NSMutableArray *)userWithSql:(NSString *)sql {
    NSMutableArray *arr = [NSMutableArray array];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {

            NSString *ID = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,0) encoding:NSUTF8StringEncoding];
            NSString *userID = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,1) encoding:NSUTF8StringEncoding];
            NSString *usertoken = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,2) encoding:NSUTF8StringEncoding];
            NSString *username = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,3) encoding:NSUTF8StringEncoding];
            NSString *nickname = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,4) encoding:NSUTF8StringEncoding];
            NSString *photo_s = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,5) encoding:NSUTF8StringEncoding];
            NSString *sex = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,6) encoding:NSUTF8StringEncoding];
            NSString *bir = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,7) encoding:NSUTF8StringEncoding];
            NSString *area = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,8) encoding:NSUTF8StringEncoding];
            NSString *heigh = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,9) encoding:NSUTF8StringEncoding];
            NSString *edu = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,10) encoding:NSUTF8StringEncoding];
            NSString *pay = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,11) encoding:NSUTF8StringEncoding];
            NSString *love = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,12) encoding:NSUTF8StringEncoding];
            NSString *loginstatus = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,13) encoding:NSUTF8StringEncoding];
            NSString *degree = [NSString stringWithCString:(const char*)sqlite3_column_text(stmt,14) encoding:NSUTF8StringEncoding];
            
            User *user = [User userWithName:ID userID:userID usertoken:usertoken username:username nickname:nickname photo_s:photo_s sex:sex bir:bir area:area heigh:heigh edu:edu pay:pay love:love loginstatus:loginstatus degree:degree];
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
