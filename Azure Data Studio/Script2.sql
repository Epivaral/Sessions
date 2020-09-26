/*

For more in-depth information about custom snippets, please check my article at:

https://www.mssqltips.com/sqlservertip/5768/create-custom-tsql-code-snippets-with-azure-data-studio/

*/


-- To access existing code snippets, just type 'sql' and navigate on any snippet you want and select it

sql

-- To create a new code snippet, open the command palette (F1) and select the "Configure User Snippets option"
-- A .JSON file will open with a sample snippet we can take as a base.
-- we will use a simple DBCC command as an snippet:


"Database Consistency check": {
"prefix":"sqlDBCC",
"body":[
"DBCC ${1|CHECKDB,CHECKALLOC,CHECKCATALOG|}(${2:DBNAME}) ${3| ,WITH NO_INFOMSGS|};",
"GO "
],
"description":"Perform Database consistency check tasks"
}



-- try it by typing sqldbcc, select any dbcc type:

sql

-- try it now, but navigating with TAB key, to explore additional parameters

sql


