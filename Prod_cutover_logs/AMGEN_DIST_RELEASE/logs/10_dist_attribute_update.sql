----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Niroj Kumar Panigrahi                                            	          --
-- FILENAME             : 10_DIST_ATTRIBUTE_UPDATE.SQL 			    				              --
-- PURPOSE              : This Script is to update the Temporary table with attribute code valus from Excel    --
-- DATE CREATED         : 21-NOV-2020  
-- MODIFIED BY          : Sai Krushna Dupati /Navya Chandramouli	
-- MODIFIED DATE        : 09-SEP-2025                    						              --
-- REVIEWD BY           : DEBASIS DAS                                                                         --
-- ********************************************************************************************** --
DO $$
DECLARE 
Lv_string TEXT;
Lv_string1 TEXT;
l_context TEXT;
BEGIN

SELECT STRING_AGG(COLUMN_NAME,'') INTO Lv_string
FROM 
(SELECT 'CREATE TABLE C_DISTRIBUTION_RULES_CODE
(SL_NO VARCHAR(200),CONTACT_NAME  VARCHAR(200),FORMAT VARCHAR(200),DISPLAY_NAME VARCHAR(200),RULE_ACTIVE VARCHAR(200),DATA_PRIVACY VARCHAR(200), RELEASE VARCHAR(200)
,TIME_LINE_DAY VARCHAR(200),RULE_INCLUSION VARCHAR(200),PIVOT_NAME VARCHAR(200),PIVOT_VALUE VARCHAR(200),PIVOT_RULE VARCHAR(200),CONTACT_LEVEL_PIVOT  VARCHAR(2000),FORMAT_LEVEL_PIVOT  VARCHAR(2000)
,RULE_SEQUENCE VARCHAR(200),REPORT_TYPE VARCHAR(200),FINAL_EXPRESSION VARCHAR(200),Timeline_1 VARCHAR(200),TL1_PARAM VARCHAR(200),TL1_DAY VARCHAR(200),Timeline_2 VARCHAR(200),TL2_PARAM VARCHAR(200),TL2_DAY VARCHAR(200),Timeline_3 VARCHAR(200),
TL3_PARAM VARCHAR(200),TL3_DAY VARCHAR(200),Timeline_4 VARCHAR(200),TL4_PARAM VARCHAR(200),TL4_DAY VARCHAR(200),DEFAULT_TIMELINE_DAYS VARCHAR(200),format_display_name VARCHAR(200), OLT VARCHAR(200),' COLUMN_NAME FROM DUAL
UNION ALL
SELECT STRING_AGG(COLUMN_NAME,'') FROM 
(SELECT REPLACE(TTT,'-','')||' VARCHAR(400),' COLUMN_NAME FROM (
select CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 'I_' ELSE 'U_' END|| 
REPLACE(REPLACE(SUBSTRING(SUBSTRING(RULE_NAME,CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 5 ELSE 1 END,40),1,15),' ','_')||'_'||RULE_ID,'__','_') TTT 
from LSMV_RULE_DETAILS WHERE ACTIVE_YN = 'Y' AND MODULE_NAME = 'Distribution'
--Below condition added by Swathi
and rule_id not like '%DR065%'
and RULE_ID not in ('CR001')) a ORDER BY TTT) b
UNION ALL
SELECT STRING_AGG(COLUMN_NAME,'') FROM(
SELECT TTT||'_EX'||' VARCHAR(400),' COLUMN_NAME FROM (
select CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 'I_' ELSE 'U_' END|| 
REPLACE(REPLACE(SUBSTRING(SUBSTRING(RULE_NAME,CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 5 ELSE 1 END,40),1,15),' ','_')||'_'||RULE_ID,'__','_') TTT 
from LSMV_RULE_DETAILS  WHERE EXCLUDABLE_RULE = 'Y' AND ACTIVE_YN = 'Y' AND MODULE_NAME = 'Distribution'--Below condition added by Swathi
and rule_id not like '%DR065%'
and RULE_ID not in ('CR001')) a  ORDER BY TTT) b
UNION ALL
(SELECT STRING_AGG(COLUMN_NAME,'') FROM(
SELECT TTT||'_VAL'||' VARCHAR(32000),' COLUMN_NAME FROM (
select CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 'I_' ELSE 'U_' END|| 
REPLACE(REPLACE(SUBSTR(SUBSTR(RULE_NAME,CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 5 ELSE 1 END,40),1,15),' ','_')||'_'||RULE_ID,'__','_') TTT 
from LSMV_RULE_DETAILS  
	WHERE RULE_PARAM_MAP <> '{"adhocRules":[],"paramMap":{}}' 
	and RULE_PARAM_MAP <> '{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{}}'
	AND (UPPER(RULE_PARAM_MAP) LIKE '%LIB_%' OR UPPER(RULE_PARAM_MAP) LIKE '%CL_%')
AND RULE_ID NOT LIKE '%/_%' ESCAPE '/'
AND ACTIVE_YN = 'Y' AND MODULE_NAME = 'Distribution'
--Below condition added by Swathi
and rule_id not like '%DR065%'
and RULE_ID not in ('CR001')) a ORDER BY TTT
)a )) T ;

 Lv_string := RTRIM(Lv_string,',')||')';
 
EXECUTE 'DROP TABLE IF EXISTS C_DISTRIBUTION_RULES_code';
 --Lv_string := 'SELECT 1 FROM DUAL';
EXECUTE  Lv_string;
 
--RAISE NOTICE 'EXCEPTION :%', Lv_string;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE NOTICE 'EXCEPTION :%', 'NO DATA FOUND';
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION :%', l_context;
END $$;






UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'Report type: Report from study/Study type=Clinical trials','Report_type:Report from study/Study_type:Clinical Trials')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%Report type: Report from study/Study type=Clinical trials%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_PRODUCT_SERIOUS_DR028 = REPLACE (I_PRODUCT_SERIOUS_DR028,'ISP_PRODUCT_SERIOUS_LABELING','ISP_PRODUCT_SERIOUS_RELATEDNESS_LABELING')
WHERE I_PRODUCT_SERIOUS_DR028 LIKE '%ISP_PRODUCT_SERIOUS_LABELING%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'/ Study type:Clinical trials','/Study_type:Clinical Trials')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%/ Study type:Clinical trials%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'/Study type :Clinical trials','/Study_type:Clinical Trials')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%/Study type :Clinical trials%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'/ Study type: Clinical trials','/Study_type:Clinical Trials')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%/ Study type: Clinical trials%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'//','/')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%//%';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET I_REPORT_TYPE_DR027_VAL = REPLACE (I_REPORT_TYPE_DR027_VAL,'Report type :Report from study ','Report type:Report from study ')
WHERE I_REPORT_TYPE_DR027_VAL LIKE '%Report type :Report from study %';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'CIOMS I','1')
WHERE FORMAT = 'CIOMS I';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'E2B','3')
WHERE FORMAT = 'E2B';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'cIOMS','1')
WHERE FORMAT = 'cIOMS';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'CIOMS','1')
WHERE FORMAT = 'CIOMS';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'COIMS','1')
WHERE FORMAT = 'COIMS';

/*
UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'Other Reg. Report','20')
WHERE FORMAT = 'Other Reg. Report';
*/



UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'Other Reg. Report','20')
WHERE FORMAT = 'Other Reg. Report';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'MIR-PDF','39')
WHERE FORMAT = 'MIR-PDF';


UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'FDA3500A (Devices)','4')
WHERE FORMAT = 'FDA3500A (Devices)';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'FDA MedWatch 3500A Drug','2'), FORMAT_DISPLAY_NAME = 'FDA 3500A'
WHERE FORMAT = 'FDA MedWatch 3500A Drug';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'US FDA MedWatch 3500A Drug','2')
WHERE FORMAT = 'US FDA MedWatch 3500A Drug';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'FDA 3500A','2')
WHERE FORMAT = 'FDA 3500A';


UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'CIOMS_Unblinded','1')
WHERE FORMAT = 'CIOMS_Unblinded';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'CIOMS_blinded','1')
WHERE FORMAT = 'CIOMS_blinded';


UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'Health Canada Device Report','40')
WHERE FORMAT = 'Health Canada Device Report';


UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'Source document (Japanese)','8006')
WHERE FORMAT = 'Source document (Japanese)';


UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'Case Summary Sheet (Japanese)','8005')
WHERE FORMAT = 'Case Summary Sheet (Japanese)';

UPDATE C_DISTRIBUTION_RULES_DECODE
SET FORMAT = REPLACE(FORMAT,'CIOMS LL','8007')
WHERE FORMAT = 'CIOMS LL';



DROP TABLE IF EXISTS DR_ERROR_LOG;

/*
CREATE TABLE DR_ERROR_LOG(
CONTACT_NAME VARCHAR(1000),
 VARCHAR(100),
CONTACT_NAME VARCHAR(100),
FORMAT VARCHAR(100),
DISPLAY_NAME VARCHAR(100)
);

*/
DROP TABLE IF EXISTS ATTRIBUTE_STATUS;


CREATE TABLE ATTRIBUTE_STATUS(
NAME VARCHAR(1000),
STATUS VARCHAR(100),
CONTACT_NAME VARCHAR(100),
FORMAT VARCHAR(100),
DISPLAY_NAME VARCHAR(100)
);




DO $$
DECLARE
I RECORD;
BEGIN

FOR I IN (SELECT ROW_NUMBER() over() AS RN,CONTACT_NAME,FORMAT,FORMAT_DISPLAY_NAME,DISPLAY_NAME,RULE_INCLUSION,PIVOT_NAME,PIVOT_VALUE,FINAL_EXPRESSION,RULE_SEQUENCE FROM C_DISTRIBUTION_RULES_DECODE ctdc ORDER BY SL_NO)
		   
	LOOP
    
    INSERT INTO C_DISTRIBUTION_RULES_CODE(SL_NO,CONTACT_NAME,FORMAT,FORMAT_DISPLAY_NAME,DISPLAY_NAME,RULE_INCLUSION,PIVOT_NAME,PIVOT_VALUE,RULE_SEQUENCE)
    VALUES(I.RN,I.CONTACT_NAME,I.FORMAT,I.FORMAT_DISPLAY_NAME,I.DISPLAY_NAME,I.RULE_INCLUSION,I.PIVOT_NAME,I.PIVOT_VALUE,I.RULE_SEQUENCE);
	
	
	
    END LOOP;
--COMMIT;
exception
when others then
RAISE NOTICE 'EXCEPTION  IN CONTACT NAME LOADING :%',SQLERRM;	
END $$;

DO $$
DECLARE
I RECORD ;
final_expresiion RECORD;
lv_final_expression VARCHAR(3000);
lv_rule_name VARCHAR(1000);
lv_rule_id VARCHAR(100);
final_rule_id VARCHAR(1000);
lv_null_rule VARCHAR(100);
BEGIN
lv_null_rule := NULL;
FOR I IN (SELECT row_NUMBER() over() AS RN,CONTACT_NAME,FORMAT,FORMAT_DISPLAY_NAME,DISPLAY_NAME,RULE_INCLUSION,PIVOT_NAME,PIVOT_VALUE,FINAL_EXPRESSION
           FROM C_DISTRIBUTION_RULES_DECODE ctdc where FINAL_EXPRESSION IS NOT NULL ORDER BY SL_NO)
		   
	LOOP
	lv_final_expression := RTRIM(I.FINAL_EXPRESSION,',');
    
    FOR final_expresiion IN  SELECT regexp_split_to_table(lv_final_expression,'\,+') AS FINAL_EXP
LOOP
		  --RAISE NOTICE '1------%  contact :% format: %',final_expresiion.FINAL_EXP,I.CONTACT_NAME,I.FORMAT;
		  SELECT RULE_NAME,RULE_ID INTO lv_rule_name,lv_rule_id 
		  FROM LSMV_RULE_DETAILS
		  where UPPER(TRIM(RULE_NAME)) = UPPER(TRIM(final_expresiion.FINAL_EXP));
		  --RAISE NOTICE '2 :%  3: %',lv_rule_name,lv_rule_id;
		  
          IF lv_null_rule IS NULL THEN
		  UPDATE C_DISTRIBUTION_RULES_CODE
		  SET FINAL_EXPRESSION = lv_rule_id
		  WHERE CONTACT_NAME = I.CONTACT_NAME AND FORMAT = I.FORMAT AND FORMAT_DISPLAY_NAME = I.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = I.DISPLAY_NAME;
          
		  lv_null_rule := lv_rule_id;
          
          ELSE
          
          UPDATE C_DISTRIBUTION_RULES_CODE
		  SET FINAL_EXPRESSION = LTRIM((FINAL_EXPRESSION||','||lv_rule_id),',')
		  WHERE CONTACT_NAME = I.CONTACT_NAME AND FORMAT = I.FORMAT AND FORMAT_DISPLAY_NAME = I.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = I.DISPLAY_NAME;
          
          END IF;
          
		  END LOOP;
	lv_null_rule := NULL;
    END LOOP;
--COMMIT;
exception
when others then
RAISE NOTICE 'EXCEPTION  in Final Expression loading :%',SQLERRM;	
END $$;

--SELECT * FROM C_DISTRIBUTION_RULES_CODE;
DO $$
DECLARE
l_context TEXT;
cur_att_upd RECORD;
lv_cu_acc VARCHAR(1000);
lv_cu_acc_rec_id BIGINT;
lv_final_expression VARCHAR(3000);
lv_rule_name VARCHAR(1000);
lv_rule_id VARCHAR(100);
final_rule_id VARCHAR(1000);
lv_null_rule VARCHAR(100);
lv_study_type VARCHAR(1000);
lv_study_prod_type VARCHAR(1000);
lv_source_type VARCHAR(1000);
lv_source_ha_type VARCHAR(1000);
lv_repor_qua_type VARCHAR(1000);
lv_psc_cod_cnr_type VARCHAR(4000);
lv_protocol_type VARCHAR(1000);
lv_usr_prod VARCHAR(1000);
lv_prod_rec_id INT;
lv_trade_rec_id INT;
lv_iss_code VARCHAR(1000);
lv_rep_med_type VARCHAR(1000);
lv_case_sig_type VARCHAR(1000);
lv_psc_cntry_type VARCHAR(1000);
lv_prm_src_cntry VARCHAR(1000);
lv_spanish_state VARCHAR(1000);
lv_code_broken VARCHAR(1000);
lv_prod_app_con_cpd VARCHAR(1000);
lv_label_cntry VARCHAR(1000);
lv_report_type VARCHAR(1000);
lv_study_type1 VARCHAR(1000);
lv_approval_type VARCHAR(1000);
lv_approval_cntry VARCHAR(1000);
lv_Study_design VARCHAR(1000);
lv_event_severity VARCHAR(1000);
lv_report_classification VARCHAR(1000);
lv_product_flag VARCHAR(1000);
lv_study_reg_c VARCHAR(1000);
lv_obtatin_country VARCHAR(1000);
lv_approv_ongng VARCHAR(4000);
lv_PSC_CODE VARCHAR(4000);
lv_PSC_CODE_A VARCHAR(4000);
lv_usr_ptnt_country varchar(1000);
cur_usr_ptnt_cntry record;
lv_psc_prd_flag varchar(1000);
lv_PSC_CODE_APP VARCHAR(4000);
lv_std_spnsr VARCHAR(4000);
lv_project_no TEXT;
lv_protocol_no TEXT;

BEGIN
lv_null_rule := NULL;
FOR cur_att_upd IN (SELECT * FROM C_DISTRIBUTION_RULES_DECODE ctdc ORDER BY SL_NO)
		   
	LOOP
	
	
	IF  cur_att_upd.I_SENDER_ORGANIZA_DR024 <> '' THEN
	      UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_SENDER_ORGANIZA_DR024 = SUBSTR('I_SENDER_ORGANIZA_DR024',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_SENDER_ORGANIZA_DR024,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          --ELSE 
          --RAISE NOTICE '1------%','EXCEPTION  IN I_SENDER_ORGANIZA_DR024';
          END IF;
		  
		  DECLARE
	     lv_test_null VARCHAR(1000);
		 cur_cu_acc RECORD;
	      BEGIN
		  lv_cu_acc := SUBSTR(cur_att_upd.I_SENDER_ORGANIZA_DR024_VAL,8);
		  lv_test_null := NULL;
		  
		  
		  FOR cur_cu_acc IN  SELECT regexp_split_to_table(lv_cu_acc,'\,+') AS CU_ACC_NAME
	
            LOOP
				
                 BEGIN
				 
				 BEGIN 
                 SELECT RECORD_ID INTO STRICT lv_cu_acc_rec_id
                 FROM LSMV_ACCOUNTS
                 WHERE UPPER(TRIM(ACCOUNT_ID)) = UPPER(TRIM(cur_cu_acc.CU_ACC_NAME));
				 
				 EXCEPTION 
				 WHEN OTHERS THEN 	 
                    
					SELECT RECORD_ID INTO STRICT lv_cu_acc_rec_id
                    FROM LSMV_ACCOUNTS
                    WHERE UPPER(TRIM(ACCOUNT_NAME)) = UPPER(TRIM(cur_cu_acc.CU_ACC_NAME));
		   
				END;
		IF lv_cu_acc_rec_id IS NOT NULL
		THEN 
			IF lv_test_null IS NULL 
			THEN
				UPDATE C_DISTRIBUTION_RULES_CODE
				SET I_SENDER_ORGANIZA_DR024_VAL = 'CU_ACC:'||lv_cu_acc_rec_id		  
				WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
				lv_test_null := lv_cu_acc_rec_id;
			ELSE
				UPDATE C_DISTRIBUTION_RULES_CODE
				SET I_SENDER_ORGANIZA_DR024_VAL = LTRIM((I_SENDER_ORGANIZA_DR024_VAL||','||lv_cu_acc_rec_id),',')		  
				WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
       
			--  lv_test_null :=  NULL;
			END IF;
		END IF;
            EXCEPTION 
            WHEN OTHERS THEN 
                        BEGIN
                        SELECT RECORD_ID INTO STRICT lv_cu_acc_rec_id
                        FROM LSMV_PARTNER 
                        WHERE UPPER(TRIM(PARTNER_ID)) = UPPER(TRIM(lv_list(J))) ;
						
						IF lv_cu_acc_rec_id IS NOT NULL
						THEN 
						
							IF lv_test_null IS NULL 
							THEN
								UPDATE C_DISTRIBUTION_RULES_CODE
								SET I_SENDER_ORGANIZA_DR024_VAL = 'CU_ACC:'||lv_cu_acc_rec_id		  
								WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
							ELSE
								UPDATE C_DISTRIBUTION_RULES_CODE
								SET I_SENDER_ORGANIZA_DR024_VAL = LTRIM((I_SENDER_ORGANIZA_DR024_VAL||','||lv_cu_acc_rec_id),',')		  
								WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
							END IF;
						END IF;
						EXCEPTION
						WHEN OTHERS THEN
						   RAISE NOTICE 'DR024 : %','Company unit or account not found';
						END;
					--END IF;	
                END;
				end loop;
				
				lv_test_null :=  NULL;
	  END;
		  	END IF;
			
	IF cur_att_upd.I_SENDER_ORGANIZA_DR024_EX <> '' THEN	
	UPDATE C_DISTRIBUTION_RULES_CODE
       SET I_SENDER_ORGANIZA_DR024_EX = SUBSTR('I_SENDER_ORGANIZA_DR024_EX',19)
	   WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	   
    END IF;	
			
	IF  cur_att_upd.I_PREGNANCY_DR019 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PREGNANCY_DR019 = SUBSTR('I_PREGNANCY_DR019',13)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
    END IF;	
	
	IF cur_att_upd.I_INVALID_CASE_DR020 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_INVALID_CASE_DR020 = SUBSTR('I_INVALID_CASE_DR020',16)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;
	
	IF  cur_att_upd.I_INVALID_CASE_DR020_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_INVALID_CASE_DR020_EX = SUBSTR('I_INVALID_CASE_DR020_EX',16)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
		IF  cur_att_upd.I_NON_AE_CASE_DR025 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_NON_AE_CASE_DR025 = SUBSTR('I_NON_AE_CASE_DR025',15)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;
	
	IF cur_att_upd.I_NON_AE_CASE_DR025_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_NON_AE_CASE_DR025_EX = SUBSTR('I_NON_AE_CASE_DR025_EX',15)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.I_CASE_SUSAR_DR008 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_CASE_SUSAR_DR008 = SUBSTR('I_CASE_SUSAR_DR008',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		
    END IF;
	
		IF cur_att_upd.I_CASE_SUSAR_DR008_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_CASE_SUSAR_DR008_EX = SUBSTR('I_CASE_SUSAR_DR008_EX',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		
    END IF;
	
	IF cur_att_upd.I_DEATH_LIFE_THRE_DR033 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_DEATH_LIFE_THRE_DR033 = SUBSTR('I_DEATH_LIFE_THRE_DR033',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
    END IF;
	
	IF cur_att_upd.I_DEATH_LIFE_THRE_DR033_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_DEATH_LIFE_THRE_DR033_EX = 'DR033_EX'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
    END IF;
	
	IF cur_att_upd.I_STUDY_TYPE_DR010 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_STUDY_TYPE_DR010 = SUBSTR('I_STUDY_TYPE_DR010',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	    
	 IF cur_att_upd.I_STUDY_TYPE_DR010_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_STUDY_TYPE_DR010_EX = SUBSTR('I_STUDY_TYPE_DR010_EX',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
		  
    END IF; 
	
	IF cur_att_upd.I_STUDY_TYPE_DR010_VAL <> '' THEN
	
	           lv_study_type := SUBSTR(cur_att_upd.I_STUDY_TYPE_DR010_VAL,12);
	
	              DECLARE
				  cur_study_type RECORD;
				  lv_cd_code INT;
				  lv_cd_decode VARCHAR(100);
				  lv_test_null INT;
				  BEGIN
				  lv_test_null := NULL;
	FOR cur_study_type IN  SELECT regexp_split_to_table(lv_study_type,'\,+') AS STUDY_TYPE

            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1004
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_study_type.STUDY_TYPE));
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_STUDY_TYPE_DR010_VAL = '1004:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
					 
					 
		 IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_TYPE_DR010_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_TYPE_DR010_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_STUDY_TYPE_DR010_VAL = LTRIM((I_STUDY_TYPE_DR010_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
					 
		IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_TYPE_DR010_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE 
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_TYPE_DR010_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);

          END IF;
			      END IF;
			  
             
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE 'DR010 :%','EXCEPTION  IN 1004 CODELIST';        
            END; 
    END IF;

--Added by Swathi for ISP_DEATH

	IF cur_att_upd.I_DEATH_DR011 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_DEATH_DR011 = SUBSTR('I_DEATH_DR011',9)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	    
	 IF cur_att_upd.I_DEATH_DR011_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_DEATH_DR011_EX = SUBSTR('I_DEATH_DR011_EX',9)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
		  
    END IF;		
	
	IF cur_att_upd.I_STUDY_PRODUCT_T_DR035 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_STUDY_PRODUCT_T_DR035 = SUBSTR('I_STUDY_PRODUCT_T_DR035',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
    END IF;
	
--I_STUDY_PRODUCT_T_DR035_VAL  STUDY PRODUCT TYPE:Placebo

	IF cur_att_upd.I_STUDY_PRODUCT_T_DR035_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_STUDY_PRODUCT_T_DR035_EX = SUBSTR('I_STUDY_PRODUCT_T_DR035_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_EX,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_EX,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
    END IF;
	
	
	IF cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL <> '' THEN
	
	           lv_study_prod_type := SUBSTR(cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL,20);
	
	              DECLARE
				  lv_cd_code INT;
				  cur_study_prod_type RECORD;
				  lv_cd_decode VARCHAR(100);
				  lv_test_null INT;
				  BEGIN
				  lv_test_null := NULL;
				  
		FOR cur_study_prod_type IN  SELECT regexp_split_to_table(lv_study_prod_type,'\,+') AS STUDY_PROD_TYPE		  
	
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 8008
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_study_prod_type.STUDY_PROD_TYPE));
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_STUDY_PRODUCT_T_DR035_VAL = '8008:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
					 
		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE 
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_STUDY_PRODUCT_T_DR035_VAL = LTRIM((I_STUDY_PRODUCT_T_DR035_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
					 
		IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_STUDY_PRODUCT_T_DR035_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
			      END IF;
			  
              
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE 'DR035 :%','EXCEPTION  IN 8008 CODELIST';        
            END;
    END IF;
	
	IF cur_att_upd.I_SERIOUSNESS_DR005 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_SERIOUSNESS_DR005 = SUBSTR('I_SERIOUSNESS_DR005',15)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

		  
    END IF;
	
	IF cur_att_upd.I_SERIOUSNESS_DR005_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_SERIOUSNESS_DR005_EX = SUBSTR('I_SERIOUSNESS_DR005_EX',15)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
          
    END IF;

--I_SOURCE_DR026,I_SOURCE_DR026_EX,I_SOURCE_DR026_VAL

	IF cur_att_upd.I_SOURCE_DR026 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_SOURCE_DR026 = SUBSTR('I_SOURCE_DR026',10)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_SOURCE_DR026,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_SOURCE_DR026,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;

    END IF;
	
	IF cur_att_upd.I_SOURCE_DR026_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_SOURCE_DR026_EX = SUBSTR('I_SOURCE_DR026_EX',10)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.I_SOURCE_DR026_VAL <> '' THEN
	
	           lv_source_type := SUBSTR(cur_att_upd.I_SOURCE_DR026_VAL,8);
			   
	--RAISE NOTICE '%','source---'||lv_source_type); 
	              DECLARE
				  lv_cd_code VARCHAR(100);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null INT;
				  cur_source_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_source_type IN  SELECT regexp_split_to_table(lv_source_type,'\,+') AS SOURCE_TYPE

            LOOP
						
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 346
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_source_type.SOURCE_TYPE));
			
			--RAISE NOTICE '%','source code ---'||lv_cd_code||'----------'||lv_cd_decode);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_SOURCE_DR026_VAL = '346:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_SOURCE_DR026_VAL = LTRIM((I_SOURCE_DR026_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
					 
			IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_SOURCE_DR026_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.I_SOURCE_DR026_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
			END IF;
			  
              
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE 'DR026 :%','EXCEPTION  IN 346 CODELIST';        
            END;
    END IF;
	


            IF cur_att_upd.I_EVENT_PT_DR016 <> '' THEN
	        UPDATE C_DISTRIBUTION_RULES_CODE
		          SET I_EVENT_PT_DR016 = SUBSTR('I_EVENT_PT_DR016',12)		  
		          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

            END IF;
			
		IF cur_att_upd.I_EVENT_PT_DR016_EX <> '' THEN
	        UPDATE C_DISTRIBUTION_RULES_CODE
		          SET I_EVENT_PT_DR016_EX = 'DR016_EX'		  
		          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

            END IF;
			
	IF cur_att_upd.I_EVENT_PT_DR016_VAL <> '' THEN
	        UPDATE C_DISTRIBUTION_RULES_CODE
		          SET I_EVENT_PT_DR016_VAL = REPLACE(cur_att_upd.I_EVENT_PT_DR016_VAL,'MedDRA','Meddra')		  
		          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

            END IF;

--U_USER_HEALTH_AUT_DR5001_EX,U_USER_HEALTH_AUT_DR5001_VAL
/*
  IF cur_att_upd.U_USER_HEALTH_AUT_DR5001 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_USER_HEALTH_AUT_DR5001 = SUBSTR('U_USER_HEALTH_AUT_DR5001',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	 IF cur_att_upd.U_USER_HEALTH_AUT_DR5001_EX IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_USER_HEALTH_AUT_DR5001_EX = SUBSTR('U_USER_HEALTH_AUT_DR5001_EX',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF; 
	
	IF cur_att_upd.U_USER_HEALTH_AUT_DR5001_VAL IS NOT NULL THEN
	
	           lv_source_ha_type := SUBSTR(cur_att_upd.U_USER_HEALTH_AUT_DR5001_VAL,8);
	
	              DECLARE
				  lv_cd_code INT;
				  lv_cd_decode VARCHAR(100);
				  lv_test_null INT;
				  cur_source_ha_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
				  
		FOR cur_source_ha_type IN  SELECT regexp_split_to_table(lv_source_ha_type,'\,+') AS SOURCE_HA_TYPE
		
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 346
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_source_ha_type.SOURCE_HA_TYPE));
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_HEALTH_AUT_DR5001_VAL = '346:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_HEALTH_AUT_DR5001_VAL = LTRIM((U_USER_HEALTH_AUT_DR5001_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF;            
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 346 Health authority CODELIST');        
            END;
    END IF;
	
--I_QUALIFICATION_DR042,I_QUALIFICATION_DR042_EX,I_QUALIFICATION_DR042_VAL

			IF cur_att_upd.I_QUALIFICATION_DR042 IS NOT NULL THEN
	         UPDATE C_DISTRIBUTION_RULES_CODE
		      SET I_QUALIFICATION_DR042 = SUBSTR('I_QUALIFICATION_DR042',17)		  
		      WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	 IF cur_att_upd.I_QUALIFICATION_DR042_EX IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_QUALIFICATION_DR042_EX = SUBSTR('I_QUALIFICATION_DR042_EX',17)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF; 
	
	IF cur_att_upd.I_QUALIFICATION_DR042_VAL IS NOT NULL THEN
	
	           lv_repor_qua_type := SUBSTR(cur_att_upd.I_QUALIFICATION_DR042_VAL,15);--REPORTER_TYPE:Phy,HP,Phrama
	
	              DECLARE
				  lv_cd_code INT;
				  lv_cd_decode VARCHAR(100);
				  lv_test_null INT;
				  cur_repor_qua_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
				  
		FOR cur_repor_qua_type IN  SELECT regexp_split_to_table(lv_repor_qua_type,'\,+') AS REPOR_QUA_TYPE
		
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1003
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_repor_qua_type.REPOR_QUA_TYPE));
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_QUALIFICATION_DR042_VAL = '1003:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_QUALIFICATION_DR042_VAL = LTRIM((I_QUALIFICATION_DR042_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF;            
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE 'DR042 :%','EXCEPTION  IN 1003 Reporter Qualification CODELIST');        
            END;
    END IF;
	
	IF cur_att_upd.U_USER_PSC_COD_DR5003 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_USER_PSC_COD_DR5003 = SUBSTR('U_USER_PSC_COD_DR5003',16)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  

    END IF;
	
	IF cur_att_upd.U_USER_PSC_COD_DR5003_VAL IS NOT NULL THEN
	
	           lv_psc_cod_cnr_type := SUBSTR(cur_att_upd.U_USER_PSC_COD_DR5003_VAL,13);--E2B COUNTRY:ARGENTINA
			   
			   --RAISE NOTICE '%','psc or cod---'||lv_psc_cod_cnr_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_psc_cod_cnr_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
				  
		FOR cur_psc_cod_cnr_type IN  SELECT regexp_split_to_table(lv_psc_cod_cnr_type,'\,+') AS PSC_COD_CNR_TYPE

            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_psc_cod_cnr_type.PSC_COD_CNR_TYPE));
			
			--RAISE NOTICE '%','psc or cod---'||lv_cd_code;
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_PSC_COD_DR5003_VAL = '1015:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_PSC_COD_DR5003_VAL = LTRIM((U_USER_PSC_COD_DR5003_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE 'DR5003 :%','EXCEPTION  IN 1015 psc or cod CODELIST';        
            END;
    END IF;
		
	IF cur_att_upd.U_PSC_OR_COD_IN_E_DR5003_1 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_OR_COD_IN_E_DR5003_1 = SUBSTR('U_PSC_OR_COD_IN_E_DR5003_1',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.U_PSC_OR_COD_NOT_DR5003_2 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_OR_COD_NOT_DR5003_2 = SUBSTR('U_PSC_OR_COD_NOT_DR5003_2',18)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.U_PSC_AND_COD_NOT_DR5003_3 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_AND_COD_NOT_DR5003_3 = SUBSTR('U_PSC_AND_COD_NOT_DR5003_3',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.U_PSC_OR_COD_IN_E_DR5003_4 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_OR_COD_IN_E_DR5003_4 = SUBSTR('U_PSC_OR_COD_IN_E_DR5003_4',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.U_PSC_OR_COD_IN_E_DR5003_5 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_OR_COD_IN_E_DR5003_5 = SUBSTR('U_PSC_OR_COD_IN_E_DR5003_5',19)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	IF cur_att_upd.U_PSC_OR_COD_NOT_DR5003_6 IS NOT NULL THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_PSC_OR_COD_NOT_DR5003_6 = SUBSTR('U_PSC_OR_COD_NOT_DR5003_6',18)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
*/	
--I_PROTOCOL_NO_DR003,I_PROTOCOL_NO_DR003_EX,I_PROTOCOL_NO_DR003_VAL,


	IF cur_att_upd.I_PRODUCT_SERIOUS_DR028 <> '' THEN
	   UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRODUCT_SERIOUS_DR028 = SUBSTR('I_PRODUCT_SERIOUS_DR028',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
    END IF;
	
	IF cur_att_upd.I_PRODUCT_SERIOUS_DR028_VAL <> '' THEN
	   
--------------------------------------------------------------------------------------------------------------		  
DECLARE
lv_rel_prod_rec_id VARCHAR(1000);
lv_rel_trade_rec_id VARCHAR(1000);
lv_ser VARCHAR(1000);
lv_prod VARCHAR(1000);
lv_lab VARCHAR(1000);
lv_cntry VARCHAR(1000);
LV_VALUE VARCHAR(1000);
dr028_ser VARCHAR(1000);
dr028_prod VARCHAR(1000);
dr028_lab VARCHAR(100);
dr028_country VARCHAR(2000);
cur_prod_ser_rel RECORD;
l_context TEXT;
dr_final VARCHAR(1000) := '';
lv_cd_code VARCHAR(100);
lv_cd_decode VARCHAR(100);
BEGIN
LV_VALUE:= cur_att_upd.I_PRODUCT_SERIOUS_DR028_VAL;

FOR cur_prod_ser_rel IN  SELECT regexp_split_to_table(LV_VALUE,'\/+') AS PROD_SER_REL

LOOP

IF UPPER(TRIM(cur_prod_ser_rel.PROD_SER_REL)) LIKE UPPER(TRIM('Seriousness%')) THEN

  lv_ser := SUBSTR(cur_prod_ser_rel.PROD_SER_REL,13);
  
  SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1002
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(lv_ser));
			
	dr028_ser := '1002:'||lv_cd_code;

ELSIF
  UPPER(cur_prod_ser_rel.PROD_SER_REL) LIKE UPPER('Product%') THEN
  
    lv_prod := SUBSTR(cur_prod_ser_rel.PROD_SER_REL,9);
	
	DECLARE
		  cur_usr_prod RECORD;
		  lv_test_null VARCHAR(1000);
		  lv_cnt int;
	      BEGIN
		  
		     lv_test_null := NULL;
	FOR cur_usr_prod IN  SELECT regexp_split_to_table(lv_prod,'\^+') AS USR_PROD

            LOOP
			     
                 BEGIN
				 
				 SELECT COUNT(*) INTO lv_cnt
                 FROM lsmv_product
                 WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 IF lv_cnt = 0 THEN
				   RAISE NOTICE 'PRODUCT MISSING IN DR028:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||cur_usr_prod.USR_PROD;
				 
				 ELSIF lv_cnt = 1 THEN
				 
                 SELECT RECORD_ID INTO STRICT lv_rel_prod_rec_id
                 FROM lsmv_product
                 WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 ELSE
				   SELECT STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),',') INTO STRICT lv_rel_prod_rec_id
                   FROM lsmv_product
                   WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 END IF;

				 
		IF (lv_rel_prod_rec_id IS NOT NULL AND lv_test_null IS NULL) THEN

		     dr028_prod:= 'Product:'||lv_rel_prod_rec_id;
		     lv_test_null := lv_rel_prod_rec_id;
			  ELSE
             dr028_prod = LTRIM((dr028_prod||','||lv_rel_prod_rec_id),',');

        END IF;	

        	
       
            EXCEPTION 
            WHEN OTHERS THEN 
   			RAISE NOTICE '%',' DR028 product not found';
            END;
		  
            END LOOP;      
			lv_test_null := NULL;	
		  END;
  
ELSIF

UPPER(TRIM(cur_prod_ser_rel.PROD_SER_REL)) LIKE UPPER(TRIM('Labled%')) OR UPPER(TRIM(cur_prod_ser_rel.PROD_SER_REL)) LIKE UPPER(TRIM('Listed%')) THEN

  lv_lab := SUBSTR(cur_prod_ser_rel.PROD_SER_REL,8);
  
  SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 9159
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(lv_lab));
			
	dr028_lab := '9159:'||lv_cd_code;
	
ELSIF
UPPER(cur_prod_ser_rel.PROD_SER_REL) LIKE UPPER('%COUNTRY%') THEN
	lv_cntry := SUBSTR(cur_prod_ser_rel.PROD_SER_REL,13);
	
	DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_rel_cntry RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_rel_cntry IN  SELECT regexp_split_to_table(lv_cntry,'\^+') AS REL_CNTRY
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_rel_cntry.REL_CNTRY));
			
			IF lv_cd_code IS NULL
			THEN 
				SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
				FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
				WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
				AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
				AND CD.LANGUAGE_CODE = 'en'
				AND CN.CODELIST_ID = 9744
				AND CC.CODE_STATUS='1'
				AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_rel_cntry.REL_CNTRY));
			
			END IF;
			

              IF lv_test_null IS NULL THEN
				     
		             dr028_country := '1015:'||lv_cd_code;		-- chnaged on 16/09/2022  
		                           
			  lv_test_null := lv_cd_code;
			  ELSE

		        dr028_country := LTRIM((dr028_country||','||lv_cd_code),',');	  
			
			  END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN Labled COUNTRY 1015 CODELIST';        
            END;
	
END IF;


END LOOP;
--RAISE NOTICE '1-----------%',dr028_ser;
--RAISE NOTICE '2-----------%',dr028_prod;
--RAISE NOTICE '3-----------%',dr028_lab;
--RAISE NOTICE '4-----------%',dr028_country;

IF dr028_ser IS NOT NULL THEN
dr_final := dr028_ser;
END IF;
IF dr028_prod IS NOT NULL THEN
dr_final := dr_final||'/'||dr028_prod;
END IF;
IF dr028_lab IS NOT NULL THEN
dr_final := dr_final||'/'||dr028_lab;
END IF;
IF dr028_country IS NOT NULL THEN
dr_final := dr_final||'/'||dr028_country;
END IF;


--dr_final := dr028_ser||'/'||dr028_prod||'/'||dr028_lab||'/'||dr028_country;

dr_final := LTRIM(dr_final,'/');


--RAISE NOTICE '5-----------%',dr_final;
          UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRODUCT_SERIOUS_DR028_VAL = dr_final
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

EXCEPTION 
WHEN OTHERS THEN
    RAISE NOTICE 'EXCEPTION :%', 'EXCEPTION  in DR028 Atribute';
END;	

          	   
------------------------------------------------------------------------------------------------------------------		   
	           
    END IF;
	
	IF  cur_att_upd.I_PRD_SERIOUS_RLT_DR028_1 <> '' THEN
	   UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRD_SERIOUS_RLT_DR028_1 = 'DR028_1'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
    END IF;
	
	IF  cur_att_upd.I_PRD_SERIOUS_RLT_DR028_2 <> '' THEN
	   UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRD_SERIOUS_RLT_DR028_2 = 'DR028_2'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
    END IF;
	
	IF  cur_att_upd.I_PRD_SERIOUS_RLT_DR028_3 <> '' THEN
	   UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRD_SERIOUS_RLT_DR028_3 = 'DR028_3'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
    END IF;
	
	IF cur_att_upd.I_PRD_SERIOUS_RLT_DR028_4 <> '' THEN
	   UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRD_SERIOUS_RLT_DR028_4 = 'DR028_4'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
    END IF;


	 	
/*
     IF cur_att_upd.I_APPROVAL_NO_DR0042 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_APPROVAL_NO_DR0042 = SUBSTR('I_APPROVAL_NO_DR0042',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF; 
	
	IF cur_att_upd.I_APPROVAL_NO_DR0042_VAL IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_APPROVAL_NO_DR0042_VAL = cur_att_upd.I_APPROVAL_NO_DR0042_VAL
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;
			
	IF cur_att_upd.I_APPROVAL_TYPE_DR0043 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_APPROVAL_TYPE_DR0043 = SUBSTR('I_APPROVAL_TYPE_DR0043',17)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	

    IF cur_att_upd.I_APPROVAL_TYPE_DR0043_VAL IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_APPROVAL_TYPE_DR0043_VAL = cur_att_upd.I_APPROVAL_TYPE_DR0043_VAL
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;			
*/
/*			
	 IF cur_att_upd.U_USER_CONGENTIAL_DR5006 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_CONGENTIAL_DR5006 = SUBSTR('U_USER_CONGENTIAL_DR5006',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;			

		
     IF cur_att_upd.U_USER_PRODUCT_DR5005 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_PRODUCT_DR5005 = SUBSTR('U_USER_PRODUCT_DR5005',16)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	

     IF cur_att_upd.U_USER_PRODUCT_DR5005_EX IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_PRODUCT_DR5005_EX = SUBSTR('U_USER_PRODUCT_DR5005_EX',16)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	
*/

/*
       IF cur_att_upd.I_REP_RECEI_MED_DR043 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_REP_RECEI_MED_DR043 = SUBSTR('I_REP_RECEI_MED_DR043',17)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	

--I_REP_RECEI_MED_DR043_VAL	need to discuss	

        IF cur_att_upd.I_REP_RECEI_MED_DR043_VAL IS NOT NULL THEN
	
	           lv_rep_med_type := SUBSTR(cur_att_upd.I_REP_RECEI_MED_DR043_VAL,15);--reporter_type:Lawsuit

			   
			   --RAISE NOTICE '%','report receiving medium---'||lv_rep_med_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_rep_med_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_rep_med_type IN  SELECT regexp_split_to_table(lv_rep_med_type,'\,+') AS REP_MED_TYPE

            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 501
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_rep_med_type.REP_MED_TYPE));
			
			--RAISE NOTICE '%','report receiving medium---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REP_RECEI_MED_DR043_VAL = '501:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REP_RECEI_MED_DR043_VAL = LTRIM((I_REP_RECEI_MED_DR043_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 501 report receiving medium CODELIST');        
            END;
    END IF;
	*/
/*
       IF cur_att_upd.U_USER_PRODUCT_DR5005_VAL IS NOT NULL THEN
		  
		  lv_usr_prod := SUBSTR(cur_att_upd.U_USER_PRODUCT_DR5005_VAL,9);
		  DECLARE
		  cur_usr_prod RECORD;
	      BEGIN
		  
	FOR cur_usr_prod IN  SELECT regexp_split_to_table(lv_usr_prod,'\,+') AS USR_PROD

            LOOP
                 BEGIN
                 SELECT RECORD_ID INTO STRICT lv_prod_rec_id
                 FROM lsmv_product
                 WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
       
            EXCEPTION 
            WHEN OTHERS THEN 
                        BEGIN
                        SELECT RECORD_ID INTO STRICT lv_trade_rec_id
                        FROM LSMV_PRODUCT_TRADENAME 
                        WHERE UPPER(TRIM(LOCAL_TRADENAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD)) ;
						EXCEPTION
						WHEN OTHERS THEN
						   RAISE NOTICE '%','product not found';
						END;
                END;
				
		IF lv_prod_rec_id IS NOT NULL THEN
		  UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_USER_PRODUCT_DR5005_VAL = 'Product:'||lv_prod_rec_id		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		         
		  IF NOT FOUND THEN
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.U_USER_PRODUCT_DR5005_VAL,'UPDATE FAIL',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          ELSE
          INSERT INTO ATTRIBUTE_STATUS VALUES(cur_att_upd.U_USER_PRODUCT_DR5005_VAL,'UPDATE PASS',cur_att_upd.CONTACT_NAME,cur_att_upd.FORMAT,cur_att_upd.DISPLAY_NAME);
          END IF;
		  
		  ELSE
		  UPDATE C_DISTRIBUTION_RULES_CODE
		  SET U_USER_PRODUCT_DR5005_VAL = 'Product:'||lv_trade_rec_id		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
		  
		  END IF;
            END LOOP;      
			
		  END;
	           
            END IF;	
		
		
     IF cur_att_upd.U_USER_SPONSOR_IS_DR5007 IS NOT NULL THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_SPONSOR_IS_DR5007 = SUBSTR('U_USER_SPONSOR_IS_DR5007',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
	        SELECT CC.CODE INTO lv_iss_code
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 346
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM('Investigator initiated study'));
			
               UPDATE C_DISTRIBUTION_RULES_CODE
                   SET U_USER_SPONSOR_IS_DR5007_VAL = '346:'||lv_iss_code
		           WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;		
*/			
/*

I_PRODUCT_APPROVAL_DR044  VARCHAR(1000),
I_PRODUCT_APPROVAL_DR044_VAL  VARCHAR(1000),
*/


	IF cur_att_upd.I_AESI_DR034 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_AESI_DR034 = SUBSTR('I_AESI_DR034',8)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

		  
    END IF;
	
	IF cur_att_upd.I_AESI_DR034_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_AESI_DR034_EX = SUBSTR('I_AESI_DR034_EX',8)		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
          
    END IF;


IF cur_att_upd.I_NON_CASE_DR021 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_NON_CASE_DR021 = 'DR021'		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;
	
	IF  cur_att_upd.I_NON_CASE_DR021_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_NON_CASE_DR021_EX = 'DR021_EX'		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
			
	IF  cur_att_upd.I_CASE_SIGNIFICAN_DR022 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_CASE_SIGNIFICAN_DR022 = SUBSTR('I_CASE_SIGNIFICAN_DR022',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  
	END IF;	  


	IF cur_att_upd.I_CASE_SIGNIFICAN_DR022_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_CASE_SIGNIFICAN_DR022_EX = SUBSTR('I_CASE_SIGNIFICAN_DR022_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  
		  
	IF  cur_att_upd.I_CASE_SIGNIFICAN_DR022_VAL <> '' THEN
	
	           lv_case_sig_type := SUBSTR(cur_att_upd.I_CASE_SIGNIFICAN_DR022_VAL,19);--LST CASE_SIGNIFICANCE:Non-Significant (Not reportable)    Case Significance:Significant (Reportable)

			   
			   --RAISE NOTICE '%','case significance---'||lv_case_sig_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_case_sig_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
				  
		FOR cur_case_sig_type IN  SELECT regexp_split_to_table(lv_case_sig_type,'\,+') AS CASE_SIG_TYPE
		
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 9605
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_case_sig_type.CASE_SIG_TYPE));
			
			--RAISE NOTICE '%','case significance---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_CASE_SIGNIFICAN_DR022_VAL = '9605:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_CASE_SIGNIFICAN_DR022_VAL = LTRIM((I_CASE_SIGNIFICAN_DR022_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 9605 case significance CODELIST';        
            END;
    END IF;	  
	
    	IF  cur_att_upd.I_IDENTIFIABLE_PA_DR018 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_IDENTIFIABLE_PA_DR018 = SUBSTR('I_IDENTIFIABLE_PA_DR018',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;

	IF  cur_att_upd.I_IDENTIFIABLE_PA_DR018_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_IDENTIFIABLE_PA_DR018_EX = SUBSTR('I_IDENTIFIABLE_PA_DR018_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  

    IF  cur_att_upd.I_COUNTRY_OF_DETE_DR001 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_COUNTRY_OF_DETE_DR001 = SUBSTR('I_COUNTRY_OF_DETE_DR001',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

        END IF;
	IF  cur_att_upd.I_COUNTRY_OF_DETE_DR001_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_COUNTRY_OF_DETE_DR001_EX = SUBSTR('I_COUNTRY_OF_DETE_DR001_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  
		  
	IF  cur_att_upd.I_COUNTRY_OF_DETE_DR001_VAL <> '' THEN
	
	           lv_psc_cntry_type := SUBSTR(cur_att_upd.I_COUNTRY_OF_DETE_DR001_VAL,13); 

			   
			   --RAISE NOTICE '%','E2B country---'||lv_psc_cntry_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_psc_cntry_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_psc_cntry_type IN  SELECT replace(regexp_split_to_table(lv_psc_cntry_type,'\^+'),',',', ') AS PSC_CNTRY_TYPE -- Added replace for "KOREA,REPUBLIC OF"
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_psc_cntry_type.PSC_CNTRY_TYPE));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_COUNTRY_OF_DETE_DR001_VAL = '1015:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_COUNTRY_OF_DETE_DR001_VAL = LTRIM((I_COUNTRY_OF_DETE_DR001_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 1015 CODELIST';        
            END;
    END IF;
	
	
	IF  cur_att_upd.i_product_approva_dr044 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET i_product_approva_dr044 = 'DR044'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  
	
	IF  cur_att_upd.i_product_approva_dr044_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET i_product_approva_dr044_EX = 'DR044_EX'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  

IF  cur_att_upd.i_product_approva_dr044 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET i_product_approva_dr044 = 'DR044'
          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;   
    
    IF  cur_att_upd.i_product_approva_dr044_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET i_product_approva_dr044_EX = 'DR044_EX'
          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;   

IF cur_att_upd.i_product_approva_dr044_VAL <> '' THEN
DECLARE
LV_VALUE VARCHAR(1000);
lv_approval_type varchar(1000);
lv_country varchar(1000);
lv_mah varchar(1000);
dr044_mah VARCHAR(1000);
dr044_approvaltype VARCHAR(1000);
dr044_country VARCHAR(1000);
cur_prod_apprvl RECORD;
l_context TEXT;
dr_final VARCHAR(1000) := '';
lv_cd_code VARCHAR(100);
lv_cd_decode VARCHAR(100);
lv_mah_name VARCHAR(1000);
lv_prod_char VARCHAR(1000);
dr044_prod_char VARCHAR(1000);
BEGIN
LV_VALUE:= cur_att_upd.i_product_approva_dr044_VAL;
FOR cur_prod_apprvl IN  SELECT regexp_split_to_table(LV_VALUE,'\/+') AS prod_apprvl
LOOP
 

IF UPPER(TRIM(cur_prod_apprvl.prod_apprvl)) LIKE UPPER(TRIM('Approval%')) THEN
  lv_approval_type := SUBSTR(cur_prod_apprvl.prod_apprvl,15);
  DECLARE
		lv_cd_code VARCHAR(1000);
		lv_cd_decode VARCHAR(100);
		lv_test_null VARCHAR(1000);
		cur_prod_apptype RECORD;
		Lv_prd_flg_val VARCHAR(4000);
		BEGIN
		lv_test_null := NULL;
  FOR cur_prod_apptype IN  SELECT regexp_split_to_table(lv_approval_type,'\,+') AS APP_TYPE
        LOOP
 
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 709
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_prod_apptype.APP_TYPE));
 
            IF lv_test_null IS NULL 
			THEN			
			dr044_approvaltype := '709:'||lv_cd_code;
			lv_test_null := lv_cd_code;
			ELSE
			    dr044_approvaltype := dr044_approvaltype||','||lv_cd_code;
			END IF;
			END LOOP;      
		lv_test_null := NULL;
		EXCEPTION 
		WHEN OTHERS 
		THEN 
			RAISE NOTICE '%','EXCEPTION  IN 709 CODELIST';        
		END;

   ELSIF  UPPER(cur_prod_apprvl.prod_apprvl) LIKE UPPER('E2B Country%') THEN
		   lv_country := SUBSTR(cur_prod_apprvl.prod_apprvl,13);
		DECLARE
		lv_cd_code VARCHAR(1000);
		lv_cd_decode VARCHAR(100);
		lv_test_null VARCHAR(1000);
		cur_prod_country RECORD;
		Lv_prd_flg_val VARCHAR(4000);
		BEGIN
		lv_test_null := NULL;
  FOR cur_prod_country IN  SELECT regexp_split_to_table(lv_country,'\^+') AS country
        LOOP
 
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			--AND UPPER(TRIM(CD.DECODE)) = replace(UPPER(TRIM(cur_prod_country.country)),',',', ');
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_prod_country.country));
IF lv_test_null IS NULL 
			THEN			
			dr044_country := '1015:'||lv_cd_code;
			lv_test_null := lv_cd_code;
			ELSE
			    dr044_country := dr044_country||','||lv_cd_code;
			END IF;
			END LOOP;      
		lv_test_null := NULL;
		EXCEPTION 
		WHEN OTHERS 
		THEN 
			RAISE NOTICE '%','EXCEPTION  IN 1015 CODELIST';        
		END;     
		
		ELSIF UPPER(TRIM(cur_prod_apprvl.prod_apprvl)) LIKE UPPER(TRIM('Product%')) THEN

				lv_prod_char := SUBSTR(cur_prod_apprvl.prod_apprvl,26); --Product Characterization:Suspect
				
			
		DECLARE
		
		lv_cd_code VARCHAR(1000);
		lv_cd_decode VARCHAR(100);
		lv_test_null VARCHAR(1000);
		cur_prod_char RECORD;
		Lv_prd_final_val VARCHAR(4000);
		BEGIN
		
				lv_test_null := NULL;

		FOR cur_prod_char IN select regexp_split_to_table(lv_prod_char,'\,+') AS prod_char
		LOOP
			
			--RAISE NOTICE '%', lv_prod_char;
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1013
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_prod_char.prod_char));
			
--			RAISE NOTICE '1.%',lv_cd_code ;
--			RAISE NOTICE '2.%', lv_prod_char;

			--RAISE NOTICE '3.%',lv_prod_char; 
			
			
		
			 IF lv_test_null IS NULL  THEN
			 
									--RAISE NOTICE '4.%',lv_prod_char; 

			 
				dr044_prod_char := '1013:'||lv_cd_code;
--			RAISE NOTICE '5.%',lv_prod_char; 

				lv_test_null := lv_cd_code;
				
--			RAISE NOTICE '6.%',lv_prod_char; 

			ELSE
--						RAISE NOTICE '7.%',lv_prod_char; 

			    dr044_prod_char := dr044_prod_char||','||lv_cd_code;
--			RAISE NOTICE '8.%',lv_prod_char; 

			END IF;
--			RAISE NOTICE '9.%',lv_prod_char; 

			
		END LOOP;   

--			RAISE NOTICE '10.%',lv_prod_char; 

	
		lv_test_null := NULL;
		
		
---					raise NOTICE 'Before Exception block %',dr044_prod_char;

	
		EXCEPTION 
		WHEN OTHERS 
		THEN 
		
			RAISE NOTICE '%','EXCEPTION  IN 1013 CODELIST';   
			--raise notice '%',dr044_prod_char;

		END; 
		
		
		
		
		

		ELSIF  UPPER(cur_prod_apprvl.prod_apprvl) LIKE UPPER('mah%') THEN
        lv_mah := SUBSTR(cur_prod_apprvl.prod_apprvl,5);
        DECLARE
		lv_cd_code VARCHAR(1000);
		lv_cd_decode VARCHAR(100);
		lv_test_null VARCHAR(1000);
		CUR_MAH_VAL RECORD;
		lv_cnt int;
		lv_mah_record_name varchar(1000);
		lv_test2_null varchar(1000);
		lv_acc_cnt int;
		BEGIN
		lv_test_null := NULL;
 

			 FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
 

            LOOP
			      --BEGIN
				 SELECT COUNT(*) INTO lv_cnt
                 FROM lsmv_partner
                 WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 IF lv_cnt = 0 THEN
				   RAISE NOTICE 'MAH MISSING IN DR044:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||cur_usr_prod.USR_PROD;
				 ELSIF lv_cnt = 1 THEN
 
                 SELECT name INTO STRICT lv_mah_record_name
                 FROM lsmv_partner
                 WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
 
 
				 ELSE
				   SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name
                   FROM lsmv_partner
                   WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 END IF;
				 --END;
				 IF lv_test_null IS NULL THEN
				 dr044_mah := 'CU_ACC:'||lv_mah_record_name;
				 END IF;
/*                       IF (lv_mah_record_id IS NOT NULL and lv_test_null IS NULL) THEN
                                lv_test_null := 'CU_ACC:'||lv_mah_record_id;
                                dr5009_mah := 'CU_ACC:'||lv_mah_record_id;
                            ELSE
                                dr5009_mah := LTRIM((dr5009_mah||','||lv_mah_record_id),',');
                            END IF; */
         END LOOP;
            EXCEPTION 
            WHEN OTHERS THEN 
                       raise notice '%','DR044-1 ACCOUNT not found'; 
			FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
LOOP			
				BEGIN
				SELECT COUNT(*) INTO lv_acc_cnt
                 FROM lsmv_accounts
                 WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 IF lv_acc_cnt = 0 THEN
				   RAISE NOTICE 'MAH ACCOUNT MISSING IN DR044:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||cur_usr_prod.USR_PROD;
				 ELSIF lv_acc_cnt = 1 THEN
 
                 SELECT account_name INTO STRICT lv_mah_record_name
                 FROM lsmv_accounts
                 WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
 
				 ELSE
				   SELECT STRING_AGG(TRIM(TO_CHAR(account_name,'XXXXXXXXXXXXXXXXX')),',') INTO STRICT lv_mah_record_name
                   FROM lsmv_accounts
                   WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 END IF;
				 				 IF lv_test_null IS NULL THEN
				 dr044_mah := 'CU_ACC:'||lv_mah_record_name;
				 END IF;
/*                       IF (lv_mah_record_id IS NOT NULL and lv_test_null IS NULL) 
                            THEN
                                lv_test_null := 'CU_ACC:'||lv_mah_record_id;
                                dr5009_mah := 'CU_ACC:'||lv_mah_record_id;
                            ELSE
                                dr5009_mah := LTRIM((dr5009_mah||','||lv_mah_record_id),',');
                            END IF; */
			exception 
			when others then
			raise notice '%','DR044-2 ACCOUNT not found';
			raise notice '%',SQLERRM;
			end;
			END LOOP;
            END;
            --END LOOP;      
			--lv_test_null := NULL;	
		-- END;
		END IF;
END LOOP;
 

IF dr044_mah IS NOT NULL THEN
dr_final := dr_final||'/'||dr044_mah;
END IF;
--raise notice '%',dr_final;
IF dr044_approvaltype IS NOT NULL THEN
dr_final := dr_final||'/'||dr044_approvaltype;
END IF;
IF dr044_country IS NOT NULL THEN
dr_final := dr_final||'/'||dr044_country;
END IF;
IF dr044_prod_char IS NOT NULL THEN
dr_final := dr_final||'/'||dr044_prod_char;
END IF;
dr_final := LTRIM(dr_final,'/');

--RAISE NOTICE '5-----------%',dr_final;
          UPDATE C_DISTRIBUTION_RULES_CODE
		  SET i_product_approva_dr044_VAL = dr_final
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
EXCEPTION 
WHEN OTHERS THEN
    RAISE NOTICE 'EXCEPTION :%', 'EXCEPTION  in DR044 Atribute';
END;	
 

END IF;	
 

-------------------- For Amgen START----------------------------------------------


    IF  cur_att_upd.I_PROD_APP_CON_CP_DR031 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_PROD_APP_CON_CP_DR031 = SUBSTR('I_PROD_APP_CON_CP_DR031',20)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	
	
	IF cur_att_upd.I_PROD_APP_CON_CP_DR031_VAL <> '' THEN
	
	lv_prod_app_con_cpd := SUBSTR(cur_att_upd.I_PROD_APP_CON_CP_DR031_VAL,23);--Authorization Country:Lebanon
                  
				  DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_prod_app_con_cpd RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_prod_app_con_cpd IN  SELECT regexp_split_to_table(lv_prod_app_con_cpd,'\^+') AS PROD_APP_CON_CPD
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_prod_app_con_cpd.PROD_APP_CON_CPD));
			
			
			IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_PROD_APP_CON_CP_DR031_VAL = '1015:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_PROD_APP_CON_CP_DR031_VAL = LTRIM((I_PROD_APP_CON_CP_DR031_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 1015 CODELIST FOR PROD APP CON CPD ATTRIBUTE';        
            END;
	END IF;

	 IF  cur_att_upd.I_IS_HCP_DR014 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_IS_HCP_DR014 = SUBSTR('I_IS_HCP_DR014',10)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
/*	
	IF cur_att_upd.I_NON_AE_CASE_DR025 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_NON_AE_CASE_DR025 = SUBSTR('I_NON_AE_CASE_DR025',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_NON_AE_CASE_DR025_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_NON_AE_CASE_DR025_EX = SUBSTR('I_NON_AE_CASE_DR025_EX',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
*/	
	IF cur_att_upd.I_CODEBROKEN_DR015 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_CODEBROKEN_DR015 = SUBSTR('I_CODEBROKEN_DR015',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.I_CODEBROKEN_DR015_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_CODEBROKEN_DR015_EX = SUBSTR('I_CODEBROKEN_DR015_EX',14)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_CODEBROKEN_DR015_VAL <> '' THEN
                  
		lv_code_broken := SUBSTR(cur_att_upd.I_CODEBROKEN_DR015_VAL,13);--Codebroken:Code broken	  
		-- RAISE NOTICE '%','lv_code_broken' || lv_code_broken ; 		  
		DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_code_broken RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_code_broken IN  SELECT regexp_split_to_table(lv_code_broken,'\,+') AS CODE_BROKEN
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 54
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_code_broken.CODE_BROKEN));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_CODEBROKEN_DR015_VAL = '54:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_CODEBROKEN_DR015_VAL = LTRIM((I_CODEBROKEN_DR015_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 54 CODELIST';        
            END;		  
	END IF;
	
	IF cur_att_upd.I_PRIMARY_SOURCE_DR002 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_PRIMARY_SOURCE_DR002 = SUBSTR('I_PRIMARY_SOURCE_DR002',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

        END IF;
	IF cur_att_upd.I_PRIMARY_SOURCE_DR002_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_PRIMARY_SOURCE_DR002_EX = SUBSTR('I_PRIMARY_SOURCE_DR002_EX',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  
		  
	IF cur_att_upd.I_PRIMARY_SOURCE_DR002_VAL <> '' THEN
	
	           lv_prm_src_cntry := SUBSTR(cur_att_upd.I_PRIMARY_SOURCE_DR002_VAL,13);--E2B COUNTRY:Denmark

			   
			   --RAISE NOTICE '%','E2B country---'||lv_psc_cntry_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_prm_src_cntry RECORD;
				  BEGIN
				  lv_test_null := NULL;
				  
		lv_prm_src_cntry := replace(lv_prm_src_cntry,',',', ');
		
		FOR cur_prm_src_cntry IN  SELECT regexp_split_to_table(lv_prm_src_cntry,'\^+') AS PRM_SRC_CNTRY
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_prm_src_cntry.PRM_SRC_CNTRY));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_PRIMARY_SOURCE_DR002_VAL = '1015:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_PRIMARY_SOURCE_DR002_VAL = LTRIM((I_PRIMARY_SOURCE_DR002_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN PRIMARY SOURCE COUNTRY 1015 CODELIST';        
            END;
    END IF;
	
		IF  cur_att_upd.I_REPORT_TYPE_DR027 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_REPORT_TYPE_DR027 = SUBSTR('I_REPORT_TYPE_DR027',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

        END IF;
	IF  cur_att_upd.I_REPORT_TYPE_DR027_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_REPORT_TYPE_DR027_EX = SUBSTR('I_REPORT_TYPE_DR027_EX',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	  
		  
	IF  cur_att_upd.I_REPORT_TYPE_DR027_VAL <> '' THEN
--Report_type:Report from study/Study_type:Clinical Trials
				IF DR_REGEXP_COUNT(cur_att_upd.I_REPORT_TYPE_DR027_VAL,'/') > 0
				THEN 
			        lv_report_type := TRIM(SUBSTR(SUBSTR(cur_att_upd.I_REPORT_TYPE_DR027_VAL,1,POSITION('/' in cur_att_upd.I_REPORT_TYPE_DR027_VAL)),13),'/');
			    	lv_study_type1 := SUBSTR(SUBSTR(cur_att_upd.I_REPORT_TYPE_DR027_VAL,POSITION('/' in cur_att_upd.I_REPORT_TYPE_DR027_VAL)+1),12);
				ELSE 
					lv_report_type := SUBSTR(cur_att_upd.I_REPORT_TYPE_DR027_VAL,13);
					lv_study_type1 := NULL;
				END IF;

			   
			   --RAISE NOTICE '%','E2B country---'||lv_psc_cntry_type);
	        IF lv_report_type IS NOT NULL THEN
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_report_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_report_type IN  SELECT regexp_split_to_table(lv_report_type,'\,+') AS L_REPORT_TYPE
		
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1001
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_report_type.L_REPORT_TYPE));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REPORT_TYPE_DR027_VAL = '1001:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REPORT_TYPE_DR027_VAL = LTRIM((I_REPORT_TYPE_DR027_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN report type 1001 CODELIST';        
            END;
			
        END IF;
		
		 IF lv_study_type1 IS NOT NULL THEN
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_study_type RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_study_type IN  SELECT regexp_split_to_table(lv_study_type1,'\,+') AS L_STUDY_TYPE
		
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1004
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_study_type.L_STUDY_TYPE));
			
			
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REPORT_TYPE_DR027_VAL = I_REPORT_TYPE_DR027_VAL||'/'||'1004:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_REPORT_TYPE_DR027_VAL = LTRIM((I_REPORT_TYPE_DR027_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN study type 1004 CODELIST';        
            END;
			
		END IF;
		
    END IF;
	
	IF  cur_att_upd.I_LABELEDNESS_DR007 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_DR007 = SUBSTR('I_LABELEDNESS_DR007',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

        END IF;
		/*
	IF  cur_att_upd.I_LABELEDNESS_DR007_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_DR007_EX = SUBSTR('I_LABELEDNESS_DR007_EX',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	*/
	
		IF  cur_att_upd.I_LABELEDNESS_DR007_VAL <> '' THEN
	
	           lv_label_cntry := SUBSTR(cur_att_upd.I_LABELEDNESS_DR007_VAL,9);--COUNTRY:

			   
			   --RAISE NOTICE '%','E2B country---'||lv_psc_cntry_type);
	
	              DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_label_cntry RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_label_cntry IN  SELECT regexp_split_to_table(lv_label_cntry,'\,+') AS LABEL_CNTRY
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 1015
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_label_cntry.LABEL_CNTRY));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_LABELEDNESS_DR007_VAL = '1015:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET I_LABELEDNESS_DR007_VAL = LTRIM((I_LABELEDNESS_DR007_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN labelled country 1015 CODELIST';        
            END;
    END IF;
	
	IF  cur_att_upd.I_LABELEDNESS_Lab_DR007_5 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Lab_DR007_5 = SUBSTR('I_LABELEDNESS_Lab_DR007_5',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_LABELEDNESS_Non_DR007_3 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Non_DR007_3 = SUBSTR('I_LABELEDNESS_Non_DR007_3',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;	
	
	IF  cur_att_upd.I_LABELEDNESS_Non_DR007_4 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Non_DR007_4 = SUBSTR('I_LABELEDNESS_Non_DR007_4',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_LABELEDNESS_Ser_DR007_1 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Ser_DR007_1 = SUBSTR('I_LABELEDNESS_Ser_DR007_1',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.I_LABELEDNESS_Ser_DR007_2 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Ser_DR007_2 = SUBSTR('I_LABELEDNESS_Ser_DR007_2',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_LABELEDNESS_Un_DR007_6 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_LABELEDNESS_Un_DR007_6 = SUBSTR('I_LABELEDNESS_Un_DR007_6',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_RELATEDNESS_DR006 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_RELATEDNESS_DR006 = SUBSTR('I_RELATEDNESS_DR006',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.I_RELATED_AS_PER_DR006_1 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_RELATED_AS_PER_DR006_1 = SUBSTR('I_RELATED_AS_PER_DR006_1',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_RELATED_AS_PER_DR006_2 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_RELATED_AS_PER_DR006_2 = SUBSTR('I_RELATED_AS_PER_DR006_2',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.I_UNRELATED_AS_P_DR006_3 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_UNRELATED_AS_P_DR006_3 = SUBSTR('I_UNRELATED_AS_P_DR006_3',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF cur_att_upd.I_UNRELATED_AS_P_DR006_4 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_UNRELATED_AS_P_DR006_4 = SUBSTR('I_UNRELATED_AS_P_DR006_4',18)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.I_PRODUCT_DR032 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_PRODUCT_DR032 = SUBSTR('I_PRODUCT_DR032',11)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	

     IF  cur_att_upd.I_PRODUCT_DR032_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_PRODUCT_DR032_EX = SUBSTR('I_PRODUCT_DR032_EX',11)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	           
            END IF;	
			
	IF cur_att_upd.I_PRODUCT_DR032_VAL <> '' THEN
	
	IF UPPER(cur_att_upd.I_PRODUCT_DR032_VAL) LIKE '%PORTFOLIO%'
	THEN
		DECLARE
		Lv_Prod_PF VARCHAR(32000);
		begin 
		
		Lv_Prod_PF:= cur_att_upd.I_PRODUCT_DR032_VAL;
		  UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRODUCT_DR032_VAL = Lv_Prod_PF	  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;  
		end;
	ELSE
	
DECLARE
lv_prod_rec_id VARCHAR(32000);
lv_trade_rec_id VARCHAR(32000);
lv_prod VARCHAR(32000);
LV_VALUE VARCHAR(32000);
dr032_prod VARCHAR(32000);
cur_prod_ser_rel RECORD;
l_context TEXT;
lv_cnt int;
BEGIN
LV_VALUE:= SUBSTR(cur_att_upd.I_PRODUCT_DR032_VAL,9);
	
	DECLARE
		  cur_usr_prod RECORD;
		  lv_test_null VARCHAR(1000);
	      BEGIN
		  
		     lv_test_null := NULL;
	FOR cur_usr_prod IN  SELECT regexp_split_to_table(LV_VALUE,'\^+') AS USR_PROD

            LOOP
			cur_usr_prod.USR_PROD := REPLACE(cur_usr_prod.USR_PROD,'erenumab Combination','erenumab  Combination');
                 BEGIN
				 SELECT COUNT(*) INTO lv_cnt
                 FROM lsmv_product
                 WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 IF lv_cnt = 0 THEN
				   RAISE NOTICE 'PRODUCT MISSING :%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||cur_usr_prod.USR_PROD;
				 
				 ELSIF lv_cnt = 1 THEN
				 
                 SELECT RECORD_ID INTO STRICT lv_prod_rec_id
                 FROM lsmv_product
                 WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 ELSE
				   SELECT STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),',') INTO STRICT lv_prod_rec_id
                   FROM lsmv_product
                   WHERE UPPER(TRIM(PRODUCT_NAME)) = UPPER(TRIM(cur_usr_prod.USR_PROD));
				 
				 END IF;
			
				 
		IF (lv_prod_rec_id IS NOT NULL AND lv_test_null IS NULL) THEN

		     dr032_prod:= 'Product:'||COALESCE(lv_prod_rec_id,'');
		     lv_test_null := lv_prod_rec_id;
			  ELSE
             dr032_prod := REPLACE(LTRIM(dr032_prod||','||COALESCE(lv_prod_rec_id,''),','),',,',',');

        END IF;	
     
            EXCEPTION 
            WHEN OTHERS THEN 
                 RAISE NOTICE 'ISSUE IN DR032%',SQLERRM;       
                END;
		  
            END LOOP;      
			lv_test_null := NULL;	
		  END;
		 UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PRODUCT_DR032_VAL = dr032_prod	  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;  
		  
		  
	END;
  END IF;
END IF;

--Swathi added below for DR034
	 IF  cur_att_upd.I_AESI_DR034 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_AESI_DR034 = 'DR034'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF; 
	
	 IF  cur_att_upd.I_AESI_DR034_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_AESI_DR034_EX = 'DR034_EX'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF; 	
--Added by Swathi for DR049--
	IF cur_att_upd.I_LITERATURE_REFE_DR049 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_LITERATURE_REFE_DR049 = 'DR049'	  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

		  
    END IF;
	
	IF cur_att_upd.I_LITERATURE_REFE_DR049_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_LITERATURE_REFE_DR049_EX = 'DR049_EX'		  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	
 END IF;	

	IF cur_att_upd.I_COMPANY_PRODUCT_DR023 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_COMPANY_PRODUCT_DR023 = 'DR023'
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF; 
	
	--------------DR003
	
	
   IF cur_att_upd.I_PROTOCOL_NO_DR003 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PROTOCOL_NO_DR003 = SUBSTR('I_PROTOCOL_NO_DR003',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	

	IF cur_att_upd.I_PROTOCOL_NO_DR003_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PROTOCOL_NO_DR003_EX = SUBSTR('I_PROTOCOL_NO_DR003_EX',15)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

    END IF;
	
	
	IF cur_att_upd.I_PROTOCOL_NO_DR003_VAL <> '' THEN
			UPDATE C_DISTRIBUTION_RULES_CODE
			SET I_PROTOCOL_NO_DR003_VAL = DR_DECODE_CODE_PROTOCOLNO(cur_att_upd.I_PROTOCOL_NO_DR003_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;
	
	
	
	
	
------------------------dr060-----
	IF cur_att_upd.I_PROJECT_NUMBER_DR060 <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PROJECT_NUMBER_DR060 = 'DR060'	  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;

	IF cur_att_upd.I_PROJECT_NUMBER_DR060_EX <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
		  SET I_PROJECT_NUMBER_DR060_EX = 'DR060_EX'	  
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;

	IF cur_att_upd.I_PROJECT_NUMBER_DR060_VAL <> '' THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET I_PROJECT_NUMBER_DR060_VAL = DR_DECODE_CODE_PROJECTNO(cur_att_upd.I_PROJECT_NUMBER_DR060_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;
	
	
		
----------------------------ISP_REPORT_CLASSIFICATION START

IF  cur_att_upd.I_REPORT_CLASSIFI_DR053 <> '' -- 1003
THEN 
     UPDATE C_DISTRIBUTION_RULES_CODE
    SET I_REPORT_CLASSIFI_DR053 = SUBSTR('I_REPORT_CLASSIFI_DR053',19)
    WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
END IF;

IF  cur_att_upd.I_REPORT_CLASSIFI_DR053_VAL <> '' -- 9747-- CLASSIFICATION:PDILI
THEN 
lv_report_classification := SUBSTR(cur_att_upd.I_REPORT_CLASSIFI_DR053_VAL,'16');

	 DECLARE
		  lv_cd_code VARCHAR(1000);
		  lv_cd_decode VARCHAR(100);
		  lv_test_null VARCHAR(1000);
		  cur_report_clasification RECORD;
		  
		  BEGIN
		  lv_test_null := NULL;
		  --lv_Study_design := SUBSTR(cur_att_upd.I_STUDY_DESIGN_DR5001_VAL,14);--Study_design:
		  
	FOR cur_report_clasification IN  SELECT regexp_split_to_table(lv_report_classification,'\,+') AS L_REPORT_CLSIFICATION
	LOOP
	
		SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
		FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		AND CD.LANGUAGE_CODE = 'en'
		AND CN.CODELIST_ID = 9747
		AND CC.CODE_STATUS='1'
		AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_report_clasification.L_REPORT_CLSIFICATION));
		
		  IF lv_test_null IS NULL THEN
			 UPDATE C_DISTRIBUTION_RULES_CODE
			 SET I_REPORT_CLASSIFI_DR053_VAL = '9747:'||lv_cd_code		  
			 WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
		  lv_test_null := lv_cd_code;
		  ELSE
			 UPDATE C_DISTRIBUTION_RULES_CODE
			 SET I_REPORT_CLASSIFI_DR053_VAL = LTRIM((I_REPORT_CLASSIFI_DR053_VAL||','||lv_cd_code),',')	  
			 WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
		
		  END IF; 
	end loop;
	
	lv_test_null := NULL;
	EXCEPTION 
	WHEN OTHERS THEN 
		RAISE NOTICE 'DR5001 :%','ERROR IN 9747 CODELIST';        
	END; 
   
END IF;		

IF cur_att_upd.I_REPORT_CLASSIFI_DR053_EX <> '' THEN	
					UPDATE C_DISTRIBUTION_RULES_CODE
							SET I_REPORT_CLASSIFI_DR053_EX = SUBSTR('I_REPORT_CLASSIFI_DR053_EX',19)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	   	END IF;

----------------------------ISP_REPORT_CLASSIFICATION END

------------literature
IF cur_att_upd.I_LITERATURE_REFE_DR049 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_LITERATURE_REFE_DR049 = 'DR049'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_LITERATURE_REFE_DR049_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_LITERATURE_REFE_DR049_EX = 'DR049_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

---------literature

--------------------------ISP_STUDY_SPONSOR---
IF cur_att_upd.I_STUDY_SPONSOR_DR059 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_SPONSOR_DR059 = 'DR059'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_STUDY_SPONSOR_DR059_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_SPONSOR_DR059_EX = 'DR059_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_STUDY_SPONSOR_DR059_VAL <> ''
THEN 
		--lv_std_spnsr := SUBSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_std.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1);

		DECLARE
		  lv_cd_code VARCHAR(1000);
		  --lv_cd_decode VARCHAR(100);
		  --lv_test_null VARCHAR(1000);
		  
		BEGIN
		  --lv_test_null := NULL;
		  
		  SELECT '9959:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO lv_cd_code
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9959
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1,1000))),'\,+') FROM DUAL);
		  
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_SPONSOR_DR059_VAL = lv_cd_code            --'CU_ACC:/'||COALESCE(lv_cd_code,'')  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;


--------------------------ISP_STUDY_SPONSOR---

-------------------------ISP_STUDY_PHASE

IF cur_att_upd.I_STUDY_PHASE_DR056 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_PHASE_DR056 = 'DR056'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_STUDY_PHASE_DR056_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_PHASE_DR056_EX = 'DR056_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_STUDY_PHASE_DR056_VAL <> ''
THEN 
		--lv_std_spnsr := SUBSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_std.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1);

		DECLARE
		  lv_cd_code VARCHAR(1000);
		  --lv_cd_decode VARCHAR(100);
		  --lv_test_null VARCHAR(1000);
		  
		BEGIN
		  --lv_test_null := NULL;
		  
		  SELECT '133:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO lv_cd_code
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 133
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(cur_att_upd.I_STUDY_PHASE_DR056_VAL,DR_INSTR(cur_att_upd.I_STUDY_PHASE_DR056_VAL,':',1,1)+1,1000))),'\,+') FROM DUAL);
		  
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_STUDY_PHASE_DR056_VAL = lv_cd_code            --'CU_ACC:/'||COALESCE(lv_cd_code,'')  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;

--------------------ISP_STUDY_PHASE END

    ---------------------------------------I_STUDY_REGISTRAT_DR063--------------------------------------------
    IF cur_att_upd.I_STUDY_REGISTRAT_DR063 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_STUDY_REGISTRAT_DR063 = SUBSTR('I_STUDY_REGISTRAT_DR063',18)
          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

 

        END IF;
    IF cur_att_upd.I_STUDY_REGISTRAT_DR063_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET I_STUDY_REGISTRAT_DR063_EX = SUBSTR('I_STUDY_REGISTRAT_DR063_EX',18)
          WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
    END IF;      

    IF cur_att_upd.I_STUDY_REGISTRAT_DR063_VAL <> '' THEN
	UPDATE C_DISTRIBUTION_RULES_CODE
			SET I_STUDY_REGISTRAT_DR063_VAL = DR_DECODE_CODE_REGCNTRY(cur_att_upd.I_STUDY_REGISTRAT_DR063_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
			END IF;

----------DR046

IF cur_att_upd.I_INITIAL_SUBMISS_DR046 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_INITIAL_SUBMISS_DR046 = 'DR046'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_INITIAL_SUBMISS_DR046_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_INITIAL_SUBMISS_DR046_EX = 'DR046_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;


----------DR047

IF cur_att_upd.I_FOLLOW_UP_SUBMI_DR047 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_FOLLOW_UP_SUBMI_DR047 = 'DR047'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.I_FOLLOW_UP_SUBMI_DR047_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET I_FOLLOW_UP_SUBMI_DR047_EX = 'DR047_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;




------------------------
 ---- USER ATTRIBUTE ----
 ------------------------



IF cur_att_upd.U_USER_IMPLIED_CA_DR5001 <> ''
		THEN 

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_IMPLIED_CA_DR5001 = 'DR5001'	
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			--WHERE rule_no = cur_att_upd.rule_no;

		END IF;


		IF cur_att_upd.U_USER_IMPLIED_CA_DR5001_VAL <> '' 
		THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_IMPLIED_CA_DR5001_VAL = DR_DECODE_CODE_SSIC(cur_att_upd.U_USER_IMPLIED_CA_DR5001_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;
---------------------------------------DR5001 STARTED

IF cur_att_upd.U_USER_PRODUCT_EV_DR5012 <> ''
		THEN 

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_PRODUCT_EV_DR5012 = 'DR5012'	
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			--WHERE rule_no = cur_att_upd.rule_no;

		END IF;


		IF cur_att_upd.U_USER_PRODUCT_EV_DR5012_VAL <> '' 
		THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_PRODUCT_EV_DR5012_VAL = DR_DECODE_CODE_SSIC_NEW(cur_att_upd.U_USER_PRODUCT_EV_DR5012_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;


------------------------------------------------------------


IF cur_att_upd.U_USER_PAT_REP_CO_DR5025 <> ''
		THEN 

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_PAT_REP_CO_DR5025 = 'DR5025'	
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			--WHERE rule_no = cur_att_upd.rule_no;

		END IF;


		IF cur_att_upd.U_USER_PAT_REP_CO_DR5025_VAL <> '' 
		THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_PAT_REP_CO_DR5025_VAL = UPPER(cur_att_upd.U_USER_PAT_REP_CO_DR5025_VAL) --Country:AUSTRALIA
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;


------------------------------------------------------------------------------------

IF cur_att_upd.U_USER_FATAL_ADVR_DR5014 <> ''
		THEN 

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_FATAL_ADVR_DR5014 = 'DR5014'	
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			--WHERE rule_no = cur_att_upd.rule_no;

		END IF;


		IF cur_att_upd.U_USER_FATAL_ADVR_DR5014_VAL <> '' 
		THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_FATAL_ADVR_DR5014_VAL = UPPER(cur_att_upd.U_USER_FATAL_ADVR_DR5014_VAL) --Country:AUSTRALIA
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;



-------------------------------------------------------------------------------


		IF  cur_att_upd.U_USER_SPHT_DR5002 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_SPHT_DR5002 = SUBSTR('U_USER_SPHT_DR5002',13)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;

        END IF;

IF cur_att_upd.U_USER_RETRO_SURV_DR5062 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_RETRO_SURV_DR5062 = 'DR5062'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_RETRO_SURV_DR5062_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_RETRO_SURV_DR5062_EX = 'DR5062_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_COUNTRY_PU_DR5063 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_COUNTRY_PU_DR5063 = 'DR5063'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_COUNTRY_PU_DR5063_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_COUNTRY_PU_DR5063_EX = 'DR5063_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_CLINICAL_C_DR5064 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_CLINICAL_C_DR5064 = 'DR5064'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_CLINICAL_C_DR5064_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_CLINICAL_C_DR5064_EX = 'DR5064_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

---------------------------------------DR5008 STARTED

IF cur_att_upd.U_USER_SCRIPTED_M_DR5008 <> ''
		THEN 

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_SCRIPTED_M_DR5008 = 'DR5008'	
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			--WHERE rule_no = cur_att_upd.rule_no;

		END IF;

		IF cur_att_upd.U_USER_SCRIPTED_M_DR5008_VAL <> '' 
		THEN

			UPDATE C_DISTRIBUTION_RULES_CODE
			SET U_USER_SCRIPTED_M_DR5008_VAL = DR_DECODE_CODE_SM(cur_att_upd.U_USER_SCRIPTED_M_DR5008_VAL)
			WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
				--WHERE rule_no = cur_att_upd.rule_no;	

		END IF;
	
----------------------------------------DR5008 ENDED

------------------------------------------------PMDA DEVICE RULES START----------------------------------------------


-------------------------DR5019

IF cur_att_upd.U_USER_DEVICE_MAT_DR5019 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_DEVICE_MAT_DR5019 = 'DR5019'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_DEVICE_MAT_DR5019_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_DEVICE_MAT_DR5019_EX = 'DR5019_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_DEVICE_MAT_DR5019_VAL <> ''
THEN 

	DECLARE

	DR18_VAL RECORD;
	Lv_input_sting TEXT;
	Lv_1 TEXT;
	Lv_2 TEXT;
	Lv_3 TEXT;
	Lv_4 TEXT;
	Lv_5 TEXT;
	Lv_6 TEXT;
	Lv_7 TEXT;
	Lv_8 TEXT;
	Lv_9 TEXT;
	Lv_final TEXT;

	BEGIN

		Lv_input_sting:=  REPLACE(cur_att_upd.U_USER_DEVICE_MAT_DR5019_VAL,'Nutraceutical/Food','Nutraceutical?Food');
		
	FOR DR18_VAL IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		 
		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Flag%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);

		END IF;
		If Lv_1 is null then Lv_1:='5015:'; end if;
		

		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('Outcome%'))
		THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 and cc.code_status = 1
			 AND UPPER(TRIM(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_2 is null then Lv_2:='1002:'; end if;
		
		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Characterization%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_3 is null then Lv_3:='1013:'; end if;
		

		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Damage Type%'))
		THEN  
			 SELECT '10064:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 10064
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_4 is null then Lv_4:='10064:'; end if;
		
		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Seriousness%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_5 is null then Lv_5:='1002:'; end if;
		

		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Approval Type%'))
		THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_6
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_6 is null then Lv_6:='709:'; end if;

		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Risk%'))
		THEN  
			 SELECT '10063:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 10063
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_7 is null then Lv_7:='10063:'; end if;
		
		
		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Authorization%'))
		 THEN  
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_8
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1015
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
		END IF;
		If Lv_8 is null then Lv_8:='1015:'; end if;
		
		
		IF TRIM(UPPER(DR18_VAL.IND_VALS)) LIKE UPPER(TRIM('%Causality%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR18_VAL.IND_VALS,DR_INSTR(DR18_VAL.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_9 is null then Lv_9:='8201:'; end if;
		
		END LOOP;
	 		  
		Lv_final:= COALESCE(Lv_1,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_3,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_5,'')||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_8,'')||'/'||COALESCE(Lv_9,'');
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_DEVICE_MAT_DR5019_VAL = Lv_final
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;
-------------------------DR5020

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5020 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5020 = 'DR5020'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5020_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5020_EX = 'DR5020_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5020_VAL <> ''
THEN 
		--lv_std_spnsr := SUBSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_std.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1);

		DECLARE
		  lv_cd_code VARCHAR(1000);
		  --lv_cd_decode VARCHAR(100);
		  --lv_test_null VARCHAR(1000);
		  
		BEGIN
		  --lv_test_null := NULL;
		  
		  SELECT '10092:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO lv_cd_code
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 10092
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(cur_att_upd.U_USER_PMDA_DEVIC_DR5020_VAL,DR_INSTR(cur_att_upd.U_USER_PMDA_DEVIC_DR5020_VAL,':',1,1)+1,1000))),'\,+') FROM DUAL);
		  
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5020_VAL = lv_cd_code            --'CU_ACC:/'||COALESCE(lv_cd_code,'')  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;
-------------------------DR5021

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5021 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5021 = 'DR5021'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5021_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5021_EX = 'DR5021_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_PMDA_DEVIC_DR5021_VAL <> ''
THEN 
		--lv_std_spnsr := SUBSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_std.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1);

		DECLARE
		  lv_cd_code VARCHAR(1000);
		  --lv_cd_decode VARCHAR(100);
		  --lv_test_null VARCHAR(1000);
		  
		BEGIN
		  --lv_test_null := NULL;
		  
		  SELECT '10067:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO lv_cd_code
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 10067
			 AND CC.CODE_STATUS='1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(cur_att_upd.U_USER_PMDA_DEVIC_DR5021_VAL,DR_INSTR(cur_att_upd.U_USER_PMDA_DEVIC_DR5021_VAL,':',1,1)+1,1000))),'\,+') FROM DUAL);
		  
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_PMDA_DEVIC_DR5021_VAL = lv_cd_code            --'CU_ACC:/'||COALESCE(lv_cd_code,'')  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;



----------DR 5025

IF cur_att_upd.U_USER_MANUAL_SUB_DR5065 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_MANUAL_SUB_DR5065 = 'DR5065'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_MANUAL_SUB_DR5065_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_MANUAL_SUB_DR5065_EX = 'DR5065_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;



IF cur_att_upd.U_USER_REPORTER_S_DR5013 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_REPORTER_S_DR5013 = 'DR5013'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_REPORTER_S_DR5013_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_REPORTER_S_DR5013_EX = 'DR5013_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;


IF cur_att_upd.U_USER_REPORTER_S_DR5013_VAL <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_REPORTER_S_DR5013_VAL =  SUBSTR(cur_att_upd.U_USER_REPORTER_S_DR5013_VAL,7) --State:KOSOVO
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

-------------------------------------------------START DR5015
IF cur_att_upd.U_USER_STUDY_CODE_DR5015 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_STUDY_CODE_DR5015 = SUBSTR('U_USER_STUDY_CODE_DR5015',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.U_USER_STUDY_CODE_DR5015_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_STUDY_CODE_DR5015_EX = SUBSTR('U_USER_STUDY_CODE_DR5015_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;




	IF cur_att_upd.U_USER_STUDY_CODE_DR5015_VAL <> '' THEN
                  
		lv_code_broken := SUBSTR(cur_att_upd.U_USER_STUDY_CODE_DR5015_VAL,12);--Codebroken:Code broken	  
		-- RAISE NOTICE '%','lv_code_broken' || lv_code_broken ; 		  
		DECLARE
				  lv_cd_code VARCHAR(1000);
				  lv_cd_decode VARCHAR(100);
				  lv_test_null VARCHAR(1000);
				  cur_code_broken RECORD;
				  BEGIN
				  lv_test_null := NULL;
		FOR cur_code_broken IN  SELECT regexp_split_to_table(lv_code_broken,'\,+') AS CODE_BROKEN
            LOOP
			
			
			SELECT CC.CODE,CD.DECODE INTO lv_cd_code,lv_cd_decode
            FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
            WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
            AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
            AND CD.LANGUAGE_CODE = 'en'
            AND CN.CODELIST_ID = 54
			AND CC.CODE_STATUS='1'
			AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(cur_code_broken.CODE_BROKEN));
			
			--RAISE NOTICE '%','japan country---'||lv_cd_code);
                 IF lv_test_null IS NULL THEN
				     UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_STUDY_CODE_DR5015_VAL = '54:'||lv_cd_code		  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
              
			  lv_test_null := lv_cd_code;
			  ELSE
			  
			         UPDATE C_DISTRIBUTION_RULES_CODE
		             SET U_USER_STUDY_CODE_DR5015_VAL = LTRIM((U_USER_STUDY_CODE_DR5015_VAL||','||lv_cd_code),',')	  
		             WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
			
			      END IF; 				  
            END LOOP;      
			lv_test_null := NULL;
			EXCEPTION 
            WHEN OTHERS THEN 
                RAISE NOTICE '%','EXCEPTION  IN 54 CODELIST';        
            END;		  
	END IF;




-------------------------------------------------END DR5015


-------------------------------------------------START DR5017
IF cur_att_upd.U_USER_SENDER_ORG_DR5017 <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_SENDER_ORG_DR5017 = SUBSTR('U_USER_SENDER_ORG_DR5017',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;
	
	IF  cur_att_upd.U_USER_SENDER_ORG_DR5017_EX <> '' THEN
                  UPDATE C_DISTRIBUTION_RULES_CODE
                         SET U_USER_SENDER_ORG_DR5017_EX = SUBSTR('U_USER_SENDER_ORG_DR5017_EX',19)
		  WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME;
	END IF;

-------------------------------------------------END DR5017

-------------------------------------------------START USER_SPONSOR_TYPE  U_USER_SPONCER_TY_DR5016_VAL
IF cur_att_upd.U_USER_SPONCER_TY_DR5016 <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_SPONCER_TY_DR5016 = 'DR5016'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_SPONCER_TY_DR5016_EX <> ''
THEN 

	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_SPONCER_TY_DR5016_EX = 'DR5016_EX'	  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 

END IF;

IF cur_att_upd.U_USER_SPONCER_TY_DR5016_VAL <> ''
THEN 
		--lv_std_spnsr := SUBSTR(cur_att_upd.I_STUDY_SPONSOR_DR059_VAL,DR_INSTR(cur_std.I_STUDY_SPONSOR_DR059_VAL,':',1,1)+1);

		DECLARE
		  lv_cd_code VARCHAR(1000);
		  --lv_cd_decode VARCHAR(100);
		  --lv_test_null VARCHAR(1000);
		  
		BEGIN
		  --lv_test_null := NULL;
		  
		  SELECT '9959:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO lv_cd_code
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9959
			 AND CC.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(cur_att_upd.U_USER_SPONCER_TY_DR5016_VAL,DR_INSTR(cur_att_upd.U_USER_SPONCER_TY_DR5016_VAL,':',1,1)+1,1000))),'\,+') FROM DUAL);
		  
		
	UPDATE C_DISTRIBUTION_RULES_CODE
	SET U_USER_SPONCER_TY_DR5016_VAL = lv_cd_code            --'CU_ACC:/'||COALESCE(lv_cd_code,'')  
	WHERE CONTACT_NAME = cur_att_upd.CONTACT_NAME AND FORMAT = cur_att_upd.FORMAT AND FORMAT_DISPLAY_NAME = cur_att_upd.FORMAT_DISPLAY_NAME AND DISPLAY_NAME = cur_att_upd.DISPLAY_NAME; 
	
	end;

END IF;


-------------------------------------------------END USER_SPONSOR_TYPE 





END LOOP;
	

--COMMIT;
EXCEPTION 
WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE 'EXCEPTION: %', l_context;
	RAISE NOTICE 'MAIN BLOCK: %',SQLERRM;
END $$;


update C_DISTRIBUTION_RULES_CODE
set  I_PROTOCOL_NO_DR003_VAL = replace(I_PROTOCOL_NO_DR003_VAL,'PAN/2018','PAN?2018')
where I_PROTOCOL_NO_DR003_VAL like '%PAN/2018%';