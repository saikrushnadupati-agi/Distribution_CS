----------------------------------------------------------------------------------------------------
--             Copyright © 2000-2020 PharmApps, LLc.                				  			  --
--             All Rights Reserved.								 							      --
--             This software is the confidential and proprietary information of PharmApps,LLC.	  --
--             (Confidential Information).														  --
----------------------------------------------------------------------------------------------------
-- CREATED BY           : Sanjay k Behera   													  --
-- FILENAME             : 3_dist_user_attribute.sql		    				              	  	  --
-- PURPOSE              : Creation of user attribute   											  --
-- DATE CREATED         : 08/03/2023                          						              --
-- OBJECT LIST          :                                                                         --
-- MODIFIED BY 			: Sai Krushna Dupati /Navya Chandramouli										  --
-- DATE MODIFIED		: 08/09/2025                      						              	  --
-- REVIEWD BY           : DEBASIS DAS                                                             --
-- ********************************************************************************************** --

-- USER ATTRIBUTE CREATION 

Do $$
DECLARE
l_context TEXT;
BEGIN

    UPDATE LSMV_DISTRIBUTION_UNIT 
		SET fk_pivot_rule = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;
    UPDATE LSMV_DISTRIBUTION_FORMAT 
		SET fk_pivot_rule = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;
    UPDATE LSMV_DISTRIBUTION_RULE_ANCHOR 
		SET fk_pivot_rule = NULL,PARAM_MAP = NULL,exclude_pivot_rule = 0,user_modified ='AMGEN_DR' , date_modified= CURRENT_TIMESTAMP;
              
               DELETE FROM LSMV_DISTRIBUTION_RULE_MAPPING 
               WHERE FK_DISTRIBUTION_RULE_ID IN (SELECT RECORD_ID FROM lsmv_rule_details
                                                 WHERE RULE_ID IN ('DR5001','DR5001_1','DR5001_2','DR5002','DR5062',
																   'DR5063','DR5064','DR5008','DR5008_1','DR5008_2',
																   'DR5065','DR5012','DR5012_1','DR5012_2','DR5019_2',
																   'DR5019','DR5019_1','DR5020','DR5022','DR5023',
																    'DR5021','DR5021_1','DR5021_2','DR5013','DR5024','DR5025',
																	'DR5014','DR5015','DR5017','DR5016'
												 ));


                                                                                                                                    
     DELETE FROM lsmv_rule_details
     WHERE RULE_ID IN ('DR5001','DR5001_1','DR5001_2','DR5002','DR5062','DR5063',
					  'DR5064','DR5008','DR5008_1','DR5008_2','DR5065','DR5012',
					  'DR5012_1','DR5012_2','DR5019_2','DR5019','DR5019_1','DR5020',
					  'DR5022','DR5023', 'DR5021','DR5021_1','DR5021_2','DR5013','DR5024','DR5025',
					  'DR5014','DR5015','DR5017','DR5016'
					  );
	 
----------------DR5001 START


INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_IMPLIED_CAUSALITY',NULL,NULL,'Y','(C2)','{"recordId":"1706128095750","childConditions":[{"recordId":"1706128169780","refRuleConditionId":"1706128137316"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_IMPLIED_CAUSALITY_PARAM","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_IMPLIED_CAUSALITY_PARAM","rhsSameCtx":"N","index":"1","nfMarked":"N","recordId":"1706128108439","anyOneLhs":"N","referenceRuleID":"DR5001_1","rhsFilterConddLogic":"N","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_IMPLIED_CAUSALITY_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_IMPLIED_CAUSALITY_JS","rhsSameCtx":"N","index":"2","nfMarked":"N","recordId":"1706128137316","anyOneLhs":"N","referenceRuleID":"DR5001_2","rhsFilterConddLogic":"N","unitFieldPath":"N"}]',NULL,'N','Y',NULL,'DistributionRule','User Implied Causality','{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"codelistId":"9741","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Group","fieldPath":"productGroup.safetyReport.aerInfo.flpath","parameterName":"Product Group","fieldId":"102113"},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Group Inclusion ?","fieldPath":"productGroupInclExcl.safetyReport.aerInfo.flpath","parameterName":"Product Group Inclusion?","fieldId":"102114"},"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MAH As Coded","fieldId":"954003"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Authorization Number","fieldPath":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Authorization Number","fieldId":"954006"},"CL_805":{"codelistId":"805","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Form of admin.","fieldPath":"drugDosageForm.drugTherapyCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Form of admin.","fieldId":"122012"},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Strength (number)","fieldPath":"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Strength (number)","fieldId":"115254"},"CL_9070":{"codelistId":"9070","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Strength (unit)","fieldPath":"substanceStrengthUnit.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Strength (unit)","fieldId":"115355"},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"New Drug ?","fieldPath":"newDrug.safetyReport.aerInfo.flpath","parameterName":"New Drug ?","fieldId":"102114"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_9159":{"codelistId":"9159","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"}],"fieldId":"150103"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Causality","fieldId":"102112"},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","fieldPath":"ANDOR.safetyReport.aerInfo.flpath","parameterName":"Causality Logic (Yes = AND, Default = OR)","fieldId":"102114"},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Company Causality","fieldPath":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Company Causality","fieldId":"117676"},"CL_8201_reporterCausality":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Reporter Causality","fieldPath":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Reporter Causality","fieldId":"117122"},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"IC Exclude ?","fieldPath":"impliedCausality.safetyReport.aerInfo.flpath","parameterName":"IC Exclude ?","fieldId":"102114"},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"SS Exclude ?","fieldPath":"SSExclude.safetyReport.aerInfo.flpath","parameterName":"SS Exclude ?","fieldId":"102114"},"LIB_Meddra":{"codelistId":null,"libraryName":"Meddra","defaultValue":{},"fieldLabel":"MedDRAPT ","fieldPath":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MedDRAPT ","fieldId":"111112"},"SMQCMQTYPE_BROAD.flpath":{"codelistId":"1021","libraryName":null,"fieldLabel":"SMQCMQ Type : Broad","fieldPath":"SMQCMQTYPE_BROAD.flpath","parameterName":"Broad","fieldId":"111112"},"SMQCMQTYPE_NARROW.flpath":{"codelistId":"1021","libraryName":null,"fieldLabel":"SMQCMQ Type : Narrow","fieldPath":"SMQCMQTYPE_NARROW.flpath","parameterName":"Narrow","fieldId":"111112"}}}',NULL,'Y','Frozen','DR5001','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_IMPLIED_CAUSALITY_PARAM',NULL,'reactionCollection$patient.safetyReport.aerInfo|drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo|drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo','Y','()','{"recordId":"1682513041605","operator":"AND"}','[{"parameterizedRhs":"Y","lhsFieldcodelistId":"9741","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Group In ?","index":"1","nfMarked":"N","operator":"In","recordId":"1684485770773","anyOneLhs":"N","lhsField":"productGroup.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Group"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Group Inclusion In ?","index":"2","nfMarked":"N","operator":"In","recordId":"1684485770774","anyOneLhs":"N","lhsField":"productGroupInclExcl.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Group Inclusion"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1013","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Characterization In ?","index":"3","nfMarked":"N","operator":"In","recordId":"1682514091702","anyOneLhs":"N","lhsField":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Characterization"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"5015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Flag In ?","index":"4","nfMarked":"N","operator":"In","recordId":"1684485770775","anyOneLhs":"N","lhsField":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Flag"},{"recordId":"1683289370020","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product description In ?","index":"5","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Product description","operator":"In"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8008","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Study Product Type In ?","index":"6","nfMarked":"N","operator":"In","recordId":"1682514090811","anyOneLhs":"N","lhsField":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Study Product Type"},{"recordId":"1682514442839","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"MAH As Coded In ?","index":"7","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"MAH As Coded","operator":"In"},{"recordId":"1682514444449","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Authorization Number In ?","index":"8","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Authorization Number","operator":"In"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"709","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Approval Type In ?","index":"9","nfMarked":"N","operator":"In","recordId":"1682514456591","anyOneLhs":"N","lhsField":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD Approval Type"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Authorization Country In ?","index":"10","nfMarked":"N","operator":"In","recordId":"1683537829297","anyOneLhs":"N","lhsField":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD Authorization Country"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"805","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Form of admin. In ?","rhsSameCtx":"N","index":"11","nfMarked":"N","operator":"In","recordId":"1705633189602","anyOneLhs":"N","lhsField":"drugDosageForm.drugTherapyCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Form of admin."},{"parameterizedRhs":"Y","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Strength (number) Equals ?","rhsSameCtx":"N","index":"12","nfMarked":"N","operator":"Equals","recordId":"1745784036223","anyOneLhs":"N","lhsField":"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","rhsFilterConddLogic":"N","lhsFieldString":"Strength (number)"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"9070","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Strength (unit) Equals ?","rhsSameCtx":"N","index":"13","nfMarked":"N","operator":"Equals","recordId":"1754324037246","anyOneLhs":"N","lhsField":"substanceStrengthUnit.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Strength (unit)"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"New Drug ?","index":"14","nfMarked":"N","operator":"In","recordId":"1907721770774","anyOneLhs":"N","lhsField":"newDrug.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"New Drug ?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Seriousness In ?","index":"15","nfMarked":"N","operator":"In","recordId":"1683537851916","anyOneLhs":"N","lhsField":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Seriousness"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Life Threatening? In ?","index":"16","nfMarked":"N","operator":"In","recordId":"1683537877216","anyOneLhs":"N","lhsField":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Life Threatening?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Death? In ?","index":"17","nfMarked":"N","operator":"In","recordId":"1682514065782","anyOneLhs":"N","lhsField":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Death?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"9159","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Labelling In ?","index":"18","nfMarked":"N","operator":"In","recordId":"1682514296331","anyOneLhs":"N","lhsField":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Labelling"},{"recordId":"1682514441758","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Labelling Country In ?","index":"19","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Labelling Country","operator":"In"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8201","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Causality In ?","index":"20","nfMarked":"N","operator":"In","recordId":"1684485770772","anyOneLhs":"N","lhsField":"causality.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Causality"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1021","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Causality Logic (Yes = AND, Default = OR)","index":"21","nfMarked":"N","operator":"In","recordId":"1244485770774","anyOneLhs":"N","lhsField":"ANDOR.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Causality Logic (Yes = AND, Default = OR)"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8201","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reporter Causality Equals ?","rhsSameCtx":"N","index":"22","nfMarked":"N","operator":"Equals","recordId":"1346030156544","anyOneLhs":"N","lhsField":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Reporter Causality"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8201","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Company Causality Equals ?","rhsSameCtx":"N","index":"23","nfMarked":"N","operator":"Equals","recordId":"1446030185606","anyOneLhs":"N","lhsField":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Company Causality"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1021","lhsFilterConddLogic":"N","ruleCondDisplayStr":"IC Exclude ?","index":"24","nfMarked":"N","operator":"In","recordId":"1656721770774","anyOneLhs":"N","lhsField":"impliedCausality.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"IC Exclude ?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1021","lhsFilterConddLogic":"N","ruleCondDisplayStr":"SS Exclude ?","index":"25","nfMarked":"N","operator":"In","recordId":"1243467870774","anyOneLhs":"N","lhsField":"ssExclude.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"SS Exclude ?"},{"recordId":"1987188411234","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"MedDRAPT [B.2.i.2.b] In ?","index":"26","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"MedDRAPT [B.2.i.2.b]","operator":"In"}]',NULL,'N','Y',NULL,'DistributionRule','DR5001_1:USER_IMPLIED_CAUSALITY_PARAM','{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{"CL_9741_productGroup.safetyReport.aerInfo.flpath":{"codelistId":"9741","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Group","fieldPath":"productGroup.safetyReport.aerInfo.flpath","parameterName":"Product Group","fieldId":"102113"},"CL_1002_productGroupInclExcl.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Group Inclusion ?","fieldPath":"productGroupInclExcl.safetyReport.aerInfo.flpath","parameterName":"Product Group Inclusion?","fieldId":"102114"},"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MAH As Coded","fieldId":"954003"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Authorization Number","fieldPath":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Authorization Number","fieldId":"954006"},"CL_805":{"codelistId":"805","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Form of admin.","fieldPath":"drugDosageForm.drugTherapyCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Form of admin.","fieldId":"122012"},"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Strength (number)","fieldPath":"substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Strength (number)","fieldId":"115254"},"CL_9070":{"codelistId":"9070","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Strength (unit)","fieldPath":"substanceStrengthUnit.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Strength (unit)","fieldId":"115355"},"CL_1002_newDrug.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"New Drug ?","fieldPath":"newDrug.safetyReport.aerInfo.flpath","parameterName":"New Drug ?","fieldId":"102114"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_9159":{"codelistId":"9159","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"}],"fieldId":"150103"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Causality","fieldId":"102112"},"CL_1021_ANDOR.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Causality Logic (Yes = AND, Default = OR)","fieldPath":"ANDOR.safetyReport.aerInfo.flpath","parameterName":"Causality Logic (Yes = AND, Default = OR)","fieldId":"102114"},"CL_8201_companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Company Causality","fieldPath":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Company Causality","fieldId":"117676"},"CL_8201_reporterCausality":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Reporter Causality","fieldPath":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Reporter Causality","fieldId":"117122"},"CL_1021_impliedCausality.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"IC Exclude ?","fieldPath":"impliedCausality.safetyReport.aerInfo.flpath","parameterName":"IC Exclude ?","fieldId":"102114"},"CL_1021_SSExclude.safetyReport.aerInfo.flpath":{"codelistId":"1021","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"SS Exclude ?","fieldPath":"SSExclude.safetyReport.aerInfo.flpath","parameterName":"SS Exclude ?","fieldId":"102114"},"LIB_Meddra":{"codelistId":null,"libraryName":"Meddra","defaultValue":{},"fieldLabel":"MedDRAPT ","fieldPath":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MedDRAPT ","fieldId":"111112"},"SMQCMQTYPE_BROAD.flpath":{"codelistId":"1021","libraryName":null,"fieldLabel":"SMQCMQ Type : Broad","fieldPath":"SMQCMQTYPE_BROAD.flpath","parameterName":"Broad","fieldId":"111112"},"SMQCMQTYPE_NARROW.flpath":{"codelistId":"1021","libraryName":null,"fieldLabel":"SMQCMQ Type : Narrow","fieldPath":"SMQCMQTYPE_NARROW.flpath","parameterName":"Narrow","fieldId":"111112"}}}',NULL,'Y','Frozen','DR5001_1',NULL,'Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_IMPLIED_CAUSALITY_JS',NULL,NULL,'Y','()','{"recordId":"1706127993091","operator":"AND"}',NULL,NULL,'Y','Y','var ruleName = ''USER_IMPLIED_CAUSALITY'';
var logFlag = true;
var receiptNum = inboundMessage.receiptItem.receiptNo;
logConsole(''Execution Started'');

// Case level values
var caseLrd = new Date(inboundMessage.aerInfo.safetyReport.receiptDate);
var reactionCollection = inboundMessage.aerInfo.safetyReport.patient.reactionCollection;
var drugCollection = inboundMessage.aerInfo.safetyReport.patient.drugCollection;

// Generic fn to Logger
function logConsole(message) {
  if (logFlag) {
    UTIL.getLogger().error(receiptNum + '': '' + ruleName + '': '' + message);
  }
}
// Generic fn to convert string from UI separated by delimiter to character separated by Comma
function getStringToChar(inputString) {
  // Split the string into an array using the custom delimiter and add single quotes
  var customSeparatedStringWithQuotes = inputString.split(''|'').map(function(value) {
    return "''" + value + "''";
  }).join('','');
  return customSeparatedStringWithQuotes;
}
// Generic fn to check the case data and input param multivalue
function compareCaseWithParamValue(caseData, paramList) {
  // Check if both caseData and paramList are not empty or null
  if (UTIL.isNotNullCheck(caseData) && paramList.length > 0) {
    for (var i = 0; i < paramList.length; i++) {
      // Check if caseData matches the current value in paramList
      if (caseData == paramList[i]) {
        return true;
      }
    }
  }
  return false;
}
// Generic fn to check Param values against Case data
function checkParamValue(collectionName, caseFieldName, paramValue) {
  // Split param value by ''|'' if it''s not null or undefined else set to null
  var paramList = paramValue ? paramValue.split(''|'') : [];
  // Convert the corresponding case field to String
  var caseValue = String(collectionName[caseFieldName]);
  // Use the compareCaseWithParamValue function for the comparison
  return compareCaseWithParamValue(caseValue, paramList);
}

// Event level fields logic starts here
var eventSeriousParam = UTIL.isNotNullCheck(userParameters.get(''seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventLTParam = UTIL.isNotNullCheck(userParameters.get(''lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventDTParam = UTIL.isNotNullCheck(userParameters.get(''death.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''death.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var ssExcludeParam = UTIL.isNotNullCheck(userParameters.get(''SSExclude.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''SSExclude.safetyReport.aerInfo.flpath'')) : null;
var medDraPTParam = UTIL.isNotNullCheck(userParameters.get(''reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventArrList = new java.util.ArrayList();
// Function to check Seriousness, LT, and Death above param values with case data for each event
function chkEventDetailsAndLoad() {
  var ssptList = UTIL.isNotNullCheck(medDraPTParam) ? medDraPTParam.split(''|'') : [];
  var ssLogic = ssptList.length > 0 ? true : false;
  ssExcludeParam = UTIL.isNotNullCheck(ssExcludeParam) ? true : false;
  try {
    for (var eventIndex = 0; eventIndex < reactionCollection.size(); eventIndex++) {
      var currEvent = reactionCollection.get(eventIndex);

      var eventToBeChecked = false;
      // check if SS PT list is selected or current event is part of the SS list based on Exclude or Include logic
      if (!ssLogic || (ssExcludeParam && medDraPTParam.indexOf(currEvent.reactMedDraPtCode) == -1) || (!ssExcludeParam && medDraPTParam.indexOf(currEvent.reactMedDraPtCode) != -1)) {
        eventToBeChecked = true;
      }
      if (eventToBeChecked) {
        // If Seriousness, LT, and Death case level is NF or Blank, ''2'' (No) will be assigned
        var eventSeriousness = UTIL.isNotNullCheck(String(currEvent.seriousness)) ? String(currEvent.seriousness) : ''2'';
        var eventLifeThreat = UTIL.isNotNullCheck(String(currEvent.lifethreatening)) ? String(currEvent.lifethreatening) : ''2'';
        var eventDeath = UTIL.isNotNullCheck(String(currEvent.death)) ? String(currEvent.death) : ''2'';
        // Check if current event matches the specified parameters
        var eventSeriousMatch = UTIL.isNotNullCheck(eventSeriousParam) ? (eventSeriousParam == eventSeriousness) : true;
        var deathorltMatch = ( UTIL.isNullCheck(eventDTParam) && UTIL.isNullCheck(eventLTParam))? true: ( UTIL.isNotNullCheck(eventDTParam) && (eventDTParam == eventDeath))|| (UTIL.isNotNullCheck(eventLTParam) && (eventLTParam == eventLifeThreat));
        // If all conditions are met, add the current event to the list
        if (eventSeriousMatch && deathorltMatch) {
          eventArrList.add(currEvent.recordId);
        }
      }
    }
  } catch (error) {
    logConsole("Exception caught in Event check: " + error);
  }
}
// Event level fields logic ends here

// Product related fields comparison starts here
var productCharParam = UTIL.isNotNullCheck(userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var productFlagParam = UTIL.isNotNullCheck(userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var studyPrdTypeParam = UTIL.isNotNullCheck(userParameters.get(''studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodAppTypeParam = UTIL.isNotNullCheck(userParameters.get(''cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodAppCntryParam = UTIL.isNotNullCheck(userParameters.get(''cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var mahAsCodedParam = UTIL.isNotNullCheck(userParameters.get(''mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodAppNoParam = UTIL.isNotNullCheck(userParameters.get(''approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var formOfAdminParam = UTIL.isNotNullCheck(userParameters.get(''drugDosageForm.drugTherapyCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''drugDosageForm.drugTherapyCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prdStrengthNoParam = UTIL.isNotNullCheck(userParameters.get(''substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''substanceStrength.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prdStrengthUnitParam = UTIL.isNotNullCheck(userParameters.get(''substanceStrengthUnit.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''substanceStrengthUnit.activeSubstanceCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
  
// Fn to check Product related param data with case data fields
function checkAgainstCaseDrug(currentProd) {
  // Generic fn call for Drug Characterization, Study product Type and Product Flag
  var caseDrugCharMatch = UTIL.isNotNullCheck(productCharParam) ? checkParamValue(currentProd, ''drugCharacterization'', productCharParam) : true;
  var caseDrugStudyProdTypeMatch = UTIL.isNotNullCheck(studyPrdTypeParam) ? checkParamValue(currentProd, ''studyProductType'', studyPrdTypeParam) : true;
  var caseDrugProdFlagMatch = UTIL.isNotNullCheck(productFlagParam) ? checkParamValue(currentProd, ''productType'', productFlagParam) : true;

  var drugApprovalCollection = currentProd.drugApprovalCollection;
  for (var drugAppIndex = 0; drugAppIndex < drugApprovalCollection.size(); drugAppIndex++) {
    var currProdAppr = drugApprovalCollection.get(drugAppIndex);
    // Generic fn call for App Type, No, Country and MAH as coded
    var caseDrugProdAppTypeMatch = UTIL.isNotNullCheck(prodAppTypeParam) ? checkParamValue(currProdAppr, ''approvalType'', prodAppTypeParam) : true;
    var caseDrugProdAppNoMatch = UTIL.isNotNullCheck(prodAppNoParam) ? checkParamValue(currProdAppr, ''approvalNo'', prodAppNoParam) : true;
    // var caseDrugProdAppCntryMatch = UTIL.isNotNullCheck(prodAppCntryParam) ? checkParamValue(currProdAppr, ''approvalCoutry'', prodAppCntryParam) : true;
    var caseDrugProdAppMAHMatch = UTIL.isNotNullCheck(mahAsCodedParam) ? checkParamValue(currProdAppr, ''mahAsCoded'', mahAsCodedParam) : true;
  }

  var drugTherapyCollection = currentProd.drugTherapyCollection;
  for (var drugTherIndex = 0; drugTherIndex < drugTherapyCollection.size(); drugTherIndex++) {
    var currProdTherapy = drugTherapyCollection.get(drugTherIndex);
    // Generic fn call for Form of Admin, Strength/unit
    var caseDrugTherapyFOAmatch = UTIL.isNotNullCheck(formOfAdminParam) ? checkParamValue(currProdTherapy, ''drugDosageForm'', formOfAdminParam) : true;
    var caseDrugTherapyStrength = UTIL.isNotNullCheck(prdStrengthNoParam) ? checkParamValue(currProdTherapy, ''formStrength'', prdStrengthNoParam) : true;
    var caseDrugTherapyStrenUnit = UTIL.isNotNullCheck(prdStrengthUnitParam) ? checkParamValue(currProdTherapy, ''formStrengthUnit'', prdStrengthUnitParam) : true;
  }

  return (caseDrugCharMatch && caseDrugStudyProdTypeMatch && caseDrugProdFlagMatch && caseDrugProdAppTypeMatch && caseDrugProdAppNoMatch && caseDrugProdAppMAHMatch && caseDrugTherapyFOAmatch && caseDrugTherapyStrength && caseDrugTherapyStrenUnit);
}

// Fn to check Product related Param data with CPD fields except prod char and study prod type
var formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
var initialReceivedDate = new Date(inboundMessage.aerInfo.safetyReport.receiveDate);
logConsole("initialReceivedDate: " + initialReceivedDate);
var prodListForCPD = [];
var prodListForPortfolio = [];
var finalProdListforCausality = new java.util.ArrayList();
function chkAgainstCPD() {
  try {
    var cpdQueryCount;
    var portfolioQueryCount;

    // Build the SQL query conditions for Prod Group and Prod Desc
    var prodCPDRecId = prodListForCPD.filter(Boolean).join('','');
    if (UTIL.isNotNullCheck(prodCPDRecId)) {
      var cpdQueryConditions = [
        "lpt.fk_agx_product_rec_id = lp.record_id",
        "lpt.license_status = ''1''",
		"(lpt.approval_date is null OR lpt.approval_date >= TO_DATE(''" + initialReceivedDate + "'', ''Dy Mon DD YYYY HH24:MI:SS''))",
        "lp.record_id IN (" + prodCPDRecId + ")",
        (UTIL.isNotNullCheck(productFlagParam)) ? "coalesce(lp.product_type, ''NA'') IN (" + getStringToChar(productFlagParam) + ")" : null,
        (UTIL.isNotNullCheck(mahAsCodedParam)) ? "coalesce(lpt.mah_name, ''NA'') IN (" + getStringToChar(mahAsCodedParam) + ")" : null,
        (UTIL.isNotNullCheck(prodAppTypeParam)) ? "coalesce(lpt.APPROVAL_TYPE,''NA'') IN (" + getStringToChar(prodAppTypeParam) + ")" : null,
        (UTIL.isNotNullCheck(prodAppCntryParam)) ? "coalesce(lpt.COUNTRY_CODE,''NA'') IN (" + getStringToChar(prodAppCntryParam) + ")" : null,
        (UTIL.isNotNullCheck(prodAppNoParam)) ? "coalesce(lpt.APPROVAL_NO,''NA'') IN (" + getStringToChar(prodAppNoParam) + ")" : null,
        (UTIL.isNotNullCheck(formOfAdminParam)) ? "coalesce(lp.form_admin,''NA'') IN (" + getStringToChar(formOfAdminParam) + ")" : null,
        (UTIL.isNotNullCheck(prdStrengthNoParam)) ? "coalesce(lp.strength,''NA'') IN (" + getStringToChar(prdStrengthNoParam) + ")" : null,
        (UTIL.isNotNullCheck(prdStrengthUnitParam)) ? "coalesce(lp.strength_unit,''NA'') IN (" + getStringToChar(prdStrengthUnitParam) + ")" : null
      ];
      // Filter out null values and join the conditions using ''AND''
      cpdQueryCount = "SELECT DISTINCT lp.record_id FROM lsmv_product_tradename lpt, lsmv_product lp WHERE " + cpdQueryConditions.filter(Boolean).join(" AND ");
    }
	
	// Build the SQL query conditions for Prod portfolio
    var prodPortfolioRecId = prodListForPortfolio.filter(Boolean).join('','');
    if (UTIL.isNotNullCheck(prodPortfolioRecId)) {
      var portfolioQueryConditions = [
        "lpt.fk_agx_product_rec_id = lp.record_id",
        "lpt.license_status = ''1''",
		"(lpt.approval_date is null OR lpt.approval_date >= TO_DATE(''" + initialReceivedDate + "'', ''Dy Mon DD YYYY HH24:MI:SS''))",
        "lp.record_id IN (" + prodPortfolioRecId + ")",
        (UTIL.isNotNullCheck(prodAppCntryParam)) ? "coalesce(lpt.COUNTRY_CODE,''NA'') IN (" + getStringToChar(prodAppCntryParam) + ")" : null
      ];

      portfolioQueryCount = "SELECT DISTINCT lp.record_id FROM lsmv_product_tradename lpt, lsmv_product lp WHERE " + portfolioQueryConditions.filter(Boolean).join(" AND ");
    }
	
	// Concat final SQL query based on Prod Group/Desc and Prod Portfolio
    var finalQueryCount = cpdQueryCount && portfolioQueryCount ? cpdQueryCount + " UNION " + portfolioQueryCount : cpdQueryCount || portfolioQueryCount || null;
    logConsole("finalQueryCount: " + finalQueryCount);
    // Use the generated SQL query for the count
    var param = new java.util.HashMap();
    var cpdMatchResults = genericCrudService.findAllByNativeQuery(finalQueryCount, null);
    if (cpdMatchResults != null) {
      for (var i = 0; i < cpdMatchResults.size(); i++) {
        finalProdListforCausality.add(cpdMatchResults.get(i))
      }
    }

  } catch (error) {
    logConsole("Exception caught in chkAgainstCPD: " + error);
  }
}
// Product related fields comparison ends here

// New Drug logic start here
var newDrugLogicParam = UTIL.isNotNullCheck(userParameters.get(''newDrug.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''newDrug.safetyReport.aerInfo.flpath'')) : null;
function checkNewDrug(currProductRecordID) {
  var isNewDrug = false;
  var prodLTNQuery = null;
  var prodLTNResult = null;
  try {
    // Check if New Drug param is not blank
    if (UTIL.isNotNullCheck(newDrugLogicParam) && UTIL.isNotNullCheck(currProductRecordID)) {
      // Build the query to fetch approval_start_date based on approval country, type and number 
	  var ltnQueryCondition = [
	  "lpt.fk_agx_product_rec_id = lp.record_id",
	  "lpt.license_status = ''1''",
	  "lpt.approval_start_date IS NOT NULL",
	  "lp.record_id IN (" + currProductRecordID + ")",
	  (UTIL.isNotNullCheck(prodAppTypeParam)) ? "coalesce(lpt.APPROVAL_TYPE,''NA'') IN (" + getStringToChar(prodAppTypeParam) + ")" : null,
      (UTIL.isNotNullCheck(prodAppCntryParam)) ? "coalesce(lpt.COUNTRY_CODE,''NA'') IN (" + getStringToChar(prodAppCntryParam) + ")" : null,
	  (UTIL.isNotNullCheck(prodAppNoParam)) ? "coalesce(lpt.APPROVAL_NO,''NA'') IN (" + getStringToChar(prodAppNoParam) + ")" : null
	  ];

      prodLTNQuery = "SELECT DISTINCT lpt.approval_start_date FROM lsmv_product_tradename lpt, lsmv_product lp WHERE " + ltnQueryCondition.filter(Boolean).join(" AND ");
      prodLTNResult = genericCrudService.findAllByNativeQuery(prodLTNQuery, null);
      logConsole("New Drug prodLTNQuery: " + prodLTNQuery);
	  logConsole("New Drug prodLTNResult: " + prodLTNResult);
      if (prodLTNResult != null && prodLTNResult.size() > 0) {
        for (var apprResultIndx = 0; apprResultIndx < prodLTNResult.size(); apprResultIndx++) {
          var approvalStartDate = prodLTNResult.get(apprResultIndx);
          // Convert approvalStartDate to JavaScript Date object
          var approvalStartDateInJS = formatter.parse(approvalStartDate);

          var dateArr = UTIL.differenceForAgeCal(approvalStartDateInJS, caseLrd);
          var diffYear = dateArr[0];
		  var diffMonth = dateArr[1];
		  var diffDays = dateArr[2];
          // Check New Drug param is Yes or No and timeDifference conditions
          if (newDrugLogicParam == ''1'' && (diffYear < 5 || (diffYear == 5 && diffMonth == 0 && diffDays == 0))) {
            isNewDrug = true;
            break;
          } else if (newDrugLogicParam == ''2'' && (diffYear > 5 || (diffYear == 5 && (diffMonth > 0 || diffDays > 0)))) {
            isNewDrug = true;
            break;
          }
        }
      } else {
        isNewDrug = true;
      }
    } else {
      isNewDrug = true;
    }
  } catch (error) {
    logConsole("Exception caught in New Drug: " + error);
  }

  return isNewDrug;
}
// New Drug logic ends here

// Product Group logic starts here
var productGroupParam = UTIL.isNotNullCheck(userParameters.get(''productGroup.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''productGroup.safetyReport.aerInfo.flpath'')) : null;
var prodGrpInclExclParam = UTIL.isNotNullCheck(userParameters.get(''productGroupInclExcl.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''productGroupInclExcl.safetyReport.aerInfo.flpath'')) : null;
var productDescParam = UTIL.isNotNullCheck(userParameters.get(''medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodGrpInclExclValue = UTIL.isNotNullCheck(prodGrpInclExclParam) ? prodGrpInclExclParam : ''1'';

// fn to fetch PPD rec id of Product Group List
var prodGroupPPDRecIdList = new java.util.ArrayList();
function prodGroupList(prdGrpParamValue) {
  // Fetch prod rec id from DB for the product group
  var prodPPDsQuery = "SELECT record_id FROM lsmv_product WHERE product_active = 1 AND product_group IN (" + prdGrpParamValue + ")";
  prodGroupPPDRecIdList = genericCrudService.findAllByNativeQuery(prodPPDsQuery, null);
}

// fn to fetch LTN or PPD rec id of Product portfolio List
var portfolioPPDRecIdList = new java.util.ArrayList();
var portfolioLTNRecIdList = new java.util.ArrayList();
function prodPortfolioList(productDescValue) {
  var ltnProtfolioQuery = "SELECT record_id FROM lsmv_product_tradename WHERE license_status = ''1'' AND record_id IN (SELECT CAST(unnest(string_to_array(tradename_search_result, '','')) AS INTEGER) FROM lsmv_product_group WHERE product_group_name IN (" + productDescValue + "))";
  portfolioLTNRecIdList = genericCrudService.findAllByNativeQuery(ltnProtfolioQuery, null);

  if (portfolioLTNRecIdList.size() == 0) {
    var ppdProtfolioQuery = "SELECT record_id FROM lsmv_product WHERE product_active = ''1'' AND record_id IN (SELECT CAST(unnest(string_to_array(product_search_result, '','')) AS INTEGER) FROM lsmv_product_group WHERE product_group_name IN (" + productDescValue + "))";
    portfolioPPDRecIdList = genericCrudService.findAllByNativeQuery(ppdProtfolioQuery, null);
  }
}

// fn to call Prod Group, Prod Portfolio functions, Prod description and load
var prdDescList = '''';
function getProdListFromParam() {
  var prodPortfolioParam = false;
  try {
    if (UTIL.isNotNullCheck(productGroupParam)) {
      var prdGrpParamValue = getStringToChar(productGroupParam);
      //If product group is selected, relevant products selected in a case will be assigned to prdGrpList array
      prodGroupList(prdGrpParamValue);
    }

    if (UTIL.isNotNullCheck(productDescParam)) {
      // If statement for Prod Desc/Portfolio
      if (productDescParam.indexOf("PROD_PORTFOLIO") != -1) {
        // Pass if Prod Desc was selected from Portfolio lookup and remove the PROD_PORTFOLIO#
        var portfolioName = productDescParam.substring(productDescParam.indexOf("#") + 1, productDescParam.length);
        var productDescValue = getStringToChar(portfolioName);
        prodPortfolioList(productDescValue);
        prodPortfolioParam = true;
      } else {
        // Pass if prod desc doesn''t have PROD_PORTFOLIO
        prdDescList = productDescParam;
      }
    }
  } catch (error) {
    logConsole(''Exception in Product loading calling Prod Group and Desc'' + error);
  }
}

// Implied Causality logic starts here
var causalityParam = UTIL.isNotNullCheck(userParameters.get(''causality.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''causality.safetyReport.aerInfo.flpath'')) : null;
var icExcludeParam = UTIL.isNotNullCheck(userParameters.get(''impliedCausality.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''impliedCausality.safetyReport.aerInfo.flpath'')) : null;
var cmyCausParam = UTIL.isNotNullCheck(userParameters.get(''companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var repCausParam = UTIL.isNotNullCheck(userParameters.get(''reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var causalityLogicParam = UTIL.isNotNullCheck(userParameters.get(''ANDOR.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''ANDOR.safetyReport.aerInfo.flpath'')) : null;
var labellingParam = UTIL.isNotNullCheck(userParameters.get(''listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var labCntryParam = UTIL.isNotNullCheck(userParameters.get(''country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;

icExcludeParam = UTIL.isNotNullCheck(icExcludeParam) ? true : false;
causalityLogicParam = UTIL.isNotNullCheck(causalityLogicParam) ? true : false;
var accountId = distributionUnit.accountId;
// Related values from account relatedness will be assigned to relatedCausalityArr
var relatedCausalityArr = [];
try {
  var relatedQuery = "SELECT TRIM(casuality_results) FROM LSMV_ACCOUNTS WHERE record_id = " + accountId + " AND NULLIF(TRIM(casuality_results),'''') IS NOT NULL";
  var relatedQueryResult = genericCrudService.findAllByNativeQuery(relatedQuery, null);
  if (relatedQueryResult != null && relatedQueryResult.size() > 0) {
	  var appParamQueryResult = String(relatedQueryResult.get(0));
    relatedCausalityArr = appParamQueryResult.split('','');
  }
} catch (error) {
  logConsole(''Exception in Account relatedness fetching DB '' + error);
}

// Related values from app param will be assigned to relatedCausalityArr
if (relatedCausalityArr.length == 0) {
try {
  var relatedQuery = "SELECT preference_value FROM lsmv_agx_appl_pref WHERE preference_name = ''CASUALITY_RESULTS''";
  var relatedQueryResult = genericCrudService.findAllByNativeQuery(relatedQuery, null);
  if (relatedQueryResult != null && relatedQueryResult.size() > 0) {
	  var appParamQueryResult = String(relatedQueryResult.get(0));
    relatedCausalityArr = appParamQueryResult.split('','');
  }
} catch (error) {
  logConsole(''Exception in Application param relatedness fetching DB '' + error);
}
}

// Fn to check the normal causality custom codelist values against the case data
labCntryParam = UTIL.isNotNullCheck(labCntryParam) ? labCntryParam.split(''|'') : [];
function checkNormalCausality(reporterCausality, companyCausality) {
  if (causalityParam == ''8001'') { // Related as per company
    return compareCaseWithParamValue(companyCausality, relatedCausalityArr);
  } else if (causalityParam == ''8002'') { // Related as per company or reporter
    return compareCaseWithParamValue(companyCausality, relatedCausalityArr) || compareCaseWithParamValue(reporterCausality, relatedCausalityArr);
  } else if (causalityParam == ''8003'') { // Not Related as per company
    return !compareCaseWithParamValue(companyCausality, relatedCausalityArr);
  } else if (causalityParam == ''8004'') { // Not Related as per company and reporter
    return !compareCaseWithParamValue(companyCausality, relatedCausalityArr) && !compareCaseWithParamValue(reporterCausality, relatedCausalityArr);
  }

  return false;
}

// Fn to check the Listedness and Country param against the case fields
function checkLabelingAndCountry(currReactRelatednessCollection) {
  if (UTIL.isNotNullCheck(labellingParam) || labCntryParam.length > 0) {
    for (var reactLabelIndex = 0; reactLabelIndex < currReactRelatednessCollection.drugReactListednessCollection.size(); reactLabelIndex++) {
      var labelling = currReactRelatednessCollection.drugReactListednessCollection.get(reactLabelIndex).listed + '''';
      var labellingCntry = currReactRelatednessCollection.drugReactListednessCollection.get(reactLabelIndex).country + '''';
      var labResult = UTIL.isNotNullCheck(labellingParam) ? (labelling == labellingParam) : true;
      var labCntryResult = UTIL.isNotNullCheck(labCntryParam) ? compareCaseWithParamValue(labellingCntry, labCntryParam) : true;
      if (labResult && labCntryResult) {
        return true;
      }
    }
  } else {
    return true;
  }
  return false;
}

// Fn to check the causality value as per IC logic
function checkCausality() {
  try {
    var compCausalityArray = UTIL.isNotNullCheck(cmyCausParam) ? cmyCausParam.split(''|'') : [];
    var repCausalityArray = UTIL.isNotNullCheck(repCausParam) ? repCausParam.split(''|'') : [];
    // 17 - Related, 08 - Not Related
    var isRelRepCauParam = compareCaseWithParamValue(''17'', repCausalityArray);
    var isNotRelRepCauParam = compareCaseWithParamValue(''08'', repCausalityArray);
    var isRelCompCauParam = compareCaseWithParamValue(''17'', compCausalityArray);
    var isNotRelCompCauParam = compareCaseWithParamValue(''08'', compCausalityArray);

    var repCausFlag = false;
    var compCausFlag = false;
    for (var drugIndex = 0; drugIndex < drugCollection.size(); drugIndex++) {
      var eachDrugRecord = drugCollection.get(drugIndex);
	  var caseDrugCharMatch = UTIL.isNotNullCheck(productCharParam) ? checkParamValue(eachDrugRecord, ''drugCharacterization'', productCharParam) : true;
      var caseDrugStudyProdTypeMatch = UTIL.isNotNullCheck(studyPrdTypeParam) ? checkParamValue(eachDrugRecord, ''studyProductType'', studyPrdTypeParam) : true;
      // Loop only for the product exists in Final product list Array
      if (finalProdListforCausality.indexOf(eachDrugRecord.productRecordID) != -1 && caseDrugCharMatch && caseDrugStudyProdTypeMatch) {

        for (var drugCausalityIndex = 0; drugCausalityIndex < eachDrugRecord.drugReactRelatednessCollection.size(); drugCausalityIndex++) {
          var currReactRelatednessCollection = eachDrugRecord.drugReactRelatednessCollection.get(drugCausalityIndex);
          var reporterCausality = currReactRelatednessCollection.reporterCausality + '''';
          var companyCausality = currReactRelatednessCollection.companyCausality + '''';

          // Check if the event is qualified for causality check
          if (eventArrList.indexOf(currReactRelatednessCollection.reaction) == -1) {
            logConsole(''Event and Product not qualified for causality check'');
            continue;
          }
		  
		  // if IC Exclude is blank, RC/CC, Noramal causality is blank and Labelling matches
          if (!icExcludeParam && UTIL.isNullCheck(cmyCausParam) && UTIL.isNullCheck(repCausParam) && UTIL.isNullCheck(causalityParam) && checkLabelingAndCountry(currReactRelatednessCollection)) {
            return true;
          }

		  // if IC Exclude and RC/CC is blank, Noramal causality is not blank and Labelling matches
		  if (!icExcludeParam && UTIL.isNullCheck(cmyCausParam) && UTIL.isNullCheck(repCausParam) && UTIL.isNotNullCheck(causalityParam) && checkNormalCausality(reporterCausality, companyCausality) && checkLabelingAndCountry(currReactRelatednessCollection)) {
			  return true;
		  }

          // Check reporter causality is 17 or 08 in IC, then checks against Appl param relatedness list otherwise case data
          if (UTIL.isNotNullCheck(reporterCausality) &&
            (((isRelRepCauParam && compareCaseWithParamValue(reporterCausality, relatedCausalityArr)) ||
                (isNotRelRepCauParam && !compareCaseWithParamValue(reporterCausality, relatedCausalityArr))) ||
              (!isRelRepCauParam && !isNotRelRepCauParam && compareCaseWithParamValue(reporterCausality, repCausalityArray)))) {
            repCausFlag = true;
          } else {
            repCausFlag = false;
          }

          // Check company causality is 17 or 08 in IC, then checks against Appl param relatedness list otherwise case data
          if (UTIL.isNotNullCheck(companyCausality) &&
            (((isRelCompCauParam && compareCaseWithParamValue(companyCausality, relatedCausalityArr)) ||
                (isNotRelCompCauParam && !compareCaseWithParamValue(companyCausality, relatedCausalityArr))) ||
              (!isRelCompCauParam && !isNotRelCompCauParam && compareCaseWithParamValue(companyCausality, compCausalityArray)))) {
            compCausFlag = true;
          } else {
            compCausFlag = false;
          }
          // IC RC/CC matches
          var causalityResult = causalityLogicParam ? (repCausFlag && compCausFlag) : (repCausFlag || compCausFlag);
          logConsole(''Causality Check icExcludeParam '' + icExcludeParam + '' causalityResult '' + causalityResult);
          logConsole(''Causality Check reporterCausality '' + reporterCausality + '' companyCausality '' + companyCausality);
		  
		  // if IC Exclude is blank, RC/CC matches and labelling matches
          if (!icExcludeParam && causalityResult && checkLabelingAndCountry(currReactRelatednessCollection)) {
            return true;
          }

          // if IC Exclude is Yes, and doesn''t match with IC RC/CC and same match with Normal Causality and Labelling
          if (icExcludeParam && UTIL.isNotNullCheck(causalityParam) && !causalityResult && checkNormalCausality(reporterCausality, companyCausality) && checkLabelingAndCountry(currReactRelatednessCollection)) {
            return true;
          }
        }
      }
    }
    return false;
  } catch (error) {
    logConsole(''Exception in checking causality checkCausality '' + error);
  }
}
// Implied Causality logic ends here

// Start of the main program
function start() {
  // load list of product related to product group and description param
  getProdListFromParam();
  logConsole(''Prod Group param prodGroupPPDRecIdList: '' + prodGroupPPDRecIdList);
  logConsole(''Prod Desc param portfolioPPDRecIdList: '' + portfolioPPDRecIdList + '' portfolioLTNRecIdList: '' + portfolioLTNRecIdList + '' prdDescList: '' + prdDescList);
  // block to check the product from param list against Drug collection and load final product list for causality
  try {
    for (var drugIndex = 0; drugIndex < drugCollection.size(); drugIndex++) {
      var currentProd = drugCollection.get(drugIndex);
      var caseDrugCharMatch = UTIL.isNotNullCheck(productCharParam) ? checkParamValue(currentProd, ''drugCharacterization'', productCharParam) : true;
      var caseDrugStudyProdTypeMatch = UTIL.isNotNullCheck(studyPrdTypeParam) ? checkParamValue(currentProd, ''studyProductType'', studyPrdTypeParam) : true;
	  
	  // Add entire drug collection if prod group and prod desc param is blank
      if (UTIL.isNullCheck(productGroupParam) && UTIL.isNullCheck(productDescParam) && UTIL.isNotNullCheck(currentProd.productRecordID)) {
        if (caseDrugCharMatch && caseDrugStudyProdTypeMatch && checkNewDrug(currentProd.productRecordID)) {
          prodListForCPD.push(currentProd.productRecordID);
		  continue;
        }
      }

      // Add to CPD list when drug record not in Prod Group list for Exclusion
      if (prodGrpInclExclValue.equals("2") && prodGroupPPDRecIdList.indexOf(currentProd.productRecordID) == -1) {
        if (caseDrugCharMatch && caseDrugStudyProdTypeMatch && checkNewDrug(currentProd.productRecordID)) {
          prodListForCPD.push(currentProd.productRecordID);
        }
      } // Add to CPD list when drug record in Prod Group list for Inclusion or Prod Desc
      else if ((prodGrpInclExclValue.equals("1") && prodGroupPPDRecIdList.indexOf(currentProd.productRecordID) != -1) || prdDescList.indexOf(currentProd.productRecordID) != -1) {
        if (caseDrugCharMatch && caseDrugStudyProdTypeMatch && checkNewDrug(currentProd.productRecordID)) {
          prodListForCPD.push(currentProd.productRecordID);
        }
      }

      // Add to final causality list when Drug prod found in Portfolio list and other prod related param matches
      if (portfolioPPDRecIdList.indexOf(currentProd.productRecordID) != -1 || portfolioLTNRecIdList.indexOf(currentProd.tradeRecId) != -1) {
        if (checkAgainstCaseDrug(currentProd) && checkNewDrug(currentProd.productRecordID)) {
          prodListForPortfolio.push(currentProd.productRecordID);
        }
      }
    }
  } catch (error) {
    logConsole(''Exception in loading prod rec id to the list: '' + error);
  }

  // Add to final causality which matches the CPD data
  logConsole(''Prod List for CPD prodListForCPD: '' + prodListForCPD);
  logConsole(''Prod List for CPD prodListForPortfolio: '' + prodListForPortfolio);
  if ((prodListForCPD != null && prodListForCPD.length>0) || (prodListForPortfolio != null && prodListForPortfolio.length>0)) {
    chkAgainstCPD();
  }
  logConsole(''Final Prod List for Causality finalProdListforCausality: '' + finalProdListforCausality);
  // Block to check product size and event size and check against causality values
  try {
    // Load qualified Events to eventArrList when final Product list is not empty
    logConsole(''Final List finalProdListforCausality: '' + finalProdListforCausality.size());
    if (finalProdListforCausality.size() > 0) {
      chkEventDetailsAndLoad();
      logConsole(''Final Event List eventArrList: '' + eventArrList.size());
    }
    // Checks causality logic for qualified product and event
    if (eventArrList.size() > 0) {
      if (checkCausality()) {
        rule.put("ruleExecutionResult", "true");
        logConsole(''RULE PASSED'');
      } else {
        rule.put("ruleExecutionResult", "false");
        logConsole(''RULE FAILED'');
      }
    } else {
      rule.put("ruleExecutionResult", "false");
      logConsole(''RULE FAILED'');
    }
  } catch (error) {
    logConsole(''Exception in looping Final Product list/Event Fn: '' + error);
  }
}

start();
// End of the main program
logConsole(''Execution Completed'');','DistributionRule','Custom JavaScript for Implied Causality','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5001_2',NULL,'Distribution');

----------------DR5001 ends

INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SPHT',NULL,'reactionCollection$patient.safetyReport.aerInfo','Y','(C0)','{"recordId":"1724164383612","childConditions":[{"recordId":"1724164485583","refRuleConditionId":"1724164387961"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Serious Public Health Threat Equals Yes","rhsSameCtx":"N","index":"0","rhsConst":"Yes","rhsField":"1","nfMarked":"N","operator":"Equals","recordId":"1724164387961","lhsField":"seriousPublicHealthThreat.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"R","rhsFilterConddLogic":"N","lhsFieldString":"Serious Public Health Threat","unitFieldPath":"N"}]','','N','N',NULL,'DistributionRule','','{"adhocRules":[],"paramMap":{}}','','Y','Frozen','DR5002',NULL,'Distribution');



INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name)
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_RETRO_SURVEY_OF_INFECTION',NULL,'','Y','(C1)','{"recordId":"1574780069464","childConditions":[{"recordId":"1574780148351","refRuleConditionId":"1574780092913"}],"operator":"OR"}','[{"recordId":"1574780092913","anyOneLhs":"N","parameterizedRhs":"N","lhsField":"retroSurveyOfInfection.summary.patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Retrospective survey of infection Equals null","index":"1","rhsConst":"null","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Retrospective survey of infection","operator":"Equals"}]',NULL,'N','N','','DistributionRule','This attribute checks whether retrospective survery of infection is null','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5062','Y','Distribution');


INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name)
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_COUNTRY_PUBLISHED',NULL,'researchReportCollection$safetyReport.aerInfo','Y','(C1)','{"recordId":"1574780069464","childConditions":[{"recordId":"1574780148351","refRuleConditionId":"1574780092913"}],"operator":"OR"}','[{"parameterizedRhs":"N","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Country published Equals null","index":"1","rhsConst":"null","nfMarked":"N","operator":"Equals","recordId":"1574780092913","anyOneLhs":"N","lhsField":"countryPublished.researchReportCollection$safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Country published"}]',NULL,'N','N','','DistributionRule','This attribute checks whether Country Published is null','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5063','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name)
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_CLINICAL_CLASSIFICATION',NULL,'clinicalClassificationCollection$safetyReport.aerInfo','Y','(C1)','{"recordId":"1574780069464","childConditions":[{"recordId":"1574780148351","refRuleConditionId":"1574780092913"}],"operator":"OR"}',E'[{"parameterizedRhs":"N","lhsFieldcodelistId":"9958","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Clinical\\/non-clinical classification Equals null","index":"1","rhsConst":"null","nfMarked":"N","operator":"Equals","recordId":"1574780092913","anyOneLhs":"N","lhsField":"clinicalYesOrNo.clinicalClassificationCollection$safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Clinical\\/non-clinical classification"}]',NULL,'N','N','','DistributionRule','This attribute checks whether clinical/non-clinical classification is null','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5064','Y','Distribution');

---DR5065
INSERT INTO LSMV_RULE_DETAILS( record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES(NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_MANUAL_SUBMISSION',NULL,NULL,'Y','()','{"recordId":"1651832219860","operator":"AND"}','[{"parameterizedRhs":"N","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Count(Receipt No) Equals 0","index":"1","rhsConst":"0","nfMarked":"N","operator":"Equals","recordId":"1651832247609","anyOneLhs":"N","lhsField":"receiptNo.receiptItem.flpath","lhsFunc":"Count","rhsFilterConddLogic":"N","lhsFieldString":"Receipt No"}]',NULL,'N','N','','DistributionRule','This attribute is a dummy and will always fail. This is to be mapped to inactive anchors.','{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5065','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SCRIPTED_MATRIX',NULL,NULL,'Y','(C2)','{"recordId":"1692185582972","childConditions":[{"recordId":"1692185612854","refRuleConditionId":"1688627378270"}],"operator":"AND"}','[{"recordId":"1688627353954","anyOneLhs":"N","parameterizedRhs":"N","referenceRuleName":"USER_SCRIPTED_MATRIX_PARAM","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_SCRIPTED_MATRIX_PARAM","referenceRuleID":"DR5008_1","index":"1","nfMarked":"N","rhsFilterConddLogic":"N"},{"recordId":"1688627378270","anyOneLhs":"N","parameterizedRhs":"N","referenceRuleName":"USER_SCRIPTED_MATRIX_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_SCRIPTED_MATRIX_JS","referenceRuleID":"DR5008_2","index":"2","nfMarked":"N","rhsFilterConddLogic":"N"}]',NULL,'N','N',NULL,'DistributionRule','DR5008:USER_SCRIPTED_MATRIX','{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MAH As Coded","fieldId":"954003"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Authorization Number","fieldPath":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Authorization Number","fieldId":"954006"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_9159":{"codelistId":"9159","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"}],"fieldId":"150103"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Causality","fieldId":"102112"},"CL_8202_tiken.safetyReport.aerInfo.flpath":{"codelistId":"8202","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Tiken","fieldPath":"tiken.safetyReport.aerInfo.flpath","parameterName":"Tiken","fieldId":"102113"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"}}}',NULL,'Y','Frozen','DR5008','Y','Distribution');



INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SCRIPTED_MATRIX_PARAM',NULL,'reactionCollection$patient.safetyReport.aerInfo|drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo|drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo','Y','()','{"recordId":"1682513041605","operator":"AND"}','[{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Death? In ?","index":"1","nfMarked":"N","operator":"In","recordId":"1682514065782","anyOneLhs":"N","lhsField":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Death?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8008","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Study Product Type In ?","index":"2","nfMarked":"N","operator":"In","recordId":"1682514090811","anyOneLhs":"N","lhsField":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Study Product Type"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1013","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Characterization In ?","index":"3","nfMarked":"N","operator":"In","recordId":"1682514091702","anyOneLhs":"N","lhsField":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Characterization"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"9159","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Labelling In ?","index":"4","nfMarked":"N","operator":"In","recordId":"1682514296331","anyOneLhs":"N","lhsField":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Labelling"},{"recordId":"1682514441758","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Country In ?","index":"5","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Country","operator":"In"},{"recordId":"1682514442839","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"MAH As Coded In ?","index":"6","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"MAH As Coded","operator":"In"},{"recordId":"1682514444449","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Authorization Number In ?","index":"7","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Authorization Number","operator":"In"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"709","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Approval Type In ?","index":"8","nfMarked":"N","operator":"In","recordId":"1682514456591","anyOneLhs":"N","lhsField":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD Approval Type"},{"recordId":"1683289370020","anyOneLhs":"N","parameterizedRhs":"Y","lhsField":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product description In ?","index":"9","nfMarked":"N","rhsFilterConddLogic":"N","lhsFieldString":"Product description","operator":"In"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Authorization Country In ?","index":"10","nfMarked":"N","operator":"In","recordId":"1683537829297","anyOneLhs":"N","lhsField":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD Authorization Country"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Seriousness In ?","index":"11","nfMarked":"N","operator":"In","recordId":"1683537851916","anyOneLhs":"N","lhsField":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Seriousness"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Life Threatening? In ?","index":"12","nfMarked":"N","operator":"In","recordId":"1683537877216","anyOneLhs":"N","lhsField":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Life Threatening?"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8201","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Causality In ?","index":"13","nfMarked":"N","operator":"In","recordId":"1684485770772","anyOneLhs":"N","lhsField":"causality.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Causality"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Tiken available In ?","index":"14","nfMarked":"N","operator":"In","recordId":"1684485770773","anyOneLhs":"N","lhsField":"tiken.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Tiken available"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"5015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Flag In ?","index":"15","nfMarked":"N","operator":"In","recordId":"1684485770774","anyOneLhs":"N","lhsField":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Flag"}]',NULL,'N','N',NULL,'DistributionRule','DR5008_1:USER_SCRIPTED_MATRIX_PARAM','{"SMQCMQ_LIST":"","adhocRules":[],"paramMap":{"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"MAH As Coded","fieldId":"954003"},"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"Authorization Number","fieldPath":"approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Authorization Number","fieldId":"954006"},"CL_1002_seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_9159":{"codelistId":"9159","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"}],"fieldId":"150103"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Causality","fieldId":"102112"},"CL_8202_tiken.safetyReport.aerInfo.flpath":{"codelistId":"8202","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Tiken","fieldPath":"tiken.safetyReport.aerInfo.flpath","parameterName":"Tiken","fieldId":"102113"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"}}}',NULL,'Y','Frozen','DR5008_1',NULL,'Distribution');


INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SCRIPTED_MATRIX_JS',NULL,NULL,'Y','()','{"recordId":"1682513020945","operator":"AND"}',NULL,NULL,'Y','N',E'//////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------------------------------
//              All Rights Reserved.
//
//              This software is the confidential and proprietary information of PharmApps, LLC.
//              (Confidential Information).
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name    :  USER_SCRIPTED_MATRIX.js
//-------------------------------------------------------------------------------------------------------
// Description  :  This script is a custom distribution attribute to Product Event Labelling Causality Combinations.
// File History :  1.0
// Created By   :  Vinay T R
// Date         :  12-DEC-2023
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  2.0
// Modified By  :  Vinay T R
// Date         :  09-JAN-2024
// Modified Desc:  Multiple Events with causality and Labelling issue fixed.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  3.0
// Modified By  :  Vinay T R
// Date         :  24-FEB-2024
// Modified Desc:  Product Flag value would be considered at CPD Level not from Case level 
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  4.0
// Modified By  :  Vinay T R
// Date         :  28-FEB-2024
// Modified Desc:  Tiken Param checked using Custom Codelist 8202 with CPD Product Flag.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  5.0
// Modified By  :  Vinay T R
// Date         :  05-MAR-2024
// Modified Desc:  Event Map loaded for Labelling and Causality Validations.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  6.0
// Modified By  :  Vinay T R
// Date         :  06-MAR-2024
// Modified Desc:  Handled scenario to check other CPD Fields when Tiken available? is NOT APPLICABLE-8003
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////

var ruleName = ''USER_SCRIPTED_MATRIX'';
var logFlag = false;

//Case level values
var initialReceivedDate = inboundMessage.aerInfo.safetyReport.receiveDate;
var receiptNum = inboundMessage.receiptItem.receiptNo;
var caseSeriouness = inboundMessage.aerInfo.safetyReport.seriousnessAsPerCompany;

//Product Characteristics  | Product Flag | Product Desc | Study Product Type 
var prodCharParam = userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'');
var prodFlagParam = userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'');
var prodDescParam = userParameters.get(''medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath'');
var studyProdTypeParam = userParameters.get(''studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath'');

//CPD level Fields : Approval Type | Approval Number | Authorization Country | MAH 
var approvalTypeParam = userParameters.get(''cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');
var approvalCtryParam = userParameters.get(''cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');
var mahParam = userParameters.get(''mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');
var approvalNoParam = userParameters.get(''approvalNo.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');

//Event related Fields : Seriousness | Death | Life Threating
var seriousnessParam = userParameters.get(''seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath'');
var deathParam = userParameters.get(''death.reactionCollection$patient.safetyReport.aerInfo.flpath'');
var ltParam = userParameters.get(''lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath'');

//Labelling and Labelling Country
var labParam = userParameters.get(''listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');
var labCtryParam = userParameters.get(''country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');

//Causality : Custom Codelist ID: 8201 with all 4 Param Values
var causalityParam = userParameters.get(''causality.safetyReport.aerInfo.flpath'');

//Tiken available? : Using Custom Codelist 8202 - BLANK-8001, NOT BLANK -8002 ,NOT APPLICABLE-8003
var tikenParam = userParameters.get(''tiken.safetyReport.aerInfo.flpath'');

var eventMap = new java.util.HashMap();
var relatedCodesArray = [];
var unrelatedCodesArray = [];
var relatedAccountCodesArray = [];
var unrelatedAccountCodesArray = [];
var caseSeriousFlag = null;

if (caseSeriouness != null) {
  caseSeriousFlag = (caseSeriouness == ''1'') ? ''true'' : ''false'';
}

try {
  logConsole("CUSTOM JAVASCRIPT EXECUTION START............");
  var prodCollection = inboundMessage.aerInfo.safetyReport.patient.drugCollection;
  var eventCollection = inboundMessage.aerInfo.safetyReport.patient.reactionCollection;
  loadEventMap();
  loadcausalityRelatedMap();
  loadcausalityUnRelatedMap();
  loadcausalityAccountRelatedMap();
  loadcausalityAccountUnRelatedMap();
  checkCombFields();
} catch (error) {
  logConsole("Exception caught in Main Block::" + error);
}

function loadEventMap() {
  var eachEvent = '''';
  if (!isEmptyAndNull(eventCollection)) {
    for (var eventIndex = 0; eventIndex < eventCollection.size(); eventIndex++) {
      eachEvent = eventCollection.get(eventIndex);
      eventMap.put(eachEvent.recordId, eachEvent);
    }
  }
}

function logConsole(message) {
  if (logFlag) {
    UTIL.getLogger().error(receiptNum + '': '' + ruleName + '': '' + message);
  }
}

function compareCaseWithParamValue(caseData, paramList) {
  var status = false;
  if (!isEmptyAndNull(caseData) && !isEmptyAndNull(paramList)) {
    for (var i = 0; i < paramList.length; i++) {
      if (caseData == paramList[i]) {
        status = true;
        break;
      }
    }
  }
  return status;
}

function convertToArray(inputParam) {
  var inputParamArray = null;
  var inputParamString = null;
  if (!isEmptyAndNull(inputParam)) {
    inputParamString = String(inputParam);
    if (!isEmptyAndNull(inputParamString)) {
      inputParamArray = inputParamString.split("|");
    }
  }
  return inputParamArray;
}

function isEmptyAndNull(inputString) {
  if (inputString != null && inputString != ''undefined'' && inputString != '''') {
    return false;
  } else {
    return true;
  }
}

function getTextFromArray(inputArray) {
  var inputTxt = '''';
  if (!isEmptyAndNull(inputArray)) {
    for (var arrayIndex = 0; arrayIndex < inputArray.length; arrayIndex++) {
      if (arrayIndex == 0) {
        inputTxt = "''" + inputArray[arrayIndex] + "''";
      } else {
        inputTxt += "," + "''" + inputArray[arrayIndex] + "''";
      }
    }
  }
  return inputTxt;
}

function checkCombFields() {
  var isProdCharMatched = false;
  var isStudyProdTypeMatched = false;
  var isCPDMahAppTyCuntry = false;
  var isSeriousDeathLT = false;
  var isCausalityMatched = false;
  var isProdDescMatched = false;
  var currentProd = null;
  try {
    if (!isEmptyAndNull(prodCollection)) {
      for (var drugIndex = 0; drugIndex < prodCollection.size(); drugIndex++) {
        currentProd = prodCollection.get(drugIndex);
        isProdCharMatched = getProdChar(currentProd);
        isStudyProdTypeMatched = getStudyProductType(currentProd);
        isProdDescMatched = checkProdDesc(currentProd);
        isCPDMahAppTyCuntry = getcpdAll(currentProd);
        isCausalityMatched = getCausalityFields(currentProd);        
        if (isProdCharMatched && isStudyProdTypeMatched &&
          isCPDMahAppTyCuntry && isCausalityMatched &&
          isProdDescMatched) {
          break;
        }
      }
      isSeriousDeathLT = getEventSpecificDetails();
    }   

    if (isProdCharMatched && isProdDescMatched && isStudyProdTypeMatched &&
      isCPDMahAppTyCuntry && isCausalityMatched && isSeriousDeathLT) {
      rule.put("ruleExecutionResult", "true");
      logConsole(''RULE PASSED'');
    } else {
      rule.put("ruleExecutionResult", "false");
      logConsole(''RULE FAILED'');
    }
  } catch (error) {
    logConsole("Exception caught in checkCombFields()::" + error);
  }
}


function getProdChar(currentProd) {
  var isValidDrugChar = false;
  var prodCharParamValueArray = null;
  var curProdCharCaseValue = null;
  if (isEmptyAndNull(prodCharParam)) {
    isValidDrugChar = true;
  } else if (!isEmptyAndNull(prodCharParam)) {
    prodCharParamValueArray = convertToArray(prodCharParam);
    curProdCharCaseValue = currentProd.drugCharacterization;
    if (!isEmptyAndNull(curProdCharCaseValue) &&
      !isEmptyAndNull(prodCharParamValueArray)) {
      isValidDrugChar = compareCaseWithParamValue(curProdCharCaseValue, prodCharParamValueArray);
    }
  }
  return isValidDrugChar;
}

function getStudyProductType(currentProd) {
  var isValidStudyProdType = false;
  var StudyProdTypeParamValueArray = '''';
  var curStudyProdTypeCaseValue = '''';
  if (isEmptyAndNull(studyProdTypeParam)) {
    isValidStudyProdType = true;
  } else if (!isEmptyAndNull(studyProdTypeParam)) {
    StudyProdTypeParamValueArray = convertToArray(studyProdTypeParam);
    curStudyProdTypeCaseValue = currentProd.studyProductType;
    if (!isEmptyAndNull(curStudyProdTypeCaseValue) &&
      !isEmptyAndNull(StudyProdTypeParamValueArray)) {
      isValidStudyProdType = compareCaseWithParamValue(
        curStudyProdTypeCaseValue, StudyProdTypeParamValueArray);
    }
  }
  return isValidStudyProdType;
}

function getEventSpecificDetails() {
  var isSeriounessAndLtOrDeathEvent = false;

  if (!isEmptyAndNull(eventCollection)) {
    for (var eventIndex = 0; eventIndex < eventCollection.size(); eventIndex++) {
      var currentEvent = eventCollection.get(eventIndex);
      isSeriounessAndLtOrDeathEvent = getAllEventCheck(currentEvent);
      if (isSeriounessAndLtOrDeathEvent) {
        break;
      }
    }
  }

  return isSeriounessAndLtOrDeathEvent;
}

function getcpdAll(currentProd) {
  var cpdFinalResult = false;
  try {
    if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(tikenParam)) {
      cpdFinalResult = true;
    } else {
      var mahValue = null;
      var mahArray = null;
      var mahText = null;
      var appTypeArray = null;
      var appCountryArray = null;
      var approvalType = null;
      var approvalCountry = null;
      var approvalNoValue = null;
      var approvalNoArray = null;
      var approvalNoText = null;
      var prodFlagParamValueArray = null;
      var prodFlagParamValue = null;

      if (!isEmptyAndNull(mahParam)) {
        mahValue = String(mahParam);
        mahValue = mahValue.toUpperCase();
        mahArray = convertToArray(mahValue);
        mahText = getTextFromArray(mahArray);
      }

      if (!isEmptyAndNull(approvalTypeParam)) {
        appTypeArray = convertToArray(approvalTypeParam);
        approvalType = getTextFromArray(appTypeArray);
      }

      if (!isEmptyAndNull(approvalCtryParam)) {
        appCountryArray = convertToArray(approvalCtryParam);
        approvalCountry = getTextFromArray(appCountryArray);
      }

      if (!isEmptyAndNull(approvalNoParam)) {
        approvalNoValue = String(approvalNoParam);
        approvalNoValue = approvalNoValue.toUpperCase();
        approvalNoArray = convertToArray(approvalNoValue);
        approvalNoText = getTextFromArray(approvalNoArray);
      }

      if (!isEmptyAndNull(prodFlagParam)) {
        prodFlagParamValueArray = convertToArray(prodFlagParam);
        prodFlagParamValue = getTextFromArray(prodFlagParamValueArray);
      }

      cpdFinalResult = getcpdSingleCombScenarios(currentProd, mahText, approvalType, approvalCountry, approvalNoText, prodFlagParamValue);
    }
  } catch (msg) {
    logConsole(''Exception occurred in getcpdAll() :'' + msg);
  }
  return cpdFinalResult;
}

function getcpdSingleCombScenarios(currentProd, mahText, approvalType, approvalCountry, approvalNoText, prodFlagParamValue) {
  var cpdCombResult = false;
  var isMahPresent = false;
  var isapprovalTypePresent = false;
  var isapprovalCtryPresent = false;
  var isapprovalNoPresent = false;
  var isMahapprovalNoPresent = false;
  var iscpdAppTypeNoCntryPresent = false;
  var iscpdAppNoCntryPresent = false;
  var iscpdAppTypeNoPresent = false;
  var iscpdMahAppTypeNoPresent = false;
  var iscpdMahAppCntryPresent = false;
  var iscpdMahAppTypePresent = false;
  var iscpdAppTypeCntryPresent = false;
  var iscpdMahAppTypeNoCntryPresent = false;
  var isCpdMahAppCntryTypePresent = false;

  var isMahPassed = !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var isapprovalTypePassed = isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var isapprovalCtryPassed = isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var isapprovalNoPassed = isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var isMahapprovalNoPassed = !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdMahAppTypePassed = !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdMahAppCntryPassed = !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdMahAppTypeNoPassed = !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var isCpdMahAppCntryTypePassed = !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdMahAppTypeNoCntryPassed = !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdAppTypeNoPassed = isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdAppNoCntryPassed = isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdAppTypeNoCntryPassed = isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);
  var iscpdAppTypeCntryPassed = isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);

  //Added newly to include missing combination and CPD Product Flag.
  var isCpdMahAuthNumAppCntryPresent = false;
  var isCpdMahAuthNumAppCntryPassed = !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam);

  var isProdFlagPresent = false;
  var isProdFlagPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahPresent = false;
  var isCpdProdFlagMahPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAppTypePresent = false;
  var isCpdProdFlagAppTypePassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthCuntryPresent = false;
  var isCpdProdFlagAuthCuntryPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthNumPresent = false;
  var isCpdProdFlagAuthNumPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAppTypePresent = false;
  var isCpdProdFlagMahAppTypePassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAuthCuntryPresent = false;
  var isCpdProdFlagMahAuthCuntryPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAuthNumPresent = false;
  var isCpdProdFlagMahAuthNumPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAppTypeAuthCuntryPresent = false;
  var isCpdProdFlagAppTypeAuthCuntryPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAppTypeAuthNumPresent = false;
  var isCpdProdFlagAppTypeAuthNumPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthCuntryAuthNumPresent = false;
  var isCpdProdFlagAuthCuntryAuthNumPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthCuntryAuthNumMahPresent = false;
  var isCpdProdFlagAuthCuntryAuthNumMahPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthCuntryAuthNumAppTypePresent = false;
  var isCpdProdFlagAuthCuntryAuthNumAppTypePassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAuthNumAppTypePresent = false;
  var isCpdProdFlagMahAuthNumAppTypePassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAppTypeAuthCuntryPresent = false;
  var isCpdProdFlagMahAppTypeAuthCuntryPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagMahAuthCuntryAuthNumPresent = false;
  var isCpdProdFlagMahAuthCuntryAuthNumPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  var isCpdProdFlagAuthCuntryAuthNumMahAuthTypePresent = false;
  var isCpdProdFlagAuthCuntryAuthNumMahAuthTypePassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(mahParam) && !isEmptyAndNull(approvalTypeParam) && !isEmptyAndNull(approvalCtryParam) && !isEmptyAndNull(approvalNoParam);

  if (!isEmptyAndNull(tikenParam) && !isEmptyAndNull(prodCollection) && prodCollection.size() > 0) {
    tikenParam = String(tikenParam);
    if (tikenParam == ''8001'' || tikenParam == ''8002'') {
      if (isMahPassed) {
        isMahPresent = getcpdMahTiken(currentProd, mahText, tikenParam);
      } else if (isapprovalTypePassed) {
        isapprovalTypePresent = getcpdAppTypeTiken(currentProd, approvalType, tikenParam);
      } else if (isapprovalCtryPassed) {
        isapprovalCtryPresent = getcpdAppCntryTiken(currentProd, approvalCountry, tikenParam);
      } else if (isapprovalNoPassed) {
        isapprovalNoPresent = getcpdAppNoTiken(currentProd, approvalNoText, tikenParam);
      } else if (isMahapprovalNoPassed) {
        isMahapprovalNoPresent = getcpdMahAppNoTiken(currentProd, mahText, approvalNoText, tikenParam);
      } else if (iscpdAppTypeNoPassed) {
        iscpdAppTypeNoPresent = getcpdAppTypeNoTiken(currentProd, approvalType, approvalNoText, tikenParam);
      } else if (iscpdMahAppTypeNoPassed) {
        iscpdMahAppTypeNoPresent = getcpdMahAppTypeNoTiken(currentProd, mahText, approvalType, approvalNoText, tikenParam);
      } else if (iscpdAppNoCntryPassed) {
        iscpdAppNoCntryPresent = getcpdAppNoCntryTiken(currentProd, approvalNoText, approvalCountry, tikenParam);
      } else if (iscpdAppTypeNoCntryPassed) {
        iscpdAppTypeNoCntryPresent = getcpdAppTypeNoCntryTiken(currentProd, approvalType, approvalNoText, approvalCountry, tikenParam);
      } else if (iscpdMahAppTypeNoCntryPassed) {
        iscpdMahAppTypeNoCntryPresent = getcpdMahAppTypeNoCntryTiken(currentProd, mahText, approvalType, approvalNoText, approvalCountry, tikenParam);
      } else if (iscpdAppTypeCntryPassed) {
        iscpdAppTypeCntryPresent = getcpdAppTypeCntryTiken(currentProd, approvalType, approvalCountry, tikenParam);
      } else if (iscpdMahAppTypePassed) {
        iscpdMahAppTypePresent = getcpdMahAppTypeTiken(currentProd, mahText, approvalType, tikenParam);
      } else if (iscpdMahAppCntryPassed) {
        iscpdMahAppCntryPresent = getcpdMahAppCntryTiken(currentProd, mahText, approvalCountry, tikenParam);
      } else if (isCpdMahAppCntryTypePassed) {
        isCpdMahAppCntryTypePresent = getcpdMahAppCntryTypeTiken(currentProd, mahText, approvalType, approvalCountry, tikenParam);
      } else if (isCpdMahAuthNumAppCntryPassed) { //Added newly to include missing comb and CPD Product Flag.
        isCpdMahAuthNumAppCntryPresent = getCpdMahAuthNumAppCntryTiken(currentProd, mahText, approvalNoText, approvalCountry, tikenParam);
      } else if (isProdFlagPassed) {
        isProdFlagPresent = getCpdProdFlagTiken(currentProd, prodFlagParamValue, tikenParam);
      } else if (isCpdProdFlagMahPassed) {
        isCpdProdFlagMahPresent = getCpdProdFlagMahTiken(currentProd, prodFlagParamValue, mahText, tikenParam);
      } else if (isCpdProdFlagAppTypePassed) {
        isCpdProdFlagAppTypePresent = getCpdProdFlagAppTypeTiken(currentProd, prodFlagParamValue, approvalType, tikenParam);
      } else if (isCpdProdFlagAuthCuntryPassed) {
        isCpdProdFlagAuthCuntryPresent = getCpdProdFlagAuthCuntryTiken(currentProd, prodFlagParamValue, approvalCountry, tikenParam);
      } else if (isCpdProdFlagAuthNumPassed) {
        isCpdProdFlagAuthNumPresent = getCpdProdFlagAuthNumTiken(currentProd, prodFlagParamValue, approvalNoText, tikenParam);
      } else if (isCpdProdFlagMahAppTypePassed) {
        isCpdProdFlagMahAppTypePresent = getCpdProdFlagMahAppTypeTiken(currentProd, prodFlagParamValue, mahText, approvalType, tikenParam);
      } else if (isCpdProdFlagMahAuthCuntryPassed) {
        isCpdProdFlagMahAuthCuntryPresent = getCpdProdFlagMahAuthCuntryTiken(currentProd, prodFlagParamValue, mahText, approvalCountry, tikenParam);
      } else if (isCpdProdFlagMahAuthNumPassed) {
        isCpdProdFlagMahAuthNumPresent = getCpdProdFlagMahAuthNumTiken(currentProd, prodFlagParamValue, mahText, approvalNoText, tikenParam);
      } else if (isCpdProdFlagAppTypeAuthCuntryPassed) {
        isCpdProdFlagAppTypeAuthCuntryPresent = getCpdProdFlagAppTypeAuthCuntryTiken(currentProd, prodFlagParamValue, approvalType, approvalCountry, tikenParam);
      } else if (isCpdProdFlagAppTypeAuthNumPassed) {
        isCpdProdFlagAppTypeAuthNumPresent = getCpdProdFlagAppTypeAuthNumTiken(currentProd, prodFlagParamValue, approvalType, approvalNoText, tikenParam);
      } else if (isCpdProdFlagAuthCuntryAuthNumPassed) {
        isCpdProdFlagAuthCuntryAuthNumPresent = getCpdProdFlagAuthCuntryAuthNumTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, tikenParam);
      } else if (isCpdProdFlagAuthCuntryAuthNumMahPassed) {
        isCpdProdFlagAuthCuntryAuthNumMahPresent = getCpdProdFlagAuthCuntryAuthNumMahTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, tikenParam);
      } else if (isCpdProdFlagAuthCuntryAuthNumAppTypePassed) {
        isCpdProdFlagAuthCuntryAuthNumAppTypePresent = getCpdProdFlagAuthCuntryAuthNumAppTypeTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, approvalType, tikenParam);
      } else if (isCpdProdFlagMahAuthNumAppTypePassed) {
        isCpdProdFlagMahAuthNumAppTypePresent = getCpdProdFlagMahAuthNumAppTypeTiken(currentProd, prodFlagParamValue, mahText, approvalNoText, approvalType, tikenParam);
      } else if (isCpdProdFlagMahAppTypeAuthCuntryPassed) {
        isCpdProdFlagMahAppTypeAuthCuntryPresent = getCpdProdFlagMahAppTypeAuthCuntryTiken(currentProd, prodFlagParamValue, mahText, approvalType, approvalCountry, tikenParam);
      } else if (isCpdProdFlagMahAuthCuntryAuthNumPassed) {
        isCpdProdFlagMahAuthCuntryAuthNumPresent = getCpdProdFlagMahAuthCuntryAuthNumTiken(currentProd, prodFlagParamValue, mahText, approvalCountry, approvalNoText, tikenParam);
      } else if (isCpdProdFlagAuthCuntryAuthNumMahAuthTypePassed) {
        isCpdProdFlagAuthCuntryAuthNumMahAuthTypePresent = getCpdProdFlagAuthCuntryAuthNumMahAuthTypeTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, approvalType, tikenParam);
      }
    }
  } 
  if (!isEmptyAndNull(prodCollection) && prodCollection.size() > 0 && (isNull(tikenParam) || (!isEmptyAndNull(tikenParam) && tikenParam == ''8003''))) {    
	if (isMahPassed) {
      isMahPresent = getcpdMah(currentProd, mahText);
    } else if (isapprovalTypePassed) {
      isapprovalTypePresent = getcpdAppType(currentProd, approvalType);
    } else if (isapprovalCtryPassed) {
      isapprovalCtryPresent = getcpdAppCntry(currentProd, approvalCountry);
    } else if (isapprovalNoPassed) {
      isapprovalNoPresent = getcpdAppNo(currentProd, approvalNoText);
    } else if (isMahapprovalNoPassed) {
      isMahapprovalNoPresent = getcpdMahAppNo(currentProd, mahText, approvalNoText);
    } else if (iscpdAppTypeNoPassed) {
      iscpdAppTypeNoPresent = getcpdAppTypeNo(currentProd, approvalType, approvalNoText);
    } else if (iscpdMahAppTypeNoPassed) {
      iscpdMahAppTypeNoPresent = getcpdMahAppTypeNo(currentProd, mahText, approvalType, approvalNoText);
    } else if (iscpdAppNoCntryPassed) {
      iscpdAppNoCntryPresent = getcpdAppNoCntry(currentProd, approvalNoText, approvalCountry);
    } else if (iscpdAppTypeNoCntryPassed) {
      iscpdAppTypeNoCntryPresent = getcpdAppTypeNoCntry(currentProd, approvalType, approvalNoText, approvalCountry);
    } else if (iscpdMahAppTypeNoCntryPassed) {
      iscpdMahAppTypeNoCntryPresent = getcpdMahAppTypeNoCntry(currentProd, mahText, approvalType, approvalNoText, approvalCountry);
    } else if (iscpdAppTypeCntryPassed) {
      iscpdAppTypeCntryPresent = getcpdAppTypeCntry(currentProd, approvalType, approvalCountry);
    } else if (iscpdMahAppTypePassed) {
      iscpdMahAppTypePresent = getcpdMahAppType(currentProd, mahText, approvalType);
    } else if (iscpdMahAppCntryPassed) {
      iscpdMahAppCntryPresent = getcpdMahAppCntry(currentProd, mahText, approvalCountry);
    } else if (isCpdMahAppCntryTypePassed) {
      isCpdMahAppCntryTypePresent = getcpdMahAppCntryType(currentProd, mahText, approvalType, approvalCountry);
    } else if (isCpdMahAuthNumAppCntryPassed) { //Added newly to include missing comb and CPD Product Flag.
      isCpdMahAuthNumAppCntryPresent = getCpdMahAuthNumAppCntry(currentProd, mahText, approvalNoText, approvalCountry);
    } else if (isProdFlagPassed) {
      isProdFlagPresent = getCpdProdFlag(currentProd, prodFlagParamValue);
    } else if (isCpdProdFlagMahPassed) {
      isCpdProdFlagMahPresent = getCpdProdFlagMah(currentProd, prodFlagParamValue, mahText);
    } else if (isCpdProdFlagAppTypePassed) {
      isCpdProdFlagAppTypePresent = getCpdProdFlagAppType(currentProd, prodFlagParamValue, approvalType);
    } else if (isCpdProdFlagAuthCuntryPassed) {
      isCpdProdFlagAuthCuntryPresent = getCpdProdFlagAuthCuntry(currentProd, prodFlagParamValue, approvalCountry);
    } else if (isCpdProdFlagAuthNumPassed) {
      isCpdProdFlagAuthNumPresent = getCpdProdFlagAuthNum(currentProd, prodFlagParamValue, approvalNoText);
    } else if (isCpdProdFlagMahAppTypePassed) {
      isCpdProdFlagMahAppTypePresent = getCpdProdFlagMahAppType(currentProd, prodFlagParamValue, mahText, approvalType);
    } else if (isCpdProdFlagMahAuthCuntryPassed) {
      isCpdProdFlagMahAuthCuntryPresent = getCpdProdFlagMahAuthCuntry(currentProd, prodFlagParamValue, mahText, approvalCountry);
    } else if (isCpdProdFlagMahAuthNumPassed) {
      isCpdProdFlagMahAuthNumPresent = getCpdProdFlagMahAuthNum(currentProd, prodFlagParamValue, mahText, approvalNoText);
    } else if (isCpdProdFlagAppTypeAuthCuntryPassed) {
      isCpdProdFlagAppTypeAuthCuntryPresent = getCpdProdFlagAppTypeAuthCuntry(currentProd, prodFlagParamValue, approvalType, approvalCountry);
    } else if (isCpdProdFlagAppTypeAuthNumPassed) {
      isCpdProdFlagAppTypeAuthNumPresent = getCpdProdFlagAppTypeAuthNum(currentProd, prodFlagParamValue, approvalType, approvalNoText);
    } else if (isCpdProdFlagAuthCuntryAuthNumPassed) {
      isCpdProdFlagAuthCuntryAuthNumPresent = getCpdProdFlagAuthCuntryAuthNum(currentProd, prodFlagParamValue, approvalCountry, approvalNoText);
    } else if (isCpdProdFlagAuthCuntryAuthNumMahPassed) {
      isCpdProdFlagAuthCuntryAuthNumMahPresent = getCpdProdFlagAuthCuntryAuthNumMah(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText);
    } else if (isCpdProdFlagAuthCuntryAuthNumAppTypePassed) {
      isCpdProdFlagAuthCuntryAuthNumAppTypePresent = getCpdProdFlagAuthCuntryAuthNumAppType(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, approvalType);
    } else if (isCpdProdFlagMahAuthNumAppTypePassed) {
      isCpdProdFlagMahAuthNumAppTypePresent = getCpdProdFlagMahAuthNumAppType(currentProd, prodFlagParamValue, mahText, approvalNoText, approvalType);
    } else if (isCpdProdFlagMahAppTypeAuthCuntryPassed) {
      isCpdProdFlagMahAppTypeAuthCuntryPresent = getCpdProdFlagMahAppTypeAuthCuntry(currentProd, prodFlagParamValue, mahText, approvalType, approvalCountry);
    } else if (isCpdProdFlagMahAuthCuntryAuthNumPassed) {
      isCpdProdFlagMahAuthCuntryAuthNumPresent = getCpdProdFlagMahAuthCuntryAuthNum(currentProd, prodFlagParamValue, mahText, approvalCountry, approvalNoText);
    } else if (isCpdProdFlagAuthCuntryAuthNumMahAuthTypePassed) {
      isCpdProdFlagAuthCuntryAuthNumMahAuthTypePresent = getCpdProdFlagAuthCuntryAuthNumMahAuthType(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, approvalType);
    }
  }
  
  if ((isMahPresent || isapprovalTypePresent || isapprovalCtryPresent || isapprovalNoPresent) ||
    isMahapprovalNoPresent || iscpdAppTypeCntryPresent || iscpdAppTypeNoCntryPresent ||
    iscpdAppNoCntryPresent || iscpdAppTypeNoPresent || iscpdMahAppTypeNoCntryPresent ||
    iscpdMahAppTypeNoPresent || iscpdMahAppCntryPresent || iscpdMahAppTypePresent || isCpdMahAppCntryTypePresent ||
    isCpdMahAuthNumAppCntryPresent || isProdFlagPresent || isCpdProdFlagMahPresent || isCpdProdFlagAppTypePresent || isCpdProdFlagAuthCuntryPresent || isCpdProdFlagAuthNumPresent ||
    isCpdProdFlagMahAppTypePresent || isCpdProdFlagMahAuthCuntryPresent || isCpdProdFlagMahAuthNumPresent ||
    isCpdProdFlagAppTypeAuthCuntryPresent || isCpdProdFlagAppTypeAuthNumPresent || isCpdProdFlagAuthCuntryAuthNumPresent ||
    isCpdProdFlagAuthCuntryAuthNumMahPresent || isCpdProdFlagAuthCuntryAuthNumAppTypePresent ||
    isCpdProdFlagMahAuthNumAppTypePresent || isCpdProdFlagMahAppTypeAuthCuntryPresent ||
    isCpdProdFlagMahAuthCuntryAuthNumPresent || isCpdProdFlagAuthCuntryAuthNumMahAuthTypePresent) { // Added newly to include missing comb and CPD Product Flag.
    cpdCombResult = true;
  }
  
  return cpdCombResult;
}


function getcpdMah(currentProd, mahText) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppType(currentProd, approvalType) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(approvalTypeParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }

  }
  return cpdSpecificResult;
}

function getcpdAppCntry(currentProd, approvalCountry) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppNo(currentProd, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  }

  if (!isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }

  return cpdSpecificResult;
}

function getcpdMahAppNo(currentProd, mahText, approvalNoText) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppType(currentProd, mahText, approvalType) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + approvalType + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppCntry(currentProd, mahText, approvalCountry) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppTypeNo(currentProd, mahText, approvalType, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) &&
    isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppTypeNoCntry(currentProd, mahText, approvalType, approvalNoText, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) &&
    isEmptyAndNull(approvalNoParam) &&
    isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeNo(currentProd, approvalType, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "''))  AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppNoCntry(currentProd, approvalNoText, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalNoParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeNoCntry(currentProd, approvalType, approvalNoText, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) &&
    isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeCntry(currentProd, approvalType, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);	
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);	
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }  
  return cpdSpecificResult;
}

function getcpdMahAppCntryType(currentProd, mahText, approvalType, approvalCountry) {
  var cpdSpecificResult = false;
  try {
    if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam)) {
      cpdSpecificResult = true;
    } else if (!isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
      !isEmptyAndNull(currentProd.productRecordID) && !isEmptyAndNull(mahText)) {
      var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
      var param = new java.util.HashMap();
      param.put(''1'', currentProd.productRecordID);
      var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCount != null && cpdSpecificCount > 0) {
        cpdSpecificResult = true;
      }
    }
  } catch (error) {
    logConsole("Exception getcpdMahAppCntryType::" + error);
  }

  return cpdSpecificResult;
}


function getcpdMahTiken(currentProd, mahText, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }

  }
  return cpdSpecificResult;
}



function getcpdAppTypeTiken(currentProd, approvalType, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(approvalTypeParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }

  }
  return cpdSpecificResult;
}

function getcpdAppCntryTiken(currentProd, approvalCountry, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppNoTiken(currentProd, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  }

  if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }

  return cpdSpecificResult;
}

function getcpdMahAppNoTiken(currentProd, mahText, approvalNoText, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppTypeTiken(currentProd, mahText, approvalType, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + approvalType + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }

  }
  return cpdSpecificResult;
}

function getcpdMahAppCntryTiken(currentProd, mahText, approvalCountry, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppTypeNoTiken(currentProd, mahText, approvalType, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) &&
    isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdMahAppTypeNoCntryTiken(currentProd, mahText, approvalType, approvalNoText, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) &&
    isEmptyAndNull(approvalNoParam) &&
    isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeNoTiken(currentProd, approvalType, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "''))  AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppNoCntryTiken(currentProd, approvalNoText, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalNoParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeNoCntryTiken(currentProd, approvalType, approvalNoText, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) &&
    isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeCntryTiken(currentProd, approvalType, approvalCountry, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam) && isEmptyAndNull(tiken)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";

    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}


function getcpdMahAppCntryTypeTiken(currentProd, mahText, approvalType, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(tiken) && !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);

    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }

    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

//Added Newly for Missed combination and Product Flag to check at CPD Level START 
function getCpdMahAuthNumAppCntry(currentProd, mahText, approvalNoText, approvalCountry) {
  var cpdSpecificResult = false;
  try {
    if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(approvalCtryParam)) {
      cpdSpecificResult = true;
    } else if (!isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
      !isEmptyAndNull(currentProd.productRecordID) && !isEmptyAndNull(mahText)) {
      var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
      var param = new java.util.HashMap();
      param.put(''1'', currentProd.productRecordID);
      var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCount != null && cpdSpecificCount > 0) {
        cpdSpecificResult = true;
      }
    }
  } catch (error) {
    logConsole("Exception Occurred in getCpdMahAuthNumAppCntry()::" + error);
  }

  return cpdSpecificResult;
}

function getCpdProdFlag(currentProd, prodFlagParamValue) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(prodFlagParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMah(currentProd, prodFlagParamValue, mahText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppType(currentProd, prodFlagParamValue, approvalType) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntry(currentProd, prodFlagParamValue, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthNum(currentProd, prodFlagParamValue, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAppType(currentProd, prodFlagParamValue, mahText, approvalType) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthCuntry(currentProd, prodFlagParamValue, mahText, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthNum(currentProd, prodFlagParamValue, mahText, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppTypeAuthCuntry(currentProd, prodFlagParamValue, approvalType, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppTypeAuthNum(currentProd, prodFlagParamValue, approvalType, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNum(currentProd, prodFlagParamValue, approvalCountry, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumMah(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumAppType(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, approvalType) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthNumAppType(currentProd, prodFlagParamValue, mahText, approvalNoText, approvalType) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAppTypeAuthCuntry(currentProd, prodFlagParamValue, mahText, approvalType, approvalCountry) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthCuntryAuthNum(currentProd, prodFlagParamValue, mahText, approvalCountry, approvalNoText) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumMahAuthType(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, approvalType) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdMahAuthNumAppCntryTiken(currentProd, mahText, approvalNoText, approvalCountry, tiken) {
  var cpdSpecificResult = false;
  try {
    if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(approvalCtryParam)) {
      cpdSpecificResult = true;
    } else if (!isEmptyAndNull(approvalNoText) && !isEmptyAndNull(tiken) && !isEmptyAndNull(approvalCountry) && !isEmptyAndNull(currentProd) &&
      !isEmptyAndNull(currentProd.productRecordID) && !isEmptyAndNull(mahText)) {
      var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ")";
      if (tiken == ''8001'') {
        cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
        var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
        if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
          cpdSpecificResult = true;
        } else {
          cpdSpecificResult = false;
        }
      }
      if (tiken == ''8002'') {
        cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
        var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
        if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
          cpdSpecificResult = true;
        } else {
          cpdSpecificResult = false;
        }
      }
      if (tiken == ''8003'') {
        cpdSpecificResult = true;
      }
      var param = new java.util.HashMap();
      param.put(''1'', currentProd.productRecordID);
      var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCount != null && cpdSpecificCount > 0) {
        cpdSpecificResult = true;
      }
    }
  } catch (error) {
    logConsole("Exception Occurred in getCpdMahAuthNumAppCntry()::" + error);
  }

  return cpdSpecificResult;
}

function getCpdProdFlagTiken(currentProd, prodFlagParamValue, tiken) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(prodFlagParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(currentProd) &&
    !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahTiken(currentProd, prodFlagParamValue, mahText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppTypeTiken(currentProd, prodFlagParamValue, approvalType, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryTiken(currentProd, prodFlagParamValue, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthNumTiken(currentProd, prodFlagParamValue, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAppTypeTiken(currentProd, prodFlagParamValue, mahText, approvalType, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthCuntryTiken(currentProd, prodFlagParamValue, mahText, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthNumTiken(currentProd, prodFlagParamValue, mahText, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppTypeAuthCuntryTiken(currentProd, prodFlagParamValue, approvalType, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppTypeAuthNumTiken(currentProd, prodFlagParamValue, approvalType, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumMahTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumAppTypeTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, approvalType, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthNumAppTypeTiken(currentProd, prodFlagParamValue, mahText, approvalNoText, approvalType, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAppTypeAuthCuntryTiken(currentProd, prodFlagParamValue, mahText, approvalType, approvalCountry, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagMahAuthCuntryAuthNumTiken(currentProd, prodFlagParamValue, mahText, approvalCountry, approvalNoText, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAuthCuntryAuthNumMahAuthTypeTiken(currentProd, prodFlagParamValue, approvalCountry, approvalNoText, mahText, approvalType, tiken) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(mahParam) && isEmptyAndNull(approvalTypeParam) && isEmptyAndNull(approvalNoParam) && isEmptyAndNull(prodFlagParam) && isEmptyAndNull(approvalCtryParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValue) && !isEmptyAndNull(tiken) &&
    !isEmptyAndNull(mahText) && !isEmptyAndNull(approvalType) && !isEmptyAndNull(approvalNoText) && !isEmptyAndNull(approvalCountry) &&
    !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1) AND (APPROVAL_DATE IS NULL OR APPROVAL_DATE >= (''" + initialReceivedDate + "'')) AND UPPER(MAH_NAME) IN (" + mahText + ") AND coalesce(APPROVAL_TYPE,''NA'') IN (" + approvalType + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + approvalCountry + ") AND UPPER(APPROVAL_NO) IN (" + approvalNoText + ") AND PRODUCT_TYPE IN (" + prodFlagParamValue + ")";
    if (tiken == ''8001'') {
      cpdQueryCount += " AND ( TIKEN IS NULL OR TIKEN = '''' ) ";
      var cpdSpecificCountBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountBlank != null && cpdSpecificCountBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8002'') {
      cpdQueryCount += " AND ( TIKEN IS NOT NULL AND TIKEN <> '''' ) ";
      var cpdSpecificCountNotBlank = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
      if (cpdSpecificCountNotBlank != null && cpdSpecificCountNotBlank > 0) {
        cpdSpecificResult = true;
      } else {
        cpdSpecificResult = false;
      }
    }
    if (tiken == ''8003'') {
      cpdSpecificResult = true;
    }
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}
//Added Newly for Missed combination and Product Flag to check at CPD Level END 

function isItNumeric(inputValue) {
  if (inputValue != null && UTIL.isNumeric(inputValue)) {
    return true;
  } else {
    return false;
  }
}

function checkProdDesc(currentProd) {
  var isProdDesc = false;
  var isProdPortfolio = false;
  var isProdPortfolioMatched = false;
  var isPPDMatched = false;
  var isNumeric = false;
  var isPPDLTNMatched = false;
  var prodDescParamValue = '''';
  var productId = '''';
  var ppdParamArray = '''';
  var ppdQuery = '''';
  var ppdProtfolioQuery = '''';
  var ppdResult = '''';
  var ppdProtfolioResult = '''';
  var ppdParamTxt = null;
  var ppdCount = null;
  var ppdPortfolioCount;
  var localTradeNameRecordID = null;
  var productRecordID = null;
  var paramMap = new java.util.HashMap();
  var param = new java.util.HashMap();
  if (isEmptyAndNull(prodDescParam)) {
    isProdDesc = true;
  } else if (!isEmptyAndNull(prodDescParam) &&
    !isEmptyAndNull(prodCollection)) {
    prodDescParamValue = String(prodDescParam);
    if (prodDescParamValue != null &&
      prodDescParamValue.indexOf(''PROD_PORTFOLIO'') != -1) {
      isProdPortfolio = true;
      prodDescParamValue = prodDescParamValue.substring(
        prodDescParamValue.indexOf("#") + 1,
        prodDescParamValue.length);
    }
    ppdParamArray = convertToArray(prodDescParamValue);
    if (ppdParamArray != null && !isProdPortfolio &&
      ppdParamArray.length > 0) {
      for (var x = 0; x < ppdParamArray.length; x++) {
        isNumeric = isItNumeric(ppdParamArray[x]);
        if (isNumeric) {
          isNumeric = true;
          break;
        }
      }
    }
    ppdParamTxt = getTextFromArray(ppdParamArray);
    ppdParamTxt = ppdParamTxt.toUpperCase();
    productId = currentProd.productRecordID;
    if (!isNumeric && isProdPortfolio && !isEmptyAndNull(productId) &&
      !isEmptyAndNull(ppdParamTxt)) {
      param.clear();
      param.put(''1'', productId);
      ppdProtfolioQuery = "SELECT COUNT(*) FROM LSMV_PRODUCT WHERE PRODUCT_ACTIVE = ''1'' AND RECORD_ID IN (SELECT CAST(unnest(string_to_array(PRODUCT_SEARCH_RESULT, '','')) AS INTEGER) FROM LSMV_PRODUCT_GROUP WHERE UPPER(PRODUCT_GROUP_NAME) IN (" +
        ppdParamTxt + ")) AND RECORD_ID IN (?1)";
      ppdProtfolioResult = genericCrudService.findAllByNativeQuery(
        ppdProtfolioQuery, param);
      if (ppdProtfolioResult != null && ppdProtfolioResult.size() > 0) {
        ppdPortfolioCount = Number(ppdProtfolioResult.get(0));
        if (ppdPortfolioCount != null && ppdPortfolioCount > 0) {
          isProdPortfolioMatched = true;
        }
      }
    }
    if (!isProdPortfolio && !isEmptyAndNull(productId) &&
      !isEmptyAndNull(ppdParamArray) && isNumeric) {
      try {
        if (ppdParamArray != null && ppdParamArray.length > 0) {
          for (var x = 0; x < ppdParamArray.length; x++) {
            productRecordID = ppdParamArray[x];
            if (productRecordID != null) {
              productId = String(productId);
              if (productRecordID.indexOf(productId) >= 0) {
                isPPDMatched = true;
                break;
              }
            }
          }
        }
        if (ppdParamArray != null && ppdParamArray.length > 0 &&
          !isPPDMatched) {
          for (var x = 0; x < ppdParamArray.length; x++) {
            localTradeNameRecordID = ppdParamArray[x];
            if (localTradeNameRecordID != null) {
              paramMap.clear();
              paramMap.put(''1'', localTradeNameRecordID);
              paramMap.put(''2'', productId);
              ppdQuery = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME  WHERE LICENSE_STATUS = ''1'' AND RECORD_ID IN (?1::bigint) AND FK_AGX_PRODUCT_REC_ID IN (?2::bigint)";
              ppdResult = genericCrudService
                .findAllByNativeQuery(ppdQuery, paramMap);
              if (ppdResult != null && ppdResult.size() > 0) {
                ppdCount = Number(ppdResult.get(0));
                if (ppdCount != null && ppdCount > 0) {
                  isPPDLTNMatched = true;
                  break;
                }
              }
            }
          }
        }
      } catch (error) {
        logConsole("Exception caught in checkProdDesc() ::" + error);
      }
    }
    if (isPPDMatched || isProdPortfolioMatched || isPPDLTNMatched) {
      isProdDesc = true;
    }
  }
  return isProdDesc;
}

function isNull(inputValue) {
  if (inputValue != null) {
    return false;
  } else {
    return true;
  }
}

function loadcausalityRelatedMap() {
  var relatedCodesQuery = '''';
  relatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) IN (SELECT trim(regexp_split_to_table(PREFERENCE_VALUE,''\\,+'')) FROM lsmv_agx_appl_pref WHERE PREFERENCE_NAME = ''CASUALITY_RESULTS'') GROUP BY C.CODE ORDER BY 1";
  var relatedResult = genericCrudService.findAllByNativeQuery(
    relatedCodesQuery, null);
  if (relatedResult != null) {
    for (var relatedIndex = 0; relatedIndex < relatedResult.size(); relatedIndex++) {
      if (relatedResult.get(relatedIndex) != null) {
        relatedCodesArray.push(String(relatedResult.get(relatedIndex)));
      }
    }
  }
}

function loadcausalityUnRelatedMap() {
  var unrelatedCodesQuery = '''';
  unrelatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) NOT IN (SELECT trim(regexp_split_to_table(PREFERENCE_VALUE,''\\,+'')) FROM lsmv_agx_appl_pref WHERE PREFERENCE_NAME = ''CASUALITY_RESULTS'') GROUP BY C.CODE ORDER BY 1";
  var unrelatedResult = genericCrudService.findAllByNativeQuery(
    unrelatedCodesQuery, null);
  if (unrelatedResult != null) {
    for (var unrelatedIndex = 0; unrelatedIndex < unrelatedResult.size(); unrelatedIndex++) {
      if (unrelatedResult.get(unrelatedIndex) != null) {
        unrelatedCodesArray.push(String(unrelatedResult.get(unrelatedIndex)));
      }
    }
  }
}

function loadcausalityAccountRelatedMap() {
  var distUnitName = distributionUnit.distributionUnitName;
  var relatedCodesQuery = '''';
  if (!isEmptyAndNull(distUnitName)) {
    relatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) IN (SELECT trim(regexp_split_to_table(CASUALITY_RESULTS,''\\,+'')) FROM LSMV_ACCOUNTS WHERE CASUALITY_RESULTS IS NOT NULL AND RECORD_ID IN (SELECT FK_ACCOUNT FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME IN (''" +
      distUnitName + "'') )) ORDER BY 1";
    var relatedResult = genericCrudService.findAllByNativeQuery(
      relatedCodesQuery, null);
    if (relatedResult != null && relatedResult.size() > 0) {
      for (var relatedIndex = 0; relatedIndex < relatedResult.size(); relatedIndex++) {
        if (relatedResult.get(relatedIndex) != null) {
          relatedAccountCodesArray.push(String(relatedResult.get(relatedIndex)));
        }
      }
    }
  }
}

function loadcausalityAccountUnRelatedMap() {
  var distUnitName = distributionUnit.distributionUnitName;
  var unrelatedCodesQuery = '''';
  if (!isEmptyAndNull(distUnitName)) {
    unrelatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) NOT IN (SELECT trim(regexp_split_to_table(CASUALITY_RESULTS,''\\,+'')) FROM LSMV_ACCOUNTS WHERE CASUALITY_RESULTS IS NOT NULL AND RECORD_ID IN (SELECT FK_ACCOUNT FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME IN (''" +
      distUnitName + "'') )) ORDER BY 1";
    var unrelatedResult = genericCrudService.findAllByNativeQuery(
      unrelatedCodesQuery, null);
    if (unrelatedResult != null && unrelatedResult.size() > 0) {
      for (var relatedIndex = 0; relatedIndex < unrelatedResult.size(); relatedIndex++) {
        if (unrelatedResult.get(relatedIndex) != null) {
          unrelatedAccountCodesArray.push(String(unrelatedResult.get(relatedIndex)));
        }
      }
    }
  }
}

function getCausalityFields(currentProd) {
  var isCausality = false;
  var isRelatedAsCompany = false;
  var isRelatedAsCompanyOrReporter = false;
  var isUnRelatedAsCompany = false;
  var isUnRelatedAsCompanyAndReporter = false;
  var isAccountRelatedAsCompany = false;
  var isAccountRelatedAsCompanyOrReporter = false;
  var isAccountUnRelatedAsCompany = false;
  var isAccountUnRelatedAsCompanyAndReporter = false;
  var causalityParamValue = null;
  var accountRelatednessExists = false;
  var drugReactRelatednessCollection = null;

  if (isEmptyAndNull(causalityParam)) {
    isCausality = true;
  } else if (!isEmptyAndNull(causalityParam)) {
    causalityParamValue = String(causalityParam);
    if (relatedAccountCodesArray != '''' && relatedAccountCodesArray != null) {
      accountRelatednessExists = true;
    } else {
      accountRelatednessExists = false;
    }
    if (!isEmptyAndNull(prodCollection) && currentProd != null) {
      drugReactRelatednessCollection = currentProd.drugReactRelatednessCollection;
      if (accountRelatednessExists && causalityParamValue != null &&
        drugReactRelatednessCollection != null) {
        if (causalityParamValue == ''8001'') {
          isAccountRelatedAsCompany = getAccountRelatedAsCompany(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8002'') {
          isAccountRelatedAsCompanyOrReporter = getAccountRelatedAsCompanyOrReporter(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8003'') {
          isAccountUnRelatedAsCompany = getAccountUnRelatedAsCompany(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8004'') {
          isAccountUnRelatedAsCompanyAndReporter = getAccountUnRelatedAsCompanyAndReporter(drugReactRelatednessCollection);
        }
      } else if (!accountRelatednessExists && causalityParamValue != null &&
        drugReactRelatednessCollection != null) {
        if (causalityParamValue == ''8001'') {
          isRelatedAsCompany = getRelatedAsCompany(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8002'') {
          isRelatedAsCompanyOrReporter = getRelatedAsCompanyOrReporter(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8003'') {
          isUnRelatedAsCompany = getUnRelatedAsCompany(drugReactRelatednessCollection);
        } else if (causalityParamValue == ''8004'') {
          isUnRelatedAsCompanyAndReporter = getUnRelatedAsCompanyAndReporter(drugReactRelatednessCollection);
        }
      }
      if (isAccountRelatedAsCompany || isAccountRelatedAsCompanyOrReporter ||
        isAccountUnRelatedAsCompany ||
        isAccountUnRelatedAsCompanyAndReporter) {
        isCausality = true;
      }
      if (isRelatedAsCompany || isRelatedAsCompanyOrReporter ||
        isUnRelatedAsCompany || isUnRelatedAsCompanyAndReporter) {
        isCausality = true;
      }
    }
  }
  return isCausality;
}

function getRelatedAsCompany(drugReactRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null &&
        caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
      }
      if (isCausalityMached) {
        var isLabCntryListed = false;
        isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
        if (isCausalityMached && isLabCntryListed) {
          isCausalityLabellingMached = true;
          break outer_loop;
        } else {
          isCausalityLabellingMached = false;
        }
      }
    }
  }
  return isCausalityLabellingMached;
}


function getRelatedAsCompanyOrReporter(drugReactRelatednessCollection) {
  var reporterCausalityCaseValue = null;
  var companyCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag &&
        isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
      }
      if (isCausalityMached) {
        var isLabCntryListed = false;
        isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
        if (isCausalityMached && isLabCntryListed) {
          isCausalityLabellingMached = true;
          break outer_loop;
        } else {
          isCausalityLabellingMached = false;
        }
      }
    }
  }
  return isCausalityLabellingMached;
}



function getUnRelatedAsCompany(drugReactRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      var isEventToBeChecked = false;
      if (currentEvent != null && caseSeriousFlag != null &&
        caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag &&
        isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      }
    }
  }
  return isCausalityLabellingMached;
}

function getUnRelatedAsCompanyAndReporter(drugReactRelatednessCollection) {
  var reporterCausalityCaseValue = null;
  var companyCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag &&
        isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      }
    }
  }
  return isCausalityLabellingMached;
}


function getAccountRelatedAsCompany(drugReactRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
      }
      if (isCausalityMached) {
        var isLabCntryListed = false;
        isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
        if (isCausalityMached && isLabCntryListed) {
          isCausalityLabellingMached = true;
          break outer_loop;
        } else {
          isCausalityLabellingMached = false;
        }
      }
    }
  }
  return isCausalityLabellingMached;
}



function getAccountRelatedAsCompanyOrReporter(drugReactRelatednessCollection) {
  var reporterCausalityCaseValue = null;
  var companyCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
      }
      if (isCausalityMached) {
        var isLabCntryListed = false;
        isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
        if (isCausalityMached && isLabCntryListed) {
          isCausalityLabellingMached = true;
          break outer_loop;
        } else {
          isCausalityLabellingMached = false;
        }
      }
    }
  }
  return isCausalityLabellingMached;
}


function getAccountUnRelatedAsCompany(drugReactRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      }
    }
  }
  return isCausalityLabellingMached;
}


function getAccountUnRelatedAsCompanyAndReporter(drugReactRelatednessCollection) {
  var reporterCausalityCaseValue = null;
  var companyCausalityCaseValue = null;
  var currentEvent = null;
  var isEventToBeChecked = false;
  var isCausalityMached = false;
  var isCausalityLabellingMached = false;

  if (!isEmptyAndNull(drugReactRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugReactRelatednessCollection.size(); curPrdIndex++) {
      currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);
      if (currentEvent != null && caseSeriousFlag != null && caseSeriousFlag) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      } else if (caseSeriousFlag != null && !caseSeriousFlag) {
        if (drugReactRelatednessCollection.get(curPrdIndex).companyCausality != null) {
          companyCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).companyCausality);
        }
        if (drugReactRelatednessCollection.get(curPrdIndex).reporterCausality != null) {
          reporterCausalityCaseValue = String(drugReactRelatednessCollection.get(curPrdIndex).reporterCausality);
        }
        isCausalityMached = isAccountUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);
        if (isCausalityMached) {
          var isLabCntryListed = false;
          isLabCntryListed = getLabellingDetails(drugReactRelatednessCollection, curPrdIndex);
          if (isCausalityMached && isLabCntryListed) {
            isCausalityLabellingMached = true;
            break outer_loop;
          } else {
            isCausalityLabellingMached = false;
          }
        }
      }
    }
  }
  return isCausalityLabellingMached;
}

function isRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, relatedCodesArray);
  }
  if (isCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}

function isRelatedCompanyOrReporter(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isReporterCausalityMatched = false;
  var isUnRelatedReporterCausalityMatched = false;
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(relatedCodesArray)) {
    isReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, relatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality,
      relatedCodesArray);
  }
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, unrelatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedCodesArray);
  }
  if (isCompanyCausalityMatched && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}

function isUnRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedCodesArray);
  }
  if (isUnRelatedCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}


function isUnRelatedCompanyAndReporter(companyCausality, reporterCausality) {
  var isUnrelatedCompanyCausalityMatched = false;
  var isUnrelatedReporterCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(unrelatedCodesArray)) {
    isUnrelatedReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, unrelatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedCodesArray)) {
    isUnrelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedCodesArray);
  }
  if (isUnrelatedCompanyCausalityMatched &&
    isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnrelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}

function isAccountRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(relatedAccountCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality,
      relatedAccountCodesArray);
  }
  if (isCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}


function isAccountRelatedCompanyOrReporter(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isReporterCausalityMatched = false;
  var isUnRelatedReporterCausalityMatched = false;
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(relatedAccountCodesArray)) {
    isReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, relatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(relatedAccountCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality,
      relatedAccountCodesArray);
  }
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, unrelatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedAccountCodesArray);
  }
  if (isCompanyCausalityMatched && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}

function isAccountUnRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedAccountCodesArray);
  }
  if (isUnRelatedCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}

function isAccountUnRelatedCompanyAndReporter(companyCausality, reporterCausality) {
  var isUnrelatedCompanyCausalityMatched = false;
  var isUnrelatedReporterCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnrelatedReporterCausalityMatched = compareCaseWithParamValue(
      reporterCausality, unrelatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) &&
    !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnrelatedCompanyCausalityMatched = compareCaseWithParamValue(
      companyCausality, unrelatedAccountCodesArray);
  }
  if (isUnrelatedCompanyCausalityMatched &&
    isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnrelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}

function getLabellingDetails(drugReactRelatednessCollection, curPrdIndex) {
  var islabellingCntryRelatedness = false;
  var labellingCountryParamArray = [];
  var labellingListedParamValue = null;

  if (!isEmptyAndNull(labParam)) {
    labellingListedParamValue = String(labParam);
  }
  if (!isEmptyAndNull(labCtryParam)) {
    labellingCountryParamArray = convertToArray(labCtryParam);
  }

  if (isEmptyAndNull(labCtryParam) && isEmptyAndNull(labParam)) {
    islabellingCntryRelatedness = true;
  } else if (!isEmptyAndNull(labCtryParam) && !isEmptyAndNull(labellingListedParamValue)) {
    islabellingCntryRelatedness = getLabelingAndCountry(drugReactRelatednessCollection, labellingCountryParamArray, labellingListedParamValue, curPrdIndex);
  } else if (isEmptyAndNull(labCtryParam) && !isEmptyAndNull(labellingListedParamValue)) {
    islabellingCntryRelatedness = getLabeling(drugReactRelatednessCollection, labellingListedParamValue, curPrdIndex);
  } else if (!isEmptyAndNull(labCtryParam) && isEmptyAndNull(labParam)) {
    islabellingCntryRelatedness = getLabelingCountry(drugReactRelatednessCollection, labellingCountryParamArray, curPrdIndex);
  }

  return islabellingCntryRelatedness;
}

function getLabelingAndCountry(drugReactRelatednessCollection, labellingCountryParamArray, labellingListedParamValue, curPrdIndex) {
  var islabellingCntryRelatedness = false;
  var isCountryMatch = false;
  var isListed = false;
  var currCaseCountry = null;
  var drugReactListednessCollection = null;
  var caseLablngListedValue = null;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(labCtryParam) && !isEmptyAndNull(labParam) && !isEmptyAndNull(drugReactRelatednessCollection)) {
    drugReactListednessCollection = drugReactRelatednessCollection.get(curPrdIndex).drugReactListednessCollection;
    var currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);

    if (!isEmptyAndNull(currentEvent) && caseSeriousFlag != null && caseSeriousFlag) {
      isEventToBeChecked = getAllEventCheck(currentEvent);
    }

    if (!isEmptyAndNull(drugReactListednessCollection)) {
      outer_loop: for (var curDrrcIndex = 0; curDrrcIndex < drugReactListednessCollection.size(); curDrrcIndex++) {

        if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
          if (drugReactListednessCollection.get(curDrrcIndex).listed != null) {
            caseLablngListedValue = String(drugReactListednessCollection.get(curDrrcIndex).listed);
          } else {
            caseLablngListedValue = null;
          }
          if (!isEmptyAndNull(caseLablngListedValue) && !isEmptyAndNull(labellingListedParamValue)) {
            if (labellingListedParamValue === caseLablngListedValue) {
              isListed = true;
            } else {
              isListed = false;
            }
          } else {
            isListed = false;
          }
          if (drugReactListednessCollection.get(curDrrcIndex).country != null && !isEmptyAndNull(labellingCountryParamArray)) {
            currCaseCountry = drugReactListednessCollection.get(curDrrcIndex).country;
            isCountryMatch = checkCountry(currCaseCountry, labellingCountryParamArray);
          }
          if (isCountryMatch && isListed) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        } else if (caseSeriousFlag != null && !caseSeriousFlag) {
          if (drugReactListednessCollection.get(curDrrcIndex).listed != null) {
            caseLablngListedValue = String(drugReactListednessCollection.get(curDrrcIndex).listed);
          } else {
            caseLablngListedValue = null;
          }
          if (!isEmptyAndNull(caseLablngListedValue) && !isEmptyAndNull(labellingListedParamValue)) {
            if (labellingListedParamValue === caseLablngListedValue) {
              isListed = true;
            } else {
              isListed = false;
            }
          } else {
            isListed = false;
          }
          if (drugReactListednessCollection.get(curDrrcIndex).country != null && !isEmptyAndNull(labellingCountryParamArray)) {
            currCaseCountry = drugReactListednessCollection.get(curDrrcIndex).country;
            isCountryMatch = checkCountry(currCaseCountry, labellingCountryParamArray);
          }
          if (isCountryMatch && isListed) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        }
      }
    }
  }
  return islabellingCntryRelatedness;
}

function getLabeling(drugReactRelatednessCollection, labellingListedParamValue, curPrdIndex) {
  var islabellingCntryRelatedness = false;
  var isListed = false;
  var drugReactListednessCollection = null;
  var caseLablngListedValue = null;
  var isEventToBeChecked = false;

  if (isEmptyAndNull(labCtryParam) && !isEmptyAndNull(labParam) && !isEmptyAndNull(drugReactRelatednessCollection)) {
    drugReactListednessCollection = drugReactRelatednessCollection.get(curPrdIndex).drugReactListednessCollection;
    var currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);

    if (!isEmptyAndNull(currentEvent) && caseSeriousFlag != null && caseSeriousFlag) {
      isEventToBeChecked = getAllEventCheck(currentEvent);
    }
    if (!isEmptyAndNull(drugReactListednessCollection)) {
      outer_loop: for (var curDrrcIndex = 0; curDrrcIndex < drugReactListednessCollection.size(); curDrrcIndex++) {

        if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
          if (drugReactListednessCollection.get(curDrrcIndex).listed != null) {
            caseLablngListedValue = String(drugReactListednessCollection.get(curDrrcIndex).listed);
          } else {
            caseLablngListedValue = null;
            isListed = false;
          }

          if (!isEmptyAndNull(caseLablngListedValue) && !isEmptyAndNull(labellingListedParamValue)) {
            labellingListedParamValue = String(labellingListedParamValue);
            if (labellingListedParamValue == caseLablngListedValue) {
              isListed = true;
            } else {
              isListed = false;
            }
          } else {
            isListed = false;
          }
          if (isListed) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        } else if (caseSeriousFlag != null && !caseSeriousFlag) {
          if (drugReactListednessCollection.get(curDrrcIndex).listed != null) {
            caseLablngListedValue = String(drugReactListednessCollection.get(curDrrcIndex).listed);
          } else {
            caseLablngListedValue = null;
            isListed = false;
          }

          if (!isEmptyAndNull(caseLablngListedValue) && !isEmptyAndNull(labellingListedParamValue)) {
            labellingListedParamValue = String(labellingListedParamValue);
            if (labellingListedParamValue == caseLablngListedValue) {
              isListed = true;
            } else {
              isListed = false;
            }
          } else {
            isListed = false;
          }
          if (isListed) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        }
      }
    }
  }
  return islabellingCntryRelatedness;
}

function getLabelingCountry(drugReactRelatednessCollection, labellingCountryParamArray, curPrdIndex) {
  var islabellingCntryRelatedness = false;
  var isCountryMatch = false;
  var drugReactListednessCollection = null;
  var currCaseCountry = null;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(labCtryParam) && isEmptyAndNull(labParam) && !isEmptyAndNull(drugReactRelatednessCollection)) {
    drugReactListednessCollection = drugReactRelatednessCollection.get(curPrdIndex).drugReactListednessCollection;
    var currentEvent = eventMap.get(drugReactRelatednessCollection.get(curPrdIndex).reaction);

    if (!isEmptyAndNull(currentEvent) && caseSeriousFlag != null && caseSeriousFlag) {
      isEventToBeChecked = getAllEventCheck(currentEvent);
    }

    if (!isEmptyAndNull(drugReactListednessCollection)) {
      outer_loop: for (var curDrrcIndex = 0; curDrrcIndex < drugReactListednessCollection.size(); curDrrcIndex++) {

        if (caseSeriousFlag != null && caseSeriousFlag && isEventToBeChecked) {
          if (drugReactListednessCollection.get(curDrrcIndex).country != null && !isEmptyAndNull(labellingCountryParamArray)) {
            currCaseCountry = drugReactListednessCollection.get(curDrrcIndex).country;
            isCountryMatch = checkCountry(currCaseCountry, labellingCountryParamArray);
          }
          if (isCountryMatch) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        } else if (caseSeriousFlag != null && !caseSeriousFlag) {
          if (drugReactListednessCollection.get(curDrrcIndex).country != null && !isEmptyAndNull(labellingCountryParamArray)) {
            currCaseCountry = drugReactListednessCollection.get(curDrrcIndex).country;
            isCountryMatch = checkCountry(currCaseCountry, labellingCountryParamArray);
          }
          if (isCountryMatch) {
            islabellingCntryRelatedness = true;
            break outer_loop;
          } else {
            islabellingCntryRelatedness = false;
          }
        }
      }
    }
  }
  return islabellingCntryRelatedness;
}

function checkCountry(currCaseCountry, labellingCountryParamArray) {
  var countryParamValue = null;
  var isLablngCuntry = false;
  if (!isEmptyAndNull(currCaseCountry) && !isEmptyAndNull(labellingCountryParamArray)) {
    outer_loop: for (var labCntryAyIndex = 0; labCntryAyIndex < labellingCountryParamArray.length; labCntryAyIndex++) {
      countryParamValue = labellingCountryParamArray[labCntryAyIndex];
      if (countryParamValue != null && currCaseCountry.equalsIgnoreCase(countryParamValue)) {
        isLablngCuntry = true;
        break outer_loop;
      } else {
        isLablngCuntry = false;
      }
    }
  }
  return isLablngCuntry;
}

function getAllEventCheck(currentEvent) {
  var isEventStatus = false;
  if (currentEvent != null) {
    if (isEmptyAndNull(seriousnessParam) && isEmptyAndNull(deathParam) && isEmptyAndNull(ltParam)) {
      isEventStatus = true;
    }
    if (!isEmptyAndNull(eventCollection) && currentEvent.seriousness != null && seriousnessParam != null) {
      var eventSeriounessCaseValue = String(currentEvent.seriousness);
      seriousnessParam = String(seriousnessParam);
      var eventDeathCaseValue = currentEvent.death != null ? String(currentEvent.death) : null;
      var eventLTCaseValue = currentEvent.lifethreatening != null ? String(currentEvent.lifethreatening) : null;
      var isSeriousEventMatch = false;
      if (eventSeriounessCaseValue == seriousnessParam) {
        isSeriousEventMatch = true;
      }
      var isDeathEvent = isSeriousEventMatch && compareCaseEventWithParamValue(eventDeathCaseValue, deathParam);
      var isLTEvent = isSeriousEventMatch && compareCaseEventWithParamValue(eventLTCaseValue, ltParam);
      if (isSeriousEventMatch && (isDeathEvent || isLTEvent)) {
        isEventStatus = true;
      } else if (isSeriousEventMatch && (isNull(deathParam) && isNull(ltParam))) {
        isEventStatus = true;
      }
    }
  }
  return isEventStatus;
}

function compareCaseEventWithParamValue(caseData, paramValue) {
  var status = false;
  if (paramValue != null) {
    paramValue = String(paramValue);
    if (paramValue.equals("1") && caseData != null) {
      status = caseData.equals(paramValue);
    }
    if (paramValue.equals("2")) {
      if (caseData != null) {
        status = caseData.equals(paramValue);
      } else if (isNull(caseData)) {
        status = true;
      }
    }
  }
  return status;
}

logConsole("CUSTOM JAVASCRIPT EXECUTION END............");
','DistributionRule','DR5008_2:USER_SCRIPTED_MATRIX_JS','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5008_2',NULL,'Distribution');



INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 

VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PRODUCT_EVENT_MATRIX_JS',NULL,NULL,'Y','()','{"recordId":"1730202785214","operator":"AND"}',NULL,NULL,'Y','Y','var ruleName = ''USER_PRODUCT_EVENT_MATRIX_JS'';
var logFlag = true;
var receiptNum = inboundMessage.receiptItem.receiptNo;
logConsole(''Execution Started...'');

// Generic fn to Logger
function logConsole(message) {
  if (logFlag) {
    UTIL.getLogger().error(receiptNum + '': '' + ruleName + '': '' + message);
  }
}
// Generic fn to convert string from UI separated by delimiter to character separated by Comma
function getStringToChar(inputString) {
  // Split the string into an array using the custom delimiter and add single quotes
  var customSeparatedStringWithQuotes = inputString.split(''|'').map(function (value) {
    return "''" + value + "''";
  }).join('','');
  return customSeparatedStringWithQuotes;
}
// Generic fn to check the case data and input param multivalue
function compareCaseWithParamValue(caseData, paramList) {
  if (UTIL.isNotNullCheck(caseData) && paramList.length > 0) {
    for (var paramIdx = 0; paramIdx < paramList.length; paramIdx++) {
      if (caseData == paramList[paramIdx]) {
        return true;
      }
    }
  }
  return false;
}
// Generic fn to call compare Param values fn against Case data
function checkParamValue(collectionName, caseFieldName, paramValue) {
  var paramList = paramValue ? paramValue.split(''|'') : [];
  var caseValue = String(collectionName[caseFieldName]);
  return compareCaseWithParamValue(caseValue, paramList);
}

// Input Parameters
var productCharParam = UTIL.isNotNullCheck(userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var productFlagParam = UTIL.isNotNullCheck(userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var studyPrdTypeParam = UTIL.isNotNullCheck(userParameters.get(''studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var productDescParam = UTIL.isNotNullCheck(userParameters.get(''medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodAppTypeParam = UTIL.isNotNullCheck(userParameters.get(''cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var prodAppCntryParam = UTIL.isNotNullCheck(userParameters.get(''cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var mahAsCodedParam = UTIL.isNotNullCheck(userParameters.get(''mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;

var labellingParam = UTIL.isNotNullCheck(userParameters.get(''listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var labCntryParam = UTIL.isNotNullCheck(userParameters.get(''country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;

var repCausParam = UTIL.isNotNullCheck(userParameters.get(''reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var cmyCausParam = UTIL.isNotNullCheck(userParameters.get(''companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var causConditionParam = UTIL.isNotNullCheck(userParameters.get(''causalityCondition.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''causalityCondition.safetyReport.aerInfo.flpath'')) : null;

var eventSeriousParam = UTIL.isNotNullCheck(userParameters.get(''seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventLTParam = UTIL.isNotNullCheck(userParameters.get(''lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventDTParam = UTIL.isNotNullCheck(userParameters.get(''death.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''death.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var medDraPTParam = UTIL.isNotNullCheck(userParameters.get(''reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var eventExcludeParam = UTIL.isNotNullCheck(userParameters.get(''eventExclude.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''eventExclude.safetyReport.aerInfo.flpath'')) : null;
var relatedToStudyConductParam = UTIL.isNotNullCheck(userParameters.get(''causeOfAdverseEvent.reactionCollection$patient.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''causeOfAdverseEvent.reactionCollection$patient.safetyReport.aerInfo.flpath'')) : null;
var studyConductConditionParam = UTIL.isNotNullCheck(userParameters.get(''causeOfAdverse.safetyReport.aerInfo.flpath'')) ? String(userParameters.get(''causeOfAdverse.safetyReport.aerInfo.flpath'')) : null;

// Reaction and Drug Collections
var reactionCollection = inboundMessage.aerInfo.safetyReport.patient.reactionCollection;
var drugCollection = inboundMessage.aerInfo.safetyReport.patient.drugCollection;

// Event level fields logic starts.
var eventArrList = new java.util.ArrayList();
// Function to check Seriousness, LT, Death and Rel to Study param values with case data for each event
relatedToStudyConductParam = UTIL.isNotNullCheck(relatedToStudyConductParam) ? relatedToStudyConductParam.split(''|'') : [];
function chkEventDetailsAndLoad() {
  var medDRAPTArray = UTIL.isNotNullCheck(medDraPTParam) ? medDraPTParam.split(''|'') : [];
  var medDRAPTParamExists = medDRAPTArray.length > 0 ? true : false;
  eventExcludeParam = (eventExcludeParam == ''1'') ? true : false;
  try {
    for (var eventIndex = 0; eventIndex < reactionCollection.size(); eventIndex++) {
      var currEvent = reactionCollection.get(eventIndex);

      var eventToBeChecked = false;
      // check if PT list is selected or current event is part of the list based on Exclude or Include logic
      if (!medDRAPTParamExists || (eventExcludeParam && medDraPTParam.indexOf(currEvent.reactMedDraPtCode) == -1) || (!eventExcludeParam && medDraPTParam.indexOf(currEvent.reactMedDraPtCode) != -1)) {
        eventToBeChecked = true;
      }
      if (eventToBeChecked) {
        // If Seriousness, LT, and Death case level is NF or Blank, ''2'' (No) will be assigned
        var eventSeriousness = UTIL.isNotNullCheck(String(currEvent.seriousness)) ? String(currEvent.seriousness) : ''2'';
        var eventLifeThreat = UTIL.isNotNullCheck(String(currEvent.lifethreatening)) ? String(currEvent.lifethreatening) : ''2'';
        var eventDeath = UTIL.isNotNullCheck(String(currEvent.death)) ? String(currEvent.death) : ''2'';
        var eventAdverseCause = UTIL.isNotNullCheck(String(currEvent.causeOfAdverseEvent)) ? String(currEvent.causeOfAdverseEvent).split('','') : [];
        // Check if current event matches the specified parameters
        var eventSeriousMatch = UTIL.isNotNullCheck(eventSeriousParam) ? (eventSeriousParam == eventSeriousness) : true;
        if (UTIL.isNotNullCheck(eventDTParam) && UTIL.isNotNullCheck(eventLTParam) && eventDTParam == ''2'' && eventLTParam == ''2'') {
          var deathorltMatch = (eventDTParam == eventDeath) && (eventLTParam == eventLifeThreat); // if both DT and LT is NO, then both should PASS else either one should PASS.
        } else {
          var deathorltMatch = (UTIL.isNullCheck(eventDTParam) && UTIL.isNullCheck(eventLTParam)) ? true : (UTIL.isNotNullCheck(eventDTParam) && (eventDTParam == eventDeath)) || (UTIL.isNotNullCheck(eventLTParam) && (eventLTParam == eventLifeThreat));
        }
        var eventRelatedStudyMatch = relatedToStudyConductParam.length > 0 ? relatedToStudyConduct(eventAdverseCause) : true;
        // If all conditions are met, add the current event to the list
        if (eventSeriousMatch && deathorltMatch && eventRelatedStudyMatch) {
          eventArrList.add(currEvent.recordId);
        }
      }
    }
  } catch (error) {
    logConsole("Exception caught in Event check: " + error);
  }
}
// Fn to check Cause of Adverse Event with Related to study param based on OR/AND conditions
function relatedToStudyConduct(eventAdverseCause) {
  try {
    if (eventAdverseCause.length == 0) { //If field is blank but in DR config is selected
      return false;
    }
    if (UTIL.isNullCheck(studyConductConditionParam) || studyConductConditionParam == ''2'') { //OR condition
      for (var eventIdx = 0; eventIdx < relatedToStudyConductParam.length; eventIdx++) {
        if (eventAdverseCause.indexOf(relatedToStudyConductParam[eventIdx]) != -1) {
          return true; // If any one codelist value matches return True
        }
      }
    } else if (studyConductConditionParam == ''1'') {//AND condition
      for (var eventIdx = 0; eventIdx < relatedToStudyConductParam.length; eventIdx++) {
        if (eventAdverseCause.indexOf(relatedToStudyConductParam[eventIdx]) == -1) {
          return false; // All codelist selected in DR config should be available
        }
      }
      return true;
    }
  }
  catch (error) {
    logConsole("Exception caught in relatedToStudyConduct: " + error);
  }
}
// Event level fields logic ends here.

// Product fields logic starts here.
// fn to fetch LTN or PPD rec id of Product portfolio List
var portfolioPPDRecIdList = new java.util.ArrayList();
var portfolioLTNRecIdList = new java.util.ArrayList();
function prodPortfolioList(productDescValue) {
  var ltnProtfolioQuery = "SELECT record_id FROM lsmv_product_tradename WHERE license_status = ''1'' AND record_id IN (SELECT CAST(unnest(string_to_array(tradename_search_result, '','')) AS BIGINT) FROM lsmv_product_group WHERE product_group_name IN (" + productDescValue + "))";
  portfolioLTNRecIdList = genericCrudService.findAllByNativeQuery(ltnProtfolioQuery, null);

  if (portfolioLTNRecIdList.size() == 0) {
    var ppdProtfolioQuery = "SELECT record_id FROM lsmv_product WHERE product_active = ''1'' AND record_id IN (SELECT CAST(unnest(string_to_array(product_search_result, '','')) AS BIGINT) FROM lsmv_product_group WHERE product_group_name IN (" + productDescValue + "))";
    portfolioPPDRecIdList = genericCrudService.findAllByNativeQuery(ppdProtfolioQuery, null);
  }
}
// fn to call Prod Portfolio functions, Prod description and load
var prdDescList = '''';
function getProdListFromParam() {
  try {

    if (UTIL.isNotNullCheck(productDescParam)) {
      if (productDescParam.indexOf("PROD_PORTFOLIO") != -1) {
        // Pass if Prod Desc was selected from Portfolio lookup and remove the PROD_PORTFOLIO#
        var portfolioName = productDescParam.substring(productDescParam.indexOf("#") + 1, productDescParam.length);
        var productDescValue = getStringToChar(portfolioName);
        prodPortfolioList(productDescValue);
      } else {
        // Pass if prod desc doesn''t have PROD_PORTFOLIO
        prdDescList = productDescParam;
      }
    }
  } catch (error) {
    logConsole(''Exception in Product loading calling Prod Group and Desc'' + error);
  }
}

// Fn to check Product related Param data with CPD fields except prod char and study prod type
var initialReceivedDate = new Date(inboundMessage.aerInfo.safetyReport.receiveDate);
var prodListForCPD = [];
var finalProdListforCausality = new java.util.ArrayList();
function chkAgainstCPD() {
  try {
    var cpdSelectQuery = null;

    // Build the SQL query for CPD related params
    var prodCPDRecId = prodListForCPD.filter(Boolean).join('','');
    if (UTIL.isNotNullCheck(prodCPDRecId)) {
      var cpdQueryConditions = [
        "lpt.fk_agx_product_rec_id = lp.record_id",
        "lpt.license_status = ''1''",
        //"(lpt.approval_date is null OR lpt.approval_date >= TO_DATE(''" + initialReceivedDate + "'', ''Dy Mon DD YYYY HH24:MI:SS''))",
        "lp.record_id IN (" + prodCPDRecId + ")",
        (UTIL.isNotNullCheck(productFlagParam)) ? "coalesce(" + (UTIL.isNotNullCheck(mahAsCodedParam) ? "lpt.product_type" : "lp.product_type") + ", ''NA'') IN (" + getStringToChar(productFlagParam) + ")" : null, //If MAH is available then Prod Flag checks at LTN level otherwise checks at PPD level
        (UTIL.isNotNullCheck(mahAsCodedParam)) ? "coalesce(lpt.mah_name, ''NA'') IN (" + getStringToChar(mahAsCodedParam) + ")" : null,
        (UTIL.isNotNullCheck(prodAppTypeParam)) ? "coalesce(lpt.APPROVAL_TYPE,''NA'') IN (" + getStringToChar(prodAppTypeParam) + ")" : null,
        (UTIL.isNotNullCheck(prodAppCntryParam)) ? "coalesce(lpt.COUNTRY_CODE,''NA'') IN (" + getStringToChar(prodAppCntryParam) + ")" : null
      ];
      // Filter out null values and join the conditions using ''AND''
      cpdSelectQuery = "SELECT DISTINCT lp.record_id FROM lsmv_product_tradename lpt, lsmv_product lp WHERE " + cpdQueryConditions.filter(Boolean).join(" AND ");
    }

    logConsole("cpdSelectQuery: " + cpdSelectQuery);
    if (UTIL.isNotNullCheck(cpdSelectQuery)) {
      var param = new java.util.HashMap();
      var cpdMatchResults = genericCrudService.findAllByNativeQuery(cpdSelectQuery, null);
      if (cpdMatchResults != null) {
        for (var i = 0; i < cpdMatchResults.size(); i++) {
          finalProdListforCausality.add(cpdMatchResults.get(i))
        }
      }
    }
  } catch (error) {
    logConsole("Exception caught in chkAgainstCPD: " + error);
  }
}

var blindedProdRecordId = new java.util.ArrayList();
function loadProdList() {
  try {
    for (var drugIndex = 0; drugIndex < drugCollection.size(); drugIndex++) {
      var currentProd = drugCollection.get(drugIndex);
      var caseDrugCharMatch = UTIL.isNotNullCheck(productCharParam) ? checkParamValue(currentProd, ''drugCharacterization'', productCharParam) : true;
      //if prod desc is not selected then prod at case level and add to list
      if (caseDrugCharMatch && UTIL.isNotNullCheck(currentProd.productRecordID) && UTIL.isNullCheck(productDescParam)) {
        prodListForCPD.push(currentProd.productRecordID);
        UTIL.isNotNullCheck(currentProd.blindedProductRecId) && UTIL.isNotNullCheck(studyPrdTypeParam) && blindedProdRecordId.add(currentProd.blindedProductRecId);
        continue;
      }
      //if prod desc is selected, then check against case data and added to list
      if (caseDrugCharMatch && UTIL.isNotNullCheck(currentProd.productRecordID) && UTIL.isNotNullCheck(productDescParam)) {
        if (prdDescList.indexOf(currentProd.productRecordID) != -1 || prdDescList.indexOf(currentProd.tradeRecId) != -1 || portfolioPPDRecIdList.indexOf(currentProd.productRecordID) != -1 || portfolioLTNRecIdList.indexOf(currentProd.tradeRecId) != -1) {
          prodListForCPD.push(currentProd.productRecordID);
        }
        UTIL.isNotNullCheck(currentProd.blindedProductRecId) && UTIL.isNotNullCheck(studyPrdTypeParam) && blindedProdRecordId.add(currentProd.blindedProductRecId);
      }
    }
    if (prodListForCPD != null && prodListForCPD.length > 0) {
      chkAgainstCPD(); //if prod is available from above check then it will be checked against CPD lib
    }
  } catch (error) {
    logConsole(''Exception in checking product details: '' + error);
  }
}

// Fn to check the Listedness and Country param against the case fields
labCntryParam = UTIL.isNotNullCheck(labCntryParam) ? labCntryParam.split(''|'') : [];
function checkLabelingAndCountry(currReactRelatednessCollection) {
  try {
    if (UTIL.isNotNullCheck(labellingParam) || labCntryParam.length > 0) {
      for (var reactLabelIndex = 0; reactLabelIndex < currReactRelatednessCollection.drugReactListednessCollection.size(); reactLabelIndex++) {
        var labelling = currReactRelatednessCollection.drugReactListednessCollection.get(reactLabelIndex).listed + '''';
        var labellingCntry = currReactRelatednessCollection.drugReactListednessCollection.get(reactLabelIndex).country + '''';
        var labResult = UTIL.isNotNullCheck(labellingParam) ? (labelling == labellingParam) : true;
        var labCntryResult = UTIL.isNotNullCheck(labCntryParam) ? compareCaseWithParamValue(labellingCntry, labCntryParam) : true;
        if (labResult && labCntryResult) { //if lab country and labelling matches with parameter
          return true;
        }
      }
    } else {
      return true;
    }
    return false;
  } catch (error) {
    logConsole(''Exception in checking Labeling checkLabelingAndCountry: '' + error);
  }
}
// Fn to check Causality case value against parameters
function checkCausality() {
  try {
    var compCausalityArray = UTIL.isNotNullCheck(cmyCausParam) ? cmyCausParam.split(''|'') : [];
    var repCausalityArray = UTIL.isNotNullCheck(repCausParam) ? repCausParam.split(''|'') : [];
    var repCausFlag = false;
    var compCausFlag = false;
    for (var drugIndex = 0; drugIndex < drugCollection.size(); drugIndex++) {
      var eachDrugRecord = drugCollection.get(drugIndex);
      var caseDrugStudyProdTypeMatch = UTIL.isNotNullCheck(studyPrdTypeParam) ? checkParamValue(eachDrugRecord, ''studyProductType'', studyPrdTypeParam) : true;
      // chk if product is part of final product list, and not a linked blinded product and study product type matches
      if (finalProdListforCausality.indexOf(eachDrugRecord.productRecordID) != -1 && blindedProdRecordId.indexOf(eachDrugRecord.recordId) == -1 && caseDrugStudyProdTypeMatch) {
        for (var drugCausalityIndex = 0; drugCausalityIndex < eachDrugRecord.drugReactRelatednessCollection.size(); drugCausalityIndex++) {
          var currReactRelatednessCollection = eachDrugRecord.drugReactRelatednessCollection.get(drugCausalityIndex);
          var reporterCausality = currReactRelatednessCollection.reporterCausality + '''';
          var companyCausality = currReactRelatednessCollection.companyCausality + '''';
          if (eventArrList.indexOf(currReactRelatednessCollection.reaction) == -1) {
            logConsole(''Event and Product not qualified for causality check : '' + currReactRelatednessCollection.reaction);
            continue;
          }
          if (repCausalityArray.length == 0 || (UTIL.isNotNullCheck(reporterCausality) && compareCaseWithParamValue(reporterCausality, repCausalityArray))) {
            repCausFlag = true;		// if rep caus param is blank or match with case data
          } else {
            repCausFlag = false;
          }
          if (compCausalityArray.length == 0 || (UTIL.isNotNullCheck(companyCausality) && compareCaseWithParamValue(companyCausality, compCausalityArray))) {
            compCausFlag = true;	// if cmpy caus param is blank or match with case data
          } else {
            compCausFlag = false;
          }
          if (repCausalityArray.length == 0 && !compCausFlag) {
            repCausFlag = false;
          }
          if (compCausalityArray.length == 0 && !repCausFlag) {
            compCausFlag = false;
          }
          logConsole(''repCausFlag : '' + repCausFlag + '' compCausFlag : '' + compCausFlag);
          var causalityResult = (causConditionParam == 1 && repCausFlag && compCausFlag) || ((UTIL.isNullCheck(causConditionParam) || causConditionParam == 2) && (repCausFlag || compCausFlag));
          if (causalityResult && checkLabelingAndCountry(currReactRelatednessCollection)) {
            return true; // if causality and labeling matches for the qualified product list
          }
        }
      }
    }
    return false;
  } catch (error) {
    logConsole(''Exception in checking causality checkCausality: '' + error);
  }
}
// Product fields logic ends here.

// Main program starts here
function start() {
  try {
    getProdListFromParam(); // Fetch product list from parameter
    loadProdList(); // Compare with case data from prepare final product rec id

    if (finalProdListforCausality.size() > 0) {
      chkEventDetailsAndLoad(); // chk Event parameters with case data and load event array list
      logConsole(''Final Event List eventArrList Count: '' + eventArrList.size());
    }
    if (eventArrList.size() > 0 && checkCausality()) { // Chk if Event, Causality and Labeling values matches
      rule.put("ruleExecutionResult", "true");
      logConsole(''RULE PASSED.'');
    } else {
      rule.put("ruleExecutionResult", "false");
      logConsole(''RULE FAILED.'');
    }
  } catch (error) {
    logConsole(''Exception in running Main Program Fn: '' + error);
  }
}

start();
// Main program ends here
logConsole(''Execution Completed.'');','DistributionRule','USER_PRODUCT_EVENT_MATRIX_JS','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5012_2',NULL,'Distribution');
INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 

	 VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PRODUCT_EVENT_MATRIX',NULL,NULL,'Y','(C1)','{"recordId":"1730203008997","childConditions":[{"recordId":"1730203160524","refRuleConditionId":"1730204995778"}],"operator":"AND"}','[{"recordId":"1730204977175","lhsSameCtx":"N","referenceRuleName":"USER_PRODUCT_EVENT_MATRIX_PARAM_NEW","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_PRODUCT_EVENT_MATRIX_PARAM_NEW","rhsSameCtx":"N","referenceRuleID":"DR5012_1","index":"0","nfMarked":"N","rhsFilterConddLogic":"N","unitFieldPath":"N"},{"recordId":"1730204995778","lhsSameCtx":"N","referenceRuleName":"USER_PRODUCT_EVENT_MATRIX_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_PRODUCT_EVENT_MATRIX_JS","rhsSameCtx":"N","referenceRuleID":"DR5012_2","index":"1","nfMarked":"N","rhsFilterConddLogic":"N","unitFieldPath":"N"}]',NULL,'N','Y','Y','DistributionRule','USER_PRODUCT_EVENT_MATRIX','{"adhocRules":[],"paramMap":{"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Product Flag","fieldId":"113690"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD MAH As Coded","fieldId":"954003"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002_death.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_9159":{"codelistId":"20005","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"},{"code":"7","decode":"RSI"}],"fieldId":"150103"},"CL_9062_reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Reporter Causality","fieldPath":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Reporter Causality","fieldId":"117122"},"CL_9062":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Company Causality","fieldPath":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Company Causality","fieldId":"117676"},"CL_1002_causalityCondition.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality Condition (Yes = And, No= Or)","fieldPath":"causalityCondition.safetyReport.aerInfo.flpath","parameterName":"Causality Condition (Yes = And, No= Or)","fieldId":"102114"},"LIB_Meddra":{"codelistId":null,"libraryName":"Meddra","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Event MedDRA PT Code","fieldPath":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Event MedDRA PT Code","fieldId":"111112"},"CL_1002_eventExclude.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Event Exclude (Yes = Exclude, No = Include)","fieldPath":"eventExclude.safetyReport.aerInfo.flpath","parameterName":"Event Exclude (Yes = Exclude, No = Include)","fieldId":"102114"},"CL_10151":{"codelistId":"10151","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Related to study conduct","fieldPath":"causeOfAdverseEvent.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Related to study conduct","fieldId":"111831"},"CL_1002_causeOfAdverse.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Related to Study Condition (Yes = And, No = Or)","fieldPath":"causeOfAdverse.safetyReport.aerInfo.flpath","parameterName":"Related to Study Condition (Yes = And, No = Or)","fieldId":"102114"}}}',NULL,'Y','Frozen','DR5012','Y','Distribution');
	 
INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 	 
	 VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PRODUCT_EVENT_MATRIX_PARAM',NULL,'drugCollection$patient.safetyReport.aerInfo','Y','(C0 | C1)','{"recordId":"1730122130438","childConditions":[{"recordId":"1730122796795","refRuleConditionId":"1730122142635"},{"recordId":"1730122803117","refRuleConditionId":"1730122350738"}],"operator":"OR"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1013","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Characterization In ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"In","recordId":"1730122142635","lhsField":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Characterization","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"5015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Product Flag In ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"In","recordId":"1730122350738","lhsField":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD Product Flag","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"8008","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Study Product Type In ?","rhsSameCtx":"N","index":"2","nfMarked":"N","operator":"In","recordId":"1730122390327","lhsField":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Study Product Type","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9042","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Product description In ?","rhsSameCtx":"N","index":"3","nfMarked":"N","operator":"In","recordId":"1730122428183","lhsField":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"T","rhsFilterConddLogic":"N","lhsFieldString":"CPD Product description","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"709","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Approval Type In ?","rhsSameCtx":"N","index":"4","nfMarked":"N","operator":"In","recordId":"1730122507355","lhsField":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"D","rhsFilterConddLogic":"N","lhsFieldString":"CPD Approval Type","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD Authorization Country In ?","rhsSameCtx":"N","index":"5","nfMarked":"N","operator":"In","recordId":"1730122594326","lhsField":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"D","rhsFilterConddLogic":"N","lhsFieldString":"CPD Authorization Country","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFilterConddLogic":"N","ruleCondDisplayStr":"CPD MAH As Coded In ?","rhsSameCtx":"N","index":"6","nfMarked":"N","operator":"In","recordId":"1730122622218","lhsField":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"CPD MAH As Coded","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Seriousness In ?","rhsSameCtx":"N","index":"7","nfMarked":"N","operator":"In","recordId":"1730123149007","lhsField":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Seriousness","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9042","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Death? In ?","rhsSameCtx":"N","index":"8","nfMarked":"N","operator":"In","recordId":"1730123170924","lhsField":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Death?","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9042","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Life Threatening? In ?","rhsSameCtx":"N","index":"9","nfMarked":"N","operator":"In","recordId":"1730123195396","lhsField":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Life Threatening?","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"20005","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Labelling In ?","rhsSameCtx":"N","index":"10","nfMarked":"N","operator":"In","recordId":"1730123229100","lhsField":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Labelling","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Labelling Country In ?","rhsSameCtx":"N","index":"11","nfMarked":"N","operator":"In","recordId":"1730123279414","lhsField":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Labelling Country","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9062","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Company Causality In ?","rhsSameCtx":"N","index":"12","nfMarked":"N","operator":"In","recordId":"1730123306809","lhsField":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Company Causality","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9062","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reporter Causality In ?","rhsSameCtx":"N","index":"13","nfMarked":"N","operator":"In","recordId":"1730123334920","lhsField":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Reporter Causality","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"0","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Event MedDRA PT Code In ?","rhsSameCtx":"N","index":"14","nfMarked":"N","operator":"In","recordId":"1730123371237","lhsField":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Event MedDRA PT Code","unitFieldPath":"N"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Causality Condition (Yes = And, No= Or)","index":"15","nfMarked":"N","operator":"In","recordId":"1907721770774","anyOneLhs":"N","lhsField":"causalityCondition.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Causality Condition (Yes = And, No= Or)"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Event Exclude (Yes = Exclude, No = Include)","index":"16","nfMarked":"N","operator":"In","recordId":"1345671770774","anyOneLhs":"N","lhsField":"eventExclude.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Event Exclude (Yes = Exclude, No = Include)"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"10151","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Related to study conduct In ?","rhsSameCtx":"N","index":"17","nfMarked":"N","operator":"In","recordId":"1730566014922","lhsField":"causeOfAdverseEvent.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"D","rhsFilterConddLogic":"N","lhsFieldString":"Related to study conduct","unitFieldPath":"N"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Related to Study Condition (Yes = And, No = Or)","index":"18","nfMarked":"N","operator":"In","recordId":"1345645632774","anyOneLhs":"N","lhsField":"causeOfAdverse.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Related to Study Condition (Yes = And, No = Or)"}]',NULL,'N','Y',NULL,'DistributionRule','USER_PRODUCT_EVENT_MATRIX_PARAM','{"adhocRules":[],"paramMap":{"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Product Flag","fieldId":"113690"},"CL_8008":{"codelistId":"8008","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Product Type","fieldPath":"studyProductType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Study Product Type","fieldId":"113130"},"LIB_Product":{"codelistId":null,"libraryName":"Product","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Product description","fieldPath":"medicinalProduct.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Product description","fieldId":"113723"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Approval Type","fieldPath":"cpd.approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Approval Type","fieldId":"954844"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD Authorization Country","fieldPath":"cpd.approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD Authorization Country","fieldId":"954843"},"LIB_CU_ACC":{"codelistId":null,"libraryName":"CU_ACC","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"CPD MAH As Coded","fieldPath":"mahAsCoded.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"CPD MAH As Coded","fieldId":"954003"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousness.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"111159"},"CL_1002_death.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"},"CL_1002_lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Life Threatening?","fieldPath":"lifethreatening.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Life Threatening?","fieldId":"111151"},"CL_9159":{"codelistId":"20005","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling","fieldPath":"listed.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling","fieldId":"150101"},"LIB_9744_1015":{"codelistId":null,"libraryName":"9744_1015","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Labelling Country","fieldPath":"country.drugReactListednessCollection$drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Labelling Country","additionalValues":[{"code":"1","decode":"CORE"},{"code":"2","decode":"IB"},{"code":"3","decode":"SmPC"},{"code":"4","decode":"DSUR "},{"code":"6","decode":"JPN Device"},{"code":"5","decode":"IB - Japan"},{"code":"7","decode":"RSI"}],"fieldId":"150103"},"CL_9062_reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Reporter Causality","fieldPath":"reporterCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Reporter Causality","fieldId":"117122"},"CL_9062":{"codelistId":"9062","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Company Causality","fieldPath":"companyCausality.drugReactRelatednessCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Company Causality","fieldId":"117676"},"CL_1002_causalityCondition.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Causality Condition (Yes = And, No= Or)","fieldPath":"causalityCondition.safetyReport.aerInfo.flpath","parameterName":"Causality Condition (Yes = And, No= Or)","fieldId":"102114"},"LIB_Meddra":{"codelistId":null,"libraryName":"Meddra","allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Event MedDRA PT Code","fieldPath":"reactMedDraPtCode.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Event MedDRA PT Code","fieldId":"111112"},"CL_1002_eventExclude.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Event Exclude (Yes = Exclude, No = Include)","fieldPath":"eventExclude.safetyReport.aerInfo.flpath","parameterName":"Event Exclude (Yes = Exclude, No = Include)","fieldId":"102114"},"CL_10151":{"codelistId":"10151","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Related to study conduct","fieldPath":"causeOfAdverseEvent.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Related to study conduct","fieldId":"111831"},"CL_1002_causeOfAdverse.safetyReport.aerInfo.flpath":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Related to Study Condition (Yes = And, No = Or)","fieldPath":"causeOfAdverse.safetyReport.aerInfo.flpath","parameterName":"Related to Study Condition (Yes = And, No = Or)","fieldId":"102114"}}}',NULL,'Y','Frozen','DR5012_1',NULL,'Distribution');




-----------------------------------------PMDA DEVICE RULES ATTRIBUTES---------------------------------------

--INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
--VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_DEVICE_MATRIX',NULL,NULL,'Y','(C2)','{"recordId":"1708337553887","childConditions":[{"recordId":"1708345330415","refRuleConditionId":"1708345317050"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_DEVICE_MATRIX_PARAM","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_DEVICE_MATRIX_PARAM","rhsSameCtx":"N","index":"1","nfMarked":"N","recordId":"1708345301256","anyOneLhs":"N","referenceRuleID":"DR5019_1","rhsFilterConddLogic":"N","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_DEVICE_MATRIX_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_DEVICE_MATRIX_JS","rhsSameCtx":"N","index":"2","nfMarked":"N","recordId":"1708345317050","anyOneLhs":"N","referenceRuleID":"DR5019_2","rhsFilterConddLogic":"N","unitFieldPath":"N"}]',NULL,'N','Y',NULL,'DistributionRule','DR5019:USER_DEVICE_MATRIX','{"adhocRules":[],"paramMap":{"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"},"CL_1002_Outcome":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Outcome is Fatal","fieldPath":"seriousnessHealathOutcome.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Outcome is Fatal","fieldId":"654012"},"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_10064":{"codelistId":"10064","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Type","fieldPath":"healthDamageType.patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Type","fieldId":"106202"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousnessHealathDamage.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"654011"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Type","fieldPath":"approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Type","fieldId":"954007"},"CL_10063":{"codelistId":"10063","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Suspect, Risk","fieldPath":"suspectRisk.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Suspect, Risk","fieldId":"654004"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Country","fieldPath":"approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Country","fieldId":"954005"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Device/Regenerative Causality to Device","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Device/Regenerative Causality to Device","fieldId":"102112"}}}',NULL,'Y','Frozen','DR5019','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
		VALUES	 (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_DEVICE_MATRIX_JS',NULL,NULL,'Y','()','{"recordId":"1708337644110","operator":"AND"}',NULL,NULL,'Y','Y','//////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------------------------------
//              All Rights Reserved.
//
//              This software is the confidential and proprietary information of PharmApps, LLC.
//              (Confidential Information).
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name    :  USER_DEVICE_MATRIX.js
//-------------------------------------------------------------------------------------------------------
// Description  :  This script is a custom distribution attribute to validate Product Approval HealthDamage and Causality Combinations.
// File History :  1.0
// Created By   :  Vinay T R
// Date         :  08-MAR-2024
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  2.0
// Modified By  :  Vinay T R
// Date         :  11-MAR-2024
// Modified Desc:  isUnRelatedAsPerCompany() & isAccountUnRelatedAsPerCompany() modified to return true when companyCausality is null  
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  3.0
// Modified By  :  Vinay T R
// Date         :  15-MAR-2024
// Modified Desc:  Outcome is Fatal Parameter Validation is checked using a new compareOutcomeCaseEventWithParamValue()
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  4.0
// Modified By  :  Vinay T R
// Date         :  08-APR-2024
// Modified Desc:  Enhanced the Validation to check DR Parameters Approval Type, Approval Country and Product Flag at CPD level.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  5.0
// Modified By  :  Vinay T R
// Date         :  16-APR-2024
// Modified Desc:  Enhanced the Validation to check DR Parameter HealthDamage Suspect, Risk value with suspect for case data Null or suspect.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  6.0
// Modified By  :  Vinay T R
// Date         :  24-APR-2024
// Modified Desc:  Enhanced to check for Empty and event related fields.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
// File History :  7.0
// Modified By  :  Vinay T R
// Date         :  24-MAY-2024
// Modified Desc:  Enhanced not to consider Blank value of Company or Reporter Causality as Related.
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////

var ruleName = ''USER_DEVICE_MATRIX'';
var logFlag = false;

//Case level values
var initialReceivedDate = inboundMessage.aerInfo.safetyReport.receiveDate;
var receiptNum = inboundMessage.receiptItem.receiptNo;
var healthDamageCollection = inboundMessage.aerInfo.safetyReport.patient.healthDamageCollection;
var healthDamageType = inboundMessage.aerInfo.safetyReport.patient.healthDamageType;

//Product Characteristics 
var prodCharParam = userParameters.get(''drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath'');

//Product Flag 
var prodFlagParam = userParameters.get(''productType.drugCollection$patient.safetyReport.aerInfo.flpath'');

//Approval Type
var appTypeArrayParam = userParameters.get(''approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');

//Authorization Country
var appCountryArrayParam = userParameters.get(''approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath'');

//Event related Fields : 
//Seriousness 
var seriousnessParam = userParameters.get(''seriousnessHealathDamage.healthDamageCollection$patient.safetyReport.aerInfo.flpath'');

//Health Damage Suspect, Risk - Codelist ID: 10063
var healthDamageSuspRiskParam = userParameters.get(''suspectRisk.healthDamageCollection$patient.safetyReport.aerInfo.flpath'');

//Health Damage Type
var healthDamageTypeParam = userParameters.get(''healthDamageType.patient.safetyReport.aerInfo.flpath'');

//Outcome is Fatal 
var OutcomeParam = userParameters.get(''seriousnessHealathOutcome.healthDamageCollection$patient.safetyReport.aerInfo.flpath'');

//Causality As per Procedure : Custom Codelist ID: 8201 with all 4 Param Values
var causalityParam = userParameters.get(''causality.safetyReport.aerInfo.flpath'');

var eventMap = new java.util.HashMap();
var relatedCodesArray = [];
var unrelatedCodesArray = [];
var relatedAccountCodesArray = [];
var unrelatedAccountCodesArray = [];
var prodCollection = null;

try {
  logConsole("CUSTOM JAVASCRIPT EXECUTION START............");
  prodCollection = loadProductCollection();
  loadEventMap();
  loadcausalityRelatedMap();
  loadcausalityUnRelatedMap();
  loadcausalityAccountRelatedMap();
  loadcausalityAccountUnRelatedMap();
  checkCombFields();
} catch (error) {
  logConsole("Exception caught in Main Block::" + error);
}

function loadProductCollection() {
  var drugCollection = inboundMessage.aerInfo.safetyReport.patient.drugCollection;
  var includeProductMap = new java.util.HashMap();
  var resultList = new java.util.ArrayList();

  try {
    if (!isEmptyAndNull(drugCollection)) {
      var isReportbleProduct = false;

      for (var drugIndex = 0; drugIndex < drugCollection.size(); drugIndex++) {
        var currentProd = drugCollection.get(drugIndex);
        if (currentProd != null && currentProd.productRecordID != null) {
          var notReportableInJpnCaseValue = currentProd.notReportableInJpn;
          if (notReportableInJpnCaseValue != null) {
            notReportableInJpnCaseValue = String(notReportableInJpnCaseValue);
            if (notReportableInJpnCaseValue == ''true'') {
              isReportbleProduct = false;
            } else if (notReportableInJpnCaseValue == ''false'') {
              isReportbleProduct = true;
            }
          } else if (isNull(notReportableInJpnCaseValue)) {
            isReportbleProduct = true;
          }
          if (isReportbleProduct) {            
            includeProductMap.put(currentProd, currentProd);
          }
        }
      }

      if (includeProductMap != null && includeProductMap.values() != null) {
        resultList.addAll(includeProductMap.values());
      } else {
        resultList = null;
      }
    } else {
      resultList = null;
    }
  } catch (msg) {
    logConsole(''loadProductCollection() :: could not load the Product Collection :'' + msg);
  }
  return resultList;
}

function loadEventMap() {
  try {
    if (!isEmptyAndNull(healthDamageCollection)) {
      for (var eventIndex = 0; eventIndex < healthDamageCollection.size(); eventIndex++) {
        var eachEvent = healthDamageCollection.get(eventIndex);
        eventMap.put(eachEvent.recordId, eachEvent);
      }
    }
  } catch (msg) {
    logConsole(''loadEventMap() :: could not load the eventMap :'' + msg);
  }
}

function logConsole(message) {
  if (logFlag) {
    UTIL.getLogger().error(receiptNum + '': '' + ruleName + '': '' + message);
  }
}

function isEmptyAndNull(inputString) {
  if (inputString != null && inputString != ''undefined'' && inputString != '''') {
    return false;
  } else {
    return true;
  }
}

function compareCaseWithParamValue(caseData, paramList) {
  var status = false;
  if (!isEmptyAndNull(caseData) && !isEmptyAndNull(paramList)) {
    for (var i = 0; i < paramList.length; i++) {
      if (caseData == paramList[i]) {
        status = true;
        break;
      }
    }
  }
  return status;
}

function compareCaseEventWithParamValue(caseData, paramValue) {
  var status = false;
  if (paramValue != null && caseData != null) {
    paramValue = String(paramValue);
    caseData = String(caseData);
    status = caseData.equals(paramValue);
  }
  if (isNull(paramValue)) {
    status = true;
  }
  return status;
}

function compareCaseEventWithParamValue(caseData, paramValue) {
  var status = false;
  if (paramValue != null && caseData != null) {
    paramValue = String(paramValue);
    caseData = String(caseData);
    status = caseData.equals(paramValue);
  }
  if (isNull(paramValue)) {
    status = true;
  }
  return status;
}

function compareOutcomeCaseEventWithParamValue(caseData, paramValue) {
  var status = false;
  if (paramValue != null) {
    paramValue = String(paramValue);
    if (paramValue.equals("1") && caseData != null) {
      status = caseData.equals(paramValue);
    }
    if (paramValue.equals("2")) {
      if (caseData != null) {
        status = caseData != ''1'';
      }
    }
  }
  if (isNull(paramValue)) {
    status = true;
  }
  return status;
}

function compareHealthSuspectRiskCaseWithParamValue(caseData, paramValue) {
  var status = false;
  if (paramValue != null) {
    paramValue = String(paramValue);
    if (paramValue.equals("2") && caseData != null) {
      status = caseData.equals(paramValue);
    }
    if (paramValue.equals("1")) {
      if (caseData != null) {
        status = caseData.equals(paramValue);
      }
      if (isNull(caseData)) {
        status = true;
      }
    }
  }

  return status;
}

function convertToArray(inputParam) {
  var inputParamArray = null;
  var inputParamString = null;
  if (!isEmptyAndNull(inputParam)) {
    inputParamString = String(inputParam);
    if (!isEmptyAndNull(inputParamString)) {
      inputParamArray = inputParamString.split("|");
    }
  }
  return inputParamArray;
}

function getTextFromArray(inputArray) {
  var inputTxt = '''';
  if (!isEmptyAndNull(inputArray)) {
    for (var arrayIndex = 0; arrayIndex < inputArray.length; arrayIndex++) {
      if (arrayIndex == 0) {
        inputTxt = "''" + inputArray[arrayIndex] + "''";
      } else {
        inputTxt += "," + "''" + inputArray[arrayIndex] + "''";
      }
    }
  }
  return inputTxt;
}

function checkCombFields() {
  var isProdCharMatched = false;
  var isCausalityMatched = false;
  var isProdFlagMatched = false;
  var isApprovalMatched = false;
  var isHealthDamageEvent = false;
  var currentProd = null;

  try {
    if (!isEmptyAndNull(prodCollection)) {
      for (var drugIndex = 0; drugIndex < prodCollection.size(); drugIndex++) {
        currentProd = prodCollection.get(drugIndex);
        isProdCharMatched = getProdChar(currentProd);
        isApprovalMatched = getApprovalDetails(currentProd);
        isCausalityMatched = getCausalityFields(currentProd);        
        if (isProdCharMatched && isApprovalMatched && isCausalityMatched) {
          break;
        }
      }
      isHealthDamageEvent = getEventSpecificDetails();
    }
    

    if (isProdCharMatched && isApprovalMatched && isCausalityMatched && isHealthDamageEvent) {
      rule.put("ruleExecutionResult", "true");
      logConsole(''RULE PASSED'');
    } else {
      rule.put("ruleExecutionResult", "false");
      logConsole(''RULE FAILED'');
    }
  } catch (msg) {
    logConsole(''Exception occured in checkCombFields() :: '' + msg);
  }
}


function getProdChar(currentProd) {
  var isValidDrugChar = false;
  var prodCharParamValueArray = null;
  var curProdCharCaseValue = null;
  if (isEmptyAndNull(prodCharParam)) {
    isValidDrugChar = true;
  } else if (!isEmptyAndNull(prodCharParam)) {
    prodCharParamValueArray = convertToArray(prodCharParam);
    curProdCharCaseValue = currentProd.drugCharacterization;
    if (!isEmptyAndNull(curProdCharCaseValue) &&
      !isEmptyAndNull(prodCharParamValueArray)) {
      isValidDrugChar = compareCaseWithParamValue(curProdCharCaseValue, prodCharParamValueArray);
    }
  }
  return isValidDrugChar;
}

function getApprovalDetails(currentProd) {
  var isApproval = false;

  try {
    if (isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam) && isEmptyAndNull(prodFlagParam)) {
      isApproval = true;
    } else {
      var appTypeArray = null;
      var appCountryArray = null;
      var prodFlagParamValueArrayArray = null;
      var approvalType = null;
      var approvalCountry = null;
      var productFlag = null;     

      if (!isEmptyAndNull(appTypeArrayParam)) {
        appTypeArray = convertToArray(appTypeArrayParam);
        approvalType = getTextFromArray(appTypeArray);
      }

      if (!isEmptyAndNull(appCountryArrayParam)) {
        appCountryArray = convertToArray(appCountryArrayParam);
        approvalCountry = getTextFromArray(appCountryArray);
      }

      if (!isEmptyAndNull(prodFlagParam)) {
        prodFlagParamValueArrayArray = convertToArray(prodFlagParam);
        productFlag = getTextFromArray(prodFlagParamValueArrayArray);
      }
      
      isApproval = getAppSingleCombScenarios(currentProd, approvalType, approvalCountry, productFlag);
    }
  } catch (msg) {
    logConsole(''Exception occured in getApprovalDetails() :: '' + msg);
  }
  return isApproval;
}

function getAppSingleCombScenarios(currentProd, appTypeArray, appCountryArray, prodFlagParamValueArrayArray) {
  var cpdCombResult = false;

  try {
    var isProductFlagPresent = false;
    var isappTypeArrayPresent = false;
    var isapprovalCtryPresent = false;
    var isProductFlagAppTypePresent = false;
    var isProductFlagAppCntryPresent = false;
    var iscpdAppTypeAppCntryPresent = false;
    var isProductFlagAppTypeAppCntryPresent = false;

    var isProductFlagPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam);
    var isappTypeArrayPassed = isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam);
    var isapprovalCtryPassed = isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appTypeArrayParam) && !isEmptyAndNull(appCountryArrayParam);
    var isProductFlagAppTypePassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam);
    var isProductFlagAppCntryPassed = !isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appTypeArrayParam) && !isEmptyAndNull(appCountryArrayParam);
    var iscpdAppTypeAppCntryPassed = isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(appTypeArrayParam) && !isEmptyAndNull(appCountryArrayParam);
    var isProductFlagAppTypeAppCntryPassed = !isEmptyAndNull(prodFlagParam) && !isEmptyAndNull(appTypeArrayParam) && !isEmptyAndNull(appCountryArrayParam);

    if (!isEmptyAndNull(prodCollection) && prodCollection.size() > 0) {
      if (isProductFlagPassed) {
        isProductFlagPresent = getcpdProdFlag(currentProd, prodFlagParamValueArrayArray);
      } else if (isappTypeArrayPassed) {
        isappTypeArrayPresent = getcpdAppType(currentProd, appTypeArray);
      } else if (isapprovalCtryPassed) {
        isapprovalCtryPresent = getcpdAppCntry(currentProd, appCountryArray);
      } else if (isProductFlagAppTypePassed) {
        isProductFlagAppTypePresent = getcpdProdFlagAppType(currentProd, prodFlagParamValueArrayArray, appTypeArray);
      } else if (isProductFlagAppCntryPassed) {
        isProductFlagAppCntryPresent = getcpdProdFlagAppCntry(currentProd, prodFlagParamValueArrayArray, appCountryArray);
      } else if (iscpdAppTypeAppCntryPassed) {
        iscpdAppTypeAppCntryPresent = getcpdAppTypeAppCntry(currentProd, appTypeArray, appCountryArray);
      } else if (isProductFlagAppTypeAppCntryPassed) {
        isProductFlagAppTypeAppCntryPresent = getcpdProdFlagAppTypeAppCntry(currentProd, prodFlagParamValueArrayArray, appTypeArray, appCountryArray);
      }
    }

    if (isProductFlagPresent || isappTypeArrayPresent || isapprovalCtryPresent ||
      isProductFlagAppTypePresent || isProductFlagAppCntryPresent ||
      iscpdAppTypeAppCntryPresent || isProductFlagAppTypeAppCntryPresent) {
      cpdCombResult = true;
    }
  } catch (msg) {
    logConsole(''Exception occured in getAppSingleCombScenarios() :: '' + msg);
  }
  return cpdCombResult;
}


function getcpdProdFlag(currentProd, prodFlagParamValueArray) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(prodFlagParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValueArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {    
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND PRODUCT_TYPE IN (" + prodFlagParamValueArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);	
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);	
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppType(currentProd, appTypeArray) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(appTypeArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(appTypeArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1) AND coalesce(APPROVAL_TYPE,''NA'') IN (" + appTypeArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }

  }
  return cpdSpecificResult;
}

function getcpdAppCntry(currentProd, appCountryArray) {
  var cpdSpecificResult = false;
  if (isEmptyAndNull(appCountryArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(appCountryArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1)  AND coalesce(COUNTRY_CODE,''NA'') IN (" + appCountryArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getCpdProdFlagAppType(currentProd, prodFlagParamValueArray, appTypeArray) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appTypeArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(appTypeArray) && !isEmptyAndNull(prodFlagParamValueArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
   var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1)  AND coalesce(APPROVAL_TYPE,''NA'') IN (" + appTypeArray + ") AND PRODUCT_TYPE IN (" + prodFlagParamValueArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdProdFlagAppCntry(currentProd, prodFlagParamValueArrayArray, appCountryArray) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appCountryArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValueArrayArray) && !isEmptyAndNull(appCountryArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1)  AND coalesce(COUNTRY_CODE,''NA'') IN (" + appCountryArray + ") AND PRODUCT_TYPE IN (" + prodFlagParamValueArrayArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdAppTypeAppCntry(currentProd, appTypeArray, appCountryArray) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(appTypeArray) && !isEmptyAndNull(appCountryArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1'' AND FK_AGX_PRODUCT_REC_ID IN (?1)  AND coalesce(APPROVAL_TYPE,''NA'') IN (" + appTypeArray + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + appCountryArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getcpdProdFlagAppTypeAppCntry(currentProd, prodFlagParamValueArrayArray, appTypeArray, appCountryArray) {
  var cpdSpecificResult = false;

  if (isEmptyAndNull(prodFlagParam) && isEmptyAndNull(appTypeArrayParam) && isEmptyAndNull(appCountryArrayParam)) {
    cpdSpecificResult = true;
  } else if (!isEmptyAndNull(prodFlagParamValueArrayArray) && !isEmptyAndNull(appTypeArray) && !isEmptyAndNull(appCountryArray) && !isEmptyAndNull(currentProd) && !isEmptyAndNull(currentProd.productRecordID)) {
    var cpdQueryCount = "SELECT COUNT(*) FROM LSMV_PRODUCT_TRADENAME WHERE LICENSE_STATUS = ''1''  AND FK_AGX_PRODUCT_REC_ID IN (?1)  AND coalesce(APPROVAL_TYPE,''NA'') IN (" + appTypeArray + ") AND coalesce(COUNTRY_CODE,''NA'') IN (" + appCountryArray + ") AND PRODUCT_TYPE IN (" + prodFlagParamValueArrayArray + ")";
    var param = new java.util.HashMap();
    param.put(''1'', currentProd.productRecordID);
    var cpdSpecificCount = genericCrudService.getCountByNativeQuery(cpdQueryCount, param);
    if (cpdSpecificCount != null && cpdSpecificCount > 0) {
      cpdSpecificResult = true;
    }
  }
  return cpdSpecificResult;
}

function getEventSpecificDetails() {
  var isHealthDamageEvent = false;
  try {
    if (!isEmptyAndNull(healthDamageCollection)) {
      for (var eventIndex = 0; eventIndex < healthDamageCollection.size(); eventIndex++) {
        var currentEvent = healthDamageCollection.get(eventIndex);
        isHealthDamageEvent = getAllEventCheck(currentEvent);
        if (isHealthDamageEvent) {
          break;
        }
      }
    }
  } catch (msg) {
    logConsole(''Exception occured in getEventSpecificDetails() :: '' + msg);
  }
  return isHealthDamageEvent;
}

function getAllEventCheck(currentEvent) {
  var isEventStatus = false;
  try {
    var isSeriousEventMatch = false;
    var isSuspectRiskEvent = false;
    var isHealthDamageTypeEvent = false;
    var isOutcomeEvent = false;
    if (isEmptyAndNull(seriousnessParam) && isEmptyAndNull(healthDamageSuspRiskParam) &&
      isEmptyAndNull(healthDamageTypeParam) && isEmptyAndNull(OutcomeParam)) {
      isEventStatus = true;
    } else if (!isEmptyAndNull(healthDamageCollection) && currentEvent != null) {

      if (isEmptyAndNull(seriousnessParam)) {
        isSeriousEventMatch = true;
      } else if (!isEmptyAndNull(seriousnessParam)) {
        var eventSeriounessCaseValue = currentEvent.seriousnessHealathDamage != null ? String(currentEvent.seriousnessHealathDamage) : null;
        isSeriousEventMatch = compareCaseEventWithParamValue(eventSeriounessCaseValue, seriousnessParam);
      }

      if (isEmptyAndNull(healthDamageSuspRiskParam)) {
        isSuspectRiskEvent = true;
      } else if (!isEmptyAndNull(healthDamageSuspRiskParam)) {
        var eventSuspectRiskCaseValue = currentEvent.suspectRisk != null ? String(currentEvent.suspectRisk) : null;
        isSuspectRiskEvent = compareHealthSuspectRiskCaseWithParamValue(eventSuspectRiskCaseValue, healthDamageSuspRiskParam);
      }

      if (isEmptyAndNull(healthDamageTypeParam)) {
        isHealthDamageTypeEvent = true;
      } else if (!isEmptyAndNull(healthDamageTypeParam)) {
        var eventHealthDamageTypeCaseValue = healthDamageType != null ? String(healthDamageType) : null;
        isHealthDamageTypeEvent = compareCaseEventWithParamValue(eventHealthDamageTypeCaseValue, healthDamageTypeParam);
      }

      if (isEmptyAndNull(OutcomeParam)) {
        isOutcomeEvent = true;
      } else if (!isEmptyAndNull(OutcomeParam)) {
        var eventOutcomeCaseValue = currentEvent.seriousnessHealathOutcome != null ? String(currentEvent.seriousnessHealathOutcome) : null;
        isOutcomeEvent = compareOutcomeCaseEventWithParamValue(eventOutcomeCaseValue, OutcomeParam);
      }
    }

    if (isHealthDamageTypeEvent && isSeriousEventMatch && isSuspectRiskEvent && isOutcomeEvent) {
      isEventStatus = true;
    }
  } catch (msg) {
    logConsole(''Exception occured in getAllEventCheck() :: '' + msg);
  }
  return isEventStatus;
}


function isNull(inputValue) {
  if (inputValue != null) {
    return false;
  } else {
    return true;
  }
}

function loadcausalityRelatedMap() {
  var relatedCodesQuery = '''';
  relatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) IN (SELECT trim(regexp_split_to_table(PREFERENCE_VALUE,''\,+'')) FROM lsmv_agx_appl_pref WHERE PREFERENCE_NAME = ''CASUALITY_RESULTS'') GROUP BY C.CODE ORDER BY 1";
  var relatedResult = genericCrudService.findAllByNativeQuery(relatedCodesQuery, null);
  if (relatedResult != null) {
    for (var relatedIndex = 0; relatedIndex < relatedResult.size(); relatedIndex++) {
      if (relatedResult.get(relatedIndex) != null) {
        relatedCodesArray.push(String(relatedResult.get(relatedIndex)));
      }
    }
  }
}

function loadcausalityUnRelatedMap() {
  var unrelatedCodesQuery = '''';
  unrelatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) NOT IN (SELECT trim(regexp_split_to_table(PREFERENCE_VALUE,''\,+'')) FROM lsmv_agx_appl_pref WHERE PREFERENCE_NAME = ''CASUALITY_RESULTS'') GROUP BY C.CODE ORDER BY 1";
  var unrelatedResult = genericCrudService.findAllByNativeQuery(unrelatedCodesQuery, null);
  if (unrelatedResult != null) {
    for (var unrelatedIndex = 0; unrelatedIndex < unrelatedResult.size(); unrelatedIndex++) {
      if (unrelatedResult.get(unrelatedIndex) != null) {
        unrelatedCodesArray.push(String(unrelatedResult.get(unrelatedIndex)));
      }
    }
  }
}

function loadcausalityAccountRelatedMap() {
  var distUnitName = distributionUnit.distributionUnitName;
  var relatedCodesQuery = '''';
  if (!isEmptyAndNull(distUnitName)) {
    relatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) IN (SELECT trim(regexp_split_to_table(CASUALITY_RESULTS,''\,+'')) FROM LSMV_ACCOUNTS WHERE CASUALITY_RESULTS IS NOT NULL AND RECORD_ID IN (SELECT FK_ACCOUNT FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME IN (''" +
      distUnitName + "'') )) ORDER BY 1";
    var relatedResult = genericCrudService.findAllByNativeQuery(relatedCodesQuery, null);
    if (relatedResult != null && relatedResult.size() > 0) {
      for (var relatedIndex = 0; relatedIndex < relatedResult.size(); relatedIndex++) {
        if (relatedResult.get(relatedIndex) != null) {
          relatedAccountCodesArray.push(String(relatedResult.get(relatedIndex)));
        }
      }
    }
  }
}

function loadcausalityAccountUnRelatedMap() {
  var distUnitName = distributionUnit.distributionUnitName;
  var unrelatedCodesQuery = '''';
  if (!isEmptyAndNull(distUnitName)) {
    unrelatedCodesQuery = "SELECT C.CODE FROM LSMV_CODELIST_NAME N, LSMV_CODELIST_CODE C, LSMV_CODELIST_DECODE D WHERE CODELIST_ID = 9062 AND FK_CL_NAME_REC_ID = N.RECORD_ID AND FK_CL_CODE_REC_ID = C.RECORD_ID AND UPPER(LANGUAGE_CODE) = ''EN'' AND trim(C.CODE) NOT IN (SELECT trim(regexp_split_to_table(CASUALITY_RESULTS,''\,+'')) FROM LSMV_ACCOUNTS WHERE CASUALITY_RESULTS IS NOT NULL AND RECORD_ID IN (SELECT FK_ACCOUNT FROM LSMV_DISTRIBUTION_UNIT WHERE DISTRIBUTION_UNIT_NAME IN (''" +
      distUnitName + "'') )) ORDER BY 1";
    var unrelatedResult = genericCrudService.findAllByNativeQuery(unrelatedCodesQuery, null);
    if (unrelatedResult != null && unrelatedResult.size() > 0) {
      for (var relatedIndex = 0; relatedIndex < unrelatedResult.size(); relatedIndex++) {
        if (unrelatedResult.get(relatedIndex) != null) {
          unrelatedAccountCodesArray.push(String(unrelatedResult.get(relatedIndex)));
        }
      }
    }
  }
}

function getCausalityFields(currentProd) {
  var isCausality = false;
  try {
	  
    if (isEmptyAndNull(causalityParam)) {
      isCausality = true;
    }
    if (!isEmptyAndNull(causalityParam)) {
      var causalityParamValue = causalityParam ? String(causalityParam) : null;
      var isRelatedAsCompany = false;
      var isRelatedAsCompanyOrReporter = false;
      var isUnRelatedAsCompany = false;
      var isUnRelatedAsCompanyAndReporter = false;
      var isAccountRelatedAsCompany = false;
      var isAccountRelatedAsCompanyOrReporter = false;
      var isAccountUnRelatedAsCompany = false;
      var isAccountUnRelatedAsCompanyAndReporter = false;
      var drugDeviceHealthRelatednessCollection = null;
      var accountRelatednessExists = false;

      if (!isEmptyAndNull(prodCollection) && currentProd != null && causalityParamValue != null) {
        drugDeviceHealthRelatednessCollection = currentProd.drugDeviceHealthRelatednessCollection;

        if (relatedAccountCodesArray != '''' && relatedAccountCodesArray != null) {
          accountRelatednessExists = true;
        } else {
          accountRelatednessExists = false;
        }
        if (accountRelatednessExists && drugDeviceHealthRelatednessCollection != null) {
          if (causalityParamValue == ''8001'') {
            isAccountRelatedAsCompany = getAccountRelatedAsCompany(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8002'') {
            isAccountRelatedAsCompanyOrReporter = getAccountRelatedAsCompanyOrReporter(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8003'') {
            isAccountUnRelatedAsCompany = getAccountUnRelatedAsCompany(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8004'') {
            isAccountUnRelatedAsCompanyAndReporter = getAccountUnRelatedAsCompanyAndReporter(drugDeviceHealthRelatednessCollection);
          }
          if (isAccountRelatedAsCompany || isAccountRelatedAsCompanyOrReporter ||
            isAccountUnRelatedAsCompany ||
            isAccountUnRelatedAsCompanyAndReporter) {
            isCausality = true;
          }
        } else if (!accountRelatednessExists && drugDeviceHealthRelatednessCollection != null) {
          if (causalityParamValue == ''8001'') {
            isRelatedAsCompany = getRelatedAsCompany(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8002'') {
            isRelatedAsCompanyOrReporter = getRelatedAsCompanyOrReporter(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8003'') {
            isUnRelatedAsCompany = getUnRelatedAsCompany(drugDeviceHealthRelatednessCollection);
          } else if (causalityParamValue == ''8004'') {
            isUnRelatedAsCompanyAndReporter = getUnRelatedAsCompanyAndReporter(drugDeviceHealthRelatednessCollection);
          }
          if (isRelatedAsCompany || isRelatedAsCompanyOrReporter ||
            isUnRelatedAsCompany || isUnRelatedAsCompanyAndReporter) {
            isCausality = true;
          }
        }
      }
    }
  } catch (error) {
    logConsole("Exception occured in getCausalityFields()::" + error);
  }
  return isCausality;
}

function getRelatedAsCompany(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var isCausalityMached = false;
  var currentEvent = null;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getRelatedAsCompanyOrReporter(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getUnRelatedAsCompany(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getUnRelatedAsCompanyAndReporter(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getAccountRelatedAsCompany(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isAccountRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getAccountRelatedAsCompanyOrReporter(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isAccountRelatedCompanyOrReporter(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getAccountUnRelatedAsCompany(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isAccountUnRelatedAsPerCompany(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function getAccountUnRelatedAsCompanyAndReporter(drugDeviceHealthRelatednessCollection) {
  var companyCausalityCaseValue = null;
  var reporterCausalityCaseValue = null;
  var currentEvent = null;
  var isCausalityMached = false;
  var isEventToBeChecked = false;

  if (!isEmptyAndNull(drugDeviceHealthRelatednessCollection)) {
    outer_loop: for (var curPrdIndex = 0; curPrdIndex < drugDeviceHealthRelatednessCollection.size(); curPrdIndex++) {
      if (drugDeviceHealthRelatednessCollection.get(curPrdIndex) != null &&
        drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage != null) {
        currentEvent = eventMap.get(drugDeviceHealthRelatednessCollection.get(curPrdIndex).healthDamage);
      }

      if (currentEvent != null) {
        isEventToBeChecked = getAllEventCheck(currentEvent);
      }
      if (isEventToBeChecked) {
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality != null) {
          companyCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceCompanyCausality);
        }
        if (drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality != null) {
          reporterCausalityCaseValue = String(drugDeviceHealthRelatednessCollection.get(curPrdIndex).deviceReporterCausality);
        }
        isCausalityMached = isAccountUnRelatedCompanyAndReporter(companyCausalityCaseValue, reporterCausalityCaseValue);

        if (isCausalityMached) {
          isCausalityMached = true;
          break outer_loop;
        } else {
          isCausalityMached = false;
        }
      }
    }
  }
  return isCausalityMached;
}

function isRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, relatedCodesArray);
  }
  if (isCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}

function isRelatedCompanyOrReporter(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isReporterCausalityMatched = false;
  var isUnRelatedReporterCausalityMatched = false;
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) &&
    !isEmptyAndNull(relatedCodesArray)) {
    isReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, relatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, relatedCodesArray);
  }
  if (!isEmptyAndNull(reporterCausality) && !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, unrelatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedCodesArray);
  }
  if (isCompanyCausalityMatched && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = false; // changed as part of CR SIMPL-75533
  } else if (isCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = false; // changed as part of CR SIMPL-75533
  }
  return isCausalityMached;
}

function isUnRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedCodesArray);
  }
  if (isUnRelatedCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}

function isUnRelatedCompanyAndReporter(companyCausality, reporterCausality) {
  var isUnrelatedCompanyCausalityMatched = false;
  var isUnrelatedReporterCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) && !isEmptyAndNull(unrelatedCodesArray)) {
    isUnrelatedReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, unrelatedCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedCodesArray)) {
    isUnrelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedCodesArray);
  }
  if (isUnrelatedCompanyCausalityMatched && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnrelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true; // changed as part of CR SIMPL-75533
  } else if (isNull(companyCausality) && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = true; // changed as part of CR SIMPL-75533
  }
  return isCausalityMached;
}

function isAccountRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedAccountCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, relatedAccountCodesArray);
  }
  if (isCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = false;
  }
  return isCausalityMached;
}

function isAccountRelatedCompanyOrReporter(companyCausality, reporterCausality) {
  var isCompanyCausalityMatched = false;
  var isReporterCausalityMatched = false;
  var isUnRelatedReporterCausalityMatched = false;
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) && !isEmptyAndNull(relatedAccountCodesArray)) {
    isReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, relatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(relatedAccountCodesArray)) {
    isCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, relatedAccountCodesArray);
  }
  if (!isEmptyAndNull(reporterCausality) && !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, unrelatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedAccountCodesArray);
  }
  if (isCompanyCausalityMatched && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isUnRelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = false; // changed as part of CR SIMPL-75533
  } else if (isCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isUnRelatedReporterCausalityMatched) {
    isCausalityMached = false;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = false; // changed as part of CR SIMPL-75533
  }
  return isCausalityMached;
}

function isAccountUnRelatedAsPerCompany(companyCausality, reporterCausality) {
  var isUnRelatedCompanyCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnRelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedAccountCodesArray);
  }
  if (isUnRelatedCompanyCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality)) {
    isCausalityMached = true;
  }
  return isCausalityMached;
}

function isAccountUnRelatedCompanyAndReporter(companyCausality, reporterCausality) {
  var isUnrelatedCompanyCausalityMatched = false;
  var isUnrelatedReporterCausalityMatched = false;
  var isCausalityMached = false;
  if (!isEmptyAndNull(reporterCausality) && !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnrelatedReporterCausalityMatched = compareCaseWithParamValue(reporterCausality, unrelatedAccountCodesArray);
  }
  if (!isEmptyAndNull(companyCausality) && !isEmptyAndNull(unrelatedAccountCodesArray)) {
    isUnrelatedCompanyCausalityMatched = compareCaseWithParamValue(companyCausality, unrelatedAccountCodesArray);
  }
  if (isUnrelatedCompanyCausalityMatched && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true; 
  } else if (isUnrelatedCompanyCausalityMatched && isNull(reporterCausality)) {
    isCausalityMached = true; // changed as part of CR SIMPL-75533
  } else if (isNull(companyCausality) && isUnrelatedReporterCausalityMatched) {
    isCausalityMached = true;
  } else if (isNull(companyCausality) && isNull(reporterCausality)) {
    isCausalityMached = true; // changed as part of CR SIMPL-75533
  }
  return isCausalityMached;
}

logConsole("CUSTOM JAVASCRIPT EXECUTION END............");
','DistributionRule','DR5019_2:USER_DEVICE_MATRIX_JS','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5019_2',NULL,'Distribution');
	 INSERT INTO LSMV_RULE_DETAILS (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
			VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_DEVICE_MATRIX',NULL,NULL,'Y','(C2)','{"recordId":"1708337553887","childConditions":[{"recordId":"1708345330415","refRuleConditionId":"1708345317050"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_DEVICE_MATRIX_PARAM","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_DEVICE_MATRIX_PARAM","rhsSameCtx":"N","index":"1","nfMarked":"N","recordId":"1708345301256","anyOneLhs":"N","referenceRuleID":"DR5019_1","rhsFilterConddLogic":"N","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_DEVICE_MATRIX_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_DEVICE_MATRIX_JS","rhsSameCtx":"N","index":"2","nfMarked":"N","recordId":"1708345317050","anyOneLhs":"N","referenceRuleID":"DR5019_2","rhsFilterConddLogic":"N","unitFieldPath":"N"}]',NULL,'N','Y',NULL,'DistributionRule','DR5019:USER_DEVICE_MATRIX','{"adhocRules":[],"paramMap":{"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"},"CL_1002_Outcome":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Outcome is Fatal","fieldPath":"seriousnessHealathOutcome.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Outcome is Fatal","fieldId":"654012"},"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_10064":{"codelistId":"10064","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Type","fieldPath":"healthDamageType.patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Type","fieldId":"106202"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousnessHealathDamage.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"654011"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Type","fieldPath":"approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Type","fieldId":"954007"},"CL_10063":{"codelistId":"10063","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Suspect, Risk","fieldPath":"suspectRisk.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Suspect, Risk","fieldId":"654004"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Country","fieldPath":"approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Country","fieldId":"954005"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Device/Regenerative Causality to Device","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Device/Regenerative Causality to Device","fieldId":"102112"}}}',NULL,'Y','Frozen','DR5019','Y','Distribution');
	 INSERT INTO LSMV_RULE_DETAILS (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
			VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_DEVICE_MATRIX_PARAM',NULL,'drugCollection$patient.safetyReport.aerInfo','Y','()','{"recordId":"1708337626033","operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1013","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Characterization In ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"In","recordId":"1708345068855","anyOneLhs":"N","lhsField":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Characterization","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"5015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Product Flag In ?","rhsSameCtx":"N","index":"2","nfMarked":"N","operator":"In","recordId":"1708345135235","anyOneLhs":"N","lhsField":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Flag","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Product Approval Country) In ?","rhsSameCtx":"N","index":"3","nfMarked":"N","operator":"In","recordId":"1708345260728","anyOneLhs":"1","lhsField":"approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Approval Country","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"709","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Product Approval Type) In ?","rhsSameCtx":"N","index":"4","nfMarked":"N","operator":"In","recordId":"1708345355937","anyOneLhs":"1","lhsField":"approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Product Approval Type","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"10063","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Health Damage Suspect, Risk) In ?","rhsSameCtx":"N","index":"5","nfMarked":"N","operator":"In","recordId":"1708346291174","anyOneLhs":"1","lhsField":"suspectRisk.healthDamageCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Health Damage Suspect, Risk","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"10064","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Health Damage Type In ?","rhsSameCtx":"N","index":"6","nfMarked":"N","operator":"In","recordId":"1708346418235","anyOneLhs":"N","lhsField":"healthDamageType.patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Health Damage Type","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Seriousness) In ?","rhsSameCtx":"N","index":"7","nfMarked":"N","operator":"In","recordId":"1708358323553","anyOneLhs":"1","lhsField":"seriousnessHealathDamage.healthDamageCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Seriousness","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Outcome is Fatal) In ?","rhsSameCtx":"N","index":"8","nfMarked":"N","operator":"In","recordId":"1708358352117","anyOneLhs":"1","lhsField":"seriousnessHealathOutcome.healthDamageCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Outcome is Fatal","unitFieldPath":"N"},{"parameterizedRhs":"Y","lhsFieldcodelistId":"8201","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Device/Regenerative Causality to Device In ?","index":"9","nfMarked":"N","operator":"In","recordId":"1684485770772","anyOneLhs":"N","lhsField":"causality.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Device/Regenerative Causality to Device"}]',NULL,'N','Y',NULL,'DistributionRule','DR5019_1:USER_DEVICE_MATRIX_PARAM','{"adhocRules":[],"paramMap":{"CL_5015":{"codelistId":"5015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Flag","fieldPath":"productType.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Flag","fieldId":"113690"},"CL_1002_Outcome":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Outcome is Fatal","fieldPath":"seriousnessHealathOutcome.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Outcome is Fatal","fieldId":"654012"},"CL_1013":{"codelistId":"1013","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Characterization","fieldPath":"drugCharacterization.drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Characterization","fieldId":"113102"},"CL_10064":{"codelistId":"10064","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Type","fieldPath":"healthDamageType.patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Type","fieldId":"106202"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Seriousness","fieldPath":"seriousnessHealathDamage.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Seriousness","fieldId":"654011"},"CL_709":{"codelistId":"709","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Type","fieldPath":"approvalType.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Type","fieldId":"954007"},"CL_10063":{"codelistId":"10063","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Health Damage Suspect, Risk","fieldPath":"suspectRisk.healthDamageCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Health Damage Suspect, Risk","fieldId":"654004"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Product Approval Country","fieldPath":"approvalCoutry.drugApprovalCollection$drugCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Product Approval Country","fieldId":"954005"},"CL_8201":{"codelistId":"8201","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Device/Regenerative Causality to Device","fieldPath":"causality.safetyReport.aerInfo.flpath","parameterName":"Device/Regenerative Causality to Device","fieldId":"102112"}}}',NULL,'Y','Frozen','DR5019_1','N','Distribution');



INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PMDA_DEVICE_PROBLEM_LABELING',NULL,NULL,'Y','(C1)','{"recordId":"1708337661645","childConditions":[{"recordId":"1708359085255","refRuleConditionId":"1708503150681"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"10092","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Device Problem Labeling In ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"In","recordId":"1708503150681","anyOneLhs":"N","lhsField":"deviceProblemLabeling.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Device Problem Labeling","unitFieldPath":"N"}]',NULL,'N','N',NULL,'DistributionRule','DR5020:USER_PMDA_DEVICE_PROBLEM_LABELING','{"adhocRules":[],"paramMap":{"CL_10092":{"codelistId":"10092","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Device Problem Labeling","fieldPath":"deviceProblemLabeling.safetyReport.aerInfo.flpath","parameterName":"Device Problem Labeling","fieldId":"102171"}}}',NULL,'Y','Frozen','DR5020','Y','Distribution');




INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE',NULL,NULL,'Y','(C2)','{"recordId":"1708337718865","childConditions":[{"recordId":"1708430722409","refRuleConditionId":"1708359291647"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_PARAM","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_PARAM","rhsSameCtx":"N","index":"1","nfMarked":"N","recordId":"1708359290819","anyOneLhs":"N","referenceRuleID":"DR5021_1","rhsFilterConddLogic":"N","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"N","referenceRuleName":"USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_JS","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Reference Rule : USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_JS","rhsSameCtx":"N","index":"2","nfMarked":"N","recordId":"1708359291647","anyOneLhs":"N","referenceRuleID":"DR5021_2","rhsFilterConddLogic":"N","unitFieldPath":"N"}]',NULL,'N','N',NULL,'DistributionRule','DR5021:USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE','{"adhocRules":[],"paramMap":{"CL_10067":{"codelistId":"10067","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"PMDA Device/Regenerative Due Date","fieldPath":"pmdaDeviceReportType.safetyReport.aerInfo.flpath","parameterName":"PMDA Device/Regenerative Due Date","fieldId":"130827"}}}',NULL,'Y','Frozen','DR5021','Y','Distribution');






INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_PARAM',NULL,'deviceCollection$drugCollection$patient.safetyReport.aerInfo','Y','()','{"recordId":"1708337747892","operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"10067","lhsFilterConddLogic":"N","ruleCondDisplayStr":"PMDA Device/Regenerative Due Date In ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"In","recordId":"1708359184654","anyOneLhs":"N","lhsField":"pmdaDeviceReportType.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"PMDA Device/Regenerative Due Date","unitFieldPath":"N"}]',NULL,'N','N',NULL,'DistributionRule','DR5021_1:USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_PARAM','{"adhocRules":[],"paramMap":{"CL_10067":{"codelistId":"10067","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"PMDA Device/Regenerative Due Date","fieldPath":"pmdaDeviceReportType.safetyReport.aerInfo.flpath","parameterName":"PMDA Device/Regenerative Due Date","fieldId":"130827"}}}',NULL,'Y','Frozen','DR5021_1',NULL,'Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_JS',NULL,NULL,'Y','()','{"recordId":"1708337767437","operator":"AND"}',NULL,NULL,'Y','N','//////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------------------------------
//              All Rights Reserved.
//
//              This software is the confidential and proprietary information of PharmApps, LLC.
//              (Confidential Information).
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Name    :  USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE.js
//-------------------------------------------------------------------------------------------------------
// Description  :  This script is a custom distribution attribute to validate PMDA Device/Regenerative Due Date.
// File History :  1.0
// Created By   :  Vinay T R
// Date         :  26-FEB-2024
// Reviewed By  :  Debasis Das
//-------------------------------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////////////

var ruleName = ''USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE'';
var logFlag = false;

//Case level values
var receiptNum = inboundMessage.receiptItem.receiptNo;
var pmdaDeviceReportTypeCaseValue = inboundMessage.aerInfo.safetyReport.pmdaDeviceReportType;

//PMDA Device/Regenerative Due Date - Codelist ID: 10067 - 15 days/30 days - 1/2
var pmdaDeviceReportTypeParam = userParameters.get(''pmdaDeviceReportType.safetyReport.aerInfo.flpath'');

try {
  logConsole("CUSTOM JAVASCRIPT EXECUTION START............");
  checkCombFields();
} catch (error) {
  logConsole("Exception caught in Main Block::" + error);
}

function logConsole(message) {
  if (logFlag) {
    UTIL.getLogger().error(receiptNum + '': '' + ruleName + '': '' + message);
  }
}

function compareCaseWithParamValue(caseData, paramList) {
  var status = false;
  if (!isEmptyAndNull(caseData) && !isEmptyAndNull(paramList)) {
    for (var i = 0; i < paramList.length; i++) {
      if (caseData == paramList[i]) {
        status = true;
        break;
      }
    }
  }
  return status;
}

function convertToArray(inputParam) {
  var inputParamArray = null;
  var inputParamString = null;
  if (!isEmptyAndNull(inputParam)) {
    inputParamString = String(inputParam);
    if (!isEmptyAndNull(inputParamString)) {
      inputParamArray = inputParamString.split("|");
    }
  }
  return inputParamArray;
}

function isEmptyAndNull(inputString) {
  if (inputString != null && inputString != ''undefined'' && inputString != '''') {
    return false;
  } else {
    return true;
  }
}

function checkCombFields() {
  var ispmdaDeviceReportTypeMatched = false;

  ispmdaDeviceReportTypeMatched = getpmdaDeviceReportType();

  if (ispmdaDeviceReportTypeMatched) {
    rule.put("ruleExecutionResult", "true");
    logConsole(''RULE PASSED'');
  } else {
    rule.put("ruleExecutionResult", "false");
    logConsole(''RULE FAILED'');
  }
}

function getpmdaDeviceReportType() {
  var isValid = false;
  try {
    var paramValueArray = null;
    if (isEmptyAndNull(pmdaDeviceReportTypeParam)) {
      isValid = true;
    } else if (!isEmptyAndNull(pmdaDeviceReportTypeParam)) {
      paramValueArray = convertToArray(pmdaDeviceReportTypeParam);
      if (!isEmptyAndNull(pmdaDeviceReportTypeCaseValue) && !isEmptyAndNull(paramValueArray)) {
        isValid = compareCaseWithParamValue(pmdaDeviceReportTypeCaseValue, paramValueArray);
      }
    }
  } catch (error) {
    logConsole("Exception caught in getDeviceProbType()::" + error);
  }
  return isValid;
}

logConsole("CUSTOM JAVASCRIPT EXECUTION END............");
','DistributionRule','DR5021_2:USER_PMDA_DEVICE_REGENERATIVE_DUE_DATE_JS','{"adhocRules":[],"paramMap":{}}',NULL,'Y','Frozen','DR5021_2',NULL,'Distribution');
-----------------dr5021 ends




INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) VALUES
	 (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_REPORTER_STATE',NULL,'primarySourceCollection$safetyReport.aerInfo','Y','(C0)','{"recordId":"1734412034789","childConditions":[{"recordId":"1734412040758","refRuleConditionId":"1734412048895"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9168","lhsFilterConddLogic":"N","ruleCondDisplayStr":"State EqualsIgnoreCase ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"EqualsIgnoreCase","recordId":"1734412048895","anyOneLhs":"N","lhsField":"reporterState.primarySourceCollection$safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"State","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','','{"adhocRules":[],"paramMap":{"reporterState.primarySourceCollection$safetyReport.aerInfo.flpath":{"codelistId":null,"libraryName":null,"fieldLabel":"State","fieldPath":"reporterState.primarySourceCollection$safetyReport.aerInfo.flpath","parameterName":"State","fieldId":"105118"}}}','','Y','Frozen','DR5013','Y','Distribution');





INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name)
		VALUES	 (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_DEATH_USDSH',NULL,'reactionCollection$patient.safetyReport.aerInfo','Y','(C0)','{"recordId":"1734418206089","childConditions":[{"recordId":"1734418337863","refRuleConditionId":"1734418233917"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","lhsFieldcodelistId":"1002","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Unanticipated Serious deterioration in state of Health Equals Yes","rhsSameCtx":"N","index":"0","rhsConst":"Yes","rhsField":"1","nfMarked":"N","operator":"Equals","recordId":"1734418233917","lhsField":"unAnticipatedStateHealth.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"R","rhsFilterConddLogic":"N","lhsFieldString":"Unanticipated Serious deterioration in state of Health","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_DEATH_USDTH','{"adhocRules":[],"paramMap":{}}','','Y','Frozen','DR5024','Y','Distribution');


--INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name)
--		VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PAT_REP_COUNTRY',NULL,'primarySourceCollection$safetyReport.aerInfo','Y','(C0 | C1)','{"recordId":"1742906965321","childConditions":[{"recordId":"1742911053073","refRuleConditionId":"1742909105734"},{"recordId":"1742911466356","refRuleConditionId":"1742911291186"}],"operator":"OR"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Country Equals ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"Equals","recordId":"1742909105734","anyOneLhs":"N","lhsField":"reporterCountry.primarySourceCollection$safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Country","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9168","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Country Equals ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"Equals","recordId":"1742911291186","lhsField":"country.patient.safetyReport.aerInfo.flpath","lhsDataType":"T","rhsFilterConddLogic":"N","lhsFieldString":"Country","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_PAT_REP_COUNTRY','{"adhocRules":[],"paramMap":{"CL_1015_country.patient.safetyReport.aerInfo.flpath":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Country","fieldPath":"country.patient.safetyReport.aerInfo.flpath","parameterName":"Country","fieldId":"106952"},"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Country","fieldPath":"reporterCountry.primarySourceCollection$safetyReport.aerInfo.flpath","parameterName":"Country","fieldId":"105122"}}}','','Y','Frozen','DR5025',NULL,'Distribution');

INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
		VALUES 	 (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_PAT_REP_COUNTRY',NULL,'','Y','(C0 | C1)','{"recordId":"1742906965321","childConditions":[{"recordId":"1742911053073","refRuleConditionId":"1742909105734"},{"recordId":"1742911466356","refRuleConditionId":"1742911291186"}],"operator":"OR"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"AnyOne(Reporter Country) Equals ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"Equals","recordId":"1742909105734","anyOneLhs":"1","lhsField":"reporterCountry.primarySourceCollection$safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Country","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"1015","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Patient Country Equals ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"Equals","recordId":"1742911291186","anyOneLhs":"N","lhsField":"country.patient.safetyReport.aerInfo.flpath","lhsDataType":"T","rhsFilterConddLogic":"N","lhsFieldString":"Country","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_PAT_REP_COUNTRY','{"adhocRules":[],"paramMap":{"CL_1015":{"codelistId":"1015","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Reporter/Patient Country","fieldPath":"country.patient.safetyReport.aerInfo.flpath,reporterCountry.primarySourceCollection$safetyReport.aerInfo.flpath","parameterName":"Reporter/Patient Country","fieldId":"105122"}}}','','Y','Frozen','DR5025',NULL,'Distribution');
		
		
		
INSERT INTO lsmv_rule_details (record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 	 
		VALUES 	 (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_FATAL_ADVRS_EVENT',NULL,'reactionCollection$patient.safetyReport.aerInfo','Y','(C0 & C1)','{"recordId":"1755511680811","childConditions":[{"recordId":"1755515069230","refRuleConditionId":"1755515038719"},{"recordId":"1755515137727","refRuleConditionId":"1755515085410"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9042","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Death? Equals ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"Equals","recordId":"1755515038719","lhsField":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Death?","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9745","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Event Type In ?","rhsSameCtx":"N","index":"1","nfMarked":"N","operator":"In","recordId":"1755515085410","lhsField":"eventType.reactionCollection$patient.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Event Type","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_FATAL_ADVRS_EVENT','{"adhocRules":[],"paramMap":{"CL_9745":{"codelistId":"9745","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Event Type","fieldPath":"eventType.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Event Type","fieldId":"111160"},"CL_1002":{"codelistId":"1002","libraryName":null,"allowMultiSelect":"N","defaultValue":{},"fieldLabel":"Death?","fieldPath":"death.reactionCollection$patient.safetyReport.aerInfo.flpath","parameterName":"Death?","fieldId":"111150"}}}','','Y','Frozen','DR5014',NULL,'Distribution');
		
		
INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_STUDY_CODE_BROCKEN',NULL,'','Y','(C0)','{"recordId":"1756548297634","childConditions":[{"recordId":"1756548464877","refRuleConditionId":"1756548309391"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"54","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Study Code Broken In ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"In","recordId":"1756548309391","lhsField":"studyCodeBroken.study.safetyReport.aerInfo.flpath","lhsDataType":"C","rhsFilterConddLogic":"N","lhsFieldString":"Study Code Broken","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_STUDY_CODE_BROCKEN','{"adhocRules":[],"paramMap":{"CL_54":{"codelistId":"54","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Study Code Broken","fieldPath":"studyCodeBroken.study.safetyReport.aerInfo.flpath","parameterName":"Study Code Broken","fieldId":"125612"}}}','','Y','Frozen','DR5015','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SENDER_ORGANIZATION',NULL,'sourceCollection$safetyReport.aerInfo','Y','(C0 & C1)','{"recordId":"1757317181670","childConditions":[{"recordId":"1757317758510","refRuleConditionId":"1757317193804"},{"recordId":"1757317762453","refRuleConditionId":"1757317701229"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"N","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Sender Organization Equals {HA} Canada","rhsSameCtx":"N","index":"0","rhsConst":"{HA} Canada","rhsField":"{HA} Canada","nfMarked":"N","operator":"Equals","recordId":"1757317193804","lhsField":"originatingAccount.sourceCollection$safetyReport.aerInfo.flpath","lhsDataType":"T","rhsFilterConddLogic":"N","lhsFieldString":"Sender Organization","unitFieldPath":"N"},{"lhsSameCtx":"N","parameterizedRhs":"N","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Sender Organization Equals {LP} Pfizer","rhsSameCtx":"N","index":"1","rhsConst":"{LP} Pfizer","rhsField":"{LP} Pfizer","nfMarked":"N","operator":"Equals","recordId":"1757317701229","lhsField":"originatingAccount.sourceCollection$safetyReport.aerInfo.flpath","lhsDataType":"T","rhsFilterConddLogic":"N","lhsFieldString":"Sender Organization","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','USER_SENDER_ORGANIZATION','{"adhocRules":[],"paramMap":{}}','','Y','Frozen','DR5017','Y','Distribution');

INSERT INTO LSMV_RULE_DETAILS(record_id,user_created,date_created,user_modified,date_modified,rule_name,fk_rule_id,rule_fields,valid_rule,condition_expression,condition_expression_json,rule_conditions_json,rule_outcomes_json,scripted_yn,system_rule_yn,rule_script,rule_type,description,rule_param_map,adhoc_rules_json,active_yn,rule_status,rule_id,excludable_rule,module_name) 
VALUES (NEXTVAL('SEQ_RECORD_ID'),'AMGEN_DR',CURRENT_TIMESTAMP,'AMGEN_DR',CURRENT_TIMESTAMP,'USER_SPONCER_TYPE',NULL,'','Y','(C0)','{"recordId":"1756552792283","childConditions":[{"recordId":"1756552910522","refRuleConditionId":"1756552869668"}],"operator":"AND"}','[{"lhsSameCtx":"N","parameterizedRhs":"Y","lhsFieldcodelistId":"9959","lhsFilterConddLogic":"N","ruleCondDisplayStr":"Sponsor Type In ?","rhsSameCtx":"N","index":"0","nfMarked":"N","operator":"In","recordId":"1756552869668","lhsField":"studySponserType.study.safetyReport.aerInfo.flpath","lhsDataType":"D","rhsFilterConddLogic":"N","lhsFieldString":"Sponsor Type","unitFieldPath":"N"}]','','N','Y',NULL,'DistributionRule','','{"adhocRules":[],"paramMap":{"CL_9959":{"codelistId":"9959","libraryName":null,"allowMultiSelect":"Y","defaultValue":{},"fieldLabel":"Sponsor Type","fieldPath":"studySponserType.study.safetyReport.aerInfo.flpath","parameterName":"Sponsor Type","fieldId":"125987"}}}','','Y','Frozen','DR5016','Y','Distribution');



EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION :%', l_context;
CALL C_PROC_DISTRIBUTION_EXCEPTION('*', 'Attribute crearion script', '*', '*','*', 
                                                                                                                      '*','*', NULL,SQLERRM, l_context);
END $$;




UPDATE LSMV_RULE_DETAILS
SET excludable_rule = 'Y',system_rule_yn = 'Y'
WHERE rule_id = 'DR5013';


UPDATE LSMV_RULE_DETAILS SET eval_locally = 'Y',user_modified='AMGEN_DR',date_modified=CURRENT_TIMESTAMP
 WHERE RULE_ID IN ('DR5001','DR5001_1','DR5001_2');

UPDATE LSMV_RULE_DETAILS 
SET IS_STD = 1 ,user_modified='AMGEN_DR',date_modified=CURRENT_TIMESTAMP
WHERE MODULE_NAME = 'Distribution' and rule_id like 'DR0%';

UPDATE LSMV_RULE_DETAILS 
SET IS_STD = 0 ,user_modified='AMGEN_DR',date_modified=CURRENT_TIMESTAMP
WHERE MODULE_NAME = 'Distribution' and rule_id like 'DR5%';

update lsmv_rule_details 
set RULE_PARAM_MAP= '{"adhocRules":[],"paramMap":{}}',user_modified='AMGEN_DR',date_modified=CURRENT_TIMESTAMP
where RULE_PARAM_MAP IS null;

---Custom attribute script 
UPDATE LSMV_RULE_DETAILS 
SET EVAL_LOCALLY = 'Y',USER_MODIFIED='AMGEN_DR',DATE_MODIFIED=CURRENT_TIMESTAMP 
WHERE RULE_ID IS NOT NULL
and  MODULE_NAME = 'Distribution' 
and RULE_NAME LIKE 'USER_%';

update lsmv_rule_details
set system_rule_yn = 'Y',user_modified='AMGEN_DR',date_modified=CURRENT_TIMESTAMP
where user_created = 'AMGEN_DR'
and system_rule_yn = 'N';