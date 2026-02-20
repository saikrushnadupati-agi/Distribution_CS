----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sai Krushna Dupati /Navya Chandramouli                                              	          --
-- FILENAME             : 14_Additional_scripts.sql  			    				          --
-- PURPOSE              : Loading of additional script 									   	      --
-- DATE CREATED         : 08-MAR-2025                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 			: 																		  --
-- DATE MODIFIED		: 				                      						              --
-- REVIEWD BY           : 			                                                              --
-- ********************************************************************************************** --

--Update feature flag
UPDATE lsmv_feature_flags SET on_off='0',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where feature_name = 'Enable Rule Engine MS';


DELETE FROM LSMV_DISTRIBUTION_RULE_MAPPING
WHERE FK_DISTRIBUTION_RULE_ID IN ( SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID in ('DR5008')); 


delete from LSMV_DISTRIBUTION_RULE_MAPPING
where param_map like '%SQL%';

update lsmv_distribution_format
set medium_details = 'dummy@arisglobal.com',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where medium_details is not null;

update lsmv_distribution_format
set cc_email_id = 'dummy@arisglobal.com',medium_details = 'dummy@arisglobal.com',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR');



update lsmv_distribution_format
set medium_details = 'amgenpatientsafety_test@amgen.com',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where medium = '2'
and FK_DISTRIBUTION_UNIT not in (
select record_id from lsmv_distribution_unit 
where upper(distribution_unit_name) in ('{PORTAL}','{HA} FRANCE CT'));

update lsmv_distribution_format
set medium_details = 'svc-safedx-dev@amgen.com',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where medium = '2'
and FK_DISTRIBUTION_UNIT in (
select record_id from lsmv_distribution_unit 
where upper(distribution_unit_name) in ('{PORTAL}'));



---update statment to make email address null
update lsmv_distribution_unit
set cc_email_id= null , correspondence_medium_details = null ,reply_to_email_address = null 
,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR');
---------------------------------------------------------------------------------------

update LSMV_DISTRIBUTION_RULE_MAPPING
set  PARAM_MAP = replace(PARAM_MAP,'PAN?2018','PAN/2018'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where PARAM_MAP like '%PAN?2018%';

-------------------------------------

update lsmv_distribution_rule_anchor
set reporting_attribute_json = '',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where (USER_CREATED = 'AMGEN_DR' OR USER_MODIFIED = 'AMGEN_DR')
and reporting_attribute_json <> '';


---Renaming anchor names it to Japanes name
---PMDA-7-治-未死
			 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-7-治-未死',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_3'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))
			 ;

---PMDA-7-治-未死_外	
		 
			 
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-7-治-未死_外',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_4'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 

---PMDA-7-治-未死__感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-7-治-未死__感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_5'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
			 
---PMDA-7-治-未死_外_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-7-治-未死_外_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_6'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---PMDA-15-治-既死			 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-既死',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_7'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既死-PMS

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既死-PMS',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_7.1'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-治-既死_外	
			 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-既死_外',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_8'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---PMDA-15-治-既死_感
			 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-既死_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_9'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---PMDA-15-治-既死_外_感			 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-既死_外_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_10'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---	PMDA-15-既死 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既死',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_11'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---PMDA-15-未死		 

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未死',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_12'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

			 
---PMDA-15-未死_外

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未死_外',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_13'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

--- PMDA-15-治-未他

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-未他',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_14'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

--- PMDA-15-治-未他

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未他-PMS',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_14.1'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-15-治-未他_外

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-未他_外',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_15'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-治-未他_感

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-未他_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_16'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-治-未他_外_感

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-治-未他_外_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_17'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-15-未他

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未他',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_18'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-15-既他(承認2年以内)

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既他(承認2年以内)',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_19'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-既他(直後調査中)

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既他(直後調査中)',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_20'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-未他_外


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未他_外',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_21'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-15-未重_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未重_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_22'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-既重_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既重_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_23'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-未重_外_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未重_外_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_24'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-既重_外_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-既重_外_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_25'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-外国措置


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-外国措置',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_26'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-研究_治_感


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-研究_治_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_27'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-研究_治


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-研究_治',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_28'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-外国措置_治


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-外国措置_治',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_29'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 
---PMDA-15-未非_感
	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-15-未非_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_30'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
			 

---PMDA-30-既他
	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-30-既他',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_31'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-30-研究_感
	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-30-研究_感',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_32'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


---PMDA-30-研究
	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
  SET display_name='PMDA-30-研究',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
  WHERE display_name = 'PMDA_RULE_33'
			 AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
			 AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---Insert scripts of 5008-- 

----------------------- DR5085---------------------------


----PMDA-7-治-未死



Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-7-治-未死' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-7-治-未死_外 ----SIMPL-73507

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-7-治-未死_外' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);



----PMDA-7-治-未死__感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-7-治-未死__感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-7-治-未死_外_感  ----SIMPL-73507


Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-7-治-未死_外_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-治-既死

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-既死' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-未他-PMS
Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未他-PMS' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","27","26","29","12"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|During post-marketing surveillance (PMS) (Instruction required drugs)|During re-examination period (Instruction required drugs)|Not applicable|Within 2 years after approval"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,7,0,0);




----PMDA-15-治-既死

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既死-PMS' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","27","26","29","12"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|During post-marketing surveillance (PMS) (Instruction required drugs)|During re-examination period (Instruction required drugs)|Not applicable|Within 2 years after approval"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,7,0,0);

----PMDA-15-治-既死_外  ----SIMPL-73507


Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-既死_外' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-治-既死_感


Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-既死_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);



----PMDA-15-治-既死_外_感  ----SIMPL-73507

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-既死_外_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-既死

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既死' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["12","11","26","27","29"],"fieldLabel":"CPD Approval Type","label":"Within 2 years after approval|During early post-marketing phase vigilance|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-未死

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未死' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-未死_外

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未死_外' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

----no chnage till here---




---PMDA-15-治-未他

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-未他' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

----PMDA-15-治-未他_外  ---SIMPL-73507

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-未他_外' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-治-未他_感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-未他_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["01","28","32","33"],"fieldLabel":"CPD Approval Type","label":"Unapproved|During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2"],"fieldLabel":"Country","label":"IB"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-治-未他_外_感   ----SIMPL-73507

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-治-未他_外_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8001"],"fieldLabel":"Tiken","label":"BLANK"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["28","32","33","01"],"fieldLabel":"CPD Approval Type","label":"During clinical trial for partial change|Approved (Drugs out of drugs defined their usage in the protocol excluding investigational drugs)|Unapproved (Drugs out of their usage in the protocol excluding investigational drugs)|Unapproved"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["2","5"],"fieldLabel":"Country","label":"IB|IB - Japan"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-既重_感  

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既重_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-未非_感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未非_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["2"],"fieldLabel":"Seriousness","label":"No"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-未重_感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未重_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


--No Death
-------------
---PMDA-15-未他

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未他' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


---PMDA-15-既他(承認2年以内)

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既他(承認2年以内)' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["12"],"fieldLabel":"CPD Approval Type","label":"Within 2 years after approval"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

----PMDA-15-既他(直後調査中)

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既他(直後調査中)' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

---PMDA-15-未他_外

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未他_外' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

----PMDA-15-未重_外_感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-未重_外_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["12","11","26","27","29"],"fieldLabel":"CPD Approval Type","label":"Within 2 years after approval|During early post-marketing phase vigilance|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["false"],"fieldLabel":"Labelling","label":"No"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


----PMDA-15-既重_外_感

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-15-既重_外_感' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["11","12","26","27","29"],"fieldLabel":"CPD Approval Type","label":"During early post-marketing phase vigilance|Within 2 years after approval|During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);

----PMDA-30-既他

Insert into LSMV_DISTRIBUTION_RULE_MAPPING
                             (RECORD_ID,FK_DISTRIBUTION_RULE_ID,FK_DISTRIBUTION_ANCHOR_ID,USER_CREATED,DATE_CREATED,
                             USER_MODIFIED,DATE_MODIFIED,PARAM_MAP,IS_TIMELINE_RULE,RULE_SEQUENCE,TIMELINE,EXCLUDE)
Values (NEXTVAL('SEQ_RECORD_ID'),(SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'),
(SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = 'PMDA-30-既他' 
AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' 
AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'))),
null,null,'AMGEN_DR',CURRENT_TIMESTAMP,
'{"adhocRules":[],"paramMap":{"CL_8202_tiken.safetyReport.aerInfo.flpath":{"values":["8003"],"fieldLabel":"Tiken","label":"NOT APPLICABLE"},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_709":{"values":["26","27","29"],"fieldLabel":"CPD Approval Type","label":"During re-examination period (Instruction required drugs)|During post-marketing surveillance (PMS) (Instruction required drugs)|Not applicable"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Life Threatening?","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":["4","3","1"],"fieldLabel":"Product Characterization","label":"Drug Not Administered|Interacting|Suspect"},"CL_1002":{"values":[],"fieldLabel":"Death?","label":""},"CL_9159":{"values":["true"],"fieldLabel":"Labelling","label":"Yes"},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":["JP"],"fieldLabel":"CPD Authorization Country","label":"JAPAN"},"LIB_9744_1015":{"values":["JP"],"fieldLabel":"Country","label":"JAPAN"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""}}}'
,0,6,0,0);


update LSMV_DISTRIBUTION_RULE_MAPPING
set PARAM_MAP = '{"adhocRules":[],"paramMap":{"CL_1013":{"values":["1"],"fieldLabel":"Product Characterization","label":"Suspect"}}}',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where fk_distribution_rule_id = (select RECORD_ID from LSMV_RULE_DETAILS where RULE_ID = 'DR051')
and (user_created = 'AMGEN_DR' or user_modified = 'AMGEN_DR');

--Update Anchor level PIVOT 
/* update LSMV_DISTRIBUTION_RULE_ANCHOR 
set fk_pivot_rule = (select record_id from lsmv_rule_details where rule_id = 'DR5001')
,param_map = '{"adhocRules":[],"paramMap":{"CL_9070":{"values":[],"fieldLabel":"Strength (unit)","label":""},"CL_709":{"values":[],"fieldLabel":"CPD Approval Type","label":""},"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group","label":""},"CL_805":{"values":[],"fieldLabel":"Form of admin.","label":""},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Life Threatening?","label":"Yes"},"CL_8201_reporterCausality":{"values":[],"fieldLabel":"Reporter Causality","label":""},"CL_5015":{"values":[],"fieldLabel":"Product Flag","label":""},"CL_8008":{"values":[],"fieldLabel":"Study Product Type","label":""},"SMQCMQTYPE_BROAD.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Broad","label":""},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"New Drug ?","label":""},"LIB_CU_ACC":{"values":[],"fieldLabel":"MAH As Coded","label":""},"CL_1013":{"values":[],"fieldLabel":"Product Characterization","label":""},"CL_9159":{"values":[],"fieldLabel":"Labelling","label":""},"CL_8201":{"values":["8002"],"fieldLabel":"Causality","label":"RELATED AS PER COMPANY OR REPORTER"},"CL_1015":{"values":[],"fieldLabel":"CPD Authorization Country","label":""},"LIB_9744_1015":{"values":[],"fieldLabel":"Labelling Country","label":""},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Authorization Number","label":""},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","label":""},"LIB_Product":{"values":[],"fieldLabel":"Product description","label":""},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"values":["1"],"fieldLabel":"Seriousness","label":"Yes"},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"SS Exclude ?","label":""},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Company Causality","label":""},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Strength (number)","label":""},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"IC Exclude ?","label":""},"LIB_Meddra":{"values":[],"fieldLabel":"MedDRAPT ","label":""},"CL_1002":{"values":["1"],"fieldLabel":"Death?","label":"Yes"},"SMQCMQTYPE_NARROW.flpath":{"values":[],"fieldLabel":"SMQCMQ Type : Narrow","label":""},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"values":[],"fieldLabel":"Product Group Inclusion ?","label":""}}}'
,exclude_pivot_rule = 1
where fk_distribution_format in (
	select record_id from lsmv_distribution_format
	where fk_distribution_unit in (
	select record_id from lsmv_distribution_unit 
	where distribution_unit_name = '{LP} Revolution'))
and display_name = 'LP_REVOLUTION_9D_S_INV'; */


Update lsmv_distribution_rule_anchor
set active = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where display_name = 'LP_SERVIER_30d_PREG';

Update lsmv_distribution_rule_anchor
set active = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where display_name = 'Rule_1'
and fk_distribution_format in (select record_id from lsmv_distribution_format where display_name = 'PMDA E2B R3 DEVICE');




update LSMV_DISTRIBUTION_RULE_MAPPING
set param_map = replace(param_map,'IB|IB - Japan','IB'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE FK_DISTRIBUTION_RULE_ID = (SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008'); -- Should not be deleted

update LSMV_DISTRIBUTION_RULE_MAPPING
set param_map = replace(param_map,'"2","5"','"2"'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE FK_DISTRIBUTION_RULE_ID = (SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008');

update LSMV_DISTRIBUTION_RULE_MAPPING
set param_map = replace(param_map,'"LIB_9744_1015":{"values":["2"]','"LIB_9744_1015":{"values":["2","8"]'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE FK_DISTRIBUTION_RULE_ID = (SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008')
AND param_map LIKE '%"IB"%';

update LSMV_DISTRIBUTION_RULE_MAPPING
set param_map = replace(param_map,'"IB"','"IB|RSI"'),user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
WHERE FK_DISTRIBUTION_RULE_ID = (SELECT RECORD_ID FROM LSMV_RULE_DETAILS WHERE RULE_ID = 'DR5008')
AND param_map LIKE '%"IB"%'; -- Should not be deleted




/* update lsmv_distribution_rule_anchor 
set param_map = '{"adhocRules":[],"paramMap":{"CL_9605":{"values":["4"],"fieldLabel":"Case Significance","label":"Significant (Reportable)"}}}'
where display_name in (
'PMDA-15-既死','PMDA-15-未死','PMDA-15-未死_外','PMDA-15-未他','PMDA-15-既他(承認2年以内)',
'PMDA-15-既他(直後調査中)','PMDA-15-未他_外','PMDA-15-未重_感','PMDA-15-既重_感','PMDA-15-未重_外_感',
'PMDA-15-既重_外_感','PMDA-15-外国措置','PMDA-15-研究_治_感','PMDA-15-研究_治','PMDA-15-外国措置_治',
'PMDA-15-未非_感','PMDA-30-既他','PMDA-30-研究_感','PMDA-30-研究'); */



update lsmv_accounts 
set apply_exclusion = 1, user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where account_name in ('{HA} EVCTMPROD','{HA} EVHUMAN');