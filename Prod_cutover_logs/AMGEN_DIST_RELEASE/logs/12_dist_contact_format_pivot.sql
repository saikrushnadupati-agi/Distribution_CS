----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sai Krushna Dupati                                             	          --
-- FILENAME             : 12_dist_contact_format_pivot.SQL 			    				              --
-- PURPOSE              : This Script is for mapping of distribution rule pivot level configuration     	        	      --
-- DATE CREATED         : 30-JAN-2025                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 		    : 																		  --
-- DATE MODIFIED		:                                   						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --






DO $$
DECLARE
I RECORD;
Lv_con_pivot_name VARCHAR(2000);
Lv_con_pivot_val VARCHAR(2000);
lv_con_att BIGINT;
Lv_con_pivot_code VARCHAR(2000);
Lv_con_pivot_val2 VARCHAR(2000);
Lv_con_name VARCHAR(2000);
lV_con_param_map VARCHAR(4000);
lv_exld_val BIGINT;
Lv_format_pivot_name VARCHAR(2000);
Lv_format_pivot_val VARCHAR(2000);
lv_format_att BIGINT;
Lv_format_pivot_code VARCHAR(2000);
Lv_format_pivot_val2 VARCHAR(2000);
Lv_format_display_name VARCHAR(2000);
lV_format_param_map VARCHAR(4000);
Lv_anchor_pivot_name VARCHAR(2000);
Lv_anchor_pivot_val VARCHAR(2000);
lv_anchor_att BIGINT;
Lv_anchor_pivot_code VARCHAR(4000);
Lv_anchor_pivot_val2 VARCHAR(4000);
Lv_anchor_display_name VARCHAR(2000);
lV_anchor_param_map VARCHAR(4000);
Lv_anchor_pivot_val_cod VARCHAR(4000);
Lv_format_pivot_val_cod VARCHAR(4000);
lv_protocol_code VARCHAR(4000);
Lv_anchor_pivot_code2 VARCHAR(4000);
val1 VARCHAR(4000);
val2 VARCHAR(4000);
lv_test_null VARCHAR(4000);
Lv_anchor_pivot_pt_val VARCHAR(4000); 
cur_pivot_study record;



BEGIN
	 UPDATE LSMV_DISTRIBUTION_UNIT 
		SET fk_pivot_rule = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;
	 UPDATE LSMV_DISTRIBUTION_FORMAT 
		SET fk_pivot_rule = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;
	 UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR 
		SET FK_PIVOT_RULE = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;

	 
FOR I IN (SELECT * from c_distribution_rules_decode)
LOOP

	Lv_con_pivot_name := I.CONTACT_LEVEL_PIVOT;
	Lv_con_pivot_val  := I.CONTACT_LEVEL_PIVOT_VAL;
	lv_con_att		 := (select record_id from lsmv_rule_details where upper(trim(rule_name)) = upper(trim(Lv_con_pivot_name)));
	Lv_con_name := I.contact_name;
	Lv_format_pivot_name := I.FORMAT_LEVEL_PIVOT;
	Lv_format_pivot_val  := I.format_level_pivot_val;
	lv_format_att		 := (select record_id from lsmv_rule_details where upper(trim(rule_name)) = upper(trim(Lv_format_pivot_name)));
	Lv_format_display_name := I.format_display_name;
	Lv_anchor_pivot_name := I.ANCHOR_LEVEL_PIVOT;
	Lv_anchor_pivot_val  := I.anchor_level_pivot_val;
	lv_anchor_att		 := (select record_id from lsmv_rule_details where upper(trim(rule_name)) = upper(trim(Lv_anchor_pivot_name)));
	Lv_anchor_display_name := I.display_name;
	
	IF Lv_con_pivot_name <> ''
	THEN 
	
	IF Lv_con_pivot_name = 'ISP_PROTOCOL_NO'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,7);
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_val,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		lV_con_param_map := '{"adhocRules":[],"paramMap":{"LIB_Study":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Protocol No ","label":"'||Lv_con_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	
	
	ELSIF Lv_con_pivot_name = 'USER_PRODUCT_EVENT_MATRIX'
	THEN 
		
		lV_con_param_map := DR_DECODE_CODE_MATRIX(DR_DECODE_CODE_SSIC_NEW(Lv_con_pivot_val));
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule   = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
		
	ELSIF Lv_con_pivot_name = 'USER_IMPLIED_CAUSALITY'
	THEN
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		lV_con_param_map := '{"adhocRules":[],"paramMap":{"CL_9070":{"values":[],"fieldLabel":"Strength (unit)","label":""},"CL_709":{"values":["34"],"fieldLabel":"CPD Approval Type","label":"Approved for Marketing (Drug)"},"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group","label":""},"CL_805":{"values":[],"fieldLabel":"Form of admin.","label":""},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8201_reporterCausality":{"values":[],"fieldLabel":"Reporter Causality","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"New Drug ?","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""},"CL_9159":{"values":[],"fieldLabel":"Labelling","label":""},"CL_8201":{"values":[],"fieldLabel":"Causality","label":""},"CL_1015":{"values":["EU"],"fieldLabel":"CPD Authorization Country","label":"European Union"},"LIB_9744_1015":{"values":[],"fieldLabel":"Labelling Country","label":""},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","label":""},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Seriousness","label":""},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"SS Exclude ?","label":""},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Company Causality","label":""},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Strength (number)","label":""},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"IC Exclude ?","label":""},"LIB_Meddra":{"values":[],"fieldLabel":"MedDRAPT ","label":""},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group Inclusion ?","label":""}}}';
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
		
	ELSIF Lv_con_pivot_name = 'ISP_CASE_SIGNIFICANCE'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,19);
		Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,9605); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot ::ISP_CASE_SIGNIFICANCE :%',Lv_con_name;
			
		END IF;
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_9605":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Case Significance","label":"'||Lv_con_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	ELSIF Lv_con_pivot_name = 'ISP_REPORT_CLASSIFICATION'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,16); -- Classification:Cluster Case
		
		Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,9747); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_REPORT_CLASSIFICATION :%',Lv_con_name;
			
		END IF;
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_9747":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Report Classification","label":"'||Lv_con_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));

	ELSIF Lv_con_pivot_name = 'ISP_SOURCE'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,8); -- Source:Non-interventional study

		
		Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,346); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_SOURCE :%',Lv_con_name;
			
		END IF;
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_346":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Source","label":"'||Lv_con_pivot_val2||'"}}}';
		
		
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	
	ELSIF Lv_con_pivot_name = 'ISP_STUDY_TYPE'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,12); -- Study Type:Clinical Trials

		
		Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,1004); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_STUDY_TYPE :%',Lv_con_name;
			
		END IF;
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_1004":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Study Type ","label":"'||Lv_con_pivot_val2||'"}}}';
		
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	

	ELSIF Lv_con_pivot_name = 'ISP_STUDY PRODUCT TYPE'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,20); -- Study Product Type:Placebo/Vehicle


		
		Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,8008); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_STUDY PRODUCT TYPE :%',Lv_con_name;
			
		END IF;
		
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_8008":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Study Product Type","label":"'||Lv_con_pivot_val2||'"},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""}}}';
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));


	ELSIF Lv_con_pivot_name = 'ISP_STUDY_SPONSOR'
	THEN 
		
		 --Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,14); -- Sponsor Type:Company Sponsored
	   
	   SELECT COALESCE(STRING_AGG(CC.CODE,','),''),COALESCE(STRING_AGG(CD.DECODE,','),'') INTO Lv_con_pivot_code,Lv_con_pivot_val2
       FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
       WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
       AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
       AND CD.LANGUAGE_CODE = 'en'
       AND CN.CODELIST_ID = 9959
	   AND CC.CODE_STATUS='1'
	   AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(Lv_con_pivot_val,DR_INSTR(Lv_con_pivot_val,':',1,1)+1,1000))),'\,+') FROM DUAL);

		--RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_con_pivot_code;
		--Lv_con_pivot_code := DR_DECODE_CODE(Lv_con_pivot_val,8008); 
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val2,',','|');
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_STUDY_SPONSOR :%',Lv_con_name;
			
		END IF;
		
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"LIB_CU_ACC_ID":{"values":[],"fieldLabel":"Sponsor","label":""},"CL_9959":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Sponsor Type","label":"'||Lv_con_pivot_val2||'"}}}';
		
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));

	ELSIF Lv_con_pivot_name = 'ISP_IDENTIFIABLE_PATIENT'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,14); -- Sponsor Type:Company Sponsored

		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	
	
	ELSIF Lv_con_pivot_name = 'ISP_LITERATURE_REFERENCE'
	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,14); -- Sponsor Type:Company Sponsored

		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));
	
	
	ELSIF Lv_con_pivot_name = 'ISP_COUNTRY_OF_DETECTION'  -- E2B COUNTRY:TAIWAN, PROVINCE OF CHINA

	THEN 
		
		Lv_con_pivot_val  := SUBSTR(Lv_con_pivot_val,13); -- E2B COUNTRY:BAHRAIN
		
--Lv_format_pivot_val := replace(Lv_format_pivot_val,'KOREA,REPUBLIC OF','KOREA, REPUBLIC OF');
		
		Lv_con_pivot_code := DR_DECODE_CODE(regexp_split_to_table(Lv_con_pivot_val,'\^+'),1015);
		Lv_con_pivot_code := REPLACE(Lv_con_pivot_code,',','","');
		
		Lv_con_pivot_val2 := replace(Lv_con_pivot_val,'^','|');
		
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_con_pivot_code;
		
		IF I.CONTACT_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_con_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Contact level pivot :: ISP_COUNTRY_OF_DETECTION :%',Lv_con_name;
			
		END IF;
		
		
		lV_con_param_map  := '{"adhocRules":[],"paramMap":{"CL_1015":{"values":["'||Lv_con_pivot_code||'"],"fieldLabel":"Country of Detection ","label":"'||Lv_con_pivot_val2||'"}}}';
				
		UPDATE LSMV_DISTRIBUTION_UNIT
		SET fk_pivot_rule = lv_con_att,
    	PARAM_MAP = lV_con_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(DISTRIBUTION_UNIT_NAME)) = TRIM(UPPER(Lv_con_name));


	ELSE 
	
	RAISE NOTICE 'Problem in Contact level pivot  :%',Lv_con_name;
	
	END IF;
	END IF;
	
	---------------------------------------------------------------------- Format level Pivot START
	IF Lv_format_pivot_name <> ''
	THEN 
	
	IF Lv_format_pivot_name = 'ISP_PROTOCOL_NO'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,7);
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_val,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		
		
		
		lV_format_param_map := '{"adhocRules":[],"paramMap":{"LIB_Study":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Protocol No ","label":"'||Lv_format_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	
	
	ELSIF Lv_format_pivot_name = 'USER_PRODUCT_EVENT_MATRIX'
	THEN 
		
		lV_format_param_map := DR_DECODE_CODE_MATRIX(DR_DECODE_CODE_SSIC_NEW(Lv_format_pivot_val));
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule = 1
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
		
	ELSIF Lv_format_pivot_name = 'USER_IMPLIED_CAUSALITY'
	THEN
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		lV_format_param_map := '{"adhocRules":[],"paramMap":{"CL_9070":{"values":[],"fieldLabel":"Strength (unit)","label":""},"CL_709":{"values":["34"],"fieldLabel":"CPD Approval Type","label":"Approved for Marketing (Drug)"},"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group","label":""},"CL_805":{"values":[],"fieldLabel":"Form of admin.","label":""},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8201_reporterCausality":{"values":[],"fieldLabel":"Reporter Causality","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"New Drug ?","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""},"CL_9159":{"values":[],"fieldLabel":"Labelling","label":""},"CL_8201":{"values":[],"fieldLabel":"Causality","label":""},"CL_1015":{"values":["EU"],"fieldLabel":"CPD Authorization Country","label":"European Union"},"LIB_9744_1015":{"values":[],"fieldLabel":"Labelling Country","label":""},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","label":""},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Seriousness","label":""},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"SS Exclude ?","label":""},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Company Causality","label":""},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Strength (number)","label":""},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"IC Exclude ?","label":""},"LIB_Meddra":{"values":[],"fieldLabel":"MedDRAPT ","label":""},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group Inclusion ?","label":""}}}';
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
		
	ELSIF Lv_format_pivot_name = 'ISP_CASE_SIGNIFICANCE'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,19);
		
		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,9605); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_CASE_SIGNIFICANCE :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_9605":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Case Significance","label":"'||Lv_format_pivot_val2||'"}}}';
		--{"adhocRules":[],"paramMap":{"CL_9605":{"values":["4"],"fieldLabel":"Case Significance","label":"Significant (Reportable)"}}}
		
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',lV_format_param_map;
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	ELSIF Lv_format_pivot_name = 'ISP_REPORT_CLASSIFICATION'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,16); -- Classification:Cluster Case
		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,9747); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_REPORT_CLASSIFICATION :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_9747":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Report Classification","label":"'||Lv_format_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));

	ELSIF Lv_format_pivot_name = 'ISP_SOURCE'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,8); -- Source:Non-interventional study

		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,346); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_SOURCE :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_346":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Source","label":"'||Lv_format_pivot_val2||'"}}}';
		
		
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	
	ELSIF Lv_format_pivot_name = 'ISP_STUDY_TYPE'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,12); -- Study Type:Clinical Trials

		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,1004); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_STUDY_TYPE :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_1004":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Study Type ","label":"'||Lv_format_pivot_val2||'"}}}';
		
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	

	ELSIF Lv_format_pivot_name = 'ISP_STUDY PRODUCT TYPE'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,20); -- Study Product Type:Placebo/Vehicle


		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,8008); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_STUDY PRODUCT TYPE :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_8008":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Study Product Type","label":"'||Lv_format_pivot_val2||'"},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""}}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
		WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));


	ELSIF Lv_format_pivot_name = 'USER_SPONCER_TYPE'
	THEN 
		
		--Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,14); -- Sponsor Type:Company Sponsored
	   SELECT COALESCE(STRING_AGG(CC.CODE,','),''),COALESCE(STRING_AGG(CD.DECODE,','),'') INTO Lv_format_pivot_code,Lv_format_pivot_val2
       FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
       WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
       AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
       AND CD.LANGUAGE_CODE = 'en'
       AND CN.CODELIST_ID = 9959
	   AND CC.code_status = '1'
	   AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(Lv_format_pivot_val,DR_INSTR(Lv_format_pivot_val,':',1,1)+1,1000))),'\,+') FROM DUAL);

		
		--Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,8008); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val2,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		--RAISE NOTICE 'Lv_format_pivot_code%',Lv_format_pivot_code;
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: USER_SPONCER_TYPE :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_9959":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Sponsor Type","label":"'||Lv_format_pivot_val2||'"}}}';
		
		
		--{"adhocRules":[],"paramMap":{"CL_9959":{"values":["8001","01"],"fieldLabel":"Sponsor Type","label":"Co-developed|Company Sponsored"}}}
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));

	ELSIF Lv_format_pivot_name = 'ISP_IDENTIFIABLE_PATIENT'
	THEN 
		
		/* Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,8008); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|'); */
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	
	
		ELSIF Lv_format_pivot_name = 'ISP_LITERATURE_REFERENCE'
		THEN 
		
		/* Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,8008); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|'); */
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	ELSIF Lv_format_pivot_name = 'ISP_COUNTRY_OF_DETECTION'
	THEN 
		
		
		Lv_format_pivot_val := replace(Lv_format_pivot_val,',',', ');
		
		--Lv_format_pivot_val_cod  := SUBSTR(Lv_format_pivot_val,13); -- E2B COUNTRY:SPAIN^CZECHIA

	SELECT COALESCE(STRING_AGG(CC.CODE,','),''),COALESCE(STRING_AGG(CD.DECODE,','),'') INTO Lv_format_pivot_code,Lv_format_pivot_val2
       FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
       WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
       AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
       AND CD.LANGUAGE_CODE = 'en'
       AND CN.CODELIST_ID = 1015
	   AND CC.CODE_STATUS='1'
	   AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(Lv_format_pivot_val,DR_INSTR(Lv_format_pivot_val,':',1,1)+1,1000))),'\^+') FROM DUAL);
		
		
		
		--Lv_anchor_pivot_code := STRING_AGG(DR_DECODE_CODE(regexp_split_to_table(Lv_anchor_pivot_val,'\^+'),1015),'');
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		
		--Lv_format_pivot_val2 := replace(Lv_format_pivot_val2,',','|');
		
		
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_COUNTRY_OF_DETECTION :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"CL_1015":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Country of Detection ","label":"'||Lv_format_pivot_val2||'"}}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	ELSIF Lv_format_pivot_name = 'ISP_MEDICALLY_CONFIRMED'
	THEN 
		
		/* Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_format_pivot_code := DR_DECODE_CODE(Lv_format_pivot_val,8008); 
		Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|'); */
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));

	
	ELSIF Lv_format_pivot_name = 'ISP_SENDER_ORGANIZATION'
	THEN 
		
		Lv_format_pivot_val  := SUBSTR(Lv_format_pivot_val,8); -- CU_ACC:LP_04


		
		Lv_format_pivot_code := (select account_name from LSMV_ACCOUNTS where ACCOUNT_ID = Lv_format_pivot_val);
		--Lv_format_pivot_code := REPLACE(Lv_format_pivot_code,',','","');
		--Lv_format_pivot_val2 := replace(Lv_format_pivot_val,',','|');
		
		IF I.format_level_pivot_ex <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_format_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in Format level pivot :: ISP_SENDER_ORGANIZATION :%',Lv_con_name||' : '||Lv_format_display_name;
			
		END IF;
		
		lV_format_param_map  := '{"adhocRules":[],"paramMap":{"LIB_CU_ACC":{"values":["'||Lv_format_pivot_code||'"],"fieldLabel":"Sender Organization","label":"'||Lv_format_pivot_code||'"}}}';
				
		UPDATE LSMV_DISTRIBUTION_FORMAT
		SET fk_pivot_rule = lv_format_att,
    	PARAM_MAP = lV_format_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_format_display_name))
		AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT 
									 WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME));
	
	
	
	
	
	
	
	
	
	
	
	
	

	ELSE 
	
	RAISE NOTICE 'Problem in format level pivot  :%',Lv_format_display_name||' : '||I.CONTACT_NAME;
	
	END IF;
	END IF;
	
	
	
	----------------------------------------------------------------------------------------------------- Anchor level Pivot START
	
	
	
		IF Lv_anchor_pivot_name <> ''
	THEN 
	
	IF Lv_anchor_pivot_name = 'ISP_PROTOCOL_NO'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,7);
		--Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_val,',','","');
		--Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		select COALESCE(STRING_AGG(protocol_no,','),'') into lv_protocol_code  
		from lsmv_study_library
		where upper(TRIM(protocol_no)) IN ( SELECT  regexp_split_to_table(TRANSLATE(UPPER(TRIM(SUBSTRING(Lv_anchor_pivot_val,DR_INSTR(Lv_anchor_pivot_val,':',1,1)+1,8000))),'?','/'),'\,+') FROM DUAL);

		Lv_anchor_pivot_code := REPLACE(lv_protocol_code,',','","');
		Lv_anchor_pivot_val2 := replace(lv_protocol_code,',','|');
	
		
		DECLARE
			Lv_anchor_pivot_val_study VARCHAR(4000);
			

			cur_pivot_study record;
			lv_protocol_code VARCHAR(4000);

		BEGIN
			Lv_anchor_pivot_val_study := Lv_anchor_pivot_val;
			lv_protocol_code := null;
			--lv_test_null := null;
			
		FOR cur_pivot_study IN  SELECT regexp_split_to_table(Lv_anchor_pivot_val_study,'\,+') AS study_val
		loop 

				select protocol_no into lv_protocol_code
				from lsmv_study_library
				where upper(TRIM(protocol_no)) = upper(trim(cur_pivot_study.study_val));

		if lv_protocol_code is null then 
		RAISE NOTICE 'Study not available -->   %',cur_pivot_study.study_val;
		end if;
		end loop;
		END;
		
		
		
		
		
		
		
		
		
		lV_anchor_param_map := '{"adhocRules":[],"paramMap":{"LIB_Study":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Protocol No ","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));
	
	
	
	ELSIF Lv_anchor_pivot_name = 'USER_PRODUCT_EVENT_MATRIX'
	THEN 
		
		lV_anchor_param_map := DR_DECODE_CODE_MATRIX(DR_DECODE_CODE_SSIC_NEW(Lv_anchor_pivot_val));
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule = 1
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));
		
	ELSIF Lv_anchor_pivot_name = 'USER_IMPLIED_CAUSALITY'
	THEN
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		lV_anchor_param_map := '{"adhocRules":[],"paramMap":{"CL_9070":{"values":[],"fieldLabel":"Strength (unit)","label":""},"CL_709":{"values":["34"],"fieldLabel":"CPD Approval Type","label":"Approved for Marketing (Drug)"},"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group","label":""},"CL_805":{"values":[],"fieldLabel":"Form of admin.","label":""},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8201_reporterCausality":{"values":[],"fieldLabel":"Reporter Causality","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"New Drug ?","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""},"CL_9159":{"values":[],"fieldLabel":"Labelling","label":""},"CL_8201":{"values":[],"fieldLabel":"Causality","label":""},"CL_1015":{"values":["EU"],"fieldLabel":"CPD Authorization Country","label":"European Union"},"LIB_9744_1015":{"values":[],"fieldLabel":"Labelling Country","label":""},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","label":""},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Seriousness","label":""},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"SS Exclude ?","label":""},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Company Causality","label":""},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Strength (number)","label":""},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"IC Exclude ?","label":""},"LIB_Meddra":{"values":[],"fieldLabel":"MedDRAPT ","label":""},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group Inclusion ?","label":""}}}';
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

		
	ELSIF Lv_anchor_pivot_name = 'ISP_CASE_SIGNIFICANCE'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,19); --Case Significance:Significant (Reportable)
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,9605); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_CASE_SIGNIFICANCE :%',Lv_anchor_display_name;
		END IF;
		
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_9605":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Case Significance","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	ELSIF Lv_anchor_pivot_name = 'ISP_REPORT_CLASSIFICATION'
	THEN 
		Lv_anchor_pivot_val := upper(replace(Lv_anchor_pivot_val,'REPORT CLASSIFICATION','CLASSIFICATION'));
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,16); -- Classification:Cluster Case
		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,9747); 
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_anchor_pivot_code;
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_REPORT_CLASSIFICATION :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_9747":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Report Classification","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));


	ELSIF Lv_anchor_pivot_name = 'ISP_SOURCE'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,8); -- Source:Non-interventional study

		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,346); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_SOURCE :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_346":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Source","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',lV_anchor_param_map;
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	
	ELSIF Lv_anchor_pivot_name = 'ISP_STUDY_TYPE'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,12); -- Study Type:Clinical Trials

		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,1004); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_STUDY_TYPE :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_1004":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Study Type ","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	

	ELSIF Lv_anchor_pivot_name = 'ISP_STUDY PRODUCT TYPE'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,20); -- Study Product Type:Placebo/Vehicle


		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,8008); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_STUDY PRODUCT TYPE :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_8008":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Study Product Type","label":"'||Lv_anchor_pivot_val2||'"},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""}}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));



	ELSIF Lv_anchor_pivot_name = 'USER_SPONCER_TYPE'
	THEN 
		
		--Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,14); -- Sponsor Type:Company Sponsored
	   SELECT COALESCE(STRING_AGG(CC.CODE,','),''),COALESCE(STRING_AGG(CD.DECODE,','),'') INTO Lv_anchor_pivot_code,Lv_anchor_pivot_val2
       FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
       WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
       AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
       AND CD.LANGUAGE_CODE = 'en'
       AND CN.CODELIST_ID = 9959
	   AND CC.CODE_STATUS='1'
	   AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(Lv_anchor_pivot_val,DR_INSTR(Lv_anchor_pivot_val,':',1,1)+1,1000))),'\,+') FROM DUAL);

		
		--Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,8008); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val2,',','|');
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: USER_SPONCER_TYPE :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_9959":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Sponsor Type","label":"'||Lv_anchor_pivot_val2||'"}}}';
		
		--{"adhocRules":[],"paramMap":{"CL_9959":{"values":["8001","01"],"fieldLabel":"Sponsor Type","label":"Co-developed|Company Sponsored"}}}
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));


	ELSIF Lv_anchor_pivot_name = 'ISP_IDENTIFIABLE_PATIENT'
	THEN 
		
/* 		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,8008); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_val,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		 */
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));
	
	ELSIF Lv_anchor_pivot_name = 'ISP_LITERATURE_REFERENCE'
	THEN 
		
/* 		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,8008); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_val,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		 */
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	
		
	ELSIF Lv_anchor_pivot_name = 'ISP_MEDICALLY_CONFIRMED'
	THEN 
		
/* 		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,14); -- Sponsor Type:Company Sponsored


		
		Lv_anchor_pivot_code := DR_DECODE_CODE(Lv_anchor_pivot_val,8008); 
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_val,',','","');
		Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		 */
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	
		

	ELSIF Lv_anchor_pivot_name = 'ISP_COUNTRY_OF_DETECTION'
	THEN 
		
		
		
		
		--Lv_anchor_pivot_val_cod  := REPLACE(UPPER(SUBSTR(Lv_anchor_pivot_val,13)),',',', '); -- E2B COUNTRY:SPAIN^CZECHIA
		
		Lv_anchor_pivot_val := REPLACE(Lv_anchor_pivot_val,',',', ');
	
	SELECT COALESCE(STRING_AGG(CC.CODE,','),''),COALESCE(STRING_AGG(CD.DECODE,','),'') INTO Lv_anchor_pivot_code,Lv_anchor_pivot_val2
       FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
       WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
       AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
       AND CD.LANGUAGE_CODE = 'en'
       AND CN.CODELIST_ID = 1015
	   AND CC.CODE_STATUS='1'
	   AND UPPER(TRIM(CD.DECODE)) IN ( SELECT  regexp_split_to_table( UPPER(TRIM(SUBSTRING(Lv_anchor_pivot_val,DR_INSTR(Lv_anchor_pivot_val,':',1,1)+1,1000))),'\^+') FROM DUAL);
		
		
																					
		
		Lv_anchor_pivot_code := REPLACE(Lv_anchor_pivot_code,',','","');
		
		if Lv_anchor_pivot_val2 LIKE '%, %'
		then 
			Lv_anchor_pivot_val2 := Lv_anchor_pivot_val2;
		ELSE
			Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val2,',','|');
		end if;
		--RAISE NOTICE 'Prob  :%',Lv_anchor_pivot_code||' : '||Lv_anchor_pivot_val2;
		
		
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_con_pivot_code;
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_COUNTRY_OF_DETECTION :%',Lv_anchor_display_name;
		END IF;
		
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_1015":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Country of Detection ","label":"'||Lv_anchor_pivot_val2||'"}}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	ELSIF Lv_anchor_pivot_name = 'ISP_SENDER_ORGANIZATION'
	THEN 
		
		Lv_anchor_pivot_val  := SUBSTR(Lv_anchor_pivot_val,8); -- CU_ACC:LP_04
				
		Lv_anchor_pivot_code := (select account_name from LSMV_ACCOUNTS where ACCOUNT_ID = Lv_anchor_pivot_val);
				
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		
		IF Lv_anchor_pivot_code = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_SENDER_ORGANIZATION :%',Lv_anchor_display_name;
		END IF;
		
		lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"LIB_CU_ACC":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Sender Organization","label":"'||Lv_anchor_pivot_code||'"}}}';
		
		--RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_anchor_pivot_val;
		
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));

	
	
	
	ELSIF Lv_anchor_pivot_name = 'ISP_EVENT_PT'
	THEN 
		
		Lv_anchor_pivot_pt_val := REPLACE(SUBSTR(Lv_anchor_pivot_val,8),',','|'); --MedDRA:Intercepted product administration error(10081573),Circumstance or information capable of leading to medication error(10064385)
		Lv_anchor_pivot_val  := TRIM(REPLACE(REPLACE(SUBSTR(Lv_anchor_pivot_val,8),'(','^'),')','')); -- MedDRA:   test1^123,test2^321
		--Lv_anchor_pivot_val2 := replace(Lv_anchor_pivot_val,',','|');
		
		declare
		lv_meddra_decode varchar(4000);
		cur_pivot_update record;
		lv_meddra_code varchar(4000);
		lv_test_null varchar(4000); 
		--Lv_anchor_pivot_val2 varchar(4000);
		
		
		BEGIN
		
		lv_test_null := null;
		
		
		FOR cur_pivot_update IN  SELECT regexp_split_to_table(Lv_anchor_pivot_val,'\,+') AS meddra
        LOOP
 
			
 
			lv_meddra_decode := cur_pivot_update.meddra;
			lv_meddra_code   := SUBSTRING(lv_meddra_decode,DR_INSTR(lv_meddra_decode,'^',1,1)+1,8);
			
            IF lv_test_null IS NULL 
			THEN			
			Lv_anchor_pivot_val2 := lv_meddra_code;
			lv_test_null := lv_meddra_code;
			ELSE
			    Lv_anchor_pivot_val2 := Lv_anchor_pivot_val2||'|'||lv_meddra_code;
			END IF;
			END LOOP;      
		lv_test_null := NULL;
		EXCEPTION 
		WHEN OTHERS 
		THEN 
			RAISE NOTICE '%','EXCEPTION  IN ISP_EVENT_PT configuration';        
		END;

		
		--RAISE NOTICE 'Lv_anchor_pivot_val2 %',Lv_anchor_pivot_val2;
		--RAISE NOTICE 'Lv_anchor_pivot_pt_val %',Lv_anchor_pivot_pt_val;
		
		IF I.ANCHOR_LEVEL_PIVOT_EX <> ''
		THEN
			lv_exld_val := 1;
		ELSE
			lv_exld_val := 0;
		END IF;
		
		IF Lv_anchor_pivot_val2 = ''
		THEN 
			 RAISE NOTICE 'Problem in anchor level pivot :: ISP_EVENT_PT :%',Lv_anchor_display_name;
		END IF;
		
		
		
		lV_anchor_param_map:= '{"adhocRules":[],"paramMap":{"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"LIB_Meddra":{"values":["'||Lv_anchor_pivot_val2||'"],"fieldLabel":"MedDRAPT ","label":"'||Lv_anchor_pivot_pt_val||'"},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""}}}';
							
							
							
		--RAISE NOTICE 'lV_anchor_param_map %',lV_anchor_param_map;					
		--lV_anchor_param_map  := '{"adhocRules":[],"paramMap":{"CL_8008":{"values":["'||Lv_anchor_pivot_code||'"],"fieldLabel":"Study Product Type","label":"'||Lv_anchor_pivot_val2||'"},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""}}}';
				
		UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
		SET fk_pivot_rule = lv_anchor_att,
    	PARAM_MAP = lV_anchor_param_map,
    	exclude_pivot_rule  = lv_exld_val, USER_MODIFIED = 'AMGEN_DR',DATE_MODIFIED = CURRENT_TIMESTAMP
		WHERE ACTIVE = 1
		AND TRIM(UPPER(display_name)) = TRIM(UPPER(Lv_anchor_display_name))
		AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
										WHERE display_name = I.FORMAT_DISPLAY_NAME
										AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
											WHERE DISTRIBUTION_UNIT_NAME IN (I.CONTACT_NAME)));
	
		
	ELSE 
	
	RAISE NOTICE 'Problem in Anchor level pivot  :%',Lv_anchor_display_name;
	
	END IF;
	END IF;
	
	lv_exld_val := 0;


	
END LOOP;

	Lv_format_pivot_code := null;
	Lv_format_pivot_val2 := null;
	Lv_anchor_pivot_code := null;
	Lv_format_pivot_val2 := null;

EXCEPTION
WHEN OTHERS THEN
raise notice '%',sqlerrm;
END $$;
 




