CREATE TABLE PRIVILEGE_ASSIGNMENT(
  "PRIVILEGE_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"ASSIGNED_PRIVILEGE_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"AUTHORIZING_USER" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"ASSIGNMENT_DATE" DATE NOT NULL ENABLE, 
	"EXPIRATION_DATE" DATE, 
	"ENABLED" VARCHAR2(1 CHAR) DEFAULT 'Y' NOT NULL ENABLE 
	CONSTRAINT "PRIVILEGE_ASSIGNMENT_CK1" CHECK (ENABLED in ('Y', 'N')) ENABLE, 
	CONSTRAINT "PRIVILEGE_ASSIGNMENT_PK" PRIMARY KEY ("PRIVILEGE_ID", "ASSIGNED_PRIVILEGE_ID"),
	CONSTRAINT "PRIVILEGE_ASSIGNMENT_FK1" FOREIGN KEY ("PRIVILEGE_ID") REFERENCES "PRIVILEGES" ("ID") ENABLE, 
  CONSTRAINT "PRIVILEGE_ASSIGNMENT_FK2" FOREIGN KEY ("ASSIGNED_PRIVILEGE_ID") REFERENCES "PRIVILEGES" ("ID") ENABLE
);

CREATE OR REPLACE TRIGGER PRIVILEGE_ASSIGNMENT_TRG
BEFORE INSERT OR UPDATE ON PRIVILEGE_ASSIGNMENT 
  FOR EACH ROW
  BEGIN  
    :NEW.authorizing_user := UPPER(:NEW.authorizing_user);
    
    if(:NEW.ASSIGNMENT_DATE is null) then
      :NEW.ASSIGNMENT_DATE := systimestamp;
    end if;
  
       
  END;
/
ALTER TRIGGER PRIVILEGE_ASSIGNMENT_TRG ENABLE;
