----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera                                            	          --
-- FILENAME             : DISTRIBUTION_FORMAT				    				              	  --
-- PURPOSE              : SCRIPT IS FOR CREATING OR UPDATING DISTRIBUTION FORMATS				  --
-- DATE CREATED         : 23/02/2022                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 		    : Sai Krushna Dupati /Navya Chandramouli																  --
-- DATE MODIFIED		: 20-Aug-2024                       						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --

DO $$
DECLARE
lv_context text;
lv_cur_con RECORD;
lv_cur_format RECORD;
lv_for_disp_nm text;
lv_format_type text;
lv_format_type_code text;
lv_rep_med text;
lv_rep_med_code text;
lv_format_desc text;
lv_xml_doc_type text;
lv_message_type text;
lv_message_type_code text;
lv_dtd_val text;
lv_r2_r3_chk_val text;
lv_r2_r3_chk INTEGER;
lv_lit_doc_val text;
lv_lit_doc INTEGER;
lv_dis_con text;
lv_dis_con_rec_id BIGINT;
lv_dtd_schema INTEGER;
lv_sender text;
lv_sender_rec_id BIGINT;
lv_receiver text;
lv_receiver_rec_id BIGINT;
lv_med_dtl text;
lv_sender_cu_rec_id BIGINT;
lv_sender_cu_par_id text;
lv_blinded_val text;
lv_blinded_code INTEGER;
lv_workflow_nm text;
lv_workflow_rec_id BIGINT;
lv_olt_code INTEGER;
lv_olt_val text;
lv_auto_chk_val text;
lv_auto_chk_code INTEGER;
lv_sim_prod_code INTEGER; 
lv_touchless_val text;
lv_touchless_code INTEGER;
lv_count INTEGER;
lv_dis_format_rec_id BIGINT;
lv_format_active INTEGER;
lv_data_privacy INTEGER;
lv_format_type_val text;
lv_format_type_cmp text;
lv_email_template text;
lv_CP_template text;
lv_email_temp_rec_id BIGINT;
lv_CP_temp_rec_id BIGINT;
lv_exp_timeline INTEGER;
lv_send_final_report_val text;
lv_send_final_report INTEGER;
Lv_MEDIUM_DETAILS text; 
Lv_allow_batch_export INTEGER;
Lv_allow_email_batch_export INTEGER;
lv_generate_xml INTEGER;
--Added by Swathi
lv_cc_email TEXT;
Lv_CC_EMAIL_ADDRESS TEXT;
Lv_OLT_Significance TEXT;
Lv_OLT_Significance_code TEXT;
lv_drop_olt INTEGER;
Lv_export_term_id TEXT;
Lv_export_term_id_CODE TEXT;
lv_enable_auto_multi_reporting_code INTEGER;
lv_edit_safety_report_code INTEGER;
lv_edit_authority_code INTEGER;
lv_edit_whodd_code INTEGER;
lv_include_whodd_code INTEGER;
Lv_icsr_modification_rule TEXT;
Lv_icsr_modification_rule_code TEXT;
lv_allow_edit_native_lan INTEGER;
lv_include_all_lab_rec INTEGER;
lv_mir_xml_schema TEXT;

BEGIN

  ---Contact Level Loop
  FOR lv_cur_con IN (SELECT distinct upper(trim(distribution_contact_name)) distribution_contact_name FROM LSMV_TEMP_UPLOAD )
  LOOP
	 -- Format Level Loop
     FOR lv_cur_format IN (SELECT distinct FORMAT_DISPLAY_NAME,FORMAT,REPORT_MEDIUM,MEDIUM_DETAILS,cc_email_address,FORMAT_DESC,xml_doc_type,format_active,
	                       message_type,R3_IN_R2,INCL_LIT_DOC,distribution_contact_name,sender,data_privacy,
						   receiver,BLINDED_REPORT,SUB_WORKFLOW,OLT,AUTO_DISTRIBUTE,TOUCHLESS,email_template,CP_TEMPLATE,exp_timeline,send_final_report,
						   allow_batch_export,SINGLE_EMAIL,xml_required,--OLT_Significance,						   drop_olt, 
						   term_id,
						   Include_WHODD_MPID,Edit_WHODD_MPID,Edit_Authority_No,Edit_Safety_Report_ID,Enable_auto_multi_reporting,ICSR_Modification_rule,
						   Allow_edit_of_Native_Language_in_LDE,Include_All_Labeling_Records,MIR_XML_Schema

                           FROM LSMV_TEMP_UPLOAD where upper(trim(distribution_contact_name))=upper(trim(Lv_cur_con.distribution_contact_name )))
     LOOP
	 
	 lv_email_template :=lv_cur_format.email_template;
	 lv_CP_template :=lv_cur_format.CP_TEMPLATE;
	 --Lv_OLT_Significance := UPPER(TRIM(lv_cur_format.OLT_Significance));
	 Lv_export_term_id := UPPER(TRIM(lv_cur_format.term_id));	 
	 Lv_icsr_modification_rule := trim(lv_cur_format.ICSR_Modification_rule);
	 lv_exp_timeline :=to_number(COALESCE(lv_cur_format.exp_timeline,'15'),'99');
	 Lv_MEDIUM_DETAILS := trim(lv_cur_format.MEDIUM_DETAILS);
	 --Added by Swathi
	 Lv_CC_EMAIL_ADDRESS := trim(lv_cur_format.cc_email_address); 
	 
	  IF lv_email_template is not null and lv_email_template<>'' THEN
	 BEGIN
        
               SELECT RECORD_ID
               INTO lv_email_temp_rec_id
               FROM LSMV_TEMPLATE
               WHERE TRIM(UPPER(TEMPLATE_NAME)) = UPPER(trim(lv_email_template))
              AND APPROVED = 1
              --AND COMPLETION_FLAG = 1
              AND LATEST_VERSION = (SELECT MAX(LATEST_VERSION)
                                    FROM LSMV_TEMPLATE
                                    WHERE TRIM(UPPER(TEMPLATE_NAME)) = UPPER(trim(lv_email_template))
                                    AND APPROVED = 1);
             
              --RAISE NOTICE 'TEMPLATE:%', UPPER(trim(lv_email_template));
              IF lv_email_temp_rec_id IS NULL
              THEN
                  RAISE NOTICE 'EMAIL_TEMPLATE is not Available:%', UPPER(trim(lv_email_template));
              END IF;
        
         EXCEPTION WHEN OTHERS THEN
         GET STACKED DIAGNOSTICS lv_context = PG_EXCEPTION_CONTEXT;
         RAISE NOTICE 'TEMPLATE:%', lv_context;
         END;
	 END IF;
	 
	 
	 
	  IF lv_CP_template is not null and lv_CP_template<>'' THEN
	 BEGIN
        
               SELECT RECORD_ID
               INTO lv_CP_temp_rec_id
               FROM LSMV_TEMPLATE
               WHERE TRIM(UPPER(TEMPLATE_NAME)) = UPPER(trim(lv_CP_template))
              AND APPROVED = 1
              --AND COMPLETION_FLAG = 1
              AND LATEST_VERSION = (SELECT MAX(LATEST_VERSION)
                                    FROM LSMV_TEMPLATE
                                    WHERE TRIM(UPPER(TEMPLATE_NAME)) = UPPER(trim(lv_CP_template))
                                    AND APPROVED = 1);
             
              --RAISE NOTICE 'TEMPLATE:%', UPPER(trim(lv_CP_template));
              IF lv_CP_temp_rec_id IS NULL
              THEN
                  RAISE NOTICE 'CP_TEMPLATE is Not Available:%', UPPER(trim(lv_CP_template));
              END IF;
        
         EXCEPTION WHEN OTHERS THEN
         GET STACKED DIAGNOSTICS lv_context = PG_EXCEPTION_CONTEXT;
         RAISE NOTICE 'TEMPLATE:%', lv_context;
         END;
	 END IF; 
	 
	 
	 lv_format_type_cmp :=DR_DECODE_CODE(lv_cur_format.FORMAT,9601);
		
	 lv_format_type_val :=COALESCE(DR_DECODE_CODE(lv_cur_format.FORMAT,9601),'20');
	 
	 if lv_format_type_cmp is not null and lv_format_type_cmp<>lv_format_type_val
	 	 then 
		 RAISE NOTICE '3.%','Format is not Available in codelist 9601 :- '|| lv_cur_format.FORMAT || ' : ' ||Lv_cur_con.distribution_contact_name;
	end if;
	 	 
	 IF lv_format_type_val=''
		THEN	
			lv_format_type_val :='20';
	 END IF;
	 
	 SELECT COUNT(1) into lv_count 
	 from lsmv_distribution_format 
	 where fk_distribution_unit in(SELECT RECORD_ID 
	 from lsmv_distribution_unit 
	 where upper(trim(distribution_unit_name))=upper(trim(Lv_cur_con.distribution_contact_name)) )
	 and format_type=lv_format_type_val
	 and display_name=lv_cur_format.FORMAT_DISPLAY_NAME;
	 
	 --To Fetch Record Id for Update part
	 If lv_count=1 then
	 SELECT record_id into lv_dis_format_rec_id 
	 from lsmv_distribution_format 
	 where fk_distribution_unit in(SELECT RECORD_ID 
	 from lsmv_distribution_unit 
	 where upper(trim(distribution_unit_name))=upper(trim(Lv_cur_con.distribution_contact_name)))
	 and format_type=lv_format_type_val
	 and display_name=lv_cur_format.FORMAT_DISPLAY_NAME;
	 --RAISE NOTICE '4.%','More than one is availbale for Contact'||lv_dis_con;
	 ELSIF lv_count>1 then
	 RAISE NOTICE '4.%','More than one format is availbale for '||Lv_cur_con.distribution_contact_name;
	 END IF;
	 
	  --To Fetch Format Active
	 If upper(lv_cur_format.format_active)='NO' OR upper(lv_cur_format.format_active)='INACTIVE'then
	 lv_format_active := 0;
	 ELSE
	 lv_format_active := 1;
	 --RAISE NOTICE '4.%','Format Active/Inactive';
	 END IF;
	 
	 IF Lv_icsr_modification_rule = 'ICSR_RULE_ICHICSR_R3_sendertags_restricted' then 
		Lv_icsr_modification_rule_code := (select record_id from LSMV_DYNAMIC_SERVICE_DETAILS where script_name = Lv_icsr_modification_rule);
	 ELSE 
		Lv_icsr_modification_rule := NULL;
		Lv_icsr_modification_rule_code := NULL;
	 END IF;
	 
	 
	 If upper(lv_cur_format.data_privacy)='NA' then
	 lv_data_privacy := 4;
	 ELSIF upper(lv_cur_format.data_privacy)= 'YES'
	 THEN
		 lv_data_privacy := 1;
	 ELSE 
		 lv_data_privacy := 2;
	 --RAISE NOTICE '4.%','Format Active/Inactive';
	 END IF;
	 	 
		BEGIN 
		IF upper(lv_cur_format.xml_required)='YES' THEN
		lv_generate_xml:=1;
		ELSE
		lv_generate_xml:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in generate_xml Column lsmv_distribution_format';
	    END; 
		
		BEGIN 
		IF upper(lv_cur_format.Include_WHODD_MPID)='YES' THEN
		lv_include_whodd_code:=1;
		ELSE
		lv_include_whodd_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in include whodd Column lsmv_distribution_format';
	    END; 
		
		BEGIN 
		IF upper(lv_cur_format.Edit_WHODD_MPID)='YES' THEN
		lv_edit_whodd_code:=1;
		ELSE
		lv_edit_whodd_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in edit_whodd Column lsmv_distribution_format';
	    END; 
		
		BEGIN 
		IF upper(lv_cur_format.Edit_Authority_No)='YES' THEN
		lv_edit_authority_code:=1;
		ELSE
		lv_edit_authority_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in edit_authority Column lsmv_distribution_format';
	    END; 
		
		BEGIN 
		IF upper(lv_cur_format.Edit_Safety_Report_ID)='YES' THEN
		lv_edit_safety_report_code:=1;
		ELSE
		lv_edit_safety_report_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in edit_safety_report Column lsmv_distribution_format';
	    END; 
		
		BEGIN 
		IF upper(lv_cur_format.enable_auto_multi_reporting)='YES' THEN
		lv_enable_auto_multi_reporting_code:=1;
		ELSE
		lv_enable_auto_multi_reporting_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '1.%','Problem in generate_xml Column lsmv_distribution_format';
	    END; 
	 
	
	 
	 --RAISE NOTICE 'L4.%',lv_format_type_val;
	 lv_for_disp_nm :=TRIM(lv_cur_format.FORMAT_DISPLAY_NAME);
	 lv_format_type :=DR_CODE_DECODE(lv_format_type_val,9601);
	 lv_rep_med := REPLACE(TRIM(lv_cur_format.REPORT_MEDIUM),'Manual','Postal');
	 lv_format_desc  := TRIM(lv_cur_format.FORMAT_DESC);
	 
	 IF lv_format_type = '3' OR lv_format_type = 'E2B'
	 THEN 	 
		 lv_xml_doc_type := UPPER(TRIM(COALESCE(lv_cur_format.xml_doc_type,'E2B R3 STANDARD')));
	 ELSE
		 lv_xml_doc_type :=UPPER(TRIM(lv_cur_format.xml_doc_type));
	 END IF;
	 
	 lv_message_type := TRIM(lv_cur_format.message_type);
	 lv_r2_r3_chk_val :=lv_cur_format.R3_IN_R2;
	 lv_lit_doc_val :=lv_cur_format.INCL_LIT_DOC;
	 lv_dis_con :=lv_cur_format.distribution_contact_name;
	 
	 IF lv_cur_format.sender IS NOT NULL OR lv_cur_format.sender <> '' THEN
	      lv_sender := TRIM(lv_cur_format.sender);
	 ELSE
	      lv_sender := 'DR_LEGACY_CU_CONT'; ---------------------------------- change to default sender
	 END IF;
	 
	 IF lv_cur_format.receiver IS NOT NULL OR lv_cur_format.receiver <> '' THEN
	      lv_receiver := TRIM(lv_cur_format.receiver);
	 ELSIF lv_format_type ='E2B' and (lv_cur_format.receiver IS NULL  OR lv_cur_format.receiver = '') THEN
	      lv_receiver := 'DR_LEGACY_ACC_CONT'; ------------------------------------------------------------------ chnage to default receiver
	 ELSE 	
     lv_receiver :=null;	 
	 END IF;

	 lv_blinded_val :=lv_cur_format.BLINDED_REPORT;
	 lv_workflow_nm := COALESCE( lv_cur_format.SUB_WORKFLOW,'ISP Submission Workflow');
	 lv_olt_val :=lv_cur_format.OLT;
	 lv_auto_chk_val :=lv_cur_format.AUTO_DISTRIBUTE;
	 lv_touchless_val :=lv_cur_format.TOUCHLESS;
	 lv_send_final_report_val :=lv_cur_format.send_final_report;
	 
	 
	 
	 IF upper(lv_cur_format.allow_batch_export)= 'YES'
	 THEN
		 Lv_allow_batch_export := 1;
	 ELSE 
		 Lv_allow_batch_export := 0;
	 END IF;
	 
	 
	  IF upper(lv_cur_format.SINGLE_EMAIL)= 'YES'
	 THEN
		 Lv_allow_email_batch_export := 1;
	 ELSE 
		 Lv_allow_email_batch_export := 0;
	 END IF;
	
	 
      --  RAISE NOTICE 'L5.%  FORMAT_CONTACT_NAME : %','Format is not Available for :- '||lv_format_type,Lv_cur_con.distribution_contact_name;
	  --To Fetch the code for Format
	 Begin
	    SELECT CC.CODE INTO lv_format_type_code
		FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		AND CD.LANGUAGE_CODE = 'en'
		AND CN.CODELIST_ID = 9601
		AND CC.CODE_STATUS='1'
		AND TRIM(UPPER(CD.DECODE))=TRIM(UPPER(lv_format_type));
		
		--If code for format is not found
		If lv_format_type_code is null then 
		RAISE NOTICE '5.%  FORMAT_CONTACT_NAME : %','Format is not Available for :- '||lv_format_type,Lv_cur_con.distribution_contact_name;
		END IF;
	 END;
	 
	 --To Fetch the code for report medium
	 Begin
	    SELECT CC.CODE INTO lv_rep_med_code
		FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		AND CD.LANGUAGE_CODE = 'en'
		AND CN.CODELIST_ID = 9602
		AND CC.CODE_STATUS='1'
		AND TRIM(UPPER(CD.DECODE))=TRIM(UPPER(lv_rep_med));
		
		--If code for report medium is not found
		If lv_rep_med_code is null then 
		RAISE NOTICE '6.%','Report Medium is not Available for :- '||lv_rep_med;
		END IF;
	 END;
	 
	 --To Fetch the code for e2b message type
	 
	 Begin
	    IF TRIM(UPPER(lv_format_type))='E2B' THEN
		lv_message_type_code :=DR_DECODE_CODE(lv_message_type,9971);
		/*SELECT CC.CODE INTO lv_message_type_code
		FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		AND CD.LANGUAGE_CODE = 'en'
		AND CN.CODELIST_ID = 9971
		AND CC.CODE_STATUS='1'
		AND UPPER(CD.DECODE)=UPPER(lv_message_type);
		RAISE NOTICE '71.%',lv_message_type_code;*/
		--If code for e2b message type is not found
		If lv_message_type_code IS NULL OR lv_message_type_code = '' then 
		RAISE NOTICE '7.%','Value for E2B Message Type is not Available for contact '||lv_dis_con;
		END IF;
	    END IF;	
	 END;
	 
	-- To Fetch DTD Type
	BEGIN
	IF UPPER(lv_format_type)='E2B' THEN
	IF UPPER(lv_xml_doc_type)='E2B R3 STANDARD' THEN
		lv_dtd_val :='ICHICSR_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='E2B R2 STANDARD' THEN
		lv_dtd_val :='ICHICSR';
		lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='E2B R2 2.2' THEN
		lv_dtd_val :='ICHICSR2.2';
		lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='E2B R2 IND 2.1' THEN
		lv_dtd_val :='ICHICSR_2.1_IND';
		lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='E2B R2 IND 2.2' THEN
		lv_dtd_val :='ICHICSR_2.2_IND';
		lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='E2B R3' THEN
		lv_dtd_val :='ICHICSR_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='EMA R3' THEN
		lv_dtd_val :='EMA_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='PMDA R3' THEN
		lv_dtd_val :='PMDA_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='MFDS R3' THEN
		lv_dtd_val :='MFDS_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='FDA R3' THEN
		lv_dtd_val :='FDA_R3';
		lv_dtd_schema :=2;
	ELSIF UPPER(lv_xml_doc_type)='EMA R2' THEN
		lv_dtd_val :='EMA_R2';
		lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='BMS_ICHICSR_INFINITY' THEN
		lv_dtd_val :='ICHICSR_INFINITY';
		lv_dtd_schema :=1;
    ELSIF UPPER(lv_xml_doc_type)='NMPA_R3' THEN
        lv_dtd_val :='NMPA_R3';
        lv_dtd_schema :=2;        
    ELSIF UPPER(lv_xml_doc_type)='PMDA R3' THEN
        lv_dtd_val :='PMDA_R3';
        lv_dtd_schema :=2;		
	ELSIF UPPER(lv_xml_doc_type)='PMDA_DEVICE' THEN	
	    lv_dtd_val :='PMDA_DEVICE';
        lv_dtd_schema :=1;	
	ELSIF UPPER(lv_xml_doc_type)='PMDA_REGENERATIVE' THEN	
	    lv_dtd_val :='PMDA_REGENERATIVE';
        lv_dtd_schema :=1;	
	ELSIF UPPER(lv_xml_doc_type)='OTHER' THEN	
	    lv_dtd_val :='OTHER';
        lv_dtd_schema :=1;	
	ELSIF UPPER(lv_xml_doc_type)='LSSRM' THEN	
	    lv_dtd_val :='LSSRM';
        lv_dtd_schema :=1;
	ELSIF UPPER(lv_xml_doc_type)='MIR' THEN	
	    lv_dtd_val :='MIR';
        lv_dtd_schema :=1;	
	ELSE
	  lv_dtd_val :=null;
	  lv_dtd_schema :=null;
	END IF;
	END IF;
	Exception 
	WHEN OTHERS THEN 
	RAISE NOTICE '8.%','Problem in DTD Type';
	END;
	

	 
	 --Value for r3 data in r2 
	Begin
	If upper(lv_r2_r3_chk_val)='YES' then
    lv_r2_r3_chk :=1;
    ELSE	
	lv_r2_r3_chk :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '9.%','Problem for r3 data in r2';
	END; 
	
	
	
	 --Value for lit doc in submission
	Begin
	If upper(lv_lit_doc_val)='YES' then
    lv_lit_doc :=1;
    ELSE	
	lv_lit_doc :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '10.%','Problem in Lic Doc Submission';
	END;
	
	-- To fetch Distribution Contact Record Id
	BEGIN
	SELECT RECORD_ID into lv_dis_con_rec_id
	FROM lsmv_distribution_unit 
	WHERE TRIM(UPPER(DISTRIBUTION_UNIT_NAME))=TRIM(UPPER(lv_dis_con));
	--When Distribution Contact Record Id is not found 
		If lv_dis_con_rec_id is null then 
		RAISE NOTICE '11.%','Distribution Contact is not Available;'||lv_dis_con;
		END IF;
	END;
	
	--To fetch FK for Sender Contact
	
	BEGIN
	SELECT record_id into lv_sender_rec_id
    FROM LSMV_PERSON 
    WHERE UPPER(person_id) = UPPER(TRIM(lv_sender));
	--When Sender Record Id is not availbale
	If lv_sender_rec_id is null then 
		SELECT record_id into lv_sender_rec_id
		FROM LSMV_PERSON 
		WHERE upper(person_id) = UPPER(TRIM('DR_LEGACY_CU_CONT')); 
		RAISE NOTICE '12.%','Sender Contact is not Available for '||lv_cur_format.distribution_contact_name ;
		END IF;
	END;
	
	--To fetch FK for Receiver Contact
	
	BEGIN
	SELECT record_id into lv_receiver_rec_id
    FROM LSMV_PERSON 
    WHERE UPPER(PERSON_ID)=UPPER(TRIM(lv_receiver));
	
	--When Receiver Record Id is not availbale
		If lv_receiver_rec_id is null 
		then
			SELECT record_id into lv_receiver_rec_id
			FROM LSMV_PERSON 
			WHERE UPPER(PERSON_ID)=UPPER(TRIM(lv_receiver));
	
			IF lv_receiver_rec_id is null and lv_format_type='E2B'
			then
				SELECT record_id into lv_receiver_rec_id
				FROM LSMV_PERSON 
				WHERE UPPER(person_id)= 'DR_LEGACY_ACC_CONT'; 
				RAISE NOTICE '13.%','Receiver Contact is not Available for '||lv_cur_format.distribution_contact_name;
			ELSE 
             lv_receiver_rec_id :=null;			
			END IF;
		END IF;
	END;
	 
	-- To fetch medium_details
	BEGIN
	
	If upper(lv_rep_med)='EMAIL' 
	THEN
		lv_med_dtl := Lv_MEDIUM_DETAILS;
		--Added by Swathi
		If Lv_CC_EMAIL_ADDRESS is null OR Lv_CC_EMAIL_ADDRESS = '' then
		lv_cc_email := '';
		ELSE
		lv_cc_email := Lv_CC_EMAIL_ADDRESS;
		END IF;
	
	-- removed, only considering excel emails
	/*IF lv_med_dtl IS NULL 
	THEN 
	SELECT email_id into lv_med_dtl
    FROM LSMV_PERSON 
    WHERE record_id = lv_receiver_rec_id;
	  end if;*/
	
		--When Receiver Email Id is not availbale
		If lv_med_dtl is null OR lv_med_dtl = '' then 
		lv_med_dtl := 'dummy@arisglobal.com';
		--RAISE NOTICE '14.%','Receiver Email is not Available';
		END IF;
	END IF;
	EXCEPTION WHEN OTHERS THEN   
	RAISE NOTICE '15.%','Problem in Receiver Email Detail';
	END;
	
	--To Fetch Sender Contact Company Unit Recordid and Comapny Unit Partner Id
	BEGIN
	SELECT fk_partner_record_id,parent_name
    into lv_sender_cu_rec_id,lv_sender_cu_par_id	
	FROM LSMV_ACCOUNTS_CONTACTS 
	WHERE contact_record_id=(lv_sender_rec_id)
	and fk_partner_record_id is not null;
	
	IF lv_sender_cu_rec_id is null THEN
    RAISE NOTICE '16.%','Sender Contact Company Unit Record Id is not Available'||Lv_cur_con.distribution_contact_name;	
	END IF;
	
	IF lv_sender_cu_par_id is null THEN
    RAISE NOTICE '17.%','Sender Contact Company Unit Partner Id is not Available'||Lv_cur_con.distribution_contact_name;	
	END IF;
	
	EXCEPTION WHEN OTHERS THEN   
	RAISE NOTICE '18.%','Problem in Sender Contact Company Unit Details';
	--SQLCODE||' '||SQLERRM||' '||
	--raise notice '% %', SQLCODE, SQLERRM;
	END;
	
	
	
	
	--Value for Blinded Report Checkbox 
	Begin
	If upper(lv_blinded_val)='YES' then
    lv_blinded_code :=1;
    ELSE	
	lv_blinded_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '19.%','Problem in Lic Doc Submission';
	END;
	
	---- To Fetch Submission Workflow RECORD_ID	  
	  Begin
	    SELECT RECORD_ID INTO lv_workflow_rec_id
		FROM LSMV_WORKFLOW 
		WHERE UPPER(TRIM(WF_NAME)) = UPPER(TRIM(lv_workflow_nm));		
		--If Submission Workflow RECORD_ID not found
		If lv_workflow_rec_id is null then 
		RAISE NOTICE '20.%  NAME :%','Submission Workflow is not Available',lv_workflow_nm;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	    RAISE NOTICE '21.%','Problem in Submission Workflow';
	  END;
		
    --To Fetch the code for olt configuration
	Begin
	If UPPER(REPLACE(TRIM(lv_olt_val),' ',''))='SEND' then
    lv_olt_code :=2;
    ELSIF UPPER(REPLACE(TRIM(lv_olt_val),' ','')) = 'SENDIFCASEISSIGNIFICANT'	 THEN 
	lv_olt_code :=3;
	LV_olt_significance_code :=4;
	ELSIF UPPER(REPLACE(TRIM(lv_olt_val),' ','')) = 'SENDIFSIGNIFICANT(REPORTABLE)' THEN 
	lv_olt_code :=3;
	LV_olt_significance_code :=4;
	ELSIF UPPER(REPLACE(TRIM(lv_olt_val),' ',''))='DONOTSEND' then
    lv_olt_code :=1;				--Do Not Send

	--RAISE NOTICE '22.%','Problem in OLT : ' ||lv_olt_val;
	/* ELSIF UPPER(REPLACE(TRIM(lv_olt_val),' ','')) IS NULL then
	lv_olt_code :=''; */
	ELSE 
	lv_olt_code :=2;
	END IF;
	
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '22.%','Problem in OLT';
	END;
	
	--Value for Autoredistribute Checkbox 
	Begin
	If upper(lv_auto_chk_val)='YES' then
    lv_auto_chk_code :=1;
    ELSE	
	lv_auto_chk_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '23.%','Problem in Autoredistribute';
	END;
	
	
	--Value for Touchless Checkbox 
	Begin
	If upper(lv_touchless_val)='YES' then
    lv_touchless_code :=1;
    ELSE	
	lv_touchless_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '25.%','Problem in Touchless';
	END;
	
	 --Value for Send Final Report
	Begin
	If upper(lv_send_final_report_val)='YES' then
    lv_send_final_report :=1;
    ELSE	
	lv_send_final_report :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '26.%','Problem for r3 data in r2';
	END; 
	  
	-- Lv_OLT_Significance
/* 		
	If upper(Lv_OLT_Significance) IS NOT NULL AND upper(Lv_OLT_Significance) <> ''
	then
       BEGIN
		SELECT STRING_AGG(CC.CODE,',') INTO Lv_OLT_Significance_code
		FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
		WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
		AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
		AND CD.LANGUAGE_CODE = 'en'
		AND CN.CODELIST_ID = 9605
		AND CC.CODE_STATUS='1'
		AND TRIM(UPPER(CD.DECODE))IN ( SELECT  regexp_split_to_table( UPPER(Lv_OLT_Significance),'\,') FROM DUAL);
              IF Lv_OLT_Significance_code IS NULL
              THEN
                  RAISE NOTICE '27.%', 'Error found at OLT Significance';
              END IF;		

	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '27.%', 'Error found at OLT Significance';
	END; 
	END IF; */
	
	-- Drop OLT 
/* 		BEGIN 
		IF upper(lv_cur_format.drop_olt)='YES' THEN
		lv_drop_olt:=1;
		ELSE
		lv_drop_olt:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '28.%','Problem in drop_olt Column lsmv_distribution_format';
	    END; 	
	 */
	-- export term_iD
	
	Begin
		If upper(Lv_export_term_id) IS NOT NULL AND upper(Lv_export_term_id) <> ''
		then
		    IF upper(Lv_export_term_id) = 'EDQM' then
			Lv_export_term_id_CODE = 'EDQM';
			ELSIF upper(Lv_export_term_id) = 'E2B R3' then
			Lv_export_term_id_CODE = 'E2B R3';
			ELSIF upper(Lv_export_term_id) = upper('Do Not Send') then
			Lv_export_term_id_CODE = 'Do Not Send';
			ELSIF upper(Lv_export_term_id) = upper('SPL/FDA Codes') then
			Lv_export_term_id_CODE = 'SPL/FDA Codes';
			
			END IF;
			
              IF Lv_export_term_id_CODE IS NULL
              THEN
                  RAISE NOTICE '28.%', 'Error found at export term id';
              END IF;	
			  
		END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '28.%','Error found at export term id';
	END; 	  
	
	
	
	--Allow_edit_of_Native_Language_in_LDE
		
	Begin
	If upper(lv_cur_format.Allow_edit_of_Native_Language_in_LDE)='YES' then
    lv_allow_edit_native_lan :=1;
    ELSE	
	lv_allow_edit_native_lan :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '26.%','Allow_edit_of_Native_Language_in_LDE';
	END; 
	
	--Include_All_Labeling_Records
	Begin
	If upper(lv_cur_format.Include_All_Labeling_Records)='YES' then
    lv_include_all_lab_rec :=1;
    ELSE	
	lv_include_all_lab_rec :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '26.%','Include_All_Labeling_Records';
	END; 
	
	--- MIR_XML_Schema
	Begin
	If upper(lv_cur_format.MIR_XML_Schema)='MIR 7.2.1 GB SCHEMA' then
    lv_mir_xml_schema := '2';
    ELSIF upper(lv_cur_format.MIR_XML_Schema)='MIR 7.3.1 SCHEMA' then
	lv_mir_xml_schema := '1';
	ELSE 
	lv_mir_xml_schema := '';
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '26.%','MIR_XML_Schema';
	END;
	
	 -- Insert or Update for Format Level Data
     If lv_count=0 then 
	 --Insert 
	  INSERT INTO lsmv_distribution_format(record_id, display_name, format_type, medium, 
	                                       medium_details,
	                                       description, include_date_of_report, dtd_type, xml_config_name, include_r3_data_in_r2,
										   fk_follow_up_no_rule, sbt_if_pre_ver_is_distributed, inc_lit_doc_in_submission, route_via_submission_module, active,
	                                       local_data_entry_req, fk_distribution_unit, user_created, date_created, user_modified,
										   date_modified, reporter_cmt_nrt_lang, dtd_schema, fk_pivot_rule, param_map,
	                                       import_comments, archived, fk_receiver_contact, fk_sender_contact, sender_contact_cu_rec_id,
										   sender_contact_cu_partner_name, data_privacy_param_map, privacy, blinded_report, fk_cover_letter_template,
										   fk_fax_template, fk_email_template, fk_submission_workflow, fk_submission_wf_name, version,
										   send_olt, auto_redistribute, exclude_pivot_rule, trusted_partner,send_final_report,
										   cc_email_id, fk_data_privacy_rule, data_privacy_rule_name, message_type, expedited_timeline,
										   allow_batch_export,allow_email_batch_export,generate_xml,
										  olt_significance,--drop_olt, 
										  export_term_id
										  ,INCLUDE_WHODD_MPID,EDIT_WHODD_MPID,EDIT_AUTHORITY_OR_COMPANY_NO,EDIT_SAFETY_REPORT_ID,ENABLE_AUTO_MULTIREPORTING,
										  icsr_rule_id,icsr_rule_name,
										  allow_edit_of_native_language_in_lde,
										  include_all_labeling,
										  mir_xml
										  ) 
                                           VALUES(nextval('seq_record_id'), lv_for_disp_nm, lv_format_type_code, lv_rep_med_code, 
										   lv_med_dtl, 
	                                              lv_format_desc, 0, lv_dtd_val, lv_xml_doc_type, lv_r2_r3_chk,
					                              null, 0, lv_lit_doc, 0, lv_format_active,
					                              0, lv_dis_con_rec_id, 'AMGEN_DR', CURRENT_TIMESTAMP, null,
					                              null, null, lv_dtd_schema, null, null,
					                              null, 0, lv_receiver_rec_id, lv_sender_rec_id, lv_sender_cu_rec_id,
					                              lv_sender_cu_par_id, null, lv_data_privacy, lv_blinded_code, lv_CP_temp_rec_id,
					                              NULL, lv_email_temp_rec_id, lv_workflow_rec_id, lv_workflow_nm, 1,
					                              lv_olt_code,lv_auto_chk_code, NULL,lv_touchless_code,lv_send_final_report,	                              
												  lv_cc_email, --Swathi: Removed null and added cc email value
												  null,null,lv_message_type_code,lv_exp_timeline,Lv_allow_batch_export,Lv_allow_email_batch_export,lv_generate_xml,
												  Lv_OLT_Significance_code,-- lv_drop_olt,
												  Lv_export_term_id_code,
												  lv_include_whodd_code,lv_edit_whodd_code,lv_edit_authority_code,lv_edit_safety_report_code,lv_enable_auto_multi_reporting_code,
												  Lv_icsr_modification_rule_code,Lv_icsr_modification_rule,
												  lv_allow_edit_native_lan,
												  lv_include_all_lab_rec,lv_mir_xml_schema
												  
					                              );
												  
	ELSIF lv_count=1 then
	 --Update
	 UPDATE lsmv_distribution_format 
	 set format_type=lv_format_type_code,medium=lv_rep_med_code,
	 medium_details=lv_med_dtl,
	 cc_email_id = lv_cc_email, --Added by Swathi
	 active=lv_format_active,privacy=lv_data_privacy,
	 description=lv_format_desc,dtd_type=lv_dtd_val,xml_config_name=lv_xml_doc_type,include_r3_data_in_r2=lv_r2_r3_chk,
	 inc_lit_doc_in_submission=lv_lit_doc,dtd_schema=lv_dtd_schema,expedited_timeline=lv_exp_timeline,
	 fk_receiver_contact=lv_receiver_rec_id,fk_sender_contact=lv_sender_rec_id,sender_contact_cu_rec_id=lv_sender_cu_rec_id,
	 sender_contact_cu_partner_name=lv_sender_cu_par_id,blinded_report=lv_blinded_code,fk_submission_workflow=lv_workflow_rec_id,send_final_report=lv_send_final_report,
	 fk_submission_wf_name=lv_workflow_nm,send_olt=lv_olt_code,auto_redistribute=lv_auto_chk_code,trusted_partner=lv_touchless_code,message_type=lv_message_type_code ,
	 user_modified='AMGEN_DR',fk_email_template=lv_email_temp_rec_id, fk_cover_letter_template = lv_CP_temp_rec_id,
	 date_modified = CURRENT_TIMESTAMP,allow_batch_export=Lv_allow_batch_export,allow_email_batch_export=Lv_allow_email_batch_export,
	 generate_xml=lv_generate_xml,
	olt_significance = Lv_OLT_Significance_code,
	 --drop_olt = lv_drop_olt,
	 export_term_id = Lv_export_term_id_code,
	 INCLUDE_WHODD_MPID=lv_include_whodd_code,EDIT_WHODD_MPID=lv_edit_whodd_code,EDIT_AUTHORITY_OR_COMPANY_NO=lv_edit_authority_code
	 ,EDIT_SAFETY_REPORT_ID=lv_edit_safety_report_code,ENABLE_AUTO_MULTIREPORTING=lv_enable_auto_multi_reporting_code,
	 icsr_rule_id = Lv_icsr_modification_rule_code,icsr_rule_name = Lv_icsr_modification_rule,
	 allow_edit_of_native_language_in_lde = lv_allow_edit_native_lan,
	 include_all_labeling = lv_include_all_lab_rec,
	 mir_xml = lv_mir_xml_schema
	 where record_id=lv_dis_format_rec_id; 
	END IF; 
--rollback;	
	 
   ----- Update all the varibales used in the condition needs to set as null
			lv_format_type_code :=null;
			lv_rep_med_code :=null;
			lv_message_type_code :=null;
			lv_dtd_val :=null;
			lv_r2_r3_chk_val :=null;
			lv_lit_doc_val :=null;
			lv_dis_con_rec_id :=null;
			lv_sender_rec_id :=null;
			lv_receiver_rec_id :=null;
			lv_med_dtl :=null;
			lv_cc_email:=null;
			lv_sender_cu_rec_id :=null;
			lv_sender_cu_par_id :=null;
			lv_blinded_val :=null;
			lv_workflow_rec_id :=null;
			lv_olt_val :=null;
			lv_olt_code :=null;
			lv_auto_chk_val :=null;
			lv_touchless_code :=0;
			lv_touchless_val :=null;
			lv_count :=null;
			lv_email_template:='';
            lv_email_temp_rec_id:=null;
			lv_CP_temp_rec_id := NULL;
			lv_format_active := 0;
			lv_data_privacy := 0;
			lv_exp_timeline :=null;
			lv_send_final_report :=0;
			Lv_allow_batch_export:=0;
			Lv_allow_email_batch_export:=0;
			lv_generate_xml:=null;
			Lv_OLT_Significance_code:=null;
			Lv_export_term_id_code:=null;
			lv_enable_auto_multi_reporting_code:=0;
			lv_edit_safety_report_code:=0;
			lv_include_whodd_code:=0;
			lv_edit_whodd_code :=0;
			lv_edit_authority_code:=0;
			lv_allow_edit_native_lan:=0;
			lv_include_all_lab_rec := 0;
			lv_mir_xml_schema := 0;
	---Format Level Loop 
     END LOOP;
	---Contact Level Loop 
	END LOOP; 
    

EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE NOTICE 'EXCEPTION :%', 'NO DATA FOUND';
WHEN others THEN
GET STACKED DIAGNOSTICS lv_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION :%', lv_context;
END $$;
