do $$
declare
l_context TEXT;
Lv_contact_table text;
Lv_format_table text;
Lv_anchor_table text;
Lv_mapping_table text;
Lv_rule_table text;

Lv_contact_table_drop text;
Lv_format_table_drop text;
Lv_anchor_table_drop text;
Lv_mapping_table_drop text;
Lv_rule_table_drop text;

Lv_contact_table_create text;
Lv_format_table_create text;
Lv_anchor_table_create text;
Lv_mapping_table_create text;
Lv_rule_table_create text;


I RECORD;
begin
	Lv_contact_table := 'LSMV_DIST_UNIT_'||TO_CHAR(CURRENT_DATE,'DD_MM_YY');
	Lv_format_table := 'LSMV_DIST_FORMAT_'||TO_CHAR(CURRENT_DATE,'DD_MM_YY');
	Lv_anchor_table := 'LSMV_DIST_ANCHOR_'||TO_CHAR(CURRENT_DATE,'DD_MM_YY');
	Lv_mapping_table := 'LSMV_DIST_ANCHOR_MAP_'||TO_CHAR(CURRENT_DATE,'DD_MM_YY');
	Lv_rule_table := 'LSMV_DIST_RULE_'||TO_CHAR(CURRENT_DATE,'DD_MM_YY');

	Lv_contact_table_drop := 'DROP TABLE IF EXISTS '||Lv_contact_table;
	Lv_format_table_drop := 'DROP TABLE IF EXISTS '||Lv_format_table;
	Lv_anchor_table_drop := 'DROP TABLE IF EXISTS '||Lv_anchor_table;
	Lv_mapping_table_drop := 'DROP TABLE IF EXISTS '||Lv_mapping_table;
	Lv_rule_table_drop := 'DROP TABLE IF EXISTS '||Lv_rule_table;

	Lv_contact_table_create := 'CREATE TABLE '||Lv_contact_table||' AS SELECT * FROM LSMV_DISTRIBUTION_UNIT';
	Lv_format_table_create := 'CREATE TABLE '||Lv_format_table||' AS SELECT * FROM LSMV_DISTRIBUTION_FORMAT';
	Lv_anchor_table_create := 'CREATE TABLE '||Lv_anchor_table||' AS SELECT * FROM LSMV_DISTRIBUTION_RULE_ANCHOR';
	Lv_mapping_table_create := 'CREATE TABLE '||Lv_mapping_table||' AS SELECT * FROM LSMV_DISTRIBUTION_RULE_MAPPING';
	Lv_rule_table_create := 'CREATE TABLE '||Lv_rule_table||' AS SELECT * FROM LSMV_RULE_DETAILS';
		
		
	EXECUTE Lv_contact_table_drop;
	EXECUTE Lv_format_table_drop;
	EXECUTE Lv_anchor_table_drop;
	EXECUTE Lv_mapping_table_drop;
	EXECUTE Lv_rule_table_drop;
		
	EXECUTE Lv_contact_table_create;
	EXECUTE Lv_format_table_create;
	EXECUTE Lv_anchor_table_create;
	EXECUTE Lv_mapping_table_create;
	EXECUTE Lv_rule_table_create;


EXCEPTION 
WHEN others THEN
GET STACKED DIAGNOSTICS l_context = PG_EXCEPTION_CONTEXT;
RAISE NOTICE 'EXCEPTION%', l_context;	
end $$;