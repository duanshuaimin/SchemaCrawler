SELECT  
  NULL AS TABLE_CAT,
  COLUMNS.OWNER AS TABLE_SCHEM,
  COLUMNS.TABLE_NAME AS TABLE_NAME,
  COLUMNS.COLUMN_NAME AS COLUMN_NAME,
  DECODE(  
  (SELECT A.TYPECODE 
     FROM DBA_TYPES A 
     WHERE A.TYPE_NAME = COLUMNS.DATA_TYPE
     AND (A.OWNER = COLUMNS.OWNER OR A.OWNER IS NULL)), 
  'OBJECT', 2002, 
  'COLLECTION', 2003, 
  DECODE(substr(COLUMNS.data_type, 1, 9), 
    'TIMESTAMP', 
      DECODE(substr(COLUMNS.data_type, 10, 1), 
        '(', 
          DECODE(substr(COLUMNS.data_type, 19, 5), 
            'LOCAL', -102, 'TIME ', -101, 93), 
        DECODE(substr(COLUMNS.data_type, 16, 5), 
          'LOCAL', -102, 'TIME ', -101, 93)), 
    'INTERVAL ', 
      DECODE(substr(COLUMNS.data_type, 10, 3), 
       'DAY', -104, 'YEA', -103), 
    DECODE(COLUMNS.data_type, 
      'BINARY_DOUBLE', 101, 
      'BINARY_FLOAT', 100, 
      'BFILE', -13, 
      'BLOB', 2004, 
      'CHAR', 1, 
      'CLOB', 2005, 
      'COLLECTION', 2003, 
      'DATE', 93, 
      'FLOAT', 6, 
      'LONG', -1, 
      'LONG RAW', -4, 
      'NCHAR', -15, 
      'NCLOB', 2011, 
      'NUMBER', 3, 
      'NVARCHAR', -9, 
      'NVARCHAR2', -9, 
      'OBJECT', 2002, 
      'OPAQUE/XMLTYPE', 2009, 
      'RAW', -3, 
      'REF', 2006, 
      'ROWID', -8, 
      'SQLXML', 2009, 
      'UROWID', -8, 
      'VARCHAR2', 12, 
      'VARRAY', 2003, 
      'XMLTYPE', 2009, 
      1111)))
  AS DATA_TYPE,
  COLUMNS.DATA_TYPE AS TYPE_NAME,
  DECODE (COLUMNS.DATA_PRECISION, NULL, DECODE(COLUMNS.DATA_TYPE, 'NUMBER', DECODE(COLUMNS.DATA_SCALE, NULL, 0 , 38), DECODE (COLUMNS.DATA_TYPE, 'CHAR', COLUMNS.CHAR_LENGTH, 'VARCHAR', COLUMNS.CHAR_LENGTH, 'VARCHAR2', COLUMNS.CHAR_LENGTH, 'NVARCHAR2', COLUMNS.CHAR_LENGTH, 'NCHAR', COLUMNS.CHAR_LENGTH, 'NUMBER', 0, COLUMNS.DATA_LENGTH) ), COLUMNS.DATA_PRECISION)
  AS COLUMN_SIZE,
  0 AS BUFFER_LENGTH,
  DECODE (COLUMNS.DATA_TYPE, 'NUMBER', DECODE(COLUMNS.DATA_PRECISION, NULL, DECODE(COLUMNS.DATA_SCALE, NULL, -127 , COLUMNS.DATA_SCALE), COLUMNS.DATA_SCALE), COLUMNS.DATA_SCALE) 
  AS DECIMAL_DIGITS,
  10 AS NUM_PREC_RADIX,
  DECODE (COLUMNS.NULLABLE, 'N', 0, 1) AS NULLABLE,
  REMARKS.COMMENTS AS REMARKS,
  COLUMNS.DATA_DEFAULT AS COLUMN_DEF,
  0 AS SQL_DATA_TYPE,
  0 AS SQL_DATETIME_SUB,
  COLUMNS.DATA_LENGTH AS CHAR_OCTET_LENGTH,
  COLUMNS.COLUMN_ID AS ORDINAL_POSITION,
  DECODE (COLUMNS.NULLABLE, 'N', 'NO', 'YES') AS IS_NULLABLE,
  NULL AS SCOPE_CATALOG,
  NULL AS SCOPE_SCHEMA,
  NULL AS SCOPE_TABLE,
  NULL AS SOURCE_DATA_TYPE,
  IDENTITY_COLUMN AS IS_AUTOINCREMENT,
  COLUMNS.VIRTUAL_COLUMN AS IS_GENERATEDCOLUMN
FROM 
  DBA_TAB_COLS COLUMNS
  LEFT OUTER JOIN DBA_COL_COMMENTS REMARKS
    ON 
      COLUMNS.OWNER = REMARKS.OWNER 
      AND COLUMNS.TABLE_NAME = REMARKS.TABLE_NAME 
      AND COLUMNS.COLUMN_NAME = REMARKS.COLUMN_NAME  
WHERE
  COLUMNS.OWNER NOT IN 
    ('ANONYMOUS', 'APEX_PUBLIC_USER', 'APPQOSSYS', 'BI', 'CTXSYS', 'DBSNMP', 'DIP', 
    'EXFSYS', 'FLOWS_30000', 'FLOWS_FILES', 'GSMADMIN_INTERNAL', 'IX', 'LBACSYS', 
    'MDDATA', 'MDSYS', 'MGMT_VIEW', 'OE', 'OLAPSYS', 'ORACLE_OCM', 
    'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'OWBSYS', 'PM', 'SCOTT', 'SH', 
    'SI_INFORMTN_SCHEMA', 'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR', 
    'SYS', 'SYSMAN', 'SYSTEM', 'TSMSYS', 'WKPROXY', 'WKSYS', 'WK_TEST', 
    'WMSYS', 'XDB', 'XS$NULL', 'RDSADMIN')  
  AND NOT REGEXP_LIKE(COLUMNS.OWNER, '^APEX_[0-9]{6}$')
  AND NOT REGEXP_LIKE(COLUMNS.OWNER, '^FLOWS_[0-9]{5,6}$')
  AND REGEXP_LIKE(COLUMNS.OWNER, '${schemas}')
  AND COLUMNS.TABLE_NAME NOT LIKE 'BIN$%'
  AND NOT REGEXP_LIKE(COLUMNS.TABLE_NAME, '^(SYS_IOT|MDOS|MDRS|MDRT|MDOT|MDXT)_.*$')
ORDER BY 
  TABLE_SCHEM, 
  TABLE_NAME, 
  ORDINAL_POSITION
