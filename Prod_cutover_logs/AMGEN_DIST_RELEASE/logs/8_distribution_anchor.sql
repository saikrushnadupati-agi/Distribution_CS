----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera                                            	          --
-- FILENAME             : DISTRIBUTION_ANCHOR       		    				              	  --
-- PURPOSE              : SCRIPT IS FOR CREATING OR UPDATING DISTRIBUTION ANCHOR 	  		      --
-- DATE CREATED         : 23/02/2022                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 		    : Sai Krushna Dupati /Navya Chandramouli															  --
-- DATE MODIFIED		: 09-SEP-2025                       						              --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --



--UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
--SET ACTIVE = 0;


/* delete from lsmv_distribution_rule_mapping ldrm 
where fk_distribution_anchor_id in (select record_id from lsmv_distribution_rule_anchor
where fk_distribution_format in ( select record_id from lsmv_distribution_format
where display_name='PMDA_E2B_R3' and fk_distribution_unit in (select record_id from lsmv_distribution_unit ldu 
where distribution_unit_name ='PMDA' )));

delete from lsmv_distribution_rule_anchor
where fk_distribution_format in( select record_id from lsmv_distribution_format
where display_name='PMDA_E2B_R3' and fk_distribution_unit in (select record_id from lsmv_distribution_unit ldu 
where distribution_unit_name ='PMDA' )) and display_name <> 'LEGACY_RULE_1';  */

delete from lsmv_distribution_rule_mapping 
where fk_distribution_anchor_id in (select record_id from lsmv_distribution_rule_anchor
where display_name = 'EVCT_HA_7d/15d_F/LT_EU_Inv_R_U');

delete from lsmv_distribution_rule_anchor
where display_name = 'EVCT_HA_7d/15d_F/LT_EU_Inv_R_U';


delete from lsmv_distribution_rule_mapping 
where fk_distribution_anchor_id in (select record_id from lsmv_distribution_rule_anchor
where display_name = 'EVCT_HA_15d_S_EU_Inv_R_U');


delete from lsmv_distribution_rule_anchor
where display_name = 'EVCT_HA_15d_S_EU_Inv_R_U';


---Renaming anchor names it to English name
---PMDA-7-治-未死

UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name= 'PMDA_RULE_3',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-7-治-未死' AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-7-治-未死_外	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR SET display_name='PMDA_RULE_4',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP WHERE display_name =  'PMDA-7-治-未死_外' AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-7-治-未死__感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_5',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-7-治-未死__感' AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-7-治-未死_外_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_6',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-7-治-未死_外_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-治-既死
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_7',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-既死'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既死-PMS
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_7.1',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既死-PMS'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-治-既死_外	
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_8',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-既死_外'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-治-既死_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_9',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-既死_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-治-既死_外_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_10',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-既死_外_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---	PMDA-15-既死 
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_11',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既死'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未死		 
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_12',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未死'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未死_外
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_13',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未死_外'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
--- PMDA-15-治-未他
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_14',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-未他'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

--- PMDA-15-治-未他
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_14.1',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未他-PMS'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));

---PMDA-15-治-未他_外
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_15',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-未他_外'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-治-未他_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_16',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-未他_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-治-未他_外_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_17',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-治-未他_外_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未他
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_18',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未他'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既他(承認2年以内)
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_19',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既他(承認2年以内)'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既他(直後調査中)
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_20',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既他(直後調査中)'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未他_外
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_21',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未他_外'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未重_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_22',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未重_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既重_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_23',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既重_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未重_外_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_24',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未重_外_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-既重_外_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_25',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-既重_外_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-外国措置
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_26',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-外国措置'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-研究_治_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name= 'PMDA_RULE_27',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name ='PMDA-15-研究_治_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-研究_治
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_28',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-研究_治'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-外国措置_治
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_29',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-外国措置_治'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-15-未非_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_30',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-15-未非_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-30-既他
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_31',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-30-既他'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-30-研究_感
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_32',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-30-研究_感'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));
---PMDA-30-研究
UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR  SET display_name='PMDA_RULE_33',user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP  WHERE display_name = 'PMDA-30-研究'AND FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT WHERE DISPLAY_NAME = 'PMDA_E2B_R3' AND FK_DISTRIBUTION_UNIT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME = 'PMDA'));


update lsmv_distribution_rule_anchor
set active = 0 ,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP
where (user_created='AMGEN_DR' or user_modified = 'AMGEN_DR');


DO $$
DECLARE
lv_context text;
lv_cur_con RECORD;
lv_cur_format RECORD;
lv_cur_anchor RECORD;
lv_count INTEGER;
--lv_val_count INTEGER :=0;
lv_tymln INTEGER;
lv_anch_tymln text;
lv_anch_nm text;
lv_anch_desc text;
lv_anch_pivot text;
lv_anch_active text;
lv_anch_rank INTEGER;
lv_anch_start_dt timestamp;
lv_anch_end_dt timestamp;
lv_anch_active_val INTEGER;
lv_fk_dis_fmt BIGINT;
lv_inc_logic  text;
lv_aff_tym_ln text;
lv_anch_rep_type text;
lv_anch_rep_type_val varchar(2000);
Lv_anchor_present INTEGER;
Lv_anchor_present_pmda TEXT;
lv_record_id BIGINT;
Lv_Locally_Expedited TEXT;
Lv_Locally_Expedited_CODE TEXT;
lv_MHLW_Report_Type TEXT;
lv_MHLW_Report_Type_code INTEGER;
lv_MHLW_Device_Report_Type TEXT;
lv_MHLW_Device_Report_Type_code varchar(100);
lv_MHLW_Regenerative_Report_Type TEXT;
lv_MHLW_Regenerative_Report_Type_code INTEGER;
lv_complete_flag TEXT;
lv_complete_flag_code text;
lv_immediate_report_flag TEXT;
lv_immediate_report_flag_code INTEGER;
lv_touchless_val TEXT;
lv_touchless_code INTEGER;

BEGIN

--Contact Level loop
FOR lv_cur_con IN (SELECT distinct upper(trim(distribution_contact_name)) distribution_contact_name
                   FROM LSMV_TEMP_UPLOAD)
  LOOP
	 --Format Level Loop
     FOR lv_cur_format IN (SELECT distinct FORMAT,FORMAT_DISPLAY_NAME
                           FROM LSMV_TEMP_UPLOAD 
						   where upper(trim(distribution_contact_name))=upper(trim(Lv_cur_con.distribution_contact_name)))
  LOOP					   
	         ----------------- after release 2 must be changed to anchor level 
	 --Anchor Level Loop	
     FOR lv_cur_anchor in (SELECT ANCHOR_NAME ,DESCRIPTION,PIVOT,ACTIVE,RANK,
                           START_DATE,END_DATE,REPORT_TYPE,TIME_LINE,INCLUSION_LOGIC,AFF_TIME_LINE,Locally_Expedited, MHLW_Report_Type, MHLW_Device_Report_Type, MHLW_Regenerative_Report_Type, Complete_Incomplete, Immediate_Report_Flag,
						   Touchless_Submission
						   FROM LSMV_TEMP_UPLOAD 
						   where upper(trim(distribution_contact_name))=upper(trim(Lv_cur_con.distribution_contact_name))
						   and FORMAT=lv_cur_format.FORMAT
						   and upper(trim(FORMAT_DISPLAY_NAME))=upper(trim(lv_cur_format.FORMAT_DISPLAY_NAME)))
						  
  LOOP 
  
                 DELETE FROM LSMV_DISTRIBUTION_RULE_MAPPING
				 WHERE FK_DISTRIBUTION_ANCHOR_ID in (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_RULE_ANCHOR WHERE DISPLAY_NAME = lv_cur_anchor.ANCHOR_NAME AND
                 FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
                                 WHERE FK_DISTRIBUTION_UNIT IN ( SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
                                                               WHERE upper(trim(DISTRIBUTION_UNIT_NAME)) = upper(trim(lv_cur_con.distribution_contact_name)))
                                                               AND upper(trim(DISPLAY_NAME))= upper(trim(lv_cur_format.FORMAT_DISPLAY_NAME)))
								AND UPPER(TRIM(DISPLAY_NAME)) = UPPER(TRIM(lv_cur_anchor.ANCHOR_NAME)));
  
      			 SELECT COUNT(1) INTO Lv_anchor_present 
				 FROM LSMV_DISTRIBUTION_RULE_ANCHOR
                 WHERE FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
                                 WHERE FK_DISTRIBUTION_UNIT IN ( SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
                                                               WHERE upper(trim(DISTRIBUTION_UNIT_NAME)) = upper(trim(lv_cur_con.distribution_contact_name)))
                                                               AND upper(trim(DISPLAY_NAME))= upper(trim(lv_cur_format.FORMAT_DISPLAY_NAME) ))
								AND UPPER(TRIM(DISPLAY_NAME)) = UPPER(TRIM(lv_cur_anchor.ANCHOR_NAME));
				
				 
								
								
								--RAISE NOTICE 'O: %',Lv_anchor_present;
								IF Lv_anchor_present = 1 
								THEN 
									SELECT RECORD_ID INTO lv_record_id 
									FROM LSMV_DISTRIBUTION_RULE_ANCHOR
									WHERE FK_DISTRIBUTION_FORMAT IN (SELECT RECORD_ID FROM LSMV_DISTRIBUTION_FORMAT
																	WHERE FK_DISTRIBUTION_UNIT IN ( SELECT RECORD_ID FROM LSMV_DISTRIBUTION_UNIT
																									WHERE upper(trim(DISTRIBUTION_UNIT_NAME ))= upper(trim(lv_cur_con.distribution_contact_name)))
																									AND upper(trim(DISPLAY_NAME))= upper(trim(lv_cur_format.FORMAT_DISPLAY_NAME) ))
																	AND UPPER(TRIM(DISPLAY_NAME)) = UPPER(TRIM(lv_cur_anchor.ANCHOR_NAME));
								--RAISE NOTICE 'O: %',lv_record_id;
								ELSIF Lv_anchor_present > 1
								THEN
									RAISE NOTICE 'MULTIPLE ANCHOR ARE PRESENT :%',lv_cur_con.distribution_contact_name||' '||lv_cur_format.FORMAT||' '||lv_cur_anchor.ANCHOR_NAME;
								END IF;
								
								
								

    --To print the values in anchor level loop
    /* lv_val_count :=lv_val_count+1;
	 RAISE NOTICE 'Value for %',lv_val_count||'.'||'Contact:- '||lv_cur_con.distribution_contact_name||' Format:-'||lv_cur_format.format
	 ||' Format display Name:- '||lv_cur_format.FORMAT_DISPLAY_NAME;*/
	 
	 --Assigning the values fetched in lv_cur_anchor cursor to variables
						   lv_anch_nm :=lv_cur_anchor.ANCHOR_NAME;
						   lv_anch_desc :=lv_cur_anchor.DESCRIPTION;
						   lv_anch_pivot :=lv_cur_anchor.PIVOT;
						   lv_anch_active :=lv_cur_anchor.ACTIVE;
						   lv_anch_rank := COALESCE(TO_NUMBER(TRIM(lv_cur_anchor.RANK),'99'),1);
						 --lv_anch_start_dt :=lv_cur_anchor.START_DATE;
						 --lv_anch_end_dt :=lv_cur_anchor.END_DATE;
						   lv_anch_rep_type :=lv_cur_anchor.REPORT_TYPE;
						   --lv_tymln :=lv_cur_anchor.TIME_LINE;
						  -- lv_anch_tymln :=lv_cur_anchor.Anchor_Timeline;
						   --lv_inc_logic :=lv_cur_anchor.INCLUSION_LOGIC;
						  --- lv_aff_tym_ln := COALESCE(TO_NUMBER(lv_cur_anchor.AFF_TIME_LINE,'99'),1);
						   Lv_Locally_Expedited := TRIM(UPPER(lv_cur_anchor.Locally_Expedited));
						   lv_MHLW_Report_Type := TRIM(UPPER(lv_cur_anchor.MHLW_Report_Type));
						   lv_MHLW_Device_Report_Type := TRIM(UPPER(lv_cur_anchor.MHLW_Device_Report_Type));
						   lv_MHLW_regenerative_report_type := TRIM(UPPER(lv_cur_anchor.MHLW_Regenerative_Report_Type));
						   lv_complete_flag := TRIM(UPPER(lv_cur_anchor.Complete_Incomplete));
						   lv_immediate_report_flag := TRIM(UPPER(lv_cur_anchor.Immediate_Report_Flag));
						    lv_touchless_val :=TRIM(UPPER(lv_cur_anchor.Touchless_Submission));
	
	

	
	--To fetch  anchor touchless value
	Begin
	If upper(lv_touchless_val)='YES' then
    lv_touchless_code :=1;
    ELSE	
	lv_touchless_code :=0;
	END IF;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '25.%','Problem in Touchless';
	END;
	
    --To fetch active anchor value
    BEGIN
    IF upper(lv_anch_active)='NO' THEN
    lv_anch_active_val :=0;
	ELSIF upper(lv_anch_active)='YES' THEN
	lv_anch_active_val :=1;
	ELSIF upper(lv_anch_active)='ACTIVE' THEN
	lv_anch_active_val :=1;
	ELSE
	lv_anch_active_val :=0;
	END if;
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','active anchor value';
	END;
	
	-- Anchor Rep TYPE
	
	BEGIN
    SELECT CC.CODE into lv_anch_rep_type_val
    FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
    WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
    AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
    AND CD.LANGUAGE_CODE = 'en'
    AND CN.CODELIST_ID = 9623
	AND CC.CODE_STATUS='1'
	and upper(cd.decode)=upper(trim(lv_anch_rep_type))
	AND CC.CODE_STATUS='1';
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '1.%','Submission Report Type Vale is not Correct';
	END;
	--
	
	-- To fetch distribution format 
	 Begin
	 SELECT RECORD_ID into STRICT lv_fk_dis_fmt
	 FROM lsmv_distribution_format WHERE FK_DISTRIBUTION_UNIT IN 
	(SELECT RECORD_ID FROM lsmv_distribution_unit 
	 WHERE  UPPER(TRIM(DISTRIBUTION_UNIT_NAME)) =UPPER(TRIM(lv_cur_con.distribution_contact_name)))
	 AND UPPER(TRIM(DISPLAY_NAME)) = UPPER(TRIM(lv_cur_format.FORMAT_DISPLAY_NAME));
	 
	 IF lv_fk_dis_fmt IS NULL THEN
	 RAISE NOTICE 'CONTACT NOT FORND :%',lv_cur_con.distribution_contact_name;
	 END IF;
	 EXCEPTION 
	 WHEN OTHERS THEN 
	 RAISE NOTICE '2.%  contct: %  format_record :%','Problem in fetching value for distribution format ',lv_cur_con.distribution_contact_name,lv_cur_format.FORMAT_DISPLAY_NAME;
	 RAISE NOTICE 'format :%',SQLERRM;
	 END;

-- Locally Expedited
	 Begin
	 IF Lv_Locally_Expedited = 'YES' 
	 THEN
		 Lv_Locally_Expedited_CODE = '1';
	 ELSIF Lv_Locally_Expedited = 'NO'
	 THEN 
		Lv_Locally_Expedited_CODE = '2';		 
	 ELSE 
		 Lv_Locally_Expedited_CODE = '';
	 END IF;
	 EXCEPTION 
	 WHEN OTHERS THEN 
	RAISE NOTICE '3.%', 'Problem in fetching value for locally expedited';
	 END;						   

	-- MHLW Rep TYPE
	
	BEGIN
    SELECT CC.CODE into lv_MHLW_Report_Type_code
    FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
    WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
    AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
    AND CD.LANGUAGE_CODE = 'en'
    AND CN.CODELIST_ID = 9652
	AND CC.CODE_STATUS='1'
	and upper(cd.decode)=upper(trim(lv_MHLW_Report_Type))
	AND CC.CODE_STATUS='1';
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '4.%','MHLW Report Type Value is not Correct';
	END;
	
	-- MHLW Device Rep TYPE
	
	BEGIN
    SELECT CC.CODE into lv_MHLW_Device_Report_Type_code
    FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
    WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
    AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
    AND CD.LANGUAGE_CODE = 'en'
    AND CN.CODELIST_ID = 10065
	AND CC.CODE_STATUS='1'
	and upper(cd.decode)=upper(trim(lv_MHLW_Device_Report_Type))
	AND CC.CODE_STATUS='1';
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '5.%','MHLW device Report Type Value is not Correct';
	END;	
	
	-- MHLW regenerative Rep TYPE
	
	BEGIN
    SELECT CC.CODE into lv_MHLW_regenerative_report_type_code
    FROM LSMV_CODELIST_NAME CN,LSMV_CODELIST_CODE CC,LSMV_CODELIST_DECODE CD
    WHERE CN.RECORD_ID = CC.FK_CL_NAME_REC_ID
    AND CC.RECORD_ID = CD.FK_CL_CODE_REC_ID
    AND CD.LANGUAGE_CODE = 'en'
    AND CN.CODELIST_ID = 10065
	AND CC.CODE_STATUS='1'
	and upper(cd.decode)=upper(trim(lv_MHLW_regenerative_report_type))
	AND CC.CODE_STATUS='1';
	EXCEPTION WHEN OTHERS THEN 
	RAISE NOTICE '6.%','MHLW regenerative Report Type Value is not Correct';
	END;	
	
-- Complete/Incomplete
	 Begin
	 --RAISE NOTICE '7.%',lv_complete_flag;
	 IF lv_complete_flag = 'YES' 
	 THEN
		 lv_complete_flag_code = '1';
	 ELSIF lv_complete_flag = 'NO'
	 THEN 
		lv_complete_flag_code = '2';
	 ELSE
		 lv_complete_flag_code = '';
		 
	 END IF;
	 EXCEPTION 
	 WHEN OTHERS THEN 
	RAISE NOTICE '7.%', 'Problem in fetching value for Complete/Incomplete';
	 END;
	 
--Immediate report flag
		BEGIN 
		IF lv_immediate_report_flag='YES' or lv_immediate_report_flag = 'CHECKED' THEN
		lv_immediate_report_flag_code:=1;
		ELSE
		lv_immediate_report_flag_code:=0;
		END IF;
		EXCEPTION WHEN OTHERS THEN 
	     RAISE NOTICE '8.%','Problem in Immediate report flag';
	    END; 	 
						 
	Begin		
		 IF Lv_anchor_present = 0 
		 
		 THEN 
		 --RAISE NOTICE 'Anchor inserted for  :%',lv_cur_con.distribution_contact_name||' : '||lv_cur_format.FORMAT||' : '||lv_cur_anchor.ANCHOR_NAME;
			INSERT INTO LSMV_DISTRIBUTION_RULE_ANCHOR(record_id, display_name, active, privacy, blinded_report,description,
													  start_date,end_date,fk_submission_workflow, fk_receiver_contact, fk_sender_contact,
												      fk_cover_letter_template, fk_fax_template, fk_email_template, submission_date_recalculaton,time_line_day,
												      fk_distribution_format, user_created, date_created, user_modified, date_modified,
												      sender_contact_cu_rec_id, sender_contact_cu_partner_id, rule_inclusion_logic, fk_pivot_rule, affliate_submission_timeline,
												      fk_data_privacy_rule, fk_submission_wf_name, archived, version, sequence,
										 		      report_type, exclude_pivot_rule,
													  Locally_Expedited,
													  MHLW_Report_Type,
													  MHLW_device_rep_type,
													  MHLW_regenerative_report_type,
													  complete_flag,
													  immediate_report_flag
													  ,reporting_attribute_json,trusted_partner
											      ) 
                                                values(nextval('seq_record_id'), lv_anch_nm, lv_anch_active_val, '0', 0, lv_anch_desc,
													   null,null,null, null, null,
												       null, null, null, 0,15,
											           lv_fk_dis_fmt, 'AMGEN_DR', CURRENT_TIMESTAMP, null,null,
													   null , null, '00',null, null,
													   null,null,0,0,lv_anch_rank,
													   lv_anch_rep_type_val,0,
													   Lv_Locally_Expedited_CODE,
													   lv_MHLW_Report_Type_code,
													   lv_MHLW_Device_Report_Type_code,
													   lv_MHLW_regenerative_report_type_code,
													   lv_complete_flag_code,
													   lv_immediate_report_flag_code,null,lv_touchless_code
													   );
		 ELSIF Lv_anchor_present = 1 
		 THEN 
		 --RAISE NOTICE 'O: %','INS';
			 UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
			 SET ACTIVE = lv_anch_active_val,display_name=lv_anch_nm,sequence=lv_anch_rank,report_type = lv_anch_rep_type_val,
			 user_modified= 'AMGEN_DR', date_modified = CURRENT_TIMESTAMP,
				 description = lv_anch_desc, Locally_Expedited = Lv_Locally_Expedited_CODE,
				 MHLW_Report_Type = lv_MHLW_Report_Type_code,
				 MHLW_device_rep_type = lv_MHLW_Device_Report_Type_code,
				 MHLW_regenerative_report_type = lv_MHLW_regenerative_report_type_code,
				 complete_flag = lv_complete_flag_code,
				 immediate_report_flag = lv_immediate_report_flag_code
				 ,reporting_attribute_json = null,trusted_partner=lv_touchless_code
			 WHERE RECORD_ID = lv_record_id; 
		 END IF;
		 
     /*EXCEPTION WHEN OTHERS THEN 
	 RAISE NOTICE 'EXCEPTION :%', lv_anch_nm;*/
	 END;
   ----- Update all the varibales used in the condition needs to set as null
   lv_anch_active_val :=null;
   Lv_anchor_present := NULL;
    Lv_anchor_present_pmda := NULL;
   lv_record_id := NULL;
   	lv_touchless_code :=0;
	lv_touchless_val :=null;
   END LOOP;
   END LOOP;
   END LOOP;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE NOTICE 'EXCEPTION :%', 'NO DATA FOUND';
WHEN others THEN
GET STACKED DIAGNOSTICS lv_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION :%', lv_context; 
RAISE NOTICE ' MAIN INSERT :%',SQLERRM; 
END $$;


UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR
SET affliate_submission_timeline = NULL,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;

