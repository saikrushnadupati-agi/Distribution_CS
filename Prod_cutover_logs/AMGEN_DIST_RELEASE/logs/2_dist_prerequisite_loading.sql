----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera                                              	          --
-- FILENAME             : 2_dist_prerequisite_loading.sql  			    				          --
-- PURPOSE              : Loading of prerequisite data needed in later part of execution   	      --
-- DATE CREATED         : 08-MAR-2020                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 			: SWATHI V														  --
-- DATE MODIFIED		: 05-JUNE-2023                      						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --


/*
CREATE TABLE IF NOT EXISTS lsmv_distribution_unit_03102023 as SELECT * FROM lsmv_distribution_unit;
CREATE TABLE IF NOT EXISTS lsmv_distribution_format_03102023 as SELECT * FROM lsmv_distribution_format;
CREATE TABLE IF NOT EXISTS lsmv_distribution_rule_anchor_03102023 as SELECT * FROM lsmv_distribution_rule_anchor;
CREATE TABLE IF NOT EXISTS LSMV_RULE_DETAILS_03102023 as SELECT * FROM LSMV_RULE_DETAILS;
*/
/*
DROP TABLE IF EXISTS C_SANOFI_CMQ;

CREATE TABLE C_SANOFI_CMQ
(
Name 		TEXT,
PT_CODE 	TEXT,
PT			TEXT,
SOC_CODE	TEXT,
SOC			TEXT,
LLT_CODE	TEXT,
LLT			TEXT,
HLT_CODE	TEXT,
HLT			TEXT,
HLGT_CODE	TEXT,
HLGT		TEXT
);
*/
/*
DROP TABLE IF EXISTS C_SANOFI_PRODUCT_PP;

CREATE TABLE C_SANOFI_PRODUCT_PP
(
PRODUCT_NAME TEXT,
Group_name TEXT
);
*/





DROP TABLE IF EXISTS C_DISTRIBUTION_AUDIT;
DROP PROCEDURE IF EXISTS C_PROC_DISTRIBUTION_EXCEPTION;


CREATE TABLE C_DISTRIBUTION_AUDIT 
(
SL_NO VARCHAR(200),
CONTACT_NAME VARCHAR(2000),
FORMAT_TYPE VARCHAR(2000),
ANCHOR_DISPLAY_NAME VARCHAR(2000),
CURRENT_ATTRIBUTE VARCHAR(2000),
CURRENT_ATTRIBUTE_LIST VARCHAR(2000),
CURRENT_ATTRIBUTE_VAL VARCHAR(2000),
LIST_VALUES VARCHAR(4000),
C_SQLERRM VARCHAR(2000),
INPUT_C_1 VARCHAR(2000),
INPUT_C_2 VARCHAR(2000),
INPUT_C_3 VARCHAR(2000),
INPUT_C_4 VARCHAR(2000),
INPUT_C_5 VARCHAR(2000),
INPUT_C_6 VARCHAR(2000),
INPUT_C_7 VARCHAR(2000)
);


CREATE OR REPLACE PROCEDURE C_PROC_DISTRIBUTION_EXCEPTION(P_SL_NO IN VARCHAR, P_CONTACT_NAME IN VARCHAR, 
P_FORMAT IN VARCHAR, P_DISPLAY_NAME IN VARCHAR,P_current_attribute IN VARCHAR, P_final_expression IN VARCHAR,
P_MULTIVALUE IN VARCHAR, P_MULTIVALUE_LIST  IN VARCHAR,P_SQLERRM  IN VARCHAR, P_INPUT_1 IN VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
LV_SL_NO VARCHAR(2000); 
LV_CONTACT_NAME VARCHAR(2000); 
LV_FORMAT_TYPE  VARCHAR(2000);
LV_ANCHOR_DISPLAY_NAME  VARCHAR(2000);
LV_CURRENT_ATTRIBUTE  VARCHAR(2000);
LV_CURRENT_ATTRIBUTE_LIST VARCHAR(2000);
LV_CURRENT_ATTRIBUTE_VAL  VARCHAR(2000);
LV_LIST_VALUES  VARCHAR(4000);
LV_C_SQLERRM  VARCHAR(2000);
LV_INPUT_C_1  VARCHAR(2000);
--PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN 
LV_SL_NO := P_SL_NO; 
LV_CONTACT_NAME := P_CONTACT_NAME; 
LV_FORMAT_TYPE := P_FORMAT;
LV_ANCHOR_DISPLAY_NAME := P_DISPLAY_NAME;
LV_CURRENT_ATTRIBUTE  := P_current_attribute;
LV_CURRENT_ATTRIBUTE_LIST := P_final_expression;
LV_CURRENT_ATTRIBUTE_VAL  := P_MULTIVALUE;
LV_LIST_VALUES  := P_MULTIVALUE_LIST;
LV_C_SQLERRM := P_SQLERRM;
LV_INPUT_C_1 := P_INPUT_1;


INSERT INTO C_DISTRIBUTION_AUDIT
                        (SL_NO, CONTACT_NAME, FORMAT_TYPE, ANCHOR_DISPLAY_NAME, CURRENT_ATTRIBUTE, 
                        CURRENT_ATTRIBUTE_LIST,CURRENT_ATTRIBUTE_VAL, LIST_VALUES, C_SQLERRM, INPUT_C_1)
VALUES(LV_SL_NO, LV_CONTACT_NAME, LV_FORMAT_TYPE, LV_ANCHOR_DISPLAY_NAME, LV_CURRENT_ATTRIBUTE, 
                        LV_CURRENT_ATTRIBUTE_LIST,LV_CURRENT_ATTRIBUTE_VAL, LV_LIST_VALUES, LV_C_SQLERRM, LV_INPUT_C_1);

--COMMIT;
EXCEPTION 
WHEN OTHERS THEN 
NULL;
END $$;

