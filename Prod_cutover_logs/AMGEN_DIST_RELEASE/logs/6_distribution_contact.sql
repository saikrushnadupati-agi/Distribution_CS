----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : SANJAY K BEHERA                                            	          --
-- FILENAME             : DISTRIBUTION_CONTACT				    				              	  --
-- PURPOSE              : SCRIPT IS FOR CREATING OR UPDATING DISTRIBUTION UNITS					  --
-- DATE CREATED         : 23/02/2021                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 			: Sai Krushna Dupati /Navya Chandramouli														  --
-- DATE MODIFIED		: 09-Oct-2025                       						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --



--------

/* CREATE TABLE IF NOT EXISTS LSMV_DISTRIBUTION_UNIT_12022024 AS SELECT * FROM LSMV_DISTRIBUTION_UNIT;
CREATE TABLE IF NOT EXISTS LSMV_DISTRIBUTION_FORMAT_12022024 AS SELECT * FROM LSMV_DISTRIBUTION_FORMAT;
CREATE TABLE IF NOT EXISTS LSMV_DISTRIBUTION_RULE_ANCHOR_12022024 AS SELECT * FROM LSMV_DISTRIBUTION_RULE_ANCHOR;
CREATE TABLE IF NOT EXISTS LSMV_DISTRIBUTION_RULE_MAPPING_12022024 AS SELECT * FROM LSMV_DISTRIBUTION_RULE_MAPPING;
 */



--------

DELETE FROM LSMV_TEMP_UPLOAD
WHERE DISTRIBUTION_CONTACT_NAME IS NULL;

UPDATE LSMV_TEMP_UPLOAD
SET distribution_contact_name = TRIM(distribution_contact_name),
    FORMAT = TRIM(FORMAT),
	FORMAT_DISPLAY_NAME = TRIM(FORMAT_DISPLAY_NAME),
	ANCHOR_NAME = TRIM(ANCHOR_NAME);
/* 	
UPDATE LSMV_PERSON
SET FIRST_NAME = PERSON_ID
WHERE FIRST_NAME IS NULL; */

UPDATE LSMV_TEMP_UPLOAD
SET SUBMISSION_DUE_DATE_CALC_BASED_ON = 'Latest Received Date'
WHERE (SUBMISSION_DUE_DATE_CALC_BASED_ON IS NULL OR SUBMISSION_DUE_DATE_CALC_BASED_ON = '');




UPDATE LSMV_DISTRIBUTION_UNIT
SET ACTIVE = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR');

UPDATE LSMV_DISTRIBUTION_FORMAT
SET ACTIVE = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR');

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
SET ACTIVE = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR');



update LSMV_TEMP_UPLOAD
set email_template = null
where email_template not in ('AMGEN WCG Portal Email Template');

update LSMV_TEMP_UPLOAD
set cp_template = null
where cp_template not in ('AMGEN_SLD_COVER_LETTER');

update LSMV_TEMP_UPLOAD
set SUBMISSION_UNIT = replace(SUBMISSION_UNIT,'DR_DUMMY','DR_LEGACY_CU');


DO $$
DECLARE
lv_context TEXT;
lv_record_id BIGINT;
lv_param_map TEXT;
lv_cur_con RECORD;
lv_param_update TEXT;
lv_Contact text;
lv_Contact_val text;
lv_receiver_org VARCHAR(2000) := '';
lv_LANGUAGE text;
lv_CONTACT_DESC TEXT;
lv_SUBMISSION_UNIT TEXT;
lv_RECV_AC_REC_ID BIGINT;
lv_RECV_CU_REC_ID BIGINT;
lv_LANG_CODE TEXT;
lv_SUB_UNT_REC_ID TEXT; 
lv_AC INTEGER;
lv_CU INTEGER := 0; -------- 
lv_WORKFLOW TEXT;
lv_CC_EMAIL TEXT;
lv_due_date_calc TEXT;
lv_due_date_cal TEXT;
lv_mail_server_rec_id BIGINT;
lv_cor_med text;
lv_cor_med_code text;
lv_cor_med_dtl text;
lv_sndr_cmnt INTEGER;
lv_sndr_cmnt_val text;
evnt_desc_acs INTEGER;
evnt_desc_acs_val text;
lv_store_loc_data INTEGER; --store local data added by SWATHI
lv_store_loc_data_val text; --store local data added by SWATHI
loc_lbl_acs INTEGER;
loc_lbl_acs_val text;
lv_ichsr INTEGER;
lv_ichsr_val text;
Lv_allow_back_report TEXT;
lv_back_report INTEGER;
lv_contact_active INTEGER;
lv_event_access INTEGER;
lv_rep_cmt_acs INTEGER;
Lv_reply_to_email_address TEXT;
Lv_H_5_r TEXT;
Lv_H_5_r_val INTEGER;
Lv_aff_due_date TEXT;
Lv_aff_due_date_CODE TEXT;
lv_spain_state_access INTEGER;
lv_local_approval_access INTEGER;
lv_variable_contact INTEGER;
lv_alternate_workflow BIGINT;
Lv_Auto_Translation TEXT;
Lv_Auto_Translation_CD INTEGER;
lv_snd_nul_neg_ack_val TEXT;
lv_snd_nul_neg_ack_code INTEGER;
lv_allow_device_fiels_val TEXT;
lv_allow_device_fiels_code INTEGER;
lv_non_com_prod_causality_val TEXT;
lv_non_com_prod_causality_code INTEGER;
lv_skip_late_cal_val TEXT;
lv_skip_late_cal_code INTEGER;
lv_subm_level_trans_val TEXT;
lv_subm_level_trans_code TEXT;


BEGIN
	 -- LOOP with all the required details for contact creation.
	 
     FOR Lv_cur_con IN (SELECT distinct RECEIVER_ORGANIZATION,CON_LANG,CON_DESCRIPTION,reply_to_email_address,CONTACT_ACTIVE,SUBMISSION_UNIT,CORRESPONDENCE_EMAIL_CC,
                        SUBMISSION_DUE_DATE_CALC_BASED_ON,aff_submission_due_date_calc_based_on,variable_contact,alternate_workflow,Variable_Attribute,CORRESPONDENCE_MEDIUM_DETAILS,
						allow_back_reporting,H4,H1,---store_local_data_lsmv,
						H_5_r,product_approval_access,LOCAL_LABELING,SND_NUL_FOR_NEG_ACK,distribution_contact_name,
						ICSR_ATTACHMENT,event_access,REPORTER_COMMENTS,correspondence_medium,Regional_State, Auto_Translation,Allow_display_of_Device_fields_in_Local_Data_Entry,
						Restrict_non_company_product_causality_export,Skip_Late_Calculations_for_Amendment_Reports,submission_level_translation_fields
 FROM LSMV_TEMP_UPLOAD
						)
     LOOP
		 
		 -- If no value present for receiver organization setting it to "DR_DEFAULT_ACCOUNT".
		 
		 IF Lv_cur_con.RECEIVER_ORGANIZATION IS NOT NULL OR Lv_cur_con.RECEIVER_ORGANIZATION  <> '' 
		 THEN
	         LV_receiver_org := TRIM(Lv_cur_con.RECEIVER_ORGANIZATION);
		 ELSE
		 	 LV_receiver_org := 'DR_LEGACY_ACC';
	   	 END IF;
	     
	
		 Lv_H_5_r := Lv_cur_con.H_5_r;
		 Lv_reply_to_email_address := TRIM(Lv_cur_con.reply_to_email_address);
         LV_LANGUAGE := TRIM(Lv_cur_con.CON_LANG);
         LV_CONTACT_DESC := TRIM(Lv_cur_con.CON_DESCRIPTION);
         LV_SUBMISSION_UNIT := TRIM(Lv_cur_con.SUBMISSION_UNIT);
		 LV_CC_EMAIL := TRIM(Lv_cur_con.CORRESPONDENCE_EMAIL_CC);
		 lv_due_date_calc := TRIM(Lv_cur_con.SUBMISSION_DUE_DATE_CALC_BASED_ON);
		 lv_cor_med_dtl := TRIM(Lv_cur_con.CORRESPONDENCE_MEDIUM_DETAILS);
		 lv_sndr_cmnt_val := TRIM(Lv_cur_con.H4);
		 evnt_desc_acs_val := TRIM(Lv_cur_con.H1);
		 --lv_store_loc_data_val := TRIM(Lv_cur_con.store_local_data_lsmv); --added by Swathi
		 loc_lbl_acs_val := TRIM(Lv_cur_con.LOCAL_LABELING);
		 LV_Contact:= TRIM(Lv_cur_con.distribution_contact_name);
		 lv_ichsr_val := TRIM(lv_cur_con.ICSR_ATTACHMENT);
		 Lv_allow_back_report := TRIM(lv_cur_con.allow_back_reporting); 
		 lv_cor_med := TRIM(lv_cur_con.correspondence_medium); 
		 Lv_aff_due_date := TRIM(lv_cur_con.aff_submission_due_date_calc_based_on);
		-- lv_spain_state_access_text:=TRIM(lv_cur_con.Regional_State);
	    --lv_local_approval_access_text:=TRIM(lv_cur_con.product_approval_access);
		 Lv_Auto_Translation := TRIM(lv_cur_con.Auto_Translation);
		 lv_snd_nul_neg_ack_val := TRIM(lv_cur_con.SND_NUL_FOR_NEG_ACK);
		 lv_allow_device_fiels_val:= TRIM(lv_cur_con.Allow_display_of_Device_fields_in_Local_Data_Entry);
		 lv_non_com_prod_causality_val :=  TRIM(lv_cur_con.Restrict_non_company_product_causality_export);
		 lv_skip_late_cal_val := TRIM(lv_cur_con.Skip_Late_Calculations_for_Amendment_Reports);
		 lv_subm_level_trans_val := TRIM(lv_cur_con.submission_level_translation_fields);  -- Added new field by Sai
		 
		 
		 -- Setting contact active based on value present in CS
		 IF UPPER(Lv_cur_con.CONTACT_ACTIVE) = 'NO' OR UPPER(Lv_cur_con.CONTACT_ACTIVE) = 'INACTIVE' OR UPPER(Lv_cur_con.CONTACT_ACTIVE) = 'UNCHECKED' OR 
			UPPER(Lv_cur_con.CONTACT_ACTIVE) = '' OR UPPER(Lv_cur_con.CONTACT_ACTIVE) IS NULL
		 THEN
			 lv_contact_active :=0;
		 ELSE
			 lv_contact_active :=1;
		 END IF;
		 
		
		IF lv_subm_level_trans_val IS NOT NULL 
		THEN  
			--RAISE NOTICE '1.%',lv_subm_level_trans_val;
			
			lv_subm_level_trans_code := '3,1';
			
		 END IF;
		 
				
		 
		 BEGIN
		 if upper (Lv_cur_con.variable_contact)='YES'
		 THEN
		 lv_variable_contact:=1;
		     select record_id into lv_alternate_workflow from lsmv_workflow
				where upper(wf_name)=upper(Lv_cur_con.alternate_workflow);
				if lv_alternate_workflow IS NULL
				THEN
				select record_id into lv_alternate_workflow from lsmv_workflow
				where upper(wf_name)=upper('ISP JAPAN Child Workflow');
				END IF;
		 ELSE
		 lv_variable_contact:=0;
		 END IF;
		 EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in Deviated Column';
	     END; 
	 
		 -- setting event access value based on CS
		 IF UPPER(Lv_cur_con.event_access)='YES' OR UPPER(Lv_cur_con.event_access) = 'CHECKED' OR UPPER(Lv_cur_con.event_access) = 'Y'
		 THEN
			 lv_event_access :=1;
		 ELSE
			 lv_event_access :=0;
		 END IF;
		 
		 IF UPPER(lv_cur_con.Regional_State)='YES'
		 THEN
			 lv_spain_state_access :=1;
		 ELSE
			 lv_spain_state_access :=0;
		 END IF;
		 
		 
		  IF UPPER(lv_cur_con.product_approval_access)='YES'
		 THEN
			 lv_local_approval_access :=1;
		 ELSE
			 lv_local_approval_access :=0;
		 END IF;
		
		 -- setting value for reporrter comments based on CS 
		 IF UPPER(Lv_cur_con.REPORTER_COMMENTS)='YES' OR UPPER(Lv_cur_con.REPORTER_COMMENTS) = 'CHECKED' OR UPPER(Lv_cur_con.REPORTER_COMMENTS) = 'Y'
		 THEN
			 lv_rep_cmt_acs :=1;
		 ELSE
			 lv_rep_cmt_acs :=0;
		 END IF;
		
		 -- getting contact name from unit table to check avilibility.
		BEGIN
	 
			  SELECT distribution_unit_name into  lv_Contact_val
		      from LSMV_DISTRIBUTION_UNIT 
			  WHERE Upper(DISTRIBUTION_UNIT_NAME)=Upper(LV_Contact);
		  
		EXCEPTION 
		WHEN OTHERS THEN 
		 CALL C_PROC_DISTRIBUTION_EXCEPTION('1', LV_Contact, '*', '*','*', 
								   '*','*', NULL,'SQLERRM', 'Contact name: '||LV_Contact||' not available');
		END;
	 
		 ---To Fetch Receiver Contact Id
		 
		Begin
	  --To Fecth Receiver Organisation From Account Table
	  SELECT RECORD_ID INTO STRICT lv_RECV_AC_REC_ID
	  FROM LSMV_ACCOUNTS WHERE UPPER(ACCOUNT_ID)=UPPER(LV_receiver_org);
	    
        -- If the value is not available there then searching from person for company unit		
	  		IF lv_RECV_AC_REC_ID is null then
			SELECT RECORD_ID INTO lv_RECV_CU_REC_ID FROM LSMV_PARTNER WHERE UPPER(PARTNER_ID)=UPPER(LV_receiver_org);
				--If the receiver organisation is not found in both the place

				IF lv_RECV_CU_REC_ID is null AND lv_RECV_AC_REC_ID is null
				THEN
					lv_RECV_AC_REC_ID := (select record_id from lsmv_accounts where account_name = 'DR_LEGACY_ACCOUNT');
					RAISE NOTICE '1.%',LV_Contact||'---Value for Receiver Organisation is not availble either in Accounts or Company Unit : ';
				LV_AC :=1;
				ELSE
				LV_CU :=1;
				END IF;
				
		   ELSE
		   LV_AC :=1;
		   END IF;
	  EXCEPTION 
	  WHEN OTHERS THEN 
		    SELECT RECORD_ID INTO lv_RECV_CU_REC_ID FROM LSMV_PARTNER WHERE UPPER(NAME)=UPPER(LV_receiver_org);
	  
				IF lv_RECV_CU_REC_ID is null 
				THEN
					lv_RECV_AC_REC_ID := (select record_id from lsmv_accounts where account_name = 'DR_LEGACY_ACCOUNT');
					RAISE NOTICE '2.%',LV_Contact||'---Value for Receiver Organisation is not availble either in Accounts or Company Unit ';
				LV_AC :=1;
				ELSE
				LV_CU :=1;
				END IF;
	  END;
	  	  
	   
		--To Fetch the code for Language
		BEGIN
			SELECT CC.CODE INTO LV_LANG_CODE
			FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
			WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
			AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
			AND CD.LANGUAGE_CODE = 'en'
			AND CN.CODELIST_ID = 9065
			AND CC.CODE_STATUS='1'
			AND UPPER(CD.DECODE)=UPPER(LV_LANGUAGE);
		
			--If Langauge not found
			IF LV_LANG_CODE IS NULL 
			THEN
				-- Assigning english as by default as languagre in CS is not available
				LV_LANG_CODE := '127';
				
				CALL C_PROC_DISTRIBUTION_EXCEPTION('4', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Assigning ENG as Language is not Available : ' ||LV_Contact||' - '|| LV_LANGUAGE);
			END IF;
		EXCEPTION 
		WHEN OTHERS THEN 
			CALL C_PROC_DISTRIBUTION_EXCEPTION('5', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Assigning ENG as Language is not Available : ' ||LV_Contact||' - '|| LV_LANGUAGE);
		END;
									
		IF lv_cor_med <> ''
		THEN 
			--To Fetch the code for CORRESPONDENCE MEDIUM
			BEGIN 
				SELECT CC.CODE into lv_cor_med_code
				FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
				WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
				AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
				AND CD.LANGUAGE_CODE = 'en'
				AND CN.CODELIST_ID = 9644
				AND CC.CODE_STATUS='1'
				AND UPPER(CD.DECODE)=UPPER(lv_cor_med);
				
			
		
				--If CORRESPONDENCE MEDIUM DETAILS not found
				IF lv_cor_med_code IS NULL 
				THEN
					
					CALL C_PROC_DISTRIBUTION_EXCEPTION('6', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Code For CORRESPONDENCE MEDIUM is not Available');
				END IF;
			END;
		ELSE
			lv_cor_med_code := '';
		END IF;
		IF lv_due_date_calc <> ''
		THEN 

			--To Fetch the code for Due date
			BEGIN
				SELECT CC.CODE into lv_due_date_cal
				FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
				WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
				AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
				AND CD.LANGUAGE_CODE = 'en'
				AND CN.CODELIST_ID = 9866
				AND CC.CODE_STATUS='1'
				AND UPPER(CD.DECODE)=UPPER(lv_due_date_calc);
				

				--If code for Due date not found
				IF lv_due_date_cal IS NULL
				THEN 
				CALL C_PROC_DISTRIBUTION_EXCEPTION('7', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Due Date Calculation Factor is not Available');
				END IF;
			END;
		END IF;
		
		IF Lv_aff_due_date <> ''
		THEN 
			--To Fetch the code for AFF Due date
			BEGIN
				SELECT CC.CODE into Lv_aff_due_date_CODE
				FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
				WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
				AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
				AND CD.LANGUAGE_CODE = 'en'
				AND CN.CODELIST_ID = 9645
				AND CC.CODE_STATUS='1'
				AND UPPER(CD.DECODE)=UPPER(Lv_aff_due_date);
		
				--If code for Due date not found
				IF Lv_aff_due_date_CODE is null then 

				CALL C_PROC_DISTRIBUTION_EXCEPTION('8', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'AFF Due Date Calculation Factor is not Available');
				END IF;
			END;
		END IF;
		
 
		--To Fetch Submission Unit Record Id
		BEGIN
			LV_SUBMISSION_UNIT :=replace(replace(trim(LV_SUBMISSION_UNIT),' ,',','),', ',','); 
			
			SELECT STRING_AGG(record_id::TEXT,',') INTO STRICT LV_SUB_UNT_REC_ID 
			FROM LSMV_PARTNER  
			WHERE upper(partner_id) IN (SELECT upper(regexp_split_to_table(LV_SUBMISSION_UNIT,',')) COL_VAL FROM dual );
			
	
			-- When Submission Unit Not Found 
			IF LV_SUB_UNT_REC_ID IS NULL 
			THEN 
				SELECT record_id INTO LV_SUB_UNT_REC_ID
				FROM LSMV_PARTNER
				WHERE partner_id = 'DR_LEGACY_CU'; 
				RAISE NOTICE '1.%','Value is not available for submission unit'||' : '||LV_SUBMISSION_UNIT;
				CALL C_PROC_DISTRIBUTION_EXCEPTION('9', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Value is not available for submission unit :'||LV_SUBMISSION_UNIT);
			END IF;
		EXCEPTION WHEN OTHERS THEN 
			CALL C_PROC_DISTRIBUTION_EXCEPTION('10', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Value is not available for submission unit :'||LV_SUBMISSION_UNIT);
		END; 
	
		--To Fetch Sender Comment Access H4  
		BEGIN
			If UPPER(lv_sndr_cmnt_val)='YES'
			THEN
				lv_sndr_cmnt :=1;
			ELSE	
				lv_sndr_cmnt :=0;
			END IF;
		EXCEPTION WHEN OTHERS 
		THEN 
			CALL C_PROC_DISTRIBUTION_EXCEPTION('10', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Problem in Sender Comment Access H4');
		END; 
		
		
			--To Fetch lv_snd_nul_neg_ack_val  
		BEGIN
			If UPPER(lv_snd_nul_neg_ack_val)='YES'
			THEN
				lv_snd_nul_neg_ack_code :=1;
			ELSE	
				lv_snd_nul_neg_ack_code :=0;
			END IF;
			
		EXCEPTION WHEN OTHERS 
		THEN 
			CALL C_PROC_DISTRIBUTION_EXCEPTION('10', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Problem in lv_snd_nul_neg_ack_val');
		END; 
	
		--To Fetch Event Description Access H1  
		BEGIN
			If UPPER(evnt_desc_acs_val) = 'YES' 
			THEN
				evnt_desc_acs :=1;
			ELSE	
				evnt_desc_acs :=0;
			END IF;
		EXCEPTION WHEN OTHERS THEN 
			RAISE NOTICE '1.%','Problem in Event Description Access H1';
			CALL C_PROC_DISTRIBUTION_EXCEPTION('11', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Problem in Event Description Access H1');
		END; 
--store local data added by SWATHI
		--To Fetch Store local Data  
/* 		BEGIN
			If UPPER(lv_store_loc_data_val) = 'YES' 
			THEN
				lv_store_loc_data :=1;
			ELSE	
				lv_store_loc_data :=0;
			END IF;
		EXCEPTION WHEN OTHERS THEN 
			RAISE NOTICE '1.%','Problem in Store local data';
			CALL C_PROC_DISTRIBUTION_EXCEPTION('11', LV_Contact, '*', '*','*',  
								   '*','*', NULL,'SQLERRM', 'Problem in Store local data');
		END; */ 	  
	  
	--To Fetch Local Labelling ACCESS 
	Begin
	If upper(loc_lbl_acs_val)='YES' then
    loc_lbl_acs :=1;
    ELSE	
	loc_lbl_acs :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Problem in Local Labelling ACCESS';
	END; 
	
	
	--To Fetch Code for allow ICHSR
	Begin
	If upper(lv_ichsr_val)='YES' then
    lv_ichsr :=1;
    ELSE	
	lv_ichsr :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Problem in Local Labelling ACCESS';
	END;

--To Fetch Code for allow back reporting
	Begin
	If (upper(Lv_allow_back_report)='YES' or  upper(Lv_allow_back_report)='CHECKED')then
    lv_back_report :=1;
    ELSE	
	lv_back_report :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Problem in Local Labelling ACCESS';
	END;


--To Fetch Code for H_5_r
	Begin
	If upper(Lv_H_5_r)='YES' then
    Lv_H_5_r_val :=1;
    ELSE	
	Lv_H_5_r_val :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Problem in Local Labelling ACCESS';
	END;
	
-- Auto_Translation
	Begin
		IF UPPER(Lv_Auto_Translation) = 'YES'
		THEN 
			Lv_Auto_Translation_CD := 1;
		ELSE 
			Lv_Auto_Translation_CD := 0;
		END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '2.%', 'Issue at Auto Translation';
	END; 
	
	
	-- Allow display of Device fields in Local Data Entry
	Begin
	If upper(lv_allow_device_fiels_val)='YES' then
    lv_allow_device_fiels_code :=1;
    ELSE	
	lv_allow_device_fiels_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Allow display of Device fields in Local Data Entry';
	END; 
	
	-- Restrict_non_company_product_causality_export
	Begin
	If upper(lv_non_com_prod_causality_val)='YES' then
    lv_non_com_prod_causality_code :=1;
    ELSE	
	lv_non_com_prod_causality_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Restrict_non_company_product_causality_export';
	END; 
	
	
	-- Skip_Late_Calculations_for_Amendment_Reports
	
	Begin
	If upper(lv_skip_late_cal_val)='YES' then
    lv_skip_late_cal_code :=1;
    ELSE	
	lv_skip_late_cal_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Skip_Late_Calculations_for_Amendment_Reports';
	END; 
	
	
	  
    -- Insert or Update for contact
      IF lv_Contact_val is null then 
	 --Insert 	 
	     INSERT INTO lsmv_distribution_unit(record_id, distribution_unit_name, active, is_company_unit, fk_company_unit, 
                                                is_account, fk_account, fk_sender_contact, fk_receiver_contact, fk_submission_workflow, 
                                                description, 
												cc_email_id,
												due_date_calculation_factor, selected_language, fk_mail_server, 
                                                correspondence_medium, 
												correspondence_medium_details,
												sender_comments_access, event_description_access,
                                                local_labelling_access, allow_icsr_attachments, summary_reporter_cmt_access, local_approval_access, causality_access, 
 		                                        --store_local_data_in_lsmv,
												user_created, date_created, user_modified, date_modified, 
		                                        sender_contact_cu_rec_id, sender_contact_cu_partner_id, reply_to_email_address,
												fk_pivot_rule, param_map, recal_affiliate_submission, trusted_partner, spain_state_access,
		                                        enable_back_reporting, send_olt, import_comments, fk_submission_wf_name,archived, 
                                                access_partners, exclude_pivot_rule, expedited_timeline,event_access,reporter_comments_access,deviated,fk_deviated_workflow, Auto_Translation,
												negative_nullification_for_ack,
												allow_display_of_device_in_lde,
												restrict_non_company_product_causality_export,
												skip_late_calculation_amendment_report,
												submission_level_translation_fields
												) 
		                                VALUES (nextval('seq_record_id'), LV_Contact,lv_contact_active, LV_CU, lv_RECV_CU_REC_ID,
                                                LV_AC, lv_RECV_AC_REC_ID , NULL, NULL, NULL, 
                                                LV_CONTACT_DESC, 
												LV_CC_EMAIL,
												lv_due_date_cal, LV_LANG_CODE, null, 
                                                lv_cor_med_code, 
												lv_cor_med_dtl,
												lv_sndr_cmnt, evnt_desc_acs,
                                                loc_lbl_acs, lv_ichsr , Lv_H_5_r_val, lv_local_approval_access, 0, 
                                               --store local data added by SWATHI
                       						    --lv_store_loc_data, 
												'AMGEN_DR', CURRENT_TIMESTAMP, NULL, NULL, 
                                                NULL, NULL, 
												Lv_reply_to_email_address,
                                                NULL, NULL, Lv_aff_due_date_CODE, 0, lv_spain_state_access,
                                                lv_back_report,0, NULL, NULL, 0,
                                                LV_SUB_UNT_REC_ID, 0, 15,lv_event_access,lv_rep_cmt_acs,lv_variable_contact,lv_alternate_workflow, Lv_Auto_Translation_CD,
												lv_snd_nul_neg_ack_code,
												lv_allow_device_fiels_code,
												lv_non_com_prod_causality_code,
												lv_skip_late_cal_code,
												lv_subm_level_trans_code
												);
	 ELSE
	 --Update
	    UPDATE lsmv_distribution_unit set is_company_unit= LV_CU, fk_company_unit = lv_RECV_CU_REC_ID, is_account = LV_AC , fk_account = lv_RECV_AC_REC_ID,active=lv_contact_active,
		description = LV_CONTACT_DESC, 
		cc_email_id = LV_CC_EMAIL, 
		due_date_calculation_factor =  lv_due_date_cal, selected_language = LV_LANG_CODE,reporter_comments_access=lv_rep_cmt_acs,
		correspondence_medium = lv_cor_med_code,
		correspondence_medium_details = lv_cor_med_dtl,
		sender_comments_access = lv_sndr_cmnt, event_description_access =  evnt_desc_acs, --store_local_data_in_lsmv = lv_store_loc_data, --store local data added by SWATHI
		event_access=lv_event_access,
		local_labelling_access= loc_lbl_acs, allow_icsr_attachments = lv_ichsr ,access_partners = LV_SUB_UNT_REC_ID , enable_back_reporting = lv_back_report,user_modified='AMGEN_DR',
		reply_to_email_address = Lv_reply_to_email_address,
		summary_reporter_cmt_access = Lv_H_5_r_val, recal_affiliate_submission = Lv_aff_due_date_CODE,
		date_modified = CURRENT_TIMESTAMP,spain_state_access=lv_spain_state_access,local_approval_access=lv_local_approval_access,
		deviated=lv_variable_contact,fk_deviated_workflow=lv_alternate_workflow,
		Auto_Translation = Lv_Auto_Translation_CD,
		negative_nullification_for_ack=lv_snd_nul_neg_ack_code,
		allow_display_of_device_in_lde = lv_allow_device_fiels_code,
		restrict_non_company_product_causality_export =lv_non_com_prod_causality_code,
		skip_late_calculation_amendment_report =lv_skip_late_cal_code,
		submission_level_translation_fields = lv_subm_level_trans_code
		
		WHERE distribution_unit_name = lv_Contact_val;
	 
	END IF;   
 
   ----- Update all the varibales used in the condition needs to set as null
	 --
	lv_RECV_AC_REC_ID :=null;
	lv_RECV_CU_REC_ID :=null;
	LV_CU :=0;
	LV_AC :=0;
	LV_LANG_CODE :=null;
	lv_due_date_cal := null;
	LV_SUB_UNT_REC_ID := null;
	lv_sndr_cmnt :=0;
	evnt_desc_acs :=0;
	lv_store_loc_data :=0;
	loc_lbl_acs :=0;
	lv_ichsr :=0;
	lv_back_report := 0;
	lv_contact_active :=0;
	lv_event_access:=null;
	lv_rep_cmt_acs:=null;
	Lv_H_5_r := '';
	Lv_H_5_r_val := NULL;
	lv_spain_state_access:=0;
	lv_local_approval_access:=0;
	lv_variable_contact:=0;
	lv_alternate_workflow:=NULL;
	Lv_Auto_Translation_CD:=0; 	
	Lv_aff_due_date_CODE:=NULL;
	lv_snd_nul_neg_ack_code:=0;
	lv_subm_level_trans_code := NULL;
     END LOOP;
	 
 
EXCEPTION
WHEN others THEN
GET STACKED DIAGNOSTICS lv_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION :%', lv_context;
RAISE NOTICE 'EXCEPTION  IN MAIN BLOCK  :%', 'SQLERRM';
END $$;

