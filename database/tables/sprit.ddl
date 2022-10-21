--------------------------------------------------------
--  DDL for Table SPRIT
--------------------------------------------------------

  CREATE TABLE "TOM"."SPRIT" 
   (	"PRICE" NUMBER, 
	"VALID_FROM" DATE, 
	"VALID_TO" DATE, 
	"PRICE_TYPE" VARCHAR2(20 BYTE) 
   )  ;

--------------------------------------------------------
--  Constraints for Table SPRIT
--------------------------------------------------------

  ALTER TABLE "TOM"."SPRIT" MODIFY ("PRICE_TYPE" NOT NULL ENABLE);
  ALTER TABLE "TOM"."SPRIT" MODIFY ("VALID_FROM" NOT NULL ENABLE);
  ALTER TABLE "TOM"."SPRIT" MODIFY ("VALID_TO" NOT NULL ENABLE);
  ALTER TABLE "TOM"."SPRIT" MODIFY ("PRICE" NOT NULL ENABLE);
  ALTER TABLE "TOM"."SPRIT" ADD CONSTRAINT "SPRIT_PK" PRIMARY KEY ("PRICE", "VALID_FROM", "PRICE_TYPE");
