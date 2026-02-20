----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Niroj Kumar Panigrahi                                            	          --
-- FILENAME             : DR_DUMMY_CON_CU_ACC.SQL 			    				              --
-- PURPOSE              : This Script is to update the Temporary table with attribute code valus from Excel    --
-- DATE CREATED         : 12-JAN-2020                          						              --
-- REVIEWD BY           : DEBASIS DAS                                                                         --
-- ********************************************************************************************** --

Do $$
DECLARE
l_context TEXT;
Lv_sender INTEGER;
Lv_receivr INTEGER;
Lv_account INTEGER;
Lv_CU INTEGER;
Lv_acc_rec INTEGER;
Lv_cu_send INTEGER;
BEGIN
	 ---------------------------------------------- DR_DUMMY_RECEIVER
	 SELECT COUNT(1) INTO Lv_receivr
	 FROM LSMV_PERSON 
	 WHERE first_name = 'DR_DUMMY_RECEIVER'; 
	 
	 IF Lv_receivr = 0 
	 THEN 
		 Insert into LSMV_PERSON (record_id,person_id,first_name,middle_name,last_name,title,address,city,state,country,zip_code,active,phone_no_office,phone_no_office_extn_no,phone_no_residence_no,fax_no,sex,email_id,specialization,hospital_name,is_health_professional,pref_comm_medium,date_modified,user_modified,comm_medium_others,person_type,fk_acu_rec_id,version,external_app_rec_id,external_app_updated_date,app_id,app_rec_id,sir_flag,validity_from,validity_to,e2b_flag,phone_country_code,fax_country_code,fax_extension_number,degree,privacy_info,requester_category,medical_interest,ext_no,suffix,organization_name,consent,other,additional_field_txt_1,additional_field_txt_2,additional_field_txt_3,additional_field_txt_4,additional_field_txt_5,additional_field_txt_6,additional_field_txt_7,additional_field_txt_8,additional_field_txt_9,additional_field_txt_10,additional_field_number_1,additional_field_number_2,additional_field_number_3,additional_field_number_4,additional_field_number_5,additional_field_date_1,additional_field_date_2,additional_field_date_3,additional_field_date_4,additional_field_date_5,dept_record_id,all_account_assign,vet_department,all_company_unit,crm_record_id,crm_source_flag,crm_last_modified_date,crm_source,contact_ins_from_schedler,dept_name,emirf_account_id,do_not_contact,first_name_in_upper,last_name_in_upper,middle_name_in_upper,sso_token_id,is_audit_required,designation,correspondence_seq,correspondence_flag,read_unread_correspondence,notes_flag,is_exported,lastuseddate,reducted,dataprivacy_present,email_id_in_upper,organization_name_in_upper,dept_name_in_upper,other_in_upper,requester_category_vet,requester_type,public_contact,task_flag,company_unit_rec_id,sales_territory_id,territory_rec_id,organization_id,primary_postal_code,postal_code,consent_share,is_inquiry_contact,person_primary_id,contact_source,request_id,mobile_number,organization,account_id,account_name,consent_collect,user_created,date_created,is_e2b_contact,interchange_id,date_informed_receiver,archive_based_on_date,icsr_ack,is_distribution,reporter_type,profession,fax_office_extn_no,doc_name_kanji,doc_name_kana,is_mdn_req) 
		 values (NEXTVAL('SEQ_RECORD_ID'),'DR_RCV','DR_DUMMY_RECEIVER',NULL,NULL,null,null,null,null,null,null,1,NULL,null,null,null,null,'dummy@arisglobal.com',null,null,null,'001',CURRENT_DATE,'AMGEN_DR',null,null,null,null,null,null,null,null,null,null,null,0,null,NULL,null,null,null,null,null,null,null,null,0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,null,1,null,0,null,null,0,null,'DR_RCV',0,'DR_DUMMY_RECEIVER',NULL,NULL,null,null,null,0,0,0,0,0,null,0,0,'dummy@arisglobal.com',null,null,null,null,null,0,0,null,null,null,null,null,null,0,0,null,null,null,null,null,null,null,null,null,null,0,null,null,0,1,1,null,null,null,null,null,1);
	 ELSIF Lv_receivr > 1
	 THEN
		 DELETE FROM LSMV_PERSON WHERE  first_name = 'DR_DUMMY_RECEIVER' AND RECORD_ID NOT IN (SELECT fk_aec_rec_id from LSMV_ACCOUNTS);
		 RAISE NOTICE 'EXP: %',' Duplicate contacts names are present: DR_DUMMY_RECEIVER';
	 END IF;
	 
	 ---------------------------------------------- DR_DUMMY_SENDER
	 SELECT COUNT(1) INTO Lv_sender
	 FROM LSMV_PERSON 
	 WHERE first_name = 'DR_DUMMY_SENDER'; 
	 
	 IF Lv_sender = 0 
	 THEN 
		 Insert into LSMV_PERSON (record_id,person_id,first_name,middle_name,last_name,title,address,city,state,country,zip_code,active,phone_no_office,phone_no_office_extn_no,phone_no_residence_no,fax_no,sex,email_id,specialization,hospital_name,is_health_professional,pref_comm_medium,date_modified,user_modified,comm_medium_others,person_type,fk_acu_rec_id,version,external_app_rec_id,external_app_updated_date,app_id,app_rec_id,sir_flag,validity_from,validity_to,e2b_flag,phone_country_code,fax_country_code,fax_extension_number,degree,privacy_info,requester_category,medical_interest,ext_no,suffix,organization_name,consent,other,additional_field_txt_1,additional_field_txt_2,additional_field_txt_3,additional_field_txt_4,additional_field_txt_5,additional_field_txt_6,additional_field_txt_7,additional_field_txt_8,additional_field_txt_9,additional_field_txt_10,additional_field_number_1,additional_field_number_2,additional_field_number_3,additional_field_number_4,additional_field_number_5,additional_field_date_1,additional_field_date_2,additional_field_date_3,additional_field_date_4,additional_field_date_5,dept_record_id,all_account_assign,vet_department,all_company_unit,crm_record_id,crm_source_flag,crm_last_modified_date,crm_source,contact_ins_from_schedler,dept_name,emirf_account_id,do_not_contact,first_name_in_upper,last_name_in_upper,middle_name_in_upper,sso_token_id,is_audit_required,designation,correspondence_seq,correspondence_flag,read_unread_correspondence,notes_flag,is_exported,lastuseddate,reducted,dataprivacy_present,email_id_in_upper,organization_name_in_upper,dept_name_in_upper,other_in_upper,requester_category_vet,requester_type,public_contact,task_flag,company_unit_rec_id,sales_territory_id,territory_rec_id,organization_id,primary_postal_code,postal_code,consent_share,is_inquiry_contact,person_primary_id,contact_source,request_id,mobile_number,organization,account_id,account_name,consent_collect,user_created,date_created,is_e2b_contact,interchange_id,date_informed_receiver,archive_based_on_date,icsr_ack,is_distribution,reporter_type,profession,fax_office_extn_no,doc_name_kanji,doc_name_kana,is_mdn_req) 
		 values (NEXTVAL('SEQ_RECORD_ID'),'DR_SEN','DR_DUMMY_SENDER',NULL,NULL,null,null,null,null,null,null,1,NULL,null,null,null,null,'dummy@arisglobal.com',null,null,null,'001',CURRENT_DATE,'AMGEN_DR',null,null,null,null,null,null,null,null,null,null,null,0,null,NULL,null,null,null,null,null,null,null,null,0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,null,1,null,0,null,null,0,null,'DR_SEN',0,'DR_DUMMY_SENDER',NULL,NULL,null,null,null,0,0,0,0,0,null,0,0,'dummy@arisglobal.com',null,null,null,null,null,0,0,null,null,null,null,null,null,0,0,null,null,null,null,null,null,null,null,null,null,0,null,null,0,1,1,null,null,null,null,null,1);
	 ELSIF Lv_sender > 1
	 THEN
		 DELETE FROM LSMV_PERSON WHERE  first_name = 'DR_DUMMY_SENDER' AND RECORD_ID NOT IN (SELECT fk_cec_rec_id from LSMV_PARTNER);
		 RAISE NOTICE 'EXP: %',' Duplicate contact names are present: DR_DUMMY_SENDER';
	 END IF;
	 
	 ---------------------------------------------- DR_DUMMY_ACCOUNT
	 SELECT COUNT(1) INTO Lv_account
	 FROM LSMV_ACCOUNTS 
	 WHERE account_name = 'DR_DUMMY_ACCOUNT'; 
	 
	 IF Lv_account = 0 
	 THEN
		 SELECT COUNT(1) INTO Lv_acc_rec  
		 FROM LSMV_PERSON 
		 WHERE FIRST_NAME = 'DR_DUMMY_RECEIVER';
		 
		 IF Lv_acc_rec = 1 
		 THEN 
			 Insert into LSMV_ACCOUNTS (record_id,account_name,account_manager,email,phone_no,website,fax,industry,description,address,phone_area_code,phone_country_code,fax_country_code,fax_area_code,time_zone,account_id,product_class_type,all_product_class_assign,all_product_assign,all_company_unit,date_modified,user_modified,domain,assign_to,assigned_to,account_type,is_e2b_account,receiver_id,report_type,country,postal_code,city,state,reporting_medium,cover_letter_tmpl_id,fax_inbound_directory,fax_domain,crm_record_id,crm_source,crm_source_flag,crm_last_modified_date,acc_ins_from_schedler,fk_aec_rec_id,correspondence_seq,correspondence_flag,read_unread_correspondence,notes_flag,keyword,task_flag,e2b_encoding_format,distribution_setting,all_product_distr_assign,vet_report_type,firm_name,firm_address,firm_city,firm_state,firm_postalcode,firm_country,fei_no,duns_no,parent_firm_name,parent_firm_address,parent_firm_city,parent_firm_state,parent_firm_postalcode,parent_firm_country,parent_fei_no,firm_function,account_group_name,account_group_rec_id,account_active,reason_for_deactive,qc_sampling_count,qc_sampling_running_count,create_date,dup_acc,is_distribution_contact,user_created,date_created,exclusion_account,exclusion_partner,mask_id,health_authority,ack_comments_length,e2b_meddra,sender_organization_type,compression,ird_lrd,migration_flag,language,region_code,region,status_date,company_status,casuality_results,eudamed_number,single_reg_num,po_box) 
			 values (NEXTVAL('SEQ_RECORD_ID'),'DR_DUMMY_ACCOUNT',null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'DR_ACC','P',0,1,1,CURRENT_DATE,'AMGEN_DR',NULL,'G','0','05','1',null,null,'AF',NULL,NULL,NULL,null,null,NULL,NULL,null,null,0,null,0,NEXTVAL('SEQ_RECORD_ID'),0,0,0,0,null,0,NULL,NULL,null,null,NULL,null,NULL,NULL,NULL,'0',NULL,null,NULL,null,NULL,NULL,NULL,'0',NULL,null,null,null,1,null,null,null,CURRENT_DATE,0,'1','AMGEN_DR',CURRENT_DATE,null,null,null,'',NULL,NULL,'1',NULL,'1',null,'en',NULL,NULL,null,NULL,NULL,NULL,NULL,NULL);
			 
			 INSERT INTO lsmv_acc_e2b_contact  (record_id,user_modified,date_modified,user_created,date_created)
			 VALUES((SELECT fk_aec_rec_id FROM lsmv_accounts WHERE ACCOUNT_NAME = 'DR_DUMMY_ACCOUNT'),NULL,NULL,'AMGEN_DR',CURRENT_DATE);


			 INSERT INTO LSMV_ACCOUNTS_CONTACTS (RECORD_ID,FK_PARTNER_RECORD_ID, FK_ACCOUNT_RECORD_ID, PARENT_NAME, CONTACT_RECORD_ID, USER_CREATED, USER_MODIFIED, DATE_CREATED, DATE_MODIFIED, IS_PRIMARY_CONTACT, INTERCHANGE_ID, IS_E2B_CONTACT, CONTACT_DISTRIBUTE      )
			 VALUES (NEXTVAL('SEQ_RECORD_ID'),NULL,(SELECT RECORD_ID FROM LSMV_ACCOUNTS WHERE ACCOUNT_NAME = 'DR_DUMMY_ACCOUNT' ),'DR_SEN', (SELECT RECORD_ID FROM LSMV_PERSON WHERE first_name = 'DR_DUMMY_RECEIVER' ),'AMGEN_DR', 'AMGEN_DR',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '1', 'DR_INTERCHANGE_ID', '1', '1');
			 
		 
		 ELSIF Lv_acc_rec > 1 
		 THEN
			 RAISE NOTICE 'EXP: %',' Duplicate contact names are present: DR_DUMMY_RECEIVER';
		 ELSE
			 RAISE NOTICE 'EXP: %',' Contact not present: DR_DUMMY_RECEIVER';
		 END IF;
		 
	 ELSIF Lv_account > 1
	 THEN
		 DELETE FROM LSMV_ACCOUNTS 
		 WHERE RECORD_ID IN ( SELECT RECORD_ID FROM LSMV_ACCOUNTS 
							  WHERE  account_name = 'DR_DUMMY_ACCOUNT' 
							  AND RECORD_ID NOT IN (SELECT fk_account from LSMV_DISTRIBUTION_UNIT 
													WHERE fk_account IN (SELECT RECORD_ID FROM LSMV_ACCOUNTS 
																		 WHERE  account_name = 'DR_DUMMY_ACCOUNT')));
		 RAISE NOTICE 'EXP: %',' Duplicate account names are present: DR_DUMMY_ACCOUNT';
	 END IF;
	 
	 
	 ---------------------------------------------- DR_DUMMY_CU
	 SELECT COUNT(1) INTO Lv_CU
	 FROM LSMV_PARTNER 
	 WHERE name = 'DR_DUMMY_CU'; 
	 
	 IF Lv_CU = 0 
	 THEN
		 SELECT COUNT(1) INTO Lv_cu_send  
		 FROM LSMV_PERSON 
		 WHERE FIRST_NAME = 'DR_DUMMY_SENDER';
		 
		 IF Lv_cu_send = 1 
		 THEN 
			 Insert into LSMV_PARTNER (record_id,partner_id,name,type,partner_mode,authority,country,fk_aper_rec_id,user_modified,date_modified,fk_inb_wf_rec_id,fk_oub_wf_rec_id,version,data_entry_site_code,external_app_contact_name,external_app_updated_date,external_app_rec_id,fk_air_rec_id,receiver_mail_id,document_backup_path,allow_lde_synch,sender_comments_access,narrative_comment_access,local_labelling_access,fda_attachment_access,priority_level_high,priority_level_medium,working_days,lrn_literal,atn_literal,rct_literal,ack_expected,allow_due_date_synch,irt_local_labeling_required,allow_e2b_classification,city,state,building_number,address,region,postal_brick,postal_code,acknowledgement,disclaimer,company_unit_header,company_unit_footer,opening_remarks,closing_remarks,default_for_anonymous,assignment_emial_format,acknowledgement_subject,company_unit_subject,cunit_med_rep_subject,cunit_sec_res_subject,sender_id,receiver_id,report_type,atn_date_format,lrn_date_format,irt_date_format,irt_num_separation_char,irt_seq_generator,fk_ae_wf_rec_id,default_for_anonymous_ae,lrn_num_separation_char,lrn_seq_generator,atn_num_separation_char,atn_seq_generator,e_mail_id,fax_number,fax_area_code,fax_country_code,week_working_days,account_for_weekend,account_for_holidays,due_date_adv,auto_complete_first_activity,all_product_assign,all_product_class_assign,product_class_type,supplement_field_rec_id,fk_cmp_wf_rec_id,is_e2b_partner,e2b_receiver,e2b_receiver_id,e2b_receiver_rec_id,e2b_import_path,e2b_export_path,e2b_import_backup_path,def_bcc_email_response,def_bcc_email_corresp,inquiry_prefix,inquiry_date_format,inquiry_num_separation_char,inquiry_id_from_cu,ack_sub_res,ack_responder,assi_emial_frmt_rspd,company_unit_subject_rspd,cunit_sec_res_subject_rspd,cunit_med_rep_subject_rspd,e2b_xml_import_path,e2b_xml_import_backup_path,e2b_xml_export_backup_path,e2b_ack_export_path,e2b_ack_export_backup_path,e2b_document_path,e2b_document_backup_path,e2b_document_ack_path,e2b_document_ack_backup_path,dtd_type,fk_cec_rec_id,e2b_encoding_format,inquiry_cu_sequence,inq_cu_seq_reset,inq_cu_inc_seq,phone_no,phone_area_code,phone_cntry_code,inquiry_template_id,inquiry_template_name,inquiry_cover_letter_id,inquiry_cover_letter_name,logo_attachment_rec_id,inquiry_form_id,inquiry_form_name,default_company_file_name,has_offline_access,fk_vet_wf_rec_id,qc_review_percentage,qc_review_days,qc_review_date,all_department_assign,default_language_code,is_sign_up,is_unregister_access,pharmacovigilance_contact_info,agrepo_language_code,export_route,agrepo_search_documents,allow_chat_access,terms_of_users,allow_chat_access_mi,cu_time_zone,cu_date_format,fk_fqc_rec_id,fk_st_wf_rec_id,company_unit_type,user_created,date_created,inv_due_days,pri_inv_due_days,is_distribution_contact,sender_organization,sender_organization_type,exclusion_account,exclusion_partner,mask_id,compounding_outsourcing,ack_comments_length,e2b_meddra,compression,time_zone,ird_lrd,irt_date_sequence,irt_country,irt_country_sequence,irt_report_type,irt_report_type_sequence,irt_padding,lrn_date_sequence,lrn_country,lrn_country_sequence,lrn_report_type,lrn_report_type_sequence,lrn_padding,migration_flag,eudamed_number,single_reg_num,po_box) 
			 values (NEXTVAL('SEQ_RECORD_ID'),'DR_DUMMY','DR_DUMMY_CU','2','1',null,'US',null,'AMGEN_DR',CURRENT_DATE,null,null,null,null,null,null,null,null,null,NULL,0,0,0,0,0,null,null,null,NULL,NULL,NULL,0,0,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,null,null,null,null,null,0,null,null,null,null,null,'DR_TEST',null,null,NULL,NULL,NULL,'-',NULL,null,0,'-',NULL,'-',NULL,NULL,NULL,NULL,NULL,'1,2,3,4,5',0,0,'F',0,1,0,'P',null,null,'0',null,null,null,null,null,null,null,null,NULL,'01','-','0',null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,NULL,NEXTVAL('SEQ_RECORD_ID'),null,NULL,'N','0',NULL,NULL,NULL,null,null,null,null,null,null,null,null,0,null,null,null,null,0,null,0,0,null,null,null,0,0,null,null,null,'4',null,null,'ALL','AMGEN_DR',CURRENT_DATE,null,null,'1','TEST','1',null,null,null,0,NULL,NULL,NULL,NULL,'1',null,null,null,null,null,NULL,NULL,'false',NULL,'false',NULL,NULL,null,NULL,NULL,NULL);
			 
			 INSERT INTO lsmv_cu_e2b_contact(record_id,user_modified,date_modified,user_created,date_created)
			 VALUES((SELECT fk_cec_rec_id FROM lsmv_partner WHERE PARTNER_ID = 'DR_DUMMY'),NULL,NULL,'AMGEN_DR',CURRENT_DATE);
			 
			 INSERT INTO LSMV_FOLLOWUP_QUEST_CONFIG (record_id,fk_p_rec_id,user_modified,date_modified,user_created,date_created)
			 VALUES (nextval('seq_record_id'),(SELECT RECORD_ID FROM lsmv_partner WHERE PARTNER_ID = 'DR_DUMMY'),NULL,NULL,'AMGEN_DR',CURRENT_DATE);
			 
			 INSERT INTO LSMV_ACCOUNTS_CONTACTS (RECORD_ID,FK_PARTNER_RECORD_ID, FK_ACCOUNT_RECORD_ID, PARENT_NAME, CONTACT_RECORD_ID, USER_CREATED, USER_MODIFIED, DATE_CREATED, DATE_MODIFIED, IS_PRIMARY_CONTACT, INTERCHANGE_ID, IS_E2B_CONTACT, CONTACT_DISTRIBUTE      )
			 VALUES (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_PARTNER WHERE partner_id = 'DR_DUMMY' ),NULL,'DR_SEN', (SELECT RECORD_ID FROM LSMV_PERSON WHERE first_name = 'DR_DUMMY_SENDER' ),'AMGEN_DR', 'AMGEN_DR',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '1', 'DR_INTERCHANGE_ID' , '1', '1');
			 
		 
		 ELSIF Lv_cu_send > 1 
		 THEN
			 RAISE NOTICE 'EXP: %',' Duplicate contact names are present: DR_DUMMY_SENDER';
		 ELSE
			 RAISE NOTICE 'EXP: %',' Contact not present: DR_DUMMY_SENDER';
		 END IF;
		 
	 ELSIF Lv_CU > 1
	 THEN
		 DELETE FROM LSMV_PARTNER WHERE  name = 'DR_DUMMY_CU' AND RECORD_ID NOT IN (SELECT fk_company_unit from LSMV_DISTRIBUTION_UNIT);
		 RAISE NOTICE 'EXP: %',' Duplicate CU names are present: DR_DUMMY_CU';
	 END IF;
	 
 
EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'ALERTS:%', l_context;
END $$;


update LSMV_ACCOUNTS_CONTACTS
set parent_name = 'DR_SEN',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where FK_ACCOUNT_RECORD_ID = (
SELECT RECORD_ID FROM LSMV_ACCOUNTS WHERE ACCOUNT_NAME = 'DR_DUMMY_ACCOUNT' );

update LSMV_ACCOUNTS_CONTACTS
set parent_name = 'DR_SEN',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where contact_record_id=(SELECT record_id     FROM LSMV_PERSON 
    WHERE UPPER(person_id) = UPPER(TRIM('DR_SEN')));
	
update LSMV_ACCOUNTS 
set COUNTRY = 'AF',health_authority = '',account_type = '05',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where ACCOUNT_NAME = 'DR_DUMMY_ACCOUNT';