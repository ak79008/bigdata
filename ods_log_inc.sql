-- json建表语句参考https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL
-- CREATE TABLE my_table(a string, b bigint, ...)
-- ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
-- STORED AS TEXTFILE;
-- 建表语句与日志文件一级字段一致,其它采用复杂数据类型建表
/*
 {
	"actions": [
		{
			"action_id": "get_coupon",
			"item": "1",
			"item_type": "coupon_id",
			"ts": 1592121500123
		}
	],
	"common": {
		"ar": "530000",
		"ba": "Xiaomi",
		"ch": "web",
		"is_new": "0",
		"md": "Xiaomi 9",
		"mid": "mid_519598",
		"os": "Android 11.0",
		"uid": "613",
		"vc": "v2.1.132"
	},
	"displays": [
		{
			"display_type": "query",
			"item": "4",
			"item_type": "sku_id",
			"order": 1,
			"pos_id": 2
		},
		{
			"display_type": "query",
			"item": "34",
			"item_type": "sku_id",
			"order": 2,
			"pos_id": 4
		},
		{
			"display_type": "query",
			"item": "7",
			"item_type": "sku_id",
			"order": 3,
			"pos_id": 4
		},
		{
			"display_type": "recommend",
			"item": "24",
			"item_type": "sku_id",
			"order": 4,
			"pos_id": 4
		},
		{
			"display_type": "promotion",
			"item": "4",
			"item_type": "sku_id",
			"order": 5,
			"pos_id": 5
		},
		{
			"display_type": "promotion",
			"item": "26",
			"item_type": "sku_id",
			"order": 6,
			"pos_id": 5
		},
		{
			"display_type": "promotion",
			"item": "29",
			"item_type": "sku_id",
			"order": 7,
			"pos_id": 3
		},
		{
			"display_type": "recommend",
			"item": "33",
			"item_type": "sku_id",
			"order": 8,
			"pos_id": 4
		},
		{
			"display_type": "query",
			"item": "24",
			"item_type": "sku_id",
			"order": 9,
			"pos_id": 1
		},
		{
			"display_type": "query",
			"item": "25",
			"item_type": "sku_id",
			"order": 10,
			"pos_id": 1
		}
	],
	"page": {
		"during_time": 12246,
		"item": "5",
		"item_type": "sku_id",
		"last_page_id": "good_list",
		"page_id": "good_detail",
		"source_type": "query"
	},
	"ts": 1592121494000
}
 */

CREATE EXTERNAL TABLE ods_log_inc
(
    `common`   STRUCT<ar :STRING,ba :STRING,ch :STRING,is_new :STRING,md :STRING,mid :STRING,os :STRING,uid :STRING,vc
                      :STRING> COMMENT '公共信息',
    `page`     STRUCT<during_time :STRING,item :STRING,item_type :STRING,last_page_id :STRING,page_id
                      :STRING,source_type :STRING> COMMENT '页面信息',
    `actions`  ARRAY<STRUCT<action_id:STRING,item:STRING,item_type:STRING,ts:BIGINT>> COMMENT '动作信息',
    `displays` ARRAY<STRUCT<display_type :STRING,item :STRING,item_type :STRING,`order` :STRING,pos_id
                            :STRING>> COMMENT '曝光信息',
    `start`    STRUCT<entry :STRING,loading_time :BIGINT,open_ad_id :BIGINT,open_ad_ms :BIGINT,open_ad_skip_ms
                      :BIGINT> COMMENT '启动信息',
    `err`      STRUCT<error_code:BIGINT,msg:STRING> COMMENT '错误信息',
    `ts`       BIGINT  COMMENT '时间戳'
) COMMENT '活动信息表'
    PARTITIONED BY (`dt` STRING)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
    LOCATION '/warehouse/gmall/ods/ods_log_inc/';

load data inpath '/origin_data/gmall/log/topic_log/2020-06-14' into table ods_log_inc partition(dt='2020-06-14');


select * from ods_log_inc;
