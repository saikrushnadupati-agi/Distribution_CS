----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : SANJAY K. BEHERA                                             	      --
-- FILENAME             : 13_DIST_TIMELINE_UPDATED.SQL	    				              	  --
-- PURPOSE              : This Script is for mapping of distribution rule     	        	      --
-- DATE CREATED         : 31/12/2020                          						              --
-- MODIFIED BY 		    : Sai Krushna Dupati /Navya Chandramouli																		  --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --


Do $$
DECLARE
l_context TEXT;
CUR_TIMELINE RECORD;
LV_dist_unit VARCHAR(2000);
lV_seq INTEGER;
LV_dist_rec_id INTEGER;
Lv_timeline_1 VARCHAR(2000);
Lv_tL1_PARAM VARCHAR(2000);
Lv_tL1_DAY VARCHAR(2000);
Lv_timeline_2 VARCHAR(2000);
Lv_tL2_PARAM VARCHAR(2000);
Lv_tL2_DAY VARCHAR(2000);
Lv_timeline_3 VARCHAR(2000);
Lv_tL3_PARAM VARCHAR(2000);
Lv_tL3_DAY VARCHAR(2000);
Lv_timeline_4 VARCHAR(2000);
Lv_tL4_PARAM VARCHAR(2000);
Lv_tL4_DAY VARCHAR(2000);
lv_DEFAULT_TIMELINE_DAYS VARCHAR(2000);
Lv_anchor_rec_id BIGINT;
LV_RULE_REC_ID BIGINT;
LV_RULE_ID VARCHAR(200);
LV_TIMELINE_VALUE INTEGER;
Lv_att_param_value VARCHAR(32000);
Lv_param_value  VARCHAR(32000);
BEGIN
    
	 Update C_DISTRIBUTION_RULES_decode 
	 set Timeline_1 = ''
	 where Timeline_1 is null;


	Update C_DISTRIBUTION_RULES_decode 
	set Timeline_2 = ''
	where Timeline_2 is null;


	Update C_DISTRIBUTION_RULES_decode 
	set Timeline_3 = ''
	where Timeline_3 is null;
	
	Update C_DISTRIBUTION_RULES_decode 
	set Timeline_3 = ''
	where Timeline_3 is null;


	Update C_DISTRIBUTION_RULES_decode 
	set DEFAULT_TIMELINE_DAYS = ''
	where DEFAULT_TIMELINE_DAYS is null;
	
	Update C_DISTRIBUTION_RULES_decode 
	set DEFAULT_TIMELINE_DAYS = '15'
	where (DEFAULT_TIMELINE_DAYS is null or DEFAULT_TIMELINE_DAYS = '')
	and upper(DISPLAY_NAME) = 'LEGACY_RULE_1';
	
	 
	 DELETE  FROM LSMV_DISTRIBUTION_RULE_MAPPING WHERE IS_TIMELINE_RULE = 1;

	 FOR CUR_TIMELINE IN (SELECT CONTACT_NAME,FORMAT,FORMAT_DISPLAY_NAME,DISPLAY_NAME,Timeline_1,TL1_PARAM,TL1_DAY,Timeline_2,TL2_PARAM,TL2_DAY,Timeline_3,TL3_PARAM,
						  TL3_DAY,Timeline_4,TL4_PARAM,TL4_DAY,DEFAULT_TIMELINE_DAYS
						  FROM C_DISTRIBUTION_RULES_decode)
	 LOOP
		 Lv_timeline_1 := CUR_TIMELINE.Timeline_1 ;
		 Lv_tL1_PARAM := CUR_TIMELINE.TL1_PARAM ;
		 Lv_TL1_DAY := CUR_TIMELINE.TL1_DAY ;
		 Lv_Timeline_2 := CUR_TIMELINE.Timeline_2 ;
		 Lv_TL2_PARAM := CUR_TIMELINE.TL2_PARAM ;
		 Lv_TL2_DAY := CUR_TIMELINE.TL2_DAY ;
		 Lv_Timeline_3 := CUR_TIMELINE.Timeline_3 ;
		 Lv_TL3_PARAM := CUR_TIMELINE.TL3_PARAM ;
		 Lv_TL3_DAY := CUR_TIMELINE.TL3_DAY ;
		 Lv_Timeline_4 := CUR_TIMELINE.Timeline_4 ;
		 Lv_TL4_PARAM := CUR_TIMELINE.TL4_PARAM ;
		 Lv_TL4_DAY := CUR_TIMELINE.TL4_DAY ;
		 lv_DEFAULT_TIMELINE_DAYS := COALESCE(CUR_TIMELINE.DEFAULT_TIMELINE_DAYS,'15') ;
	 
	 
		BEGIN 
		SELECT LDRA.RECORD_ID INTO Lv_anchor_rec_id 
		FROM LSMV_DISTRIBUTION_UNIT LDU, LSMV_DISTRIBUTION_FORMAT LDF,LSMV_DISTRIBUTION_RULE_ANCHOR LDRA
		WHERE LDU.RECORD_ID = LDF.FK_DISTRIBUTION_UNIT
		AND LDF.RECORD_ID = LDRA.FK_DISTRIBUTION_FORMAT
		AND TRIM(UPPER(LDU.DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(CUR_TIMELINE.CONTACT_NAME))
		AND TRIM(UPPER(LDF.DISPLAY_NAME)) = TRIM(UPPER(CUR_TIMELINE.FORMAT_DISPLAY_NAME))
		AND TRIM(UPPER(LDRA.DISPLAY_NAME)) = TRIM(UPPER(CUR_TIMELINE.DISPLAY_NAME));
		
		
		EXCEPTION 
		WHEN OTHERS THEN
		RAISE NOTICE 'ISSUE WITH : %',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME; 
		END;
		
		--- default timeline update 
		
		IF lv_DEFAULT_TIMELINE_DAYS <> ''
		THEN
		--RAISE NOTICE 'anchor detail : %',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME||Lv_anchor_rec_id; 
			UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
			SET TIME_LINE_DAY = TO_NUMBER(lv_DEFAULT_TIMELINE_DAYS,'99'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
			WHERE RECORD_ID = Lv_anchor_rec_id;
		--RAISE NOTICE 'default updated : %',CUR_TIMELINE.DISPLAY_NAME;
		ELSE
			RAISE NOTICE 'DEFAULT TIMELINE NT PRESENT FOR : %',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME;
		END IF;
		

	 -------------- TIMELINE 1 
	 IF Lv_timeline_1 <> ''
	 THEN 
		 SELECT RECORD_ID, RULE_ID, RULE_PARAM_MAP INTO LV_RULE_REC_ID, LV_RULE_ID, Lv_att_param_value
		 FROM LSMV_RULE_DETAILS 
		 WHERE TRIM(UPPER(RULE_NAME)) = TRIM(UPPER(Lv_timeline_1));
	 
	 IF  Lv_tL1_PARAM IS NOT NULL
	 THEN 
		 Lv_param_value := C_DECODE_CODE_PARAM(LV_RULE_ID,Lv_tL1_PARAM,'',Lv_att_param_value);
	 ELSE
		 Lv_param_value := '{"paramMap":{},"adhocRules":[]}';
	 END IF;
	 
	 IF  Lv_TL1_DAY <> ''
	 THEN 
		 LV_TIMELINE_VALUE := to_number(Lv_TL1_DAY,'99');
		 
		 Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
         values (NEXTVAL('SEQ_RECORD_ID'),LV_RULE_REC_ID,Lv_anchor_rec_id,null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
                        Lv_param_value,1,1,LV_TIMELINE_VALUE,0);
						
		IF Lv_anchor_rec_id IS NULL 
		THEN 
			RAISE NOTICE 'ANCHOR NOT P : %',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT_DISPLAY_NAME||' '||CUR_TIMELINE.DISPLAY_NAME;
		END IF;
						
	 ELSE
		 RAISE NOTICE '1. time line not present :%',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME;
	 END IF;
	 
	 END IF;
		  
	
-------------- TIMELINE 2 
	 IF Lv_timeline_2 <> ''
	 THEN 
		 SELECT RECORD_ID, RULE_ID, RULE_PARAM_MAP INTO LV_RULE_REC_ID, LV_RULE_ID, Lv_att_param_value
		 FROM LSMV_RULE_DETAILS 
		 WHERE TRIM(UPPER(RULE_NAME)) = TRIM(UPPER(Lv_timeline_2));
	 
	 IF Lv_tL2_PARAM IS NOT NULL
	 THEN 
		 Lv_param_value := C_DECODE_CODE_PARAM(LV_RULE_ID,Lv_tL2_PARAM,'',Lv_att_param_value);
	 ELSE
		 Lv_param_value := '{"paramMap":{},"adhocRules":[]}';
	 END IF;
	 
	 IF Lv_TL2_DAY IS NOT NULL OR Lv_TL2_DAY <> ''
	 THEN 
		 LV_TIMELINE_VALUE := to_number(Lv_TL2_DAY,'99');
		 
		 Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
         values (NEXTVAL('SEQ_RECORD_ID'),LV_RULE_REC_ID,Lv_anchor_rec_id,null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
                        Lv_param_value,1,2,LV_TIMELINE_VALUE,0);
						
	 ELSE
		 RAISE NOTICE '2. time line not present :%',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME;
	 END IF;
	 
	 END IF;	
		  
		  
-------------- TIMELINE 3 
	 IF Lv_timeline_3 <> ''
	 THEN 
		 SELECT RECORD_ID, RULE_ID, RULE_PARAM_MAP INTO LV_RULE_REC_ID, LV_RULE_ID, Lv_att_param_value
		 FROM LSMV_RULE_DETAILS 
		 WHERE TRIM(UPPER(RULE_NAME)) = TRIM(UPPER(Lv_timeline_3));
	 
	 IF Lv_tL3_PARAM IS NOT NULL OR Lv_tL3_PARAM <> ''
	 THEN 
		 Lv_param_value := C_DECODE_CODE_PARAM(LV_RULE_ID,Lv_tL3_PARAM,'',Lv_att_param_value);
	 ELSE
		 Lv_param_value := '{"paramMap":{},"adhocRules":[]}';
	 END IF;
	 
	 IF Lv_TL3_DAY IS NOT NULL OR Lv_TL3_DAY <> ''
	 THEN 
		 LV_TIMELINE_VALUE := to_number(Lv_TL3_DAY,'99');
		 
		 Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
         values (NEXTVAL('SEQ_RECORD_ID'),LV_RULE_REC_ID,Lv_anchor_rec_id,null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
                        Lv_param_value,1,3,LV_TIMELINE_VALUE,0);
						
	 ELSE
		 RAISE NOTICE '3. time line not present :%',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME;
	 END IF;
	 
	 END IF;		  
	


-------------- TIMELINE 4 
	 IF  Lv_timeline_4 <> ''
	 THEN 
		 SELECT RECORD_ID, RULE_ID, RULE_PARAM_MAP INTO LV_RULE_REC_ID, LV_RULE_ID, Lv_att_param_value
		 FROM LSMV_RULE_DETAILS 
		 WHERE TRIM(UPPER(RULE_NAME)) = TRIM(UPPER(Lv_timeline_4));
	 
	 IF Lv_tL4_PARAM IS NOT NULL OR Lv_tL4_PARAM <> ''
	 THEN 
		 Lv_param_value := C_DECODE_CODE_PARAM(LV_RULE_ID,Lv_tL4_PARAM,'',Lv_att_param_value);
	 ELSE
		 Lv_param_value := '{"paramMap":{},"adhocRules":[]}';
	 END IF;
	 
	 IF Lv_TL4_DAY IS NOT NULL OR Lv_TL4_DAY <> ''
	 THEN 
		 LV_TIMELINE_VALUE := to_number(Lv_TL4_DAY,'99');
		 
		 Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
         values (NEXTVAL('SEQ_RECORD_ID'),LV_RULE_REC_ID,Lv_anchor_rec_id,null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
                        Lv_param_value,1,4,LV_TIMELINE_VALUE,0);
						
	 ELSE
		 RAISE NOTICE '4. time line not present :%',CUR_TIMELINE.CONTACT_NAME||' '||CUR_TIMELINE.FORMAT||' '||CUR_TIMELINE.DISPLAY_NAME;
	 END IF;
	 
	 END IF;	
		  
		  Lv_anchor_rec_id:= null;
	 END LOOP;
	 
EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION: %', l_context;
END $$;