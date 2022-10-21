--------------------------------------------------------
--  DDL for Table COSTS
--------------------------------------------------------

  CREATE TABLE "COSTS" 
   (	"COST_TYPE" VARCHAR2(20 BYTE) COLLATE "USING_NLS_COMP", 
	"COST_DATE" DATE, 
	"PAID" NUMBER, 
	"CAR" VARCHAR2(20 BYTE) COLLATE "USING_NLS_COMP"
   )  ;
--------------------------------------------------------
--  DDL for Index COSTS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "COSTS_PK" ON "COSTS" ("COST_TYPE", "COST_DATE") ;
--------------------------------------------------------
--  Constraints for Table COSTS
--------------------------------------------------------

  ALTER TABLE "COSTS" MODIFY ("COST_TYPE" NOT NULL ENABLE);
  ALTER TABLE "COSTS" MODIFY ("COST_DATE" NOT NULL ENABLE);
  ALTER TABLE "COSTS" MODIFY ("PAID" NOT NULL ENABLE);
  ALTER TABLE "COSTS" ADD CONSTRAINT "COSTS_PK" PRIMARY KEY ("COST_TYPE", "COST_DATE")
  USING INDEX;
  