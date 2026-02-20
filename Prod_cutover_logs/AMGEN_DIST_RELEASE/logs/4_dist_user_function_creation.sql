----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera                                            	          --
-- FILENAME             : DIST_USER_FUNCTION_CREATION.sql		    				          	  --
-- PURPOSE              : THIS SCRIPT IS HAVING ALL THE REQUIRED USER FUNCTION USED IN DR SCRIPTS --
-- DATE CREATED         : 23/02/2022                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 			: PRIYA CA														  --
-- DATE MODIFIED		: 15-SEP-2023                        						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --

-- INSTR FUNCTION 

CREATE OR REPLACE FUNCTION DR_instr(string character varying,s_char character varying,s_position integer,no_of_occ integer)
    RETURNS INTEGER
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
lv_string TEXT;
Lv_s_char TEXT;
Lv_position INTEGER;
Lv_occ INTEGER;
Lv_r_position INTEGER;
lV_FINAL_POS INTEGER;
LV_FINAL_R INTEGER;
lv_prev INTEGER;
BEGIN 
	 lv_string := STRING;
	 Lv_position := S_POSITION;
	 Lv_occ := NO_OF_OCC;
	 Lv_s_char := S_CHAR;
	 Lv_prev := 0;
	 
	 FOR I IN 1..Lv_occ
	 LOOP
	 	 IF I = 1 THEN 
	 	 Lv_r_position := POSITION(Lv_s_char in lv_string);
		 lV_FINAL_POS := Lv_r_position;
		 LV_FINAL_R := Lv_r_position;
		 ELSE
		 lv_string := SUBSTRING(lv_string,lV_FINAL_POS+1,32767);
		 lV_FINAL_POS := POSITION(Lv_s_char in lv_string);
		 LV_FINAL_R := LV_FINAL_R+lV_FINAL_POS;
		 
		 END IF;
		 
		 IF Lv_prev = LV_FINAL_R
		 THEN 
		 RETURN 0;
		 ELSE 
		 Lv_prev := LV_FINAL_R;
		 END IF;
		 
	 END LOOP;
	 RETURN LV_FINAL_R;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
END;$BODY$;


-- REGEXP_COUNT FUNCTION 

create or replace FUNCTION DR_REGEXP_COUNT (STRING_VAL IN VARCHAR,MATCH_CHAR VARCHAR)
RETURNS INTEGER
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
LV_STRING  VARCHAR(32000);
LV_MATCH_CHAR VARCHAR(32767);
LV_COUNT VARCHAR(32767);
BEGIN
LV_STRING := STRING_VAL;
LV_MATCH_CHAR := MATCH_CHAR;
LV_COUNT := (LENGTH(STRING_VAL)-LENGTH( REPLACE(STRING_VAL,LV_MATCH_CHAR,'') ))/LENGTH(LV_MATCH_CHAR);

RETURN LV_COUNT;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE NOTICE '%',SQLERRM;
END;$BODY$;


drop function IF EXISTS DR_CODE_DECODE_PRD (VARCHAR);

create or replace FUNCTION DR_CODE_DECODE_PRD (P_CODE IN varchar)
RETURNS text
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   text;
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code text;
REC_LP RECORD;
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_CODE,',') COLUMN_VAL FROM DUAL)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 --raise notice '%',lv_code;
		 
		 SELECT PRODUCT_NAME INTO LV_DECODE
		 FROM LSMV_PRODUCT
		 --WHERE RECORD_ID = Lv_code;
		 WHERE TRIM(TO_CHAR(RECORD_ID,'9999999999999999')) = Lv_code;
		 
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 LV_DECODE:= '';
			 if Lv_code like  '%PORTFOLIO%'
			 then
			 	 LV_DECODE := Lv_code;
			 end if;
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||'|'||LV_DECODE; -- Swathi replaced comma with Pipe for EISAI
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,'|'),'|'),'||||','|'),'|||','|'),'||','|');

RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;


create or replace FUNCTION DR_CODE_DECODE_ACC (P_CODE IN VARCHAR)
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   VARCHAR(2000);
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code VARCHAR(2000);
REC_LP RECORD;
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_CODE,',') COLUMN_VAL FROM DUAL)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 
		         SELECT ACCOUNT_NAME INTO LV_DECODE
                 FROM LSMV_ACCOUNTS
                 WHERE TRIM(TO_CHAR(record_id,'99999999999999999')) = Lv_code;
				 
		 
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 
			 SELECT NAME INTO LV_DECODE
                        FROM LSMV_PARTNER 
                        WHERE TRIM(TO_CHAR(record_id,'99999999999999999')) = Lv_code;
						
						IF LV_DECODE IS NULL OR LV_DECODE = ''
						THEN 
							 LV_DECODE := '';
						END IF;
						
						
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||'|'||LV_DECODE;
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,'|'),'|'),'||||','|'),'|||','|'),'||','|');

RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;



-- CREATE FUNCTION CODE_DECODE for 1015 and 9744 codelist (Core,IB)

create or replace FUNCTION DR_CODE_DECODE_LBL_CNTRY (P_CODE IN VARCHAR)
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   VARCHAR(2000);
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code VARCHAR(2000);
REC_LP RECORD;
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_CODE,',') COLUMN_VAL FROM DUAL)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 
		 SELECT CD.DECODE INTO LV_DECODE
		 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		 AND CD.LANGUAGE_CODE = 'en'
		 AND CN.CODELIST_ID IN (1015,9744)
                 --AND CC.CODE_STATUS='1'
		 AND CC.CODE = Lv_code;
		 
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 LV_DECODE:= '';
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||','||LV_DECODE;
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,','),','),',,,,',','),',,,',','),',,',',');

RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;


-- CREATE FUNCTION CODE_DECODE

create or replace FUNCTION DR_CODE_DECODE (P_CODE IN VARCHAR, P_CODELIST_ID IN INTEGER)
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   VARCHAR(2000);
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code VARCHAR(2000);
REC_LP RECORD;
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_CODE,',') COLUMN_VAL FROM DUAL)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 
		 SELECT CD.DECODE INTO LV_DECODE
		 FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		 WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		 AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		 AND CD.LANGUAGE_CODE = 'en'
		 AND CN.CODELIST_ID = P_CODELIST_ID
         AND CC.CODE_STATUS='1'
		 AND CC.CODE = Lv_code;
		 
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 LV_DECODE:= '';
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||','||LV_DECODE;
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,','),','),',,,,',','),',,,',','),',,',',');

RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;




create or replace FUNCTION DR_DECODE_CODE (P_DECODE IN VARCHAR, P_CODELIST_ID IN INTEGER)
RETURNS VARCHAR
LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE text;
LV_CODE TEXT := '';
LV_CODE1 TEXT := '';
Lv_decode text;
REC_LP RECORD;
BEGIN
FOR REC_LP IN (SELECT regexp_split_to_table(P_DECODE,',') COLUMN_VAL FROM DUAL)
LOOP
Lv_decode := REC_LP.COLUMN_VAL;
SELECT CC.CODE INTO LV_CODE
FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
AND CD.LANGUAGE_CODE = 'en'
AND CN.CODELIST_ID = P_CODELIST_ID
AND CC.CODE_STATUS='1'
AND UPPER(CD.DECODE)=UPPER(Lv_decode);

IF LV_CODE IS NULL OR LV_CODE = ''
THEN
LV_CODE:= '';
END IF;
IF LV_CODE1 IS NULL
THEN
LV_CODE1 := LV_CODE;
ELSE
LV_CODE1 := LV_CODE1||','||LV_CODE;
END IF;
END LOOP;
LV_CODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_CODE1,','),','),',,,,',','),',,,',','),',,',',');

RETURN LV_CODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;


------------------------------function for MAH------
create or replace FUNCTION DR_CODE_DECODE_ACC_MAH (P_CODE IN VARCHAR)
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   VARCHAR(2000);
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code VARCHAR(2000);
REC_LP RECORD;
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_CODE,',') COLUMN_VAL FROM DUAL)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 
		         SELECT ACCOUNT_NAME INTO LV_DECODE
                 FROM LSMV_ACCOUNTS
                 WHERE TRIM(ACCOUNT_NAME) = trim(Lv_code);
				 
		 
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 
			 SELECT NAME INTO LV_DECODE
                        FROM LSMV_PARTNER 
                        WHERE TRIM(name) = trim(Lv_code);
						
						IF LV_DECODE IS NULL OR LV_DECODE = ''
						THEN 
							 LV_DECODE := '';
						END IF;
						
						
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||'|'||LV_DECODE;
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,'|'),'|'),'||||','|'),'|||','|'),'||','|');

RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$;

----------for dr5008---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_SM (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;

BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_1 is null then Lv_1:='1013:'; end if;
		

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_2 is null then Lv_2:='8201:'; end if;
				
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------
		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE
								RAISE NOTICE 'MAH MISSING IN DR5008:%','Mah not found in CU and account' ;
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		     ELSE
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
			 END IF;
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Tiken%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		 END IF;
		 If Lv_9 is null then Lv_9:='1002:'; end if;
			
			

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) in (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);    
		 END IF;
		 
		 	If Lv_10 is null then Lv_10:='1002:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 END IF;
		 If Lv_11 is null then Lv_11:='1002:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_12 is null then Lv_12:='1002:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
              and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;
		 
		 
	 END LOOP;
	 		 
		
	 lv_final_string := COALESCE(Lv_8,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_5,'')||'/'||
	                    COALESCE(Lv_3,'')||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_1,'')||'/'||COALESCE(Lv_12,'')||'/'||COALESCE(Lv_13,'')||'/'||
						COALESCE(Lv_9,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_15,'')
						;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;



----------for dr5010---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_PG (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;
Lv_16 TEXT;

BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_1 is null then Lv_1:='1013:'; end if;
		

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_2 is null then Lv_2:='8201:'; end if;
				
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------
		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE
								RAISE NOTICE 'MAH MISSING IN DR5010:%','Mah not found in CU and account' ;
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		     ELSE
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
			 END IF;
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Inclusion%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		 END IF;
		 If Lv_9 is null then Lv_9:='1002:'; end if;
			
			

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		 END IF;
		 
		 	If Lv_10 is null then Lv_10:='1002:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 END IF;
		 If Lv_11 is null then Lv_11:='1002:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_12 is null then Lv_12:='1002:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
             and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Product_Group%'))
		 THEN  
		     DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 
			 SELECT '9741:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_16
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9741
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);			
		END IF;
		If Lv_16 is null then Lv_16:='9741:'; end if;
		 
		 
	 END LOOP;
	 		 
		
	 lv_final_string := COALESCE(Lv_8,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_9,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_16,'')||'/'||COALESCE(Lv_12,'')||'/'||COALESCE(Lv_3,'')||'/'||COALESCE(Lv_5,'')
					||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_1,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_13,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_15,'')
						;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;


----------FOR DR063
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_REGCNTRY (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
Lv_7 TEXT;	
Lv_8 TEXT;	
DR16P RECORD;
lv_final_string TEXT;
Lv_input_string TEXT;
l_context TEXT;

BEGIN

Lv_input_string:=TRIM(i_string);

 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_string,'\/+') AS IND_VALS
	 LOOP
			   
               IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%COUNTRY%')) THEN
			   DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			   --lv_reg_cntry := SUBSTR(cur_att_upd.I_STUDY_REGISTRAT_DR063_VAL,13);--E2B COUNTRY:Denmark

             SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		     
			  end if;
			  
              If Lv_7 is null then Lv_7:='1015:'; 
			  END IF;
			  IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('TRIAL%'))
			  THEN
			  
			 SELECT '5509:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_8
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 5509
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		
		      end if;
			  
			  If Lv_8 is null then Lv_8:='5509:'; 
			  END IF;
			  
			 END LOOP; 
			  lv_final_string := COALESCE(Lv_7,'')||'/'||COALESCE(Lv_8,'');
     RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;

CREATE OR REPLACE FUNCTION DR_DECODE_CODE_PROTOCOLNO (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
lv_protocol_code TEXT;	
DR16P RECORD;
lv_final_string TEXT;
Lv_input_string TEXT;
l_context TEXT;

BEGIN

Lv_input_string:=TRIM(i_string);

Lv_input_string := REPLACE(i_string,'/','?'); -- Added for "Study:DRL-INDG02-PAN/2018"

 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_string,'\/+') AS IND_VALS
	 LOOP
			   
               IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%Study%')) THEN
			   --lv_reg_cntry := SUBSTR(cur_att_upd.I_STUDY_REGISTRAT_DR063_VAL,13);--E2B COUNTRY:Denmark
			   select 'Study:'||COALESCE(STRING_AGG(protocol_no,','),'') into lv_protocol_code  from lsmv_study_library
	               where upper(TRIM(protocol_no)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);

		     
			  end if;
			  
			  IF DR16P.IND_VALS LIKE '%,%' AND lv_protocol_code NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in Protocol no -->   %',DR16P.IND_VALS;   -- Updated by Sai (09/04/2025) to find the missing values in the Database
			 ELSIF lv_protocol_code = 'Study:' then
				RAISE NOTICE 'issue in the Protocol no%',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
			  
			  
			  
              If lv_protocol_code is null then lv_protocol_code:='Study:'; 
			  END IF;
			  
			 END LOOP; 
			  lv_final_string := COALESCE(lv_protocol_code,'');
     RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;


CREATE OR REPLACE FUNCTION DR_DECODE_CODE_PROJECTNO (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
lv_project_code TEXT;	
DR16P RECORD;
lv_final_string TEXT;
Lv_input_string TEXT;
l_context TEXT;

BEGIN

Lv_input_string:=TRIM(i_string);

 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_string,'\/+') AS IND_VALS
	 LOOP
			   
               IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%StudyProjectNo%')) THEN
			   --lv_reg_cntry := SUBSTR(cur_att_upd.I_STUDY_REGISTRAT_DR063_VAL,13);--E2B COUNTRY:Denmark
			   
	select 'StudyProjectNo:'||COALESCE(STRING_AGG(PROJECT_NO,','),'') into lv_project_code  from lsmv_study_library
	where upper(TRIM(project_no)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
	
			   
		     
			  end if;
			  
              If lv_project_code is null then lv_project_code:='StudyProjectNo:'; 
			  END IF;
			  
			 END LOOP; 
			  lv_final_string := COALESCE(lv_project_code,'');
     RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;


----------for DR5099---------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION DR_DECODE_CODE_MATRIX (P_MULTIVALUE TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$
DECLARE
l_context TEXT;
CUR_TEST RECORD;
cur_meddra RECORD;
LV_MULTIVALUE TEXT;
lv_causality_val TEXT;
lv_causality_code TEXT;
lv_apprval_val text;
lv_apprval_code TEXT;
lv_final_string TEXT;
lv_prod_rec_id TEXT;
lv_prod_rec_id_code TEXT;
lv_life_thre_val TEXT;
lv_life_thre_code TEXT;
lv_cmp_causal_val TEXT;
lv_cmp_causal_code TEXT;
lv_rep_causal_val TEXT;
lv_rep_causal_code TEXT;
lv_prod_flag_val TEXT;
lv_prod_flag_code TEXT;
lv_study_prd_code_val TEXT;
lv_study_prd_code TEXT;
lv_event_ex_val TEXT;
lv_event_ex_code TEXT;
lv_mah_val TEXT;
lv_mah_code TEXT;
lv_meddra_val TEXT; -- TBD Record_id
lv_meddra_code TEXT;
lv_prod_char_val TEXT;
lv_prod_char_code TEXT;
lv_seriouss_val TEXT;
lv_seriouss_code TEXT;
lv_labell_val TEXT;
lv_study_cond_val TEXT;
lv_study_cond_code TEXT;
lv_apprval_cntry_val TEXT;
lv_apprval_cntry_code TEXT;
lv_labell_cntry_val TEXT;
lv_labell_cntry_code TEXT;
lv_death_val TEXT;
lv_death_code TEXT;
lv_labell_code TEXT;
lv_labell_val_code TEXT;
lv_meddra_val_final TEXT;
lv_study_condition_code TEXT;
lv_study_condition_val TEXT;
BEGIN
 
 LV_MULTIVALUE := P_MULTIVALUE;
 
		FOR CUR_TEST IN (SELECT regexp_split_to_table(LV_MULTIVALUE,'\/+') as lv_val)
		
		LOOP
		
			IF CUR_TEST.lv_val LIKE '1002_logic:%' 
			THEN		
				lv_causality_val := REPLACE(CUR_TEST.LV_VAL,'1002_logic:','');
				
				
				IF lv_causality_val <> ''
				THEN 
										
					lv_causality_code := lv_causality_val;
					lv_causality_val := '"'||REPLACE(lv_causality_val,',','","')||'"';
					
				END IF;
			END IF;	
			
			IF CUR_TEST.lv_val LIKE 'Product:%' 
			THEN		
				lv_prod_rec_id := REPLACE(CUR_TEST.LV_VAL,'Product:','');
				IF lv_prod_rec_id <> ''
				THEN 
					lv_prod_rec_id_code := lv_prod_rec_id;
					lv_prod_rec_id := '"'||REPLACE(lv_prod_rec_id,',','","')||'"';
					
				END IF;

			END IF;	
			
			IF CUR_TEST.lv_val LIKE '709:%' 
			THEN		
				lv_apprval_val := REPLACE(CUR_TEST.LV_VAL,'709:','');
				IF lv_apprval_val <> ''
				THEN 
					lv_apprval_code := lv_apprval_val;
					lv_apprval_val := '"'||REPLACE(lv_apprval_val,',','","')||'"';
					
				END IF;				

			END IF;	
			
			IF CUR_TEST.lv_val LIKE '1002_lft:%' 
			THEN		
				lv_life_thre_val := REPLACE(CUR_TEST.LV_VAL,'1002_lft:','');
				IF lv_life_thre_val <> ''
				THEN 
					lv_life_thre_code := lv_life_thre_val;
					lv_life_thre_val := '"'||REPLACE(lv_life_thre_val,',','","')||'"';
					
				END IF;	
			END IF;	

			IF CUR_TEST.lv_val LIKE '9062_cmp:%' 
			THEN		
				lv_cmp_causal_val := REPLACE(CUR_TEST.LV_VAL,'9062_cmp:','');
				
				IF lv_cmp_causal_val <> ''
				THEN 
					lv_cmp_causal_code := lv_cmp_causal_val;
					lv_cmp_causal_val := '"'||REPLACE(lv_cmp_causal_val,',','","')||'"';
					
				END IF;		

			END IF;				
				
			IF CUR_TEST.lv_val LIKE '9062_rep:%' 
			THEN		
				lv_rep_causal_val := REPLACE(CUR_TEST.LV_VAL,'9062_rep:','');
				
				IF lv_rep_causal_val <> ''
				THEN 
					lv_rep_causal_code := lv_rep_causal_val;
					lv_rep_causal_val := '"'||REPLACE(lv_rep_causal_val,',','","')||'"';
					
				END IF;	

			END IF;		

			IF CUR_TEST.lv_val LIKE '5015:%' 
			THEN		
				lv_prod_flag_val := REPLACE(CUR_TEST.LV_VAL,'5015:','');
				
				IF lv_prod_flag_val <> ''
				THEN 
					lv_prod_flag_code := lv_prod_flag_val;
					lv_prod_flag_val := '"'||REPLACE(lv_prod_flag_val,',','","')||'"';
					
				END IF;

			END IF;	

			IF CUR_TEST.lv_val LIKE '8008:%' 
			THEN		
				lv_study_prd_code_val := REPLACE(CUR_TEST.LV_VAL,'8008:','');
				
				IF lv_study_prd_code_val <> ''
				THEN 
					lv_study_prd_code := lv_study_prd_code_val;
					lv_study_prd_code_val := '"'||REPLACE(lv_study_prd_code_val,',','","')||'"';
					
				END IF;
			END IF;	
			
			IF CUR_TEST.lv_val LIKE '1002_ss_excl:%' 
			THEN		
				lv_event_ex_val := REPLACE(CUR_TEST.LV_VAL,'1002_ss_excl:','');
				IF lv_event_ex_val <> ''
				THEN 
					lv_event_ex_code := lv_event_ex_val;
					lv_event_ex_val := '"'||REPLACE(lv_event_ex_val,',','","')||'"';
					
				END IF;
			END IF;	
			
			IF CUR_TEST.lv_val LIKE 'CU_ACC:%' 
			THEN		
				lv_mah_val := REPLACE(CUR_TEST.LV_VAL,'CU_ACC:','');
				
				IF lv_mah_val <> ''
				THEN 
					lv_mah_code := lv_mah_val;
					lv_mah_val := '"'||REPLACE(lv_mah_val,',','","')||'"';
					
				END IF;
				
			END IF;	

			IF CUR_TEST.lv_val LIKE 'Meddra:%' 
			THEN		
				lv_meddra_val := REPLACE(CUR_TEST.LV_VAL,'Meddra:','');
				
				IF lv_meddra_val <> ''
				THEN 
					lv_meddra_code := lv_meddra_val;
					--lv_meddra_val := '"'||REPLACE(lv_meddra_val,',','","')||'"'; -- "LIB_Meddra":{"values":["10037660|10028810"],"fieldLabel":"Event MedDRA PT Code","label":"Pyrexia(10037660)|Nasopharyngitis(10028810)"}
					
					/* IF lv_meddra_val NOT LIKE '%HLGT%' THEN
					lv_meddra_val_final := '"'||lv_meddra_val_final||'"';
					END IF; */
					
					IF lv_meddra_val NOT LIKE '%SMQCMQ#%' AND lv_meddra_val NOT LIKE '%HLGT%' 
					THEN --SMQCMQ#50000486
					FOR cur_meddra in (select REVERSE(SUBSTRING(REVERSE(RTRIM(regexp_split_to_table(lv_meddra_val,'\,+'),')')),1,8)) as lv_medd) --Pyrexia(10037660),Nasopharyngitis(10028810)
						loop
						
						lv_meddra_val_final := COALESCE(lv_meddra_val_final,'')||'|'||cur_meddra.lv_medd;
						lv_meddra_val_final := LTRIM(lv_meddra_val_final,'|');
						
						end loop;
						lv_meddra_val_final := '"'||lv_meddra_val_final||'"';
						ELSE 
						lv_meddra_val_final := '"'||lv_meddra_val||'"';
						
					END IF;
						--RAISE NOTICE 'lv_meddra_val_final : %',lv_meddra_val_final;
				END IF;
				--RAISE NOTICE 'Final sting : %',lv_meddra_val_final;
			END IF;
			
			IF CUR_TEST.lv_val LIKE '1013:%' 
			THEN		
				lv_prod_char_val := REPLACE(CUR_TEST.LV_VAL,'1013:','');
				
				IF lv_prod_char_val <> ''
				THEN 
					lv_prod_char_code := lv_prod_char_val;
					lv_prod_char_val := '"'||REPLACE(lv_prod_char_val,',','","')||'"';
					
				END IF;
				
			END IF;

			IF CUR_TEST.lv_val LIKE '1002_ser:%' 
			THEN		
				lv_seriouss_val := REPLACE(CUR_TEST.LV_VAL,'1002_ser:','');
				IF lv_seriouss_val <> ''
				THEN 
					lv_seriouss_code := lv_seriouss_val;
					lv_seriouss_val := '"'||REPLACE(lv_seriouss_val,',','","')||'"';
					
				END IF;
				
			END IF;
			IF CUR_TEST.lv_val LIKE '9159:%' --9159:true
			THEN		
				--lv_labell_code :=  '"'||REPLACE(REPLACE(REPLACE(REPLACE(CUR_TEST.LV_VAL,'9159:',''),'false','8002'),'true','8001'),',','","')||'"'; -- TBD
				lv_labell_code :=  '"'||REPLACE(CUR_TEST.LV_VAL,'9159:','')||'"';
				lv_labell_val := REPLACE(CUR_TEST.LV_VAL,'9159:',''); -- TBD
				IF lv_labell_val <> ''
				THEN 
					lv_labell_val_code := lv_labell_val;
					lv_labell_val := '"'||REPLACE(lv_labell_val,',','","')||'"';
					
				END IF;
			END IF;
			
			IF CUR_TEST.lv_val LIKE '10151:%' 
			THEN		
				lv_study_cond_val := REPLACE(CUR_TEST.LV_VAL,'10151:','');
				
				IF lv_study_cond_val <> ''
				THEN 
					lv_study_cond_code := lv_study_cond_val;
					lv_study_cond_val := '"'||REPLACE(lv_study_cond_val,',','","')||'"';
					
				END IF;
				
			END IF;
			
			IF CUR_TEST.lv_val LIKE '1015:%' 
			THEN		
				lv_apprval_cntry_val := REPLACE(CUR_TEST.LV_VAL,'1015:','');
				
				IF lv_apprval_cntry_val <> ''
				THEN 
					lv_apprval_cntry_code := lv_apprval_cntry_val;
					lv_apprval_cntry_val := '"'||REPLACE(lv_apprval_cntry_val,',','","')||'"';
					
				END IF;
				
				
			END IF;
			
			IF CUR_TEST.lv_val LIKE 'LIB_9744_1015:%' 
			THEN		
				lv_labell_cntry_val := REPLACE(CUR_TEST.LV_VAL,'LIB_9744_1015:',''); -- 9744 OR 1015
				
				IF  lv_labell_cntry_val <> ''
				THEN 
					lv_labell_cntry_code := lv_labell_cntry_val;
					lv_labell_cntry_val := '"'||REPLACE(lv_labell_cntry_val,',','","')||'"';
					
				END IF;
				
			END IF;
			
			IF CUR_TEST.lv_val LIKE '1002_death:%' 
			THEN		
				lv_death_val := REPLACE(CUR_TEST.LV_VAL,'1002_death:',''); 
				IF  lv_death_val <> ''
				THEN 
					lv_death_code := lv_death_val;
					lv_death_val := '"'||REPLACE(lv_death_val,',','","')||'"';
					
				END IF;
			END IF;
			
			
			IF CUR_TEST.lv_val LIKE '1021_study_cond:%' 
			THEN		
				lv_study_condition_val := REPLACE(CUR_TEST.LV_VAL,'1021_study_cond:',''); 
				IF  lv_study_condition_val <> ''
				THEN 
					lv_study_condition_code := lv_study_condition_val;
					lv_study_condition_val := '"'||REPLACE(lv_study_condition_val,',','","')||'"';
					
				END IF;
			END IF;
			
		END LOOP;
		
 lv_final_string = '{"adhocRules":[],"paramMap":{"CL_1002_causalityCondition.safetyReport.aerInfo.flpath":{"values":['
		||COALESCE(lv_causality_val,'')||'],"fieldLabel":"Causality Condition (Yes = And, No= Or)","label":"'||COALESCE(DR_CODE_DECODE(lv_causality_code,1002),'')||
		'"},"LIB_Product":{"values":['||COALESCE(lv_prod_rec_id,'')||'],"fieldLabel":"CPD Product description","label":"'||COALESCE(REPLACE(DR_CODE_DECODE_PRD(lv_prod_rec_id_code),',','|'),'')||
		'"},"CL_709":{"values":['||COALESCE(lv_apprval_val,'')||'],"fieldLabel":"CPD Approval Type","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_apprval_code,709),',','|'),'')||
		'"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":['||COALESCE(lv_life_thre_val,'')||'],"fieldLabel":"Life Threatening?","label":"'||COALESCE(DR_CODE_DECODE(lv_life_thre_code,1002),'')||
		'"},"CL_9062":{"values":['||COALESCE(lv_cmp_causal_val,'')||'],"fieldLabel":"Company Causality","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_cmp_causal_code,9062),',','|'),'')||
		'"},"CL_9062_reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":['||COALESCE(lv_rep_causal_val,'')||'],"fieldLabel":"Reporter Causality","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_rep_causal_code,9062),',','|'),'')||
		'"},"CL_5015":{"values":['||COALESCE(lv_prod_flag_val,'')||'],"fieldLabel":"CPD Product Flag","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_prod_flag_code,5015),',','|'),'')||
		'"},"CL_8008":{"values":['||COALESCE(lv_study_prd_code_val,'')||'],"fieldLabel":"Study Product Type","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_study_prd_code,8008),',','|'),'')||
		'"},"CL_1002_eventExclude.safetyReport.aerInfo.flpath":{"values":['||COALESCE(lv_event_ex_val,'')||'],"fieldLabel":"Event Exclude (Yes = Exclude, No = Include)","label":"'||COALESCE(DR_CODE_DECODE(lv_event_ex_code,1002),'')||
		'"},"LIB_CU_ACC":{"values":['||COALESCE(lv_mah_val,'')||'],"fieldLabel":"CPD MAH As Coded","label":"'||COALESCE(REPLACE(lv_mah_code,',','|'),'')||
		'"},"LIB_Meddra":{"values":['||COALESCE(lv_meddra_val_final,'')||'],"fieldLabel":"Event MedDRA PT Code","label":"'||COALESCE(REPLACE(lv_meddra_code,',','|'),'')||
		'"},"CL_1013":{"values":['||COALESCE(lv_prod_char_val,'')||'],"fieldLabel":"Product Characterization","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_prod_char_code,1013),',','|'),'')||
		'"},"CL_1002":{"values":['||COALESCE(lv_seriouss_val,'')||'],"fieldLabel":"Seriousness","label":"'||COALESCE(DR_CODE_DECODE(lv_seriouss_code,1002),'')||
		'"},"CL_9159":{"values":['||COALESCE(lv_labell_code,'')||'],"fieldLabel":"Labelling","label":"'||COALESCE(DR_CODE_DECODE(lv_labell_val_code,9159),'')||
		'"},"CL_10151":{"values":['||COALESCE(lv_study_cond_val,'')||'],"fieldLabel":"Related to study conduct","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_study_cond_code,10151),',','|'),'')||
		'"},"CL_1002_causeOfAdverse.safetyReport.aerInfo.flpath":{"values":['||COALESCE(lv_study_condition_val,'')||'],"fieldLabel":"Related to Study Condition (Yes = And, No = Or)","label":"'||COALESCE(DR_CODE_DECODE(lv_death_code,1002),'')||
		'"},"CL_1015":{"values":['||COALESCE(lv_apprval_cntry_val,'')||'],"fieldLabel":"CPD Authorization Country","label":"'||COALESCE(REPLACE(DR_CODE_DECODE(lv_apprval_cntry_code,1015),',','|'),'')||
		'"},"LIB_9744_1015":{"values":['||COALESCE(lv_labell_cntry_val,'')||'],"fieldLabel":"Labelling Country","label":"'||COALESCE(REPLACE(DR_CODE_DECODE_LBL_CNTRY(lv_labell_cntry_code),',','|'),'')||
		'"},"CL_1002_death.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":['||COALESCE(lv_death_val,'')||'],"fieldLabel":"Death?","label":"'||COALESCE(DR_CODE_DECODE(lv_death_code,1002),'')||
		'"}}}';
		
		
		--RAISE NOTICE 'Final sting : %',lv_final_string;
		
		
RETURN lv_final_string;
EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION%', l_context;
END;
$BODY$;

----------for dr5049---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_SSIC (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;
Lv_16 TEXT;
Lv_17 TEXT;
Lv_18 TEXT;
Lv_19 TEXT;
Lv_20 TEXT;
Lv_21 TEXT;
Lv_22 TEXT;
Lv_23 TEXT;
Lv_24 TEXT;
Lv_25 TEXT;
Lv_26 TEXT;

BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_1 is null then Lv_1:='1013:'; end if;
		

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Reporter_Causality%'))
		THEN  
			 SELECT '9062:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9062
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_2 is null then Lv_2:='9062:'; end if;
				
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------

		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE	
								RAISE NOTICE 'MAH MISSING IN DR5001:%','Mah not found in CU and account' ;
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000));
		     ELSE
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
			 END IF;
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Inclusion%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		 END IF;
		 If Lv_9 is null then Lv_9:='1002:'; end if;
			
			

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		 END IF;
		 
		 	If Lv_10 is null then Lv_10:='1002:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 END IF;
		 If Lv_11 is null then Lv_11:='1002:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_12 is null then Lv_12:='1002:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
             and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Product_Group%'))
		 THEN  
		     DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 
			 SELECT '9741:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_16
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9741
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);			
		END IF;
		If Lv_16 is null then Lv_16:='9741:'; end if;
		
		
		-----------------------------------------

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%Strength_unit%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_(unit)%'))
		 THEN
			 
			 SELECT '9070:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_17
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9070
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);			
		END IF;
		If Lv_17 is null then Lv_17:='9070:'; end if;
		
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%Form_of_admin%'))
		 THEN  
		     DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 
			 SELECT '805:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_18
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 805
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);			
		END IF;
		If Lv_18 is null then Lv_18:='805:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('New_Drug%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_19
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));   
		 END IF;
		 
		 	If Lv_19 is null then Lv_19:='1002:'; end if;
			
			
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality:%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_20
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_20 is null then Lv_20:='8201:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality_Logic%'))
		THEN  
			 SELECT '1021:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_21
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1021
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_21 is null then Lv_21:='1021:'; end if; 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('SS_Exclude%'))
		THEN  
			 SELECT '1021:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_22
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1021
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_22 is null then Lv_22:='1021:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Company_Causality%'))
		THEN  
			 SELECT '9062:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_23
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9062
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_23 is null then Lv_23:='9062:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('IC_Exclude%'))
		THEN  
			 SELECT '1021:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_24
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1021
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_24 is null then Lv_24:='1021:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('MedDRA%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Meddra%'))
		THEN  
			 
			 SELECT  'Meddra:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_25 FROM DUAL;
			 
		END IF;
		If Lv_25 is null then Lv_25:='Meddra:'; end if;
		
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_(number)%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_number%'))
		 THEN 
			 
             SELECT  'substanceStrength:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_26 FROM DUAL;
			 
		 END IF;
		 If Lv_26 is null then Lv_26:='substanceStrength:'; end if;
		
		 
	 END LOOP;

		
	 lv_final_string := COALESCE(Lv_17,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_16,'')||'/'||COALESCE(Lv_18,'')||'/'||COALESCE(Lv_9,'')||'/'||COALESCE(Lv_19,'')||'/'||COALESCE(Lv_3,'')||'/'||COALESCE(Lv_5,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_1,'')||'/'||COALESCE(Lv_13,'')||'/'||COALESCE(Lv_12,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_21,'')||'/'||COALESCE(Lv_8,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_24,'')||'/'||COALESCE(Lv_20,'')||'/'||COALESCE(Lv_22,'')||'/'||COALESCE(Lv_25,'')||'/'||COALESCE(Lv_23,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_26,'')||'/'||COALESCE(Lv_15,'')
	;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;

----------for dr5049---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_SSIC_NEW (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;
Lv_16 TEXT;
Lv_17 TEXT;
Lv_18 TEXT;
Lv_19 TEXT;
Lv_20 TEXT;
Lv_21 TEXT;
Lv_22 TEXT;
Lv_23 TEXT;
Lv_24 TEXT;
Lv_25 TEXT;
Lv_26 TEXT;
Lv_27 TEXT;
Lv_28 TEXT;
Lv_8_product TEXT;
product_group_name_val text;

BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_1 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 
			 ELSIF Lv_1 = '1013:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
			 
			 
		END IF;
		
		If Lv_1 is null then Lv_1:='1013:'; end if;
		

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Reporter_Causality%'))
		THEN  
			 SELECT '9062_rep:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9062
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
			 
			IF DR16P.IND_VALS LIKE '%,%' AND Lv_2 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_2 = '9062_rep:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		
		END IF;
		If Lv_2 is null then Lv_2:='9062:'; end if;
				
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		  
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_3 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_3 = '5015:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		 
				--RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS||' : '||Lv_4;
		 
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_4 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 
			 ELSIF Lv_4 = '709:' then 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;
			 
			 END IF;
		 
		 
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_5 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 
			 ELSIF Lv_5 = '8008:' then 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;
			 
			 ELSIF Lv_5 = '8008:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 		 
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------

		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE	
								RAISE NOTICE 'MAH MISSING IN DR5001:%','Mah not found in CU and account' ;
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 
			 IF DR16P.IND_VALS LIKE '%^%' AND Lv_7 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_7 = '1015:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000));
				 
				 select product_group_name into product_group_name_val
				 from lsmv_product_group
				 where product_group_name in (SUBSTRING(DR16P.IND_VALS,36));	
				
				IF product_group_name_val IS NULL THEN 
					RAISE NOTICE 'Portfolio is not present  --> %',SUBSTRING(DR16P.IND_VALS,36); 
				END IF; 
				
		     ELSE
			 --RAISE NOTICE 'issue in product: %',DR16P.IND_VALS;
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
				
				
			 
			 END IF;
			 IF DR16P.IND_VALS LIKE '%^%' AND Lv_8 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_8 = 'Product:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
			 
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		 
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Inclusion%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		 
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_9 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_1 = '1002:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 
		 
		 END IF;
		 If Lv_9 is null then Lv_9:='1002:'; end if;
			
			

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002_ser:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		   
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_10 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_10 = '1002_ser:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 
		 END IF;
		 
		 	If Lv_10 is null then Lv_10:='1002_ser:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002_death:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_11 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_11 = '1002_death:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 END IF;
		 If Lv_11 is null then Lv_11:='1002_death:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002_lft:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_12 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_12 = '1002_lft:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		
		END IF;
		If Lv_12 is null then Lv_12:='1002_lft:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_13 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_13 = '9159:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
				
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
             and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_14 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_14 = 'LIB_9744_1015:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		 
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Product_Group%'))
		 THEN  
		     DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 
			 SELECT '9741:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_16
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9741
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);			
		END IF;
		If Lv_16 is null then Lv_16:='9741:'; end if;
		
		
		-----------------------------------------

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%Strength_unit%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_(unit)%'))
		 THEN
			 
			 SELECT '9070:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_17
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9070
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);			
		END IF;
		If Lv_17 is null then Lv_17:='9070:'; end if;
		
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%Form_of_admin%'))
		 THEN  
		     DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 
			 SELECT '805:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_18
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 805
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);			
		END IF;
		If Lv_18 is null then Lv_18:='805:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('New_Drug%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_19
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));   
		 END IF;
		 
		 	If Lv_19 is null then Lv_19:='1002:'; end if;
			
			
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality:%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_20
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		 
		 
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_20 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_1 = '8201:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		
		END IF;
		If Lv_20 is null then Lv_20:='8201:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality_Logic%'))
		THEN  
			 SELECT '1002_logic:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_21
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_21 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_1 = '1002_logic:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
				
		END IF;
		If Lv_21 is null then Lv_21:='1021_logic:'; end if; 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('SS_Exclude%'))
		THEN  
			 SELECT '1002_ss_excl:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_22
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_22 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_22 = '1002_ss_excl:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		END IF;
		If Lv_22 is null then Lv_22:='1021:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Company_Causality%'))
		THEN  
			 SELECT '9062_cmp:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_23
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9062
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		
		     IF DR16P.IND_VALS LIKE '%,%' AND Lv_23 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_23 = '9062_cmp:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		END IF;
		If Lv_23 is null then Lv_23:='9062:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('IC_Exclude%'))
		THEN  
			 SELECT '1021:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_24
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1021
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_24 is null then Lv_24:='1021:'; end if;
		
		
		------------------------
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('study_conduct%'))
		THEN  
			 SELECT '10151:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_27
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 10151
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		 
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_27 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_27 = '10151:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		END IF;
		If Lv_27 is null then Lv_27:='1021:'; end if;	
		
				
		-----------------------------
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('study_Condition%'))
		THEN  
			 SELECT '1021_study_cond:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_28
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		 
			 IF DR16P.IND_VALS LIKE '%,%' AND Lv_28 NOT LIKE '%,%' THEN 
				RAISE NOTICE 'issue in some of the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 ELSIF Lv_1 = '1021_study_cond:' then
				RAISE NOTICE 'issue in the  %',DR16P.IND_VALS;   -- Updated by Sai (28/03/2025) to find the missing values in the Database
			 END IF;
		
		END IF;
		If Lv_28 is null then Lv_28:='1021_study_cond:'; end if;
		
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('MedDRA%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Meddra%'))
		THEN  
			 
			 SELECT  'Meddra:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_25 FROM DUAL;
			 
		END IF;
		If Lv_25 is null then Lv_25:='Meddra:'; end if;
		
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_(number)%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Strength_number%'))
		 THEN 
			 
             SELECT  'substanceStrength:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_26 FROM DUAL;
			 
		 END IF;
		 If Lv_26 is null then Lv_26:='substanceStrength:'; end if;
		
		 
	 END LOOP;

		
	 lv_final_string := COALESCE(Lv_17,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_16,'')||'/'||COALESCE(Lv_18,'')||'/'||COALESCE(Lv_9,'')||'/'||COALESCE(Lv_19,'')||'/'||COALESCE(Lv_3,'')||'/'||COALESCE(Lv_5,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_1,'')||'/'||COALESCE(Lv_13,'')||'/'||COALESCE(Lv_12,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_21,'')||'/'||COALESCE(Lv_8,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_24,'')||'/'||COALESCE(Lv_20,'')||'/'||COALESCE(Lv_22,'')||'/'||COALESCE(Lv_25,'')||'/'||COALESCE(Lv_23,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_26,'')||'/'||COALESCE(Lv_15,'')||'/'||COALESCE(Lv_27,'')||'/'||COALESCE(Lv_28,'')
	;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;


----------for dr5016---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_RM (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;
Lv_16 TEXT;
Lv_17 TEXT;


BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_1 is null then Lv_1:='1013:'; end if;
			

		
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Tiken%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		 END IF;
		 If Lv_2 is null then Lv_2:='1002:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------

		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE	
								RAISE NOTICE 'MAH MISSING IN DR5001:%','Mah not found in CU and account' ;
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		     ELSE
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
			 END IF;
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Malfunction%'))
		 THEN 
			 
			 SELECT '9606:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9606
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		 END IF;
		 
		 	If Lv_9 is null then Lv_9:='9606:'; end if;

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		 END IF;
		 
		 	If Lv_10 is null then Lv_10:='1002:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 END IF;
		 If Lv_11 is null then Lv_11:='1002:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_12 is null then Lv_12:='1002:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
             and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;
			
			
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality:%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_16
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_16 is null then Lv_16:='8201:'; end if;
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Remedial%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_17
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) IN  (SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);   
		 END IF;
		 
		 	If Lv_17 is null then Lv_17:='1002:'; end if;
		 
	 END LOOP;

		
	 lv_final_string := COALESCE(Lv_4,'')||'/'||COALESCE(Lv_16,'')||'/'||COALESCE(Lv_9,'')||'/'||COALESCE(Lv_3,'')||'/'||COALESCE(Lv_5,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_6,'')||'/'||COALESCE(Lv_1,'')||'/'||COALESCE(Lv_13,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_12,'')||'/'||COALESCE(Lv_7,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_8,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_17,'')||'/'||COALESCE(Lv_15,'')
	;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;



----------for dr5008---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DR_DECODE_CODE_SM (i_string TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$DECLARE
l_context TEXT;
lv_final_string TEXT;
Lv_input_sting TEXT;
DR16P RECORD;
Lv_1 TEXT;
Lv_2 TEXT;
Lv_3 TEXT;
Lv_4 TEXT;
Lv_5 TEXT;
Lv_6 TEXT;
lv_mah TEXT;
Lv_7 TEXT;
Lv_8 TEXT;
Lv_9 TEXT;
Lv_10 TEXT;
Lv_11 TEXT;
Lv_12 TEXT;
Lv_13 TEXT;
Lv_14 TEXT;
Lv_15 TEXT;

BEGIN 

	 Lv_input_sting:=  REPLACE(REPLACE(i_string,'Nutraceutical/Food','Nutraceutical?Food'),'Placebo/Vehicle','Placebo?Vehicle');
	 
	 
	 FOR DR16P IN  SELECT regexp_split_to_table(Lv_input_sting,'\/+') AS IND_VALS
	 LOOP
		 
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%CHARACTER%'))
		 THEN  
			 SELECT '1013:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_1
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1013
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\,+') FROM DUAL);
		END IF;
		If Lv_1 is null then Lv_1:='1013:'; end if;
		

		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Causality%'))
		THEN  
			 SELECT '8201:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_2
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8201
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_2 is null then Lv_2:='8201:'; end if;
				
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('%FLAG%'))
		 THEN  
			 SELECT '5015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_3
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 5015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_3 is null then Lv_3:='5015:'; end if;
		 
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Approval%')
		 THEN  
			 SELECT '709:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_4
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 709
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\|+') FROM DUAL);		
		 END IF;
		 If Lv_4 is null then Lv_4:='709:'; end if;
		 		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Study Product Type%'))
		 THEN  
			 SELECT '8008:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_5
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8008
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'?','/'),'\,+') FROM DUAL);		
		 END IF;
		 If Lv_5 is null then Lv_5:='8008:'; end if;
		 
------------------------------------
		IF  UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('mah%')) 
					THEN
		
						lv_mah := SUBSTR(DR16P.IND_VALS,DR_instr(DR16P.IND_VALS,':',1,1)+1); --5
						Lv_6 := null;

						DECLARE
							lv_cd_code VARCHAR(1000);
							lv_cd_decode VARCHAR(100);
							DR5008_mah_cu VARCHAR(100);
							DR5008_mah_acc VARCHAR(100);
							lv_test_null_cu VARCHAR(1000);
							lv_test_null_acc VARCHAR(1000);
							CUR_MAH_VAL RECORD;
							lv_cnt int;
							lv_mah_record_name_cu varchar(1000);
							lv_mah_record_name_acc varchar(1000);
							lv_acc_cnt int;
							
						BEGIN
							lv_test_null_cu := NULL;
							lv_test_null_acc := NULL;

							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
								--------------------mah in company unit
									SELECT COUNT(*) INTO lv_cnt
									FROM lsmv_partner
									WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									/*IF lv_cnt = 0
									THEN
								
										RAISE NOTICE 'MAH COMPANY UNIT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
									
									ELS*/
									
									IF lv_cnt = 1 
									THEN
								
										SELECT name INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									ELSE
								
										SELECT STRING_AGG(TRIM(name),',') INTO STRICT lv_mah_record_name_cu
										FROM lsmv_partner
										WHERE UPPER(TRIM(name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
								
									IF lv_test_null_cu IS NULL 
									THEN
										DR5008_mah_cu := lv_mah_record_name_cu;
										lv_test_null_cu := DR5008_mah_cu;
									ELSE
										DR5008_mah_cu := DR5008_mah_cu||','||lv_mah_record_name_cu;
									END IF;
									
									EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;
									
							FOR CUR_MAH_VAL IN  SELECT regexp_split_to_table(lv_mah,'\^+') AS usr_mah
							LOOP
								
								BEGIN
								
									-------------------------mah in account
									SELECT COUNT(*) INTO lv_acc_cnt
									FROM lsmv_accounts
									WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
									
									
									/*IF lv_acc_cnt = 0 
									THEN
									
										RAISE NOTICE 'MAH ACCOUNT MISSING IN DR5009:%',cur_att_upd.CONTACT_NAME||' - '||cur_att_upd.FORMAT||' - '||cur_att_upd.DISPLAY_NAME||' - '||CUR_MAH_VAL.usr_mah;
				 
									ELS*/
									IF lv_acc_cnt = 1 
									THEN				 
				 
										SELECT account_name INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									ELSE
									
										SELECT STRING_AGG(TRIM(account_name),',') INTO STRICT lv_mah_record_name_acc
										FROM lsmv_accounts
										WHERE UPPER(TRIM(account_name)) = UPPER(TRIM(CUR_MAH_VAL.usr_mah));
				 
									END IF;
									
									IF lv_test_null_acc IS NULL 
									THEN
										DR5008_mah_acc := lv_mah_record_name_acc;
										lv_test_null_acc := DR5008_mah_acc;
									ELSE
										DR5008_mah_acc := DR5008_mah_acc||','||lv_mah_record_name_acc;
									END IF;
								
							--END LOOP;	
							
							--lv_test_null_cu := NULL;
							--lv_test_null_acc := NULL;

								EXCEPTION 
									WHEN OTHERS THEN 
										raise notice '%','mah not found';
										
								END;
								
							END LOOP;

							
							IF DR5008_mah_acc IS NULL and DR5008_mah_cu IS NULL
							THEN
								RAISE NOTICE 'MAH MISSING IN DR5009:%','Mah not found in CU and account' ;
							ELSIF DR5008_mah_acc IS NULL and DR5008_mah_cu IS not NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_cu),',');
							ELSIF DR5008_mah_acc IS not NULL and DR5008_mah_cu IS NULL
							THEN
								Lv_6:= LTRIM(('CU_ACC:'||DR5008_mah_acc),',');
							ELSE
								Lv_6 := LTRIM(('CU_ACC:'||DR5008_mah_acc||','||DR5008_mah_cu),',');
							END IF;
							
						END;
		end if;
		If Lv_6 is null then Lv_6:='CU_ACC:'; end if;
-------------------------------------
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization_Country%'))
		 THEN  
		 
		 DR16P.IND_VALS := replace(DR16P.IND_VALS,',',', ');
			 SELECT '1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_7
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
			 AND CC.CODE_STATUS='1'
             AND CN.CODELIST_ID = 1015
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_7 is null then Lv_7:='1015:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER('Product description%')
		 THEN 
			 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE '%PORTFOLIO%'
			 THEN 
				 Lv_8 := 'Product:'||UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		     ELSE
			 	SELECT 'Product:'||COALESCE(STRING_AGG(TRIM(TO_CHAR(RECORD_ID,'99999999999999999')),','),'') INTO Lv_8
				FROM LSMV_PRODUCT
				WHERE TRIM(UPPER(PRODUCT_NAME)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);
			 END IF;
		 END IF;
		 If Lv_8 is null then Lv_8:='Product:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Tiken%'))
		 THEN  
			 SELECT '8202:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_9
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 8202
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));
		END IF;
		If Lv_9 is null then Lv_9:='8202:'; end if;  
			
			

		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Seriousness%'))
		 THEN 
			 
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_10
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));    
		END IF; 
		If Lv_10 is null then Lv_10:='1002:'; end if;

		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('death%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_11
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));		
		 END IF;
		 If Lv_11 is null then Lv_11:='1002:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Life_Threatening%'))
		 THEN  
			 SELECT '1002:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_12
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 1002
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_12 is null then Lv_12:='1002:'; end if;

		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Listed%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Labelling%'))
		 THEN  
			 SELECT '9159:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_13
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID = 9159
			 AND UPPER(TRIM(CD.DECODE)) = UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000)));			
		END IF;
		If Lv_13 is null then Lv_13:='9159:'; end if;
		
		
		IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Country%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('E2B Country%'))
		 THEN  
			 SELECT 'LIB_9744_1015:'||COALESCE(STRING_AGG(CC.CODE,','),'') INTO Lv_14
             FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
             WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
             AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
             AND CD.LANGUAGE_CODE = 'en'
             AND CN.CODELIST_ID IN ('1015','9744')
              and cc.code<>'8002'
			 and cc.code_status = '1'
			 AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000))),'\^+') FROM DUAL);		
		 END IF;
		 If Lv_14 is null then Lv_14:='LIB_9744_1015:'; end if;
		 
		 
		 IF TRIM(UPPER(DR16P.IND_VALS)) LIKE UPPER(TRIM('Approval No%')) OR UPPER(TRIM(DR16P.IND_VALS)) LIKE UPPER(TRIM('Authorization No%'))
		 THEN 
			 
             SELECT  'Approval No:'||TRIM(COALESCE(SUBSTRING(DR16P.IND_VALS,DR_INSTR(DR16P.IND_VALS,':',1,1)+1,1000),'')) INTO Lv_15 FROM DUAL;
			 
		 END IF;
		 If Lv_15 is null then Lv_15:='Approval No:'; end if;
		 
		 
	 END LOOP;
	 		 
		
	 lv_final_string := COALESCE(Lv_1,'')||'/'||COALESCE(Lv_5,'')||'/'||COALESCE(Lv_8,'')||'/'||COALESCE(Lv_4,'')||'/'||COALESCE(Lv_7,'')||'/'||
	                    COALESCE(Lv_6,'')||'/'||COALESCE(Lv_15,'')||'/'||COALESCE(Lv_10,'')||'/'||COALESCE(Lv_11,'')||'/'||COALESCE(Lv_12,'')||'/'||
						COALESCE(Lv_13,'')||'/'||COALESCE(Lv_14,'')||'/'||COALESCE(Lv_2,'')||'/'||COALESCE(Lv_9,'')||'/'||COALESCE(Lv_3,'')
						;
						
	-- lv_final_string:=trim(replace(lv_final_string,'XYZ:/','')); 	
    -- lv_final_string:=trim(replace(lv_final_string,'/:ABC','')); 	 
						
	 --RAISE NOTICE 'lv_final_string is: %',lv_final_string;
	 RETURN lv_final_string;
EXCEPTION 
WHEN OTHERS THEN 
RETURN 0;
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RETURN l_context;
END;$BODY$;






-------------------------------------DR5025 Start

CREATE OR REPLACE FUNCTION DR_DECODE_CODE_PAT_COUNTRY (P_MULTIVALUE TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$
DECLARE
l_context TEXT;
CUR_TEST RECORD;
cur_meddra RECORD;
LV_MULTIVALUE TEXT;
lv_causality_val TEXT;
lv_causality_code TEXT;
lv_apprval_val text;
lv_apprval_code TEXT;
lv_final_string TEXT;
lv_prod_rec_id TEXT;
lv_prod_rec_id_code TEXT;
lv_life_thre_val TEXT;
lv_life_thre_code TEXT;
lv_cmp_causal_val TEXT;
lv_cmp_causal_code TEXT;
lv_rep_causal_val TEXT;
lv_rep_causal_code TEXT;
lv_prod_flag_val TEXT;
lv_prod_flag_code TEXT;
lv_study_prd_code_val TEXT;
lv_study_prd_code TEXT;
lv_event_ex_val TEXT;
lv_event_ex_code TEXT;
lv_mah_val TEXT;
lv_mah_code TEXT;
lv_meddra_val TEXT; -- TBD Record_id
lv_meddra_code TEXT;
lv_prod_char_val TEXT;
lv_prod_char_code TEXT;
lv_seriouss_val TEXT;
lv_seriouss_code TEXT;
lv_labell_val TEXT;
lv_study_cond_val TEXT;
lv_study_cond_code TEXT;
lv_apprval_cntry_val TEXT;
lv_apprval_cntry_code TEXT;
lv_labell_cntry_val TEXT;
lv_labell_cntry_code TEXT;
lv_death_val TEXT;
lv_death_code TEXT;
lv_labell_code TEXT;
lv_labell_val_code TEXT;
lv_meddra_val_final TEXT;
lv_study_condition_val2 TEXT;
lv_study_condition_val TEXT;
BEGIN
 
 LV_MULTIVALUE := P_MULTIVALUE;
 
		FOR CUR_TEST IN (SELECT regexp_split_to_table(LV_MULTIVALUE,'\/+') as lv_val)
		
		LOOP
		
			IF UPPER(CUR_TEST.lv_val) LIKE 'COUNTRY:%' 
			THEN		
				lv_study_condition_val := SUBSTR(CUR_TEST.lv_val,9);
					
				
				lv_study_condition_val := DR_DECODE_CODE(lv_study_condition_val,1015);
				
				--RAISE NOTICE 'Final sting : %',lv_study_condition_val;
				IF  lv_study_condition_val <> ''
				THEN 
					lv_study_condition_val2 := DR_CODE_DECODE(lv_study_condition_val,1015);
					--lv_study_condition_val := '"'||REPLACE(lv_study_condition_val,',','","')||'"';
					
				END IF;
			END IF;
			
		END LOOP;
		
		--lv_final_string	='{"adhocRules":[],"paramMap":{"CL_1015_country.patient.safetyReport.aerInfo.flpath":{"values":["'||COALESCE(lv_study_condition_val,'')||'"],"fieldLabel":"Country","label":"'||COALESCE(lv_study_condition_val2,'')||'"},"CL_1015":{"values":["'||COALESCE(lv_study_condition_val,'')||'"],"fieldLabel":"Country","label":"'||COALESCE(lv_study_condition_val2,'')||'"}}}';
		
		
		lv_final_string= '{"adhocRules":[],"paramMap":{"CL_1015":{"values":["'||COALESCE(lv_study_condition_val,'')||'"],"fieldLabel":"Reporter\/Patient Country","label":"'||COALESCE(lv_study_condition_val2,'')||'"}}}';
		--RAISE NOTICE 'Final sting : %',lv_final_string;
		
		
RETURN lv_final_string;
EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION%', l_context;
END;
$BODY$;



CREATE OR REPLACE FUNCTION DR_DECODE_CODE_EVENT_TYPE (P_MULTIVALUE TEXT)
    RETURNS TEXT
    LANGUAGE 'plpgsql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
AS $BODY$
DECLARE
l_context TEXT;
CUR_TEST RECORD;
LV_MULTIVALUE TEXT;
lv_final_string TEXT;
lv_death_val TEXT;
lv_death_code TEXT;
lv_event_type_val2 TEXT;
lv_event_type_val TEXT;
BEGIN
 
 LV_MULTIVALUE := P_MULTIVALUE;
 
		FOR CUR_TEST IN (SELECT regexp_split_to_table(LV_MULTIVALUE,'\/+') as lv_val)
		
		LOOP
		
			IF UPPER(CUR_TEST.lv_val) LIKE 'EVENT TYPE:%' 
			THEN		
				lv_event_type_val := replace(SUBSTR(CUR_TEST.lv_val,12),',','|');
					
				
				lv_event_type_val2 := '3","2';
				
				
				--RAISE NOTICE 'Final sting : %',lv_event_type_val;
				
			END IF;
			
			IF UPPER(CUR_TEST.lv_val) LIKE 'DEATH:%' 
			THEN		
				lv_death_val := SUBSTR(CUR_TEST.lv_val,7);
					
				IF upper(lv_death_val) = 'YES' THEN
				
					lv_death_code := '"1"';
				ELSE 
				
					lv_death_code := '';
				END IF;
					
				
				--RAISE NOTICE 'Final sting : %',lv_event_type_val;
				
			END IF;
			
			
			
		END LOOP;
		
		
		
		
		
		lv_final_string =  '{"adhocRules":[],"paramMap":{"CL_9745":{"values":["'||COALESCE(lv_event_type_val2,'')||'"],"fieldLabel":"Event Type","label":"'||COALESCE(lv_event_type_val,'')||'"},"CL_1002":{"values":['||COALESCE(lv_death_code,'')||'],"fieldLabel":"Death?","label":"'||COALESCE(lv_death_val,'')||'"}}}';
		
		--RAISE NOTICE 'Final sting : %',lv_final_string;
		
RETURN lv_final_string;
EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION%', l_context;
END;
$BODY$;




----- 

create or replace FUNCTION DR_STRING_ORDER (P_string IN VARCHAR, V_separator in VARCHAR)
RETURNS VARCHAR
    LANGUAGE 'plpgsql'
AS $BODY$DECLARE
DECODE_CODE   VARCHAR(4000);
LV_DECODE TEXT := ''; 
LV_DECODE1 TEXT := ''; 
Lv_code VARCHAR(4000);
REC_LP RECORD;
V_separator VARCHAR := '[,'||V_separator||']+';
BEGIN
	 FOR REC_LP IN (SELECT regexp_split_to_table(P_string,V_separator) COLUMN_VAL FROM DUAL ORDER BY 1 asc)
	 LOOP 
	 	 Lv_code := REC_LP.COLUMN_VAL;
		 
		 LV_DECODE := Lv_code;
		
		 IF LV_DECODE IS NULL OR LV_DECODE = ''
		 THEN 
		 	 LV_DECODE:= '';
		 END IF;
		 IF LV_DECODE1 IS NULL 
		 THEN 
		 	 LV_DECODE1 := LV_DECODE;
		 ELSE
		 	 LV_DECODE1 := LV_DECODE1||','||LV_DECODE;
		 END IF;
		 
	 END LOOP;
	 
LV_DECODE1 := REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(LV_DECODE1,','),','),',,,,',','),',,,',','),',,',',');
	--RAISE NOTICE'final value %',LV_DECODE1;
RETURN LV_DECODE1;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;$BODY$; 