--------------------------------------------------------
--  DDL for Table PARAMS
--------------------------------------------------------

  CREATE TABLE "PARAMS" 
   ("CARNAME" VARCHAR2(20 BYTE) NOT NULL, 
	"PARAM_VALUE" NUMBER NOT NULL, 
	"PARAM_NAME" VARCHAR2(20 BYTE) NOT NULL
   ) ;

  ALTER TABLE "PARAMS" ADD CONSTRAINT "PARAMS_PK" PRIMARY KEY ("CARNAME");
  