CREATE TABLE USER_ASSIGNMENT ( 
  "LOGIN_ID" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"ASSIGNED_PRIVILEGE_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"AUTHORIZING_USER" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"ASSIGNMENT_DATE" DATE NOT NULL ENABLE, 
	"EXPIRATION_DATE" DATE, 
	"ENABLED" VARCHAR2(1 CHAR) DEFAULT 'Y' NOT NULL ENABLE
);

CREATE OR REPLACE TRIGGER USER_ASSIGNMENT_TRG
  BEFORE INSERT OR UPDATE ON USER_ASSIGNMENT 
    FOR EACH ROW
    BEGIN
      :NEW.login_id := UPPER(:NEW.login_id);
      :NEW.authorizing_user := UPPER(:NEW.authorizing_user);
      
      if(:NEW.ASSIGNMENT_DATE is null) then
        :NEW.ASSIGNMENT_DATE := systimestamp;
      end if;
    
         
    END;
/
ALTER TRIGGER USER_ASSIGNMENT_TRG ENABLE;