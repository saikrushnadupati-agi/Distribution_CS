----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera                                              	          --
-- FILENAME             : 11_C_DISTRIBUTION_RULE_MAP_LOADING.SQL 			    				              --
-- PURPOSE              : This Script is for mapping of distribution rule     	        	      --
-- DATE CREATED         : 27-MAR-2020                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 		    : Sai Krushna Dupati /Navya Chandramouli																			  --
-- DATE MODIFIED		: 09-SEP-2025                       						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --



-- OBJECTS DROP

    DROP FUNCTION IF EXISTS C_PROC_DISTRIBUTION_RULE_MAPPING;




/* 

CREATE TABLE IF NOT EXISTS C_USER_TAB_COLUMNS AS
select TABLE_NAME, COLUMN_NAME, DATA_TYPE from information_schema.columns 
where UPPER(table_name) IN ('LSMV_DISTRIBUTION_RULE_MAPPING', 'LSMV_DISTRIBUTION_RULE_ANCHOR', 
                            'LSMV_RULE_DETAILS','LSMV_DISTRIBUTION_FORMAT', 'LSMV_DISTRIBUTION_UNIT','C_DISTRIBUTION_RULE');

*/



-- DELETING RECORD FROM LSMV_DISTRIBUTION_RULE_MAPPING TABLE BEFORE INSERT 

--DELETE FROM LSMV_DISTRIBUTION_RULE_MAPPING;
--COMMIT;
			
							

							
---
DROP FUNCTION IF EXISTS C_ATTRIBUTE_CODELIST_UPDATE(varchar, varchar);

create or replace FUNCTION C_ATTRIBUTE_CODELIST_UPDATE (CODELIST IN VARCHAR, RULE_PARAM_VALUE IN VARCHAR) 
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $$ 
DECLARE
ID_CUR RECORD;
SND_CUR RECORD;
LV_MV VARCHAR(32767);
LV_VAL  VARCHAR(32767);
LV_TEST1 VARCHAR(32767);
LV_TEST2 VARCHAR(32767);
LV_ID_COUNT NUMERIC(10);
LV_CODE VARCHAR(32767);
LV_CL  NUMERIC(10);
LV_LIB NUMERIC(10);
lv_cond NUMERIC(10);
LV_VAL5 NUMERIC(10);
LV_INDX_NUM INTEGER;
BEGIN 

IF CODELIST IS NULL 
THEN 
CODELIST := '';
END IF;

LV_TEST2 := CODELIST;
LV_MV := RULE_PARAM_VALUE;
LV_ID_COUNT:= DR_REGEXP_COUNT(LV_MV,'CL_')+DR_REGEXP_COUNT(LV_MV,'LIB_');
LV_CL := DR_REGEXP_COUNT(LV_MV,'CL_');
LV_LIB := DR_REGEXP_COUNT(LV_MV,'LIB_');   
    -- for cl
    BEGIN
         FOR ID_CUR IN 1..LV_ID_COUNT
         LOOP
         LV_INDX_NUM := ID_CUR;
    --RAISE NOTICE 'T: %',ID_CUR;
         BEGIN 
         LV_CODE:= SUBSTRING(SUBSTRING (LV_MV,DR_instr(LV_MV,'CL_',1,LV_INDX_NUM)+3, 6  ),1,DR_INSTR(SUBSTRING (LV_MV,DR_instr(LV_MV,'CL_',1,LV_INDX_NUM)+3, 6  ),'"',1,1)-1);
         EXCEPTION 
         WHEN OTHERS THEN 
         LV_CODE:= '';  -- ------------------------ADDED
         END;
     --RAISE NOTICE 'TT: %',LV_CODE;      
         IF LV_CODE ~ '^[0-9]' = true
         then 
         
         lv_cond := ID_CUR;
         --LV_CODE := '';
         END IF;
    --RAISE NOTICE 'A1: %',LV_TEST2;    
    --RAISE NOTICE 'A2: %',LV_CODE;
         LV_TEST2 := LV_TEST2||'/'||CASE WHEN DR_instr(LV_TEST2,LV_CODE,1,1) >= 1 THEN '' ELSE LV_CODE||':' END;
         LV_TEST2 := REPLACE(LV_TEST2,'//','/');
         END LOOP;
         
         --LV_TEST2 := RTRIM(LV_TEST2,':');
         LV_TEST2 := RTRIM(LV_TEST2,'/');
--RAISE NOTICE 'TTT: %',LV_TEST2;        
    END;
    
    -- FOR LIB
    BEGIN
    --RAISE NOTICE 'cnt %',lv_cond;
    LV_VAL5 := CASE WHEN ABS(LV_ID_COUNT-lv_cond) = 0 THEN 1 ELSE ABS(LV_ID_COUNT-lv_cond) END;
    LV_VAL5 := COALESCE(LV_VAL5,0);
   --RAISE NOTICE 'nt %',LV_VAL5; 
      IF LV_MV LIKE '%LIB_%' THEN 
        FOR SND_CUR IN 1..LV_VAL5
        LOOP
        LV_INDX_NUM := SND_CUR;
        --RAISE NOTICE 'dft %',SND_CUR;
        LV_CODE:= SUBSTRING(SUBSTRING (LV_MV,DR_instr(LV_MV,'LIB_',1,LV_INDX_NUM)+4, 100  ),1,DR_INSTR(SUBSTRING (LV_MV,DR_instr(LV_MV,'LIB_',1,LV_INDX_NUM)+4, 100  ),'"',1,1)-1);
        --RAISE NOTICE '%',LV_CODE;
        LV_TEST2 := LV_TEST2||'/'||CASE WHEN DR_instr(LV_TEST2,LV_CODE,1,1) >= 1 THEN '' ELSE LV_CODE||':' END;
        LV_TEST2 := REPLACE(LV_TEST2,'//','/');
--RAISE NOTICE '%',LV_TEST2;
        END LOOP;
      END IF;  
        LV_TEST2 := RTRIM(LV_TEST2,'/');
		LV_TEST2 := LTRIM(LV_TEST2,'/');
    END;
    --LV_TEST2 := RTRIM(LV_TEST2,'/');
RETURN LV_TEST2;
EXCEPTION WHEN OTHERS THEN 
RETURN SQLERRM;
END;$$;



drop function IF EXISTS C_DECODE_CODE_PARAM (VARCHAR,VARCHAR,VARCHAR,VARCHAR);

create or replace FUNCTION C_DECODE_CODE_PARAM
(I_ATTRIBUTE IN VARCHAR, I_MULTIVALUE IN text, I_PARAMETERS IN text, I_ATT_PRAM_VALUES IN text)
RETURNS text
    language plpgsql
  as $$ DECLARE
l_context TEXT;
lv_val1 VARCHAR(32767);
LV_DIS_PARM text;
LV_app_no VARCHAR(32767);
Lv_product_apprvl  VARCHAR(32767);
LV_CODELIST VARCHAR(32767);
Lv_end_count INTEGER;
Lv_display_name VARCHAR(32767);
Lv_multivalue VARCHAR;
Lv_lable_display text;
lv_values varchar;
LV_values_ins VARCHAR(32767);
Lv_multi_code VARCHAR(32767);
Lv_final_param_map text;
lv_FINAL_PARAM text;
LV_PARAM text;
lv_start_brace VARCHAR(32767);
Lv_param_string VARCHAR(32767);
Lv_lable_string VARCHAR(32767);
Lv_values_string VARCHAR(32767);
Lv_after_lable VARCHAR(32767);
lv_param_end VARCHAR(32767);
lv_end_brace VARCHAR(32767);
LV_BEFORE_LABL VARCHAR(32767);
LV_ADHOCK_STRING VARCHAR(32767);
LV_MID_PARAM text;
Lv_finla_rule text;
Lv_parameter VARCHAR(32767);
Lv_adhock_string1 VARCHAR(32767);
LV_ATTRIBUTE_I_ID VARCHAR(32767);
LV_ID_COUNT INTEGER;
LV_PROD_SPL VARCHAR(32767);
LV_CODE VARCHAR(32767);
Lv_num_codelist INTEGER;
I RECORD;
LV_NULL_VAL VARCHAR(100);
LV_DIS_NO  INTEGER;
REC_LP RECORD;
Lv_lable_dispdr28 VARCHAR(32767);
Lv_lable_dispdr28_1 VARCHAR(32767);
LV_CNT_1002  INTEGER;
LV_CNT_1021  INTEGER;
LV_CNT_9062  INTEGER;
Lv_lable_dispdr28_2 VARCHAR(32767);
Lv_lable_dispdr28_3 VARCHAR(32767);

BEGIN 

LV_CNT_1002:=0;
LV_CNT_1021:=0;
LV_CNT_9062:=0;

 IF  I_MULTIVALUE IS NULL 
THEN 
Lv_multivalue := '';
END IF;


IF  I_PARAMETERS IS NULL 
THEN 
I_PARAMETERS := '';
END IF;

IF I_MULTIVALUE LIKE '%approval_no:%'
THEN 
	LV_app_no := SUBSTRING(I_MULTIVALUE,DR_INSTR(I_MULTIVALUE,'approval_no',1,1)+12,4000);
	LV_app_no := CASE WHEN LV_app_no LIKE '%/%' THEN SUBSTRING(LV_app_no,1,DR_INSTR(LV_app_no,'/',1,1)-1) ELSE LV_app_no END;
	Lv_multivalue := REPLACE(LTRIM(REPLACE(I_MULTIVALUE,'approval_no:'||LV_app_no,''),'/'),'//','/');
	LV_app_no := REPLACE(TRIM(LV_app_no),' ','');
ELSE
Lv_multivalue := I_MULTIVALUE;
END IF;


lv_val1 := I_ATT_PRAM_VALUES ;
LV_ATTRIBUTE_I_ID := I_ATTRIBUTE;
Lv_parameter := I_PARAMETERS;


-- COUNT THE NO OF VALUES AND UPDATE IF MORE THEN 1 
LV_ID_COUNT:= DR_REGEXP_COUNT(I_ATT_PRAM_VALUES,'CL_')+DR_REGEXP_COUNT(I_ATT_PRAM_VALUES,'LIB_');

IF LV_ID_COUNT > 1 AND LV_ATTRIBUTE_I_ID <> 'DR028'
THEN 
    Lv_multivalue:= C_ATTRIBUTE_CODELIST_UPDATE(Lv_multivalue,I_ATT_PRAM_VALUES);
--RAISE NOTICE 'TG1: %',Lv_multivalue ;	
ELSIF LV_ID_COUNT > 1 AND LV_ATTRIBUTE_I_ID = 'DR028'
THEN 
	Lv_multivalue:= C_ATTRIBUTE_CODELIST_UPDATE(Lv_multivalue,I_ATT_PRAM_VALUES);

	/*IF Lv_multivalue NOT LIKE '%9744_1015%'
	THEN
	Lv_multivalue := REPLACE(Lv_multivalue,'1015','9744_1015');
	--RAISE NOTICE 'y: %',Lv_multivalue;
	END IF;*/ -- COMMENTED 16/09/20222
END IF;


-- ISP_PRODUCT ADDITIONAL PARAMETER 1 HAANDLING 

IF DR_REGEXP_COUNT(I_ATT_PRAM_VALUES,'STUDY_PROD_LIB.flpath') > 0
THEN 

    IF I_MULTIVALUE LIKE '%STUDY_PROD_LIB:1%' 
    THEN 
        LV_PROD_SPL :=',"STUDY_PROD_LIB.flpath":{"label":"","values":["1"],"fieldLabel":"Included in Study"}';
    ELSE
        LV_PROD_SPL :=',"STUDY_PROD_LIB.flpath":{"label":"","values":[],"fieldLabel":"Included in Study"}';
    END IF;
     
END IF;

-- ISP_PRODUCT ADDITIONAL PARAMETER 2 HAANDLING 

IF DR_REGEXP_COUNT(I_ATT_PRAM_VALUES,'INCLUDE_PLACEBO.flpath') > 0
THEN 

    IF I_MULTIVALUE LIKE '%INCLUDE_PLACEBO:1%' 
    THEN 
		IF LV_PROD_SPL IS  NULL OR LV_PROD_SPL = ''
		THEN 
			 LV_PROD_SPL :=',"INCLUDE_PLACEBO.flpath":{"values":["1"],"fieldLabel":"Include Placebo","label":""}';
		ELSE 
			 LV_PROD_SPL := LV_PROD_SPL||',"INCLUDE_PLACEBO.flpath":{"values":["1"],"fieldLabel":"Include Placebo","label":""}';
		END IF;
    ELSE
        IF LV_PROD_SPL IS  NULL OR LV_PROD_SPL = ''
		THEN 
			 LV_PROD_SPL :=',"INCLUDE_PLACEBO.flpath":{"values":[],"fieldLabel":"Include Placebo","label":""}';
		ELSE 
			 LV_PROD_SPL := LV_PROD_SPL||',"INCLUDE_PLACEBO.flpath":{"values":[],"fieldLabel":"Include Placebo","label":""}';
		END IF;
    END IF;

END IF;


lv_start_brace := '{';
Lv_lable_string := '":{"label":"';
Lv_param_string := '"paramMap":{';
Lv_lable_string := '":{"label":"';
Lv_values_string := '","values":[';
lv_before_labl := '],"fieldLabel":"';
Lv_after_lable := '"}';
lv_param_end := '}'; 
Lv_adhock_string := '"adhocRules":[';
lv_end_brace := '}';
Lv_end_count :=  DR_REGEXP_COUNT (COALESCE(Lv_multivalue,'0'), '/')+1;

FOR I IN 1..Lv_end_count
LOOP
LV_DIS_NO := I;
LV_DIS_PARM:='';
IF I = 1
THEN
	IF  Lv_multivalue IS NULL OR Lv_multivalue = '' 
	THEN
		LV_CODELIST := '';
	ELSE 
	--RAISE NOTICE 'TS: %',Lv_multivalue;
		LV_CODELIST := TRIM(SUBSTRING(Lv_multivalue,1,DR_INSTR(Lv_multivalue,':',1,1)-1));
	END IF;
ELSE
	IF  Lv_multivalue IS NULL OR Lv_multivalue = ''
	THEN
		LV_CODELIST := '';
	ELSE 
		LV_CODELIST := SUBSTRING(Lv_multivalue,DR_INSTR(Lv_multivalue,'/',1,I-1)+1,(DR_INSTR(Lv_multivalue,':',1,I)- DR_INSTR(Lv_multivalue,'/',1,I-1))-1 );
	END IF;

END IF;

BEGIN 
--RAISE NOTICE 'DIS : %',LV_CODELIST;

-- UPDATED 16/09/2022
 IF LV_CODELIST ~ '^[0-9]' = true
 THEN 
		IF LV_CODELIST =  '1015' and LV_ATTRIBUTE_I_ID <> 'DR5019' then 
		 
			Lv_display_name := 'Country';
	
		ELSIF LV_CODELIST =  '1002' 
		THEN
	 
			IF LV_CNT_1002=0 THEN
				LV_CNT_1002 :=1;
			ELSE
				LV_CNT_1002:=	LV_CNT_1002+1; 
			END IF; 
			
			LV_DIS_PARM := SUBSTRING(lv_val1,DR_INSTR(lv_val1,'CL_'||LV_CODELIST,1,LV_CNT_1002),500);
			LV_DIS_PARM := SUBSTRING(LV_DIS_PARM,DR_INSTR(LV_DIS_PARM,'fieldLabel',1,1)+13,500 );
			Lv_display_name := SUBSTRING(LV_DIS_PARM,1,DR_INSTR(LV_DIS_PARM,'"',1,1)-1);
		
		ELSIF LV_CODELIST =  '1021' 
		THEN
	 
			IF LV_CNT_1021=0 THEN
				LV_CNT_1021 :=1;
			ELSE
				LV_CNT_1021:=	LV_CNT_1021+1; 
			END IF; 
			
			LV_DIS_PARM := SUBSTRING(lv_val1,DR_INSTR(lv_val1,'CL_'||LV_CODELIST,1,LV_CNT_1021),500);
			LV_DIS_PARM := SUBSTRING(LV_DIS_PARM,DR_INSTR(LV_DIS_PARM,'fieldLabel',1,1)+13,500 );
			Lv_display_name := SUBSTRING(LV_DIS_PARM,1,DR_INSTR(LV_DIS_PARM,'"',1,1)-1);
			
			
		ELSIF LV_CODELIST =  '9062' 
		THEN
	 
			IF LV_CNT_9062=0 THEN
				LV_CNT_9062 :=1;
				Lv_display_name := 'Company Causality';
			ELSE
				LV_CNT_9062:=	LV_CNT_9062+1;
				Lv_display_name := 'Reporter Causality';
			END IF; 
			
			LV_DIS_PARM := SUBSTRING(lv_val1,DR_INSTR(lv_val1,'CL_'||LV_CODELIST,1,LV_CNT_9062),500);
			LV_DIS_PARM := SUBSTRING(LV_DIS_PARM,DR_INSTR(LV_DIS_PARM,'fieldLabel',1,1)+13,500 );
			--Lv_display_name := SUBSTRING(LV_DIS_PARM,1,DR_INSTR(LV_DIS_PARM,'"',1,1)-1);
	
	
		ELSE 
			LV_DIS_PARM := SUBSTRING(lv_val1,DR_INSTR(lv_val1,'CL_'||LV_CODELIST,1,1),200);
			LV_DIS_PARM := SUBSTRING(LV_DIS_PARM,DR_INSTR(LV_DIS_PARM,'fieldLabel',1,1)+13,100 );
			Lv_display_name := SUBSTRING(LV_DIS_PARM,1,DR_INSTR(LV_DIS_PARM,'"',1,1)-1);	 
		END IF;
 ELSE

 	 LV_DIS_PARM := SUBSTRING(lv_val1,DR_INSTR(lv_val1,'LIB_'||LV_CODELIST,1,1),200);
	 LV_DIS_PARM := SUBSTRING(LV_DIS_PARM,DR_INSTR(LV_DIS_PARM,'fieldLabel',1,1)+13,100 );
	 Lv_display_name := SUBSTRING(LV_DIS_PARM,1,DR_INSTR(LV_DIS_PARM,'"',1,1)-1);
	 
 END IF;

IF LV_ATTRIBUTE_I_ID = 'DR032' AND Lv_display_name = ''
THEN 
	Lv_display_name := 'Product description';
END IF;

--RAISE NOTICE 'DIS1 : %',Lv_display_name;
EXCEPTION 
WHEN OTHERS THEN
Lv_display_name := '';
--RAISE NOTICE 'DIS1 : %',SQLERRM;
END;

-- values with out proper text 
IF I = 1
THEN 
lv_values := SUBSTRING(Lv_multivalue,DR_INSTR(Lv_multivalue,':',1,1)+1,
CASE WHEN DR_INSTR(Lv_multivalue,'/',1,1) > 0 THEN 
(DR_INSTR(Lv_multivalue,'/',1,1)-1)-DR_INSTR(Lv_multivalue,':',1,1) 
ELSE LENGTH(Lv_multivalue)-DR_INSTR(Lv_multivalue,':',1,1) END
);
ELSIF I = Lv_end_count
THEN 
lv_values := SUBSTRING(Lv_multivalue,DR_INSTR(Lv_multivalue,':',1,I)+1,
LENGTH(Lv_multivalue)- DR_INSTR(Lv_multivalue,':',1,I)+1 );
ELSE 
lv_values:= SUBSTRING(Lv_multivalue,DR_INSTR(Lv_multivalue,':',1,I)+1,
(DR_INSTR(Lv_multivalue,'/',1,I)- DR_INSTR(Lv_multivalue,':',1,I)-1));
END IF;



-- values to insertin place of value               
--LV_values_ins := '"'||REPLACE(lv_values,',','","')||'"';
--RAISE NOTICE 'OUTPUT : %','1';
LV_values_ins := CASE WHEN LENGTH(lv_values) >= 1 THEN '"'||REPLACE(lv_values,',','","')||'"' ELSE NULL END;

--RAISE NOTICE 'OUTPUT : %',LV_CODELIST;

IF LV_CODELIST IS NULL OR LV_CODELIST = '' OR LV_CODELIST ~ '^[0-9]' = false
THEN 
LV_NULL_VAL := '';
ELSE
Lv_num_codelist := TO_NUMBER(LV_CODELIST,'99999');
END IF;

--RAISE NOTICE 'OUTPUT : %',LV_CODELIST;
IF LV_CODELIST ~ '^[0-9]'
THEN 

	LV_CODELIST:= 'CL_'||LV_CODELIST;
	
ELSIF LV_CODELIST IS NOT NULL
THEN
	IF LV_CODELIST = 'LIB_9744_1015'
	THEN 
	LV_CODELIST := LV_CODELIST;
	ELSE
	LV_CODELIST:= 'LIB_'||LV_CODELIST;
	END IF;
	
END IF;

--RAISE NOTICE 'OUTPUT1 : %',LV_CODELIST;

IF  SUBSTRING(LV_CODELIST,1,2) = 'CL' --'ÇL' 
THEN
	
	IF LV_CODELIST = 'CL_1015' AND LV_ATTRIBUTE_I_ID = 'DR028'
	THEN 
	
		FOR REC_LP IN (SELECT regexp_split_to_table(lv_values,',') COLUMN_VAL FROM DUAL)
		LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		--RAISE NOTICE 'T1: %', Lv_code; 
		 SELECT CD.DECODE INTO Lv_lable_dispdr28
		 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		 AND CD.LANGUAGE_CODE = 'en'
		 AND CN.CODELIST_ID = 1015
		 AND CC.CODE = Lv_code;
		
		 IF Lv_lable_dispdr28 IS NULL
		 THEN 
		 	 SELECT CD.DECODE INTO Lv_lable_dispdr28
			 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
			 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
			 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
			 AND CD.LANGUAGE_CODE = 'en'
			 AND CN.CODELIST_ID = 9744
			 AND CC.CODE = Lv_code;
		 END IF;
		--RAISE NOTICE 'T2: %', Lv_lable_dispdr28;  
		 IF Lv_lable_dispdr28_1 IS NULL 
		 THEN 
		 	 Lv_lable_dispdr28_1 := Lv_lable_dispdr28;
		 ELSE
		 	 Lv_lable_dispdr28_1 := Lv_lable_dispdr28_1||','||Lv_lable_dispdr28;
		 END IF;
		 
		END LOOP;
	 Lv_lable_display := Lv_lable_dispdr28_1;
	-- RAISE NOTICE 'T1: %', Lv_lable_display;
	ELSE
		LV_CODE := TRIM(SUBSTRING(LV_CODELIST,4,7));

		IF lv_values IS NOT NULL
		THEN 
			Lv_lable_display := DR_CODE_DECODE(lv_values,Lv_num_codelist);
			--RAISE NOTICE 'OUTPUT 2: %',Lv_lable_display;
		END IF;
	END IF;
END IF;

-- Providing space to display name 
IF LV_CODELIST LIKE 'LIB%'
THEN 

    Lv_lable_display := REPLACE(lv_values,',',', '); 

    -- FOR ISP_PRODUCT RECORD ID TO PRODUCT NAME 
	
	IF LV_CODELIST = 'LIB_Meddra'
    THEN
		 Lv_lable_display := REPLACE(lv_values,', ',',');
	END IF;
    
    IF LV_CODELIST = 'LIB_Product'
    THEN
        IF lv_values IS NOT NULL
        then 
        
        Lv_lable_display := DR_CODE_DECODE_PRD(lv_values);
        end if;
    END IF;
	
	IF LV_CODELIST = 'LIB_CU_ACC'
	THEN
    IF lv_values IS NOT NULL and LV_ATTRIBUTE_I_ID = 'DR5012'
       then
            Lv_lable_display:=DR_CODE_DECODE_ACC_MAH(lv_values);

    ELSIF lv_values IS NOT NULL and ((LV_ATTRIBUTE_I_ID = 'DR5008') or (LV_ATTRIBUTE_I_ID = 'DR5010') or (LV_ATTRIBUTE_I_ID = 'DR5001') or (LV_ATTRIBUTE_I_ID = 'DR5016'))
    then
		Lv_lable_display:=DR_CODE_DECODE_ACC_MAH(lv_values);
	ELSE
		Lv_lable_display := DR_CODE_DECODE_ACC(lv_values);
    end if;
	END IF;
	
if LV_CODELIST = 'LIB_9744_1015' AND ((LV_ATTRIBUTE_I_ID = 'DR5008') or (LV_ATTRIBUTE_I_ID = 'DR5010') or (LV_ATTRIBUTE_I_ID = 'DR5001') or (LV_ATTRIBUTE_I_ID = 'DR5016'))
	then 
		FOR REC_LP IN (SELECT regexp_split_to_table(lv_values,',') COLUMN_VAL FROM DUAL)
		LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		--RAISE NOTICE 'T1: %', Lv_code; 
		 SELECT CD.DECODE INTO Lv_lable_dispdr28_2
		 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		 AND CD.LANGUAGE_CODE = 'en'
		 AND CN.CODELIST_ID = 1015
		 AND CC.CODE = Lv_code;

		 IF Lv_lable_dispdr28_2 IS NULL
		 THEN 
		 	 SELECT CD.DECODE INTO Lv_lable_dispdr28_2
			 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
			 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
			 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
			 AND CD.LANGUAGE_CODE = 'en'
			 AND CN.CODELIST_ID = 9744
			 AND CC.CODE = Lv_code;
		 END IF;

		--RAISE NOTICE 'T2: %', Lv_lable_dispdr28_2;  

		 IF Lv_lable_dispdr28_3 IS NULL 
		 THEN 
		 	 Lv_lable_dispdr28_3 := Lv_lable_dispdr28_2;
		 ELSE
		 	 Lv_lable_dispdr28_3 := Lv_lable_dispdr28_3||','||Lv_lable_dispdr28_2;
		 END IF;
		END LOOP;
	 Lv_lable_display := Lv_lable_dispdr28_3;
	-- RAISE NOTICE 'T1: %', Lv_lable_display;
	end if;
END IF;

if LV_CODELIST = 'LIB_StudyProjectNo'
		THEN
			Lv_lable_display := REPLACE(lv_values,',','|'); 
		END IF;
		

if LV_CODELIST = 'LIB_Study' and LV_ATTRIBUTE_I_ID ='DR003'
		THEN
			Lv_lable_display := REPLACE(lv_values,',','|'); 
		END IF;		

		--RAISE NOTICE 'LIB_StudyProjectNo: %', Lv_lable_display;

-- ADHOCK BLOCK 
IF Lv_parameter IS NOT NULL  OR Lv_parameter <> ''
THEN 
    Lv_adhock_string1 := Lv_parameter;
    
ELSE
    Lv_adhock_string1 := NULL;
	
END IF;

IF LV_ATTRIBUTE_I_ID in ('DR5008','DR5010','DR5001','DR5016','DR5019') then
		
			if LV_CODELIST='CL_1002'  
			then
				if Lv_display_name='Seriousness' and LV_ATTRIBUTE_I_ID <> 'DR5019' then
					LV_CODELIST:='CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Death?' then
					LV_CODELIST:='CL_1002';
				elsif Lv_display_name='New Drug ?' then
					LV_CODELIST:='CL_1002_newDrug.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Life Threatening?' then
					LV_CODELIST:='CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Tiken available?' then
					LV_CODELIST:='CL_1002_tiken.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Product Group Inclusion ?' then
					LV_CODELIST:='CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Remedial Action Initiated' then
					LV_CODELIST:='CL_1002_RemedialAction';
				elsif Lv_display_name='Outcome is Fatal' then
					LV_CODELIST:='CL_1002_Outcome';
				end if;
			END IF;
			
			if LV_CODELIST = 'CL_9741' and Lv_display_name='Product Group' 
			then
				LV_CODELIST:='CL_9741_productGroup.safetyReport.aerInfo.flpath';
			end if;
			
			if LV_CODELIST = 'LIB_Product' then 
				Lv_display_name='Product description';
			end if;
			
			if LV_CODELIST = 'CL_1015' and LV_ATTRIBUTE_I_ID <> 'DR5019' then 
				Lv_display_name='CPD Authorization Country';
			end if;
			
			if LV_CODELIST = 'LIB_9744_1015' and LV_ATTRIBUTE_I_ID <> 'DR5001' then 
				Lv_display_name='Country';
			elsif LV_CODELIST = 'LIB_9744_1015' and LV_ATTRIBUTE_I_ID = 'DR5001' then
				Lv_display_name='Labelling Country';
			end if;
			
		END IF;

IF LV_ATTRIBUTE_I_ID in ('DR5001') then

	if LV_CODELIST='CL_1021'  then
				if Lv_display_name like 'Causality Logic%' then
					LV_CODELIST:='CL_1021_ANDOR.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='IC Exclude ?' then
					LV_CODELIST:='CL_1021_impliedCausality.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='SS Exclude ?' then
					LV_CODELIST:='CL_1021_SSExclude.safetyReport.aerInfo.flpath';
				END IF;
	END IF;
	
	if LV_CODELIST='LIB_substanceStrength' 
	then
			Lv_display_name := 'Strength (number)';
			LV_CODELIST:='substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath';
	END IF;
	
	if LV_CODELIST='CL_9062'  then
				if Lv_display_name like 'Company Causality' then
					LV_CODELIST:='CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath';
				elsif Lv_display_name='Reporter Causality' then
					LV_CODELIST:='CL_8201_reporterCausality';
				END IF;
	END IF;

END IF;


--RAISE NOTICE 'OUTPUT IMP1: %', Lv_display_name;
Lv_lable_display := COALESCE(Lv_lable_display,'');

IF LV_ATTRIBUTE_I_ID in ('DR5008','DR5010') and LV_CODELIST <> 'CL_1015'
then
		Lv_lable_display := replace(Lv_lable_display,',','|');
end if;

IF LV_ATTRIBUTE_I_ID in ('DR5001','DR5016','DR5019')
then
		Lv_lable_display := replace(Lv_lable_display,',','|');
end if;


LV_values_ins := COALESCE(LV_values_ins,'');
LV_MID_PARAM := '"'||LV_CODELIST||Lv_lable_string||Lv_lable_display||Lv_values_string||LV_values_ins||lv_before_labl||
Lv_display_name||Lv_after_lable;
--RAISE NOTICE 'OUTPUT IMP: %', LV_MID_PARAM;

Lv_lable_display := '';
-- for ISP_PRODUCT 2ND PARAMETER 
IF LV_PROD_SPL IS NOT NULL OR LV_PROD_SPL <> ''
THEN 
    LV_MID_PARAM := COALESCE(LV_MID_PARAM,'')||COALESCE(LV_PROD_SPL,'');
	
END IF;

-- Adding multiple cl or lib
IF I = 1 
THEN 
--RAISE NOTICE 'OUTPUT 1: %', LV_MID_PARAM;
LV_PARAM := LV_MID_PARAM;
ELSE 
LV_PARAM := COALESCE(LV_PARAM,'')||','||COALESCE(LV_MID_PARAM,'');
END IF;


--RAISE NOTICE 'OUTPUT 2: %', LV_PARAM;
IF Lv_multivalue IS NOT NULL AND Lv_parameter IS NOT NULL
THEN 
    Lv_adhock_string1 := REPLACE(Lv_adhock_string1,'","','');
    Lv_adhock_string1 := '"'||Lv_adhock_string1||'"';
ELSE
Lv_adhock_string1 := '';
END IF;

END LOOP;

lv_FINAL_PARAM := Lv_param_string||LV_PARAM;

--RAISE NOTICE 'OUTPUT 3: %', Lv_param_string;
Lv_finla_rule := lv_start_brace||Lv_adhock_string||Lv_adhock_string1||']'||','||lv_FINAL_PARAM||lv_param_end||lv_end_brace;

--RAISE NOTICE 'OUTPUT 4: %', Lv_finla_rule;
IF Lv_multivalue IS NULL AND Lv_parameter IS NOT NULL
THEN
    IF DR_REGEXP_COUNT (Lv_parameter, ',') = 0 
    THEN 
    Lv_finla_rule := '{"paramMap":{},"adhocRules":["'||Lv_parameter||'"]}';
    ELSE
        Lv_finla_rule := '{"paramMap":{},"adhocRules":["'||REPLACE(Lv_parameter,',','","')||'"]}';
    END IF;
END IF;


IF (Lv_multivalue IS NULL OR Lv_multivalue = '') AND Lv_parameter IS NULL
THEN
    RETURN NULL;
END IF;

IF DR_REGEXP_COUNT(I_ATT_PRAM_VALUES,'studyAcronym.study.safetyReport.aerInfo.flpath') > 0 AND I_MULTIVALUE LIKE 'Acronym:%'
THEN 
	 Lv_finla_rule := REPLACE(Lv_finla_rule,'LIB_Acronym','studyAcronym.study.safetyReport.aerInfo.flpath');
END IF;


Lv_finla_rule := REPLACE(Lv_finla_rule,'[""]','[]');

IF LV_ATTRIBUTE_I_ID ='DR044'
THEN 
	IF LV_app_no <> '' OR LV_app_no IS NOT NULL
	THEN
		Lv_product_apprvl := ',"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":["'||LV_app_no||'"],"fieldLabel":"Approval No","label":""}}}';
	ELSE
		Lv_product_apprvl := ',"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Approval No","label":""}}}';
	END IF;
	
	Lv_finla_rule := REPLACE(Lv_finla_rule,'}}',Lv_product_apprvl);
END IF;


if LV_ATTRIBUTE_I_ID in ('DR5016')
then
	Lv_finla_rule:= REPLACE(Lv_finla_rule,',"LIB_MQCMQ_LIST":{"label":"","values":[],"fieldLabel":"Product Characterization"}','')
	;
end if;


IF LV_ATTRIBUTE_I_ID in ('DR5008','DR5010','DR5016')
THEN 
	IF LV_app_no <> '' OR LV_app_no IS NOT NULL
	THEN
		Lv_product_apprvl := ',"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":["'||LV_app_no||'"],"fieldLabel":"Approval No","label":""}}}';
	ELSE
		Lv_product_apprvl := ',"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}';
	END IF;
	
	IF LV_ATTRIBUTE_I_ID in ('DR5008','DR5016')
	then
		Lv_finla_rule := REPLACE(Lv_finla_rule,',"LIB_Approval No":{"label":"","values":[],"fieldLabel":"Product Characterization"}}',Lv_product_apprvl);
	elsif LV_ATTRIBUTE_I_ID = 'DR5010'  then
		Lv_finla_rule := REPLACE(Lv_finla_rule,',"LIB_Approval No":{"label":"","values":[],"fieldLabel":""}}',Lv_product_apprvl);
	end if;
	
END IF;

if LV_ATTRIBUTE_I_ID in ('DR5001')
then
	Lv_finla_rule:= REPLACE(Lv_finla_rule,'"LIB_MQCMQ_LIST":{"label":"","values":[],"fieldLabel":""}','"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""}')
	;
	Lv_finla_rule := REPLACE(Lv_finla_rule,',"LIB_Approval No":{"label":"","values":[],"fieldLabel":""}',',"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}');
	
end if;


/*
if LV_ATTRIBUTE_I_ID = 'DR059'
then 
	Lv_finla_rule  := '{"adhocRules":[],"paramMap":{"LIB_CU_ACC_ID":{"values":[],"fieldLabel":"Sponsor","label":""},"CL_9959":{"values":["02"],"fieldLabel":"Sponsor Type","label":"Non-Company Sponsored"}}}'
end if;
*/

--RAISE NOTICE '1. %',Lv_finla_rule;
RETURN Lv_finla_rule;
EXCEPTION
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
--RAISE NOTICE '3. %',l_context;
END $$;


DO $$
DECLARE

Lv_Contact_status VARCHAR(32767);
Lv_contact_fk INTEGER;
Lv_attribute_count INTEGER;
Lv_current_attribute VARCHAR(32767);
Lv_final_expression VARCHAR(32767);
Lv_rule_id BIGINT;
Lv_anchor_id BIGINT;
Lv_rule_param TEXT;
Lv_rule_json VARCHAR(32767);
Lv_attribute_codlist VARCHAR(32767);
Lv_att_codelist_id VARCHAR(32767);
Lv_value_column_name VARCHAR(32767);
Lv_c_rul_slno VARCHAR(32767);
Lv_select_string VARCHAR(32767);
LV_MULTIVALUE VARCHAR(32767);
Lv_param_value VARCHAR;
Lv_parameter VARCHAR(32767);
Lv_att_param_value VARCHAR(32767);
lV_ATTRIBUTE_ID VARCHAR(32767);
Lv_actual_attribute VARCHAR(32767);
lv_value_string VARCHAR(32767);
Lv_parameters VARCHAR(32767);
Lv_parameter_value VARCHAR(32767);
Lv_SATATEMNT VARCHAR(32767);
LV_COLUMN_NAME VARCHAR(32767);
LV_EXCLUDE INTEGER;
LV_EXL_VALUE VARCHAR(32767);
LV_PIVOT_NAME VARCHAR(32767); 
LV_PIVOT_VALUE VARCHAR(32767);
lv_pivot_param VARCHAR(40000);
LV_I_SCR_EX VARCHAR(40000);
FK_PIVOT_RULE_I_SRC VARCHAR(40000);
LV_PIVOT_ATTRIBUTE_ID VARCHAR(40000);
LV_I_SRC_PIVOT_VALUE VARCHAR(40000);
LV_RULE_SEQUENCE INTEGER;
LV_IS_TIMELINE_ATT INTEGER;
LV_TIMELINE_VALUE INTEGER;
LV_TIMELINE_VAL_COLUMN VARCHAR(4000);
LV_TIMELINE_STRING VARCHAR(40000);
LV_TL_SEQUENCE INTEGER;
LV_ATTRIBUTE_SEQ INTEGER; 
LV_rule_SEQ INTEGER;
LV_PREV_CONTACT VARCHAR(2000);
LV_PREV_FORMAT VARCHAR(2000);
lv_sl_no VARCHAR(40000); 
lv_CONTACT_NAME VARCHAR(40000);
lv_FORMAT VARCHAR(40000); 
lv_DISPLAY_NAME VARCHAR(40000);
l_context TEXT;
I RECORD;
ATT RECORD;
TIMELINE_C RECORD;
VL RECORD;
PL RECORD;
PAL RECORD;
EXL RECORD;
TL_SEQ_C RECORD;
Lv_anchor_mp_id BIGINT;
BEGIN
     LV_PREV_CONTACT := '1';
     LV_PREV_FORMAT := 'A';
     LV_rule_SEQ := 1;
     LV_EXCLUDE := 0;
     --LOOP FOR ALL THE ACTIVEE RULES PRESENT IN TEM TABLE
     FOR I IN ( SELECT * FROM C_DISTRIBUTION_RULES_CODE  
				WHERE FINAL_EXPRESSION IS NOT NULL  
     ORDER BY CONTACT_NAME,FORMAT,RULE_SEQUENCE)

     LOOP
	 
		  SELECT LDRA.RECORD_ID INTO Lv_anchor_mp_id
                 FROM LSMV_DISTRIBUTION_UNIT LDU,LSMV_DISTRIBUTION_FORMAT LDF,LSMV_DISTRIBUTION_RULE_ANCHOR LDRA
                 WHERE LDU.RECORD_ID = LDF.FK_DISTRIBUTION_UNIT
                 AND LDF.RECORD_ID = FK_DISTRIBUTION_FORMAT
                 --AND LDU.ACTIVE = 1
                 AND UPPER(TRIM(LDU.DISTRIBUTION_UNIT_NAME)) = UPPER(TRIM(I.CONTACT_NAME))
                 AND UPPER(TRIM(LDF.FORMAT_TYPE)) = UPPER(TRIM(I.FORMAT))
				 AND UPPER(TRIM(LDF.DISPLAY_NAME)) = UPPER(TRIM(I.FORMAT_DISPLAY_NAME))
                 AND UPPER(TRIM(LDRA.DISPLAY_NAME)) = UPPER(TRIM(I.DISPLAY_NAME));
				 
				 DELETE FROM LSMV_DISTRIBUTION_RULE_MAPPING WHERE FK_DISTRIBUTION_ANCHOR_ID = Lv_anchor_mp_id;
				 
          LV_ATTRIBUTE_SEQ := 0;
          --LV_RULE_SEQUENCE:= I.RULE_SEQUENCE;
          lv_sl_no := I.SL_NO; 
          lv_CONTACT_NAME := I.CONTACT_NAME;
          lv_FORMAT := I.FORMAT; 
          lv_DISPLAY_NAME := I.DISPLAY_NAME;
          
             Lv_final_expression := TRIM(I.FINAL_EXPRESSION); -- ASSIGNING FINALEXPRESSION INTO LOCAL VARIABLE

             SELECT LENGTH(Lv_final_expression) - LENGTH(REPLACE(Lv_final_expression,',','')) + 1
             INTO Lv_attribute_count
             FROM DUAL; -- GETTING THE NO OF ATTRIBUTE PRESENT IN FINAL EXPRESSION

             BEGIN 
             -- loop for the count of attirubute present in rule.
             FOR ATT IN 1..Lv_attribute_count
             LOOP

                 IF ATT = 1
                 THEN
                     IF Lv_attribute_count = 1
                     THEN
                         Lv_current_attribute := TRIM(Lv_final_expression);
                     ELSE
                     Lv_current_attribute := SUBSTRING(Lv_final_expression,1,DR_instr(Lv_final_expression,',',1,1)-1);
                     END IF;

                 ELSIF ATT = Lv_attribute_count
                 THEN
                     Lv_current_attribute := SUBSTRING(Lv_final_expression,DR_instr(Lv_final_expression,',',1,ATT-1)+1,10);
                 ELSE
                     Lv_current_attribute := SUBSTRING(Lv_final_expression,DR_instr(Lv_final_expression,',',1,ATT-1)+1,DR_instr(Lv_final_expression,',',1,ATT)-1 - DR_instr(Lv_final_expression,',',1,ATT-1));

                 END IF; -- GETTING THE CURRENT ATTRIBUTE

                 --lV_ATTRIBUTE_ID := SUBSTRING(Lv_current_attribute,-6,6);  -- REMOVED AS FINALEXPRESSION CONTAINS IDS
                   lV_ATTRIBUTE_ID := Lv_current_attribute;
--RAISE NOTICE 'PARAM : %',lV_ATTRIBUTE_ID;

                  -- TIMELINE ATTRIBUTE UPDADTE
                  /*IF lV_ATTRIBUTE_ID LIKE '%/_T' ESCAPE '/'
                  THEN
                       SELECT TTT  INTO LV_COLUMN_NAME FROM (
                                  select CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 'I_' ELSE 'U_' END||
                                  REPLACE(REPLACE(SUBSTRING(SUBSTRING(RULE_NAME,CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 5 ELSE 1 END,40),1,15),' ','_')||'_'||RULE_ID,'__','_')||'_T' TTT
                                  from LSMV_RULE_DETAILS
                                  WHERE RULE_ID = RTRIM(lV_ATTRIBUTE_ID,'_T'));

                      FOR TIMELINE_C IN (SELECT COLUMN_NAME FROM C_USER_TAB_COLUMNS WHERE TABLE_NAME = LOWER('C_DISTRIBUTION_RULES_CODE')
                               AND COLUMN_NAME LIKE LV_COLUMN_NAME||'V'
                          )
                          LOOP
                          LV_TIMELINE_STRING := 'SELECT '||TIMELINE_C.COLUMN_NAME||'  FROM C_DISTRIBUTION_RULES_CODE
                                     WHERE SL_NO = '||I.SL_NO;

                              EXECUTE  LV_TIMELINE_STRING INTO STRICT LV_TIMELINE_VAL_COLUMN;
                          END LOOP;
                     
                      LV_TIMELINE_VALUE := TO_INTEGER(LV_TIMELINE_VAL_COLUMN);
                      lV_ATTRIBUTE_ID := RTRIM(lV_ATTRIBUTE_ID,'_T');
                      LV_IS_TIMELINE_ATT := 1;

                  ELSE
                      LV_IS_TIMELINE_ATT:= 0;
                      LV_TIMELINE_VALUE := 0;
                      LV_ATTRIBUTE_SEQ := LV_ATTRIBUTE_SEQ + 1;
 
                      
                  END IF; */
				 LV_ATTRIBUTE_SEQ := LV_ATTRIBUTE_SEQ + 1;
                 SELECT TTT  INTO LV_COLUMN_NAME FROM (
                                  select CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 'I_' ELSE 'U_' END||
                                  REPLACE(REPLACE(SUBSTRING(SUBSTRING(RULE_NAME,CASE  WHEN RULE_NAME LIKE 'ISP%' THEN 5 ELSE 1 END,40),1,15),' ','_')||'_'||RULE_ID,'__','_') TTT
                                  from LSMV_RULE_DETAILS
                                  WHERE RULE_ID = lV_ATTRIBUTE_ID) T1;
                 lv_value_string := 'SELECT '||LV_COLUMN_NAME||'_VAL'||' FROM C_DISTRIBUTION_RULES_CODE
				 					WHERE SL_NO = '||I.SL_NO;

                 SELECT RULE_NAME INTO Lv_actual_attribute
                 FROM LSMV_RULE_DETAILS
                 WHERE RULE_ID = lV_ATTRIBUTE_ID;

                 -- fecting record id from LSMV_RULE_DETAILS by providing attribute name
                 select RECORD_ID
                        into Lv_rule_id
                 from LSMV_RULE_DETAILS 
                 where RULE_NAME = Lv_actual_attribute
                 AND RULE_STATUS = 'Frozen';

                 -- fetching record id from LSMV_DISTRIBUTION_RULE_ANCHOR table by providing Condition display name

                 SELECT LDRA.RECORD_ID INTO Lv_anchor_id
                 FROM LSMV_DISTRIBUTION_UNIT LDU,LSMV_DISTRIBUTION_FORMAT LDF,LSMV_DISTRIBUTION_RULE_ANCHOR LDRA
                 WHERE LDU.RECORD_ID = LDF.FK_DISTRIBUTION_UNIT
                 AND LDF.RECORD_ID = FK_DISTRIBUTION_FORMAT
                 --AND LDU.ACTIVE = 1
                 AND UPPER(TRIM(LDU.DISTRIBUTION_UNIT_NAME)) = UPPER(TRIM(I.CONTACT_NAME))
                 AND UPPER(TRIM(LDF.FORMAT_TYPE)) = UPPER(TRIM(I.FORMAT))
				 AND UPPER(TRIM(LDF.DISPLAY_NAME)) = UPPER(TRIM(I.FORMAT_DISPLAY_NAME))
                 AND UPPER(TRIM(LDRA.DISPLAY_NAME)) = UPPER(TRIM(I.DISPLAY_NAME));


                 IF LV_ANCHOR_ID is null 
                 then 
                 raise notice ': %',I.CONTACT_NAME||' '||I.FORMAT|| ' '||' '||I.FORMAT_DISPLAY_NAME||' '||I.DISPLAY_NAME;
                 END IF;
				 
                
                 -- SELECTING RULE_PARAM_MAP, ADHOC_RULES_JSON from LSMV_RULE_DETAILS for the current attribute
                 SELECT RULE_PARAM_MAP,ADHOC_RULES_JSON
                        INTO Lv_rule_param, Lv_rule_json
                 FROM LSMV_RULE_DETAILS
                 WHERE RULE_ID = lV_ATTRIBUTE_ID;

                 -- set pram as null when attributee having no parameter
                 IF Lv_rule_param = '{"adhocRules":[],"paramMap":{}}'
                 THEN
                     Lv_param_value := NULL;

                 -- When attributee having values 'cd/lib' with out parameter
                 ELSIF Lv_rule_json IS NULL AND Lv_rule_param != '{"adhocRules":[],"paramMap":{}}'
                 THEN
 				 
                     -- LIB/CD
                     for VL in (SELECT COLUMN_NAME FROM C_USER_TAB_COLUMNS WHERE TABLE_NAME = LOWER('C_DISTRIBUTION_RULES_CODE')
                               AND COLUMN_NAME LIKE LOWER(LV_COLUMN_NAME)||'_val')
                     loop
	
                     Lv_SATATEMNT := 'SELECT '||VL.COLUMN_NAME||'  FROM C_DISTRIBUTION_RULES_CODE
                                     WHERE SL_NO = '||''''||I.SL_NO||'''';

                     EXECUTE  Lv_SATATEMNT INTO STRICT LV_MULTIVALUE;
		--RAISE NOTICE 'OUTPUT: %',LV_MULTIVALUE;			 
                     END LOOP;

                 -- ATTRIBUTE WITH PARAMETER
                 ELSE
                      --PAARAM
--RAISE NOTICE 'OUTPUT: %','with param';
                     for PL in (SELECT COLUMN_NAME FROM C_USER_TAB_COLUMNS WHERE TABLE_NAME = LOWER('C_DISTRIBUTION_RULES_CODE')
                               AND COLUMN_NAME LIKE LOWER(LV_COLUMN_NAME)||'_val')
                     loop
                     Lv_SATATEMNT := 'SELECT '||PL.COLUMN_NAME||'  FROM C_DISTRIBUTION_RULES_CODE
                                     WHERE SL_NO = '||''''||I.SL_NO||'''';

                     EXECUTE  Lv_SATATEMNT INTO STRICT LV_MULTIVALUE;
                     END LOOP;

                      -- PARAMETER
                      BEGIN
                           for PAL in (SELECT COLUMN_NAME FROM C_USER_TAB_COLUMNS WHERE TABLE_NAME = LOWER('C_DISTRIBUTION_RULES_CODE')
									   AND COLUMN_NAME LIKE '%'||LOWER(lV_ATTRIBUTE_ID)||'\_%' ESCAPE '\' 
									   AND COLUMN_NAME NOT LIKE '%_val'
									   AND COLUMN_NAME NOT LIKE '%_ex'
                                     )
                           loop
--RAISE NOTICE 'OUTPUT AT: %',PAL.COLUMN_NAME;
                           Lv_SATATEMNT := 'SELECT '||PAL.COLUMN_NAME||'  FROM C_DISTRIBUTION_RULES_CODE
                                           WHERE SL_NO = '||''''||I.SL_NO||'''';

                           EXECUTE  Lv_SATATEMNT INTO STRICT Lv_parameter_value;
--RAISE NOTICE 'OUTPUT P: %',Lv_SATATEMNT ||'   -- '||Lv_parameter_value;
                           IF Lv_parameter_value IS NULL
                           THEN
                               NULL;
                           ELSE
                               -- LV_PARAMETERS := COALESCE(LV_PARAMETERS,'')||','||COALESCE(Lv_parameter_value,''); -- updated 07/09/2022
								LV_PARAMETERS := COALESCE(Lv_parameter_value,'');
                           END IF;
                           LV_PARAMETERS := REPLACE(REPLACE(REPLACE(TRIM( ',' FROM LV_PARAMETERS),',,,',','),',,',','),',,',',');

                           end loop;
                      EXCEPTION 
                      WHEN OTHERS THEN 
                      
					  RAISE NOTICE 'OUTPUT: %','PARAMETER';
                      END;

                 END IF;
--RAISE NOTICE 'OUTPUT: %','ex start';
                     for EXL in (SELECT COLUMN_NAME FROM C_USER_TAB_COLUMNS WHERE TABLE_NAME = LOWER('C_DISTRIBUTION_RULES_CODE')
                               AND COLUMN_NAME LIKE LOWER(LV_COLUMN_NAME)||'_ex')
                     loop

                     Lv_SATATEMNT := 'SELECT '||EXL.COLUMN_NAME||'  FROM C_DISTRIBUTION_RULES_CODE
                                     WHERE SL_NO = '||''''||I.SL_NO||'''';
                     EXECUTE  Lv_SATATEMNT INTO STRICT LV_EXL_VALUE;

                     IF LV_EXL_VALUE IS NOT NULL
                     THEN
                         LV_EXCLUDE := 1;

                     ELSE
                         LV_EXCLUDE := 0;

                     END IF;

                     END LOOP;

                 Lv_att_param_value := Lv_rule_param;
                 --LV_MULTIVALUE = REPLACE(LV_MULTIVALUE,'?','/');
									   
 --RAISE NOTICE 'VLUES % ',lV_ATTRIBUTE_ID;
 --RAISE NOTICE 'PARAM_VALUES : %',lV_ATTRIBUTE_ID||' $ '||COALESCE(LV_MULTIVALUE,'')||' $ '||COALESCE(Lv_parameters,'')||' $ ';


				IF lV_ATTRIBUTE_ID = 'DR5012'
				THEN 
					Lv_param_value := DR_DECODE_CODE_MATRIX(LV_MULTIVALUE);
				ELSIF 
				lV_ATTRIBUTE_ID = 'DR5025'
				THEN
				Lv_param_value := DR_DECODE_CODE_PAT_COUNTRY(LV_MULTIVALUE);
				ELSIF 
				lV_ATTRIBUTE_ID = 'DR5014'
				THEN
				Lv_param_value := DR_DECODE_CODE_EVENT_TYPE(LV_MULTIVALUE);
				ELSIF
				lV_ATTRIBUTE_ID = 'DR5013'
				THEN 
				Lv_param_value := '{"adhocRules":[],"paramMap":{"reporterState.primarySourceCollection$safetyReport.aerInfo.flpath":{"values":["'||LV_MULTIVALUE||'"],"fieldLabel":"State","label":"'||LV_MULTIVALUE||'"}}}';
				
				ELSE 
                 Lv_param_value := C_DECODE_CODE_PARAM(lV_ATTRIBUTE_ID,LV_MULTIVALUE,Lv_parameters,Lv_att_param_value);
				 --RAISE NOTICE 'PARAM : %',LV_MULTIVALUE;
                END IF;

                 --Lv_param_value := C_DECODE_CODE_PARAM(lV_ATTRIBUTE_ID,LV_MULTIVALUE,Lv_parameters,Lv_att_param_value);
				 --RAISE NOTICE 'PARAM : %',Lv_param_value;
                 IF Lv_param_value = '{"paramMap":{"{}}":{"label":"","values":[""],"fieldLabel":""}},"adhocRules":[]}'
                 THEN
                     Lv_param_value := '{"paramMap":{},"adhocRules":[]}';
                 END IF;

                 Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
                 values (NEXTVAL('SEQ_RECORD_ID'),Lv_rule_id,Lv_anchor_id,null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
                        Lv_param_value,LV_IS_TIMELINE_ATT,LV_ATTRIBUTE_SEQ,LV_TIMELINE_VALUE,LV_EXCLUDE);


                 UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
                 SET RULE_INCLUSION_LOGIC = '00',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP--,ACTIVE = 1--,SEQUENCE = LV_RULE_SEQUENCE
                 WHERE RECORD_ID = Lv_anchor_id;

                 LV_EXCLUDE := 0;
                 LV_MULTIVALUE := NULL;
                 Lv_parameters := NULL;
                 Lv_att_param_value := NULL;
                 

             END LOOP;
             --COMMIT; -- EACH RULE COMMIT TO UPDATE THE SEQUENCE FOR TIMELINE 
             LV_ATTRIBUTE_SEQ := 0;
			 
             EXCEPTION 
             WHEN OTHERS THEN
             CALL C_PROC_DISTRIBUTION_EXCEPTION(lv_sl_no, lv_CONTACT_NAME, lv_FORMAT, lv_DISPLAY_NAME,Lv_current_attribute, 
             Lv_final_expression,LV_MULTIVALUE, NULL,SQLERRM, 'ATTRIBUTE');
             END;

        -- updating the sequence for timeline attribute 
        BEGIN 

              LV_TL_SEQUENCE := 1;
              FOR TL_SEQ_C IN (SELECT * FROM  LSMV_DISTRIBUTION_RULE_MAPPING 
                               WHERE FK_DISTRIBUTION_ANCHOR_ID = Lv_anchor_id 
                               AND IS_TIMELINE_RULE = 1 
                               ORDER BY TIMELINE
                              )
              LOOP

                
                  UPDATE LSMV_DISTRIBUTION_RULE_MAPPING
                  SET RULE_SEQUENCE = LV_TL_SEQUENCE,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
                  WHERE RECORD_ID = TL_SEQ_C.RECORD_ID;
                
                  LV_TL_SEQUENCE := LV_TL_SEQUENCE+1;
              END LOOP;
              LV_TL_SEQUENCE := NULL;
        EXCEPTION WHEN OTHERS
        THEN
             CALL C_PROC_DISTRIBUTION_EXCEPTION(lv_sl_no, lv_CONTACT_NAME, lv_FORMAT, lv_DISPLAY_NAME,Lv_current_attribute, 
             Lv_final_expression,LV_MULTIVALUE, NULL,SQLERRM, 'TIME LINE SEQUENCE UPDATE');
        END;
		
		
        --COMMIT; -- SEQUENCE UPDATE COMMIT

        -- Update Pivot for anchor level 
        /*
        BEGIN
             LV_PIVOT_NAME := I.PIVOT_NAME;
             LV_PIVOT_VALUE := TRIM(I.PIVOT_VALUE);
             LV_PIVOT_VALUE := '346:'||LV_PIVOT_VALUE;
             
             
             
             -- ISP SOURCE PIVOT 
             IF LV_PIVOT_NAME = 'ISP_SOURCE'
             THEN
                 lv_pivot_param := C_DECODE_CODE_PARAM('DR026',LV_PIVOT_VALUE,NULL,'{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{"CL_346":{"codelistId":"346","libraryName":null,"defaultValue":{},"fieldLabel":"Source","fieldPath":"source.sourceCollection$safetyReport.aerInfo.flpath","parameterName":"Source","fieldId":"124001"}}}');

                 select RECORD_ID INTO FK_PIVOT_RULE_I_SRC
                 from lsmv_rule_DETAILS 
                 WHERE RULE_NAME = 'ISP_SOURCE';


                 UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
                 SET PARAM_MAP = lv_pivot_param,FK_PIVOT_RULE = FK_PIVOT_RULE_I_SRC
                 WHERE RECORD_ID = Lv_anchor_id;
             
                 FK_PIVOT_RULE_I_SRC:= NULL;
                 LV_I_SCR_EX := 0;
                 lv_pivot_param := NULL;
             
             -- DEFAULT PIVOT 
             ELSIF LV_PIVOT_NAME = 'DefaultPivot'
             THEN 
                  NULL;
             ELSE 
                  NULL;
             END IF;
     
     
        EXCEPTION WHEN OTHERS
        THEN
             CALL C_PROC_DISTRIBUTION_EXCEPTION(lv_sl_no, lv_CONTACT_NAME, lv_FORMAT, lv_DISPLAY_NAME,Lv_current_attribute, 
             Lv_final_expression,LV_MULTIVALUE, NULL,SQLERRM, 'PIVOT UPDATE');
        END; */

     -- RULE SEQUENCE UPDATE 
  
     IF I.CONTACT_NAME = LV_PREV_CONTACT AND I.FORMAT = LV_PREV_FORMAT
     THEN 
         LV_rule_SEQ := LV_rule_SEQ+1;
     ELSE
         LV_PREV_CONTACT := I.CONTACT_NAME;
         LV_PREV_FORMAT := I.FORMAT;
         LV_rule_SEQ := 1;
	END IF;
/*
     UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
     SET SEQUENCE = LV_rule_SEQ
     WHERE RECORD_ID = Lv_anchor_id;*/  -- COMENTTED FOR anchor rank update as it is handeled 
END LOOP;

EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE NOTICE 'EXCEPTION: %', 'NO DATA FOUND';
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION: %', l_context;
END $$;