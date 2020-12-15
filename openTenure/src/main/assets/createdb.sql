DROP TABLE IF EXISTS TILE;
DROP TABLE IF EXISTS TASK;
DROP TABLE IF EXISTS SURVEY_FORM_TEMPLATE;
DROP TABLE IF EXISTS CONFIGURATION;
DROP TABLE IF EXISTS LINK;
DROP TABLE IF EXISTS LOCATION;
DROP TABLE IF EXISTS MAP_BOOKMARK;
DROP TABLE IF EXISTS CLAIM;
DROP TABLE IF EXISTS PERSON;
DROP TABLE IF EXISTS ATTACHMENT;
DROP TABLE IF EXISTS ADDITIONAL_INFO;
DROP TABLE IF EXISTS VERTEX;
DROP TABLE IF EXISTS HOLE_VERTEX;
DROP TABLE IF EXISTS PROPERTY_LOCATION;
DROP TABLE IF EXISTS CLAIM_STATUS;
DROP TABLE IF EXISTS ATTACHMENT_STATUS;
DROP TABLE IF EXISTS ADJACENCY;
DROP TABLE IF EXISTS OWNER;
DROP TABLE IF EXISTS SHARE;
DROP TABLE IF EXISTS CARDINAL_DIRECTION;
DROP TABLE IF EXISTS CLAIM_TYPE;
DROP TABLE IF EXISTS DOCUMENT_TYPE;
DROP TABLE IF EXISTS ID_TYPE;
DROP TABLE IF EXISTS LAND_USE;
DROP TABLE IF EXISTS LANGUAGE;
DROP TABLE IF EXISTS ADJACENCIES_NOTES;
DROP TABLE IF EXISTS BOUNDARY;
DROP TABLE IF EXISTS BOUNDARY_TYPE;
DROP TABLE IF EXISTS BOUNDARY_STATUS;

CREATE TABLE TILE
(TILE_ID VARCHAR(255) PRIMARY KEY,
URL VARCHAR(1024) NOT NULL,
FILE_NAME VARCHAR(1024) NOT NULL);

CREATE TABLE TASK
(TASK_ID VARCHAR(255) PRIMARY KEY,
STARTED TIMESTAMP NOT NULL,
COMPLETION DECIMAL(5,2) NOT NULL);

CREATE TABLE SURVEY_FORM_TEMPLATE
(SURVEY_FORM_TEMPLATE_ID VARCHAR(255) PRIMARY KEY,
NAME VARCHAR(255) NOT NULL,
VALUE CLOB);

CREATE UNIQUE INDEX SURVEY_FORM_TEMPLATE_NAME_IDX ON SURVEY_FORM_TEMPLATE(NAME);

CREATE TABLE CONFIGURATION
(CONFIGURATION_ID VARCHAR(255) PRIMARY KEY,
NAME VARCHAR(255) NOT NULL,
VALUE CLOB);

CREATE UNIQUE INDEX CONFIGURATION_NAME_IDX ON CONFIGURATION(NAME);

MERGE INTO CONFIGURATION(CONFIGURATION_ID, NAME, VALUE) KEY (CONFIGURATION_ID) SELECT '1', 'DBVERSION', '1.7.0' FROM DUAL;
MERGE INTO CONFIGURATION(CONFIGURATION_ID, NAME, VALUE) KEY (CONFIGURATION_ID) SELECT '2', 'PROTOVERSION', '1.1' FROM DUAL;

CREATE TABLE LINK
(LINK_ID VARCHAR(255) PRIMARY KEY,
URL VARCHAR(255) NOT NULL,
DESC CLOB);

MERGE INTO LINK(LINK_ID, URL, DESC) KEY (LINK_ID) SELECT '1', 'https://demo.opentenure.org', 'OpenTenure Community: visit the OpenTenure Community web site and tell us what you think.' FROM DUAL;
MERGE INTO LINK(LINK_ID, URL, DESC) KEY (LINK_ID) SELECT '2', 'http://www.flossola.org/home', 'FLOSS SOLA: look at the latest news on FLOSS SOLA web site.' FROM DUAL;
MERGE INTO LINK(LINK_ID, URL, DESC) KEY (LINK_ID) SELECT '3', 'https://github.com/OpenTenure/ot-android-studio/blob/master/PRIVACY.md', 'Have a look at the privacy policy before using Open Tenure' FROM DUAL;

 CREATE TABLE DOCUMENT_TYPE
(ID INT auto_increment PRIMARY KEY,
 CODE VARCHAR(255) NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048)); 
 
CREATE UNIQUE INDEX DOCUMENT_TYPE_IDX ON DOCUMENT_TYPE(CODE);

 CREATE TABLE ID_TYPE
(ID INT auto_increment PRIMARY KEY,
 TYPE VARCHAR(255) NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048)); 
 
CREATE UNIQUE INDEX ID_TYPE_IDX ON ID_TYPE(TYPE);

 CREATE TABLE LAND_USE
(ID INT auto_increment PRIMARY KEY,
 TYPE VARCHAR(255) NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048));
 
CREATE UNIQUE INDEX LAND_USE_IDX ON LAND_USE(TYPE);

CREATE TABLE BOUNDARY_TYPE
(ID INT auto_increment PRIMARY KEY,
 CODE VARCHAR(40) NOT NULL,
 LEVEL SMALLINT NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048));

CREATE UNIQUE INDEX BOUNDARY_TYPE_IDX ON BOUNDARY_TYPE(CODE);

 CREATE TABLE BOUNDARY_STATUS
(ID INT auto_increment PRIMARY KEY,
 CODE VARCHAR(40) NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048));

CREATE UNIQUE INDEX BOUNDARY_STATUS_IDX ON BOUNDARY_STATUS(CODE);

CREATE TABLE BOUNDARY (
ID VARCHAR(40) PRIMARY KEY,
NAME VARCHAR(255) NOT NULL,
TYPE_CODE VARCHAR(40) NOT NULL,
AUTHORITY_NAME VARCHAR(255),
PARENT_ID VARCHAR(40),
RECORDER_NAME VARCHAR(255),
GEOM VARCHAR(100000),
STATUS_CODE VARCHAR(40) DEFAULT 'pending',
PROCESSED BOOLEAN DEFAULT TRUE,
VERSION INT DEFAULT 0,
FOREIGN KEY (STATUS_CODE) REFERENCES BOUNDARY_STATUS(CODE),
FOREIGN KEY (TYPE_CODE) REFERENCES BOUNDARY_TYPE(CODE),
FOREIGN KEY (PARENT_ID) REFERENCES BOUNDARY(ID)
);

CREATE TABLE LANGUAGE
(ID INT auto_increment PRIMARY KEY,
CODE VARCHAR(255) NOT NULL,
DISPLAY_VALUE VARCHAR(255) NOT NULL,
ACTIVE BOOLEAN NOT NULL,
IS_DEFAULT BOOLEAN NOT NULL,
LTR BOOLEAN NOT NULL,
ITEM_ORDER INT NOT NULL);

CREATE UNIQUE INDEX LANGUAGE_IDX ON LANGUAGE(CODE);
CREATE INDEX DEFAULT_LANGUAGE_IDX ON LANGUAGE(IS_DEFAULT);

CREATE TABLE PERSON
(PERSON_ID VARCHAR(255) PRIMARY KEY,
FIRST_NAME VARCHAR(255) NOT NULL,
LAST_NAME VARCHAR(255),
DATE_OF_BIRTH DATE,
PERSON_TYPE VARCHAR(255),
PLACE_OF_BIRTH VARCHAR(255),
ID_TYPE VARCHAR(255),
FOREIGN KEY (ID_TYPE)
REFERENCES ID_TYPE(TYPE),
ID_NUMBER VARCHAR(255),
EMAIL_ADDRESS VARCHAR(255),
POSTAL_ADDRESS VARCHAR(255),
MOBILE_PHONE_NUMBER VARCHAR(255),
CONTACT_PHONE_NUMBER VARCHAR(255),
GENDER CHAR(1));

CREATE TABLE LOCATION
(LOCATION_ID VARCHAR(255) PRIMARY KEY, 
NAME VARCHAR(255) NOT NULL, 
LAT DECIMAL(15,10) NOT NULL, 
LON DECIMAL(15,10) NOT NULL);

CREATE UNIQUE INDEX LOCATION_NAME_IDX ON LOCATION(NAME);

CREATE TABLE MAP_BOOKMARK
(MAP_BOOKMARK_ID VARCHAR(255) PRIMARY KEY, 
NAME VARCHAR(255) NOT NULL, 
LAT DECIMAL(15,10) NOT NULL, 
LON DECIMAL(15,10) NOT NULL);

CREATE UNIQUE INDEX MAP_BOOKMARK_NAME_IDX ON MAP_BOOKMARK(NAME);

CREATE TABLE CLAIM_STATUS
(ID INT auto_increment PRIMARY KEY,
 STATUS VARCHAR(255) NOT NULL);
 
CREATE TABLE ATTACHMENT_STATUS
(ID INT auto_increment PRIMARY KEY,
 STATUS VARCHAR(255) NOT NULL);
 
CREATE TABLE CLAIM_TYPE
(ID INT auto_increment PRIMARY KEY,
 TYPE VARCHAR(255) NOT NULL,
 DISPLAY_VALUE VARCHAR(512) NOT NULL,
 ACTIVE BOOLEAN NOT NULL,
 DESCRIPTION VARCHAR(2048)); 
 
CREATE UNIQUE INDEX CLAIM_TYPE_IDX ON CLAIM_TYPE(TYPE); 

CREATE TABLE CLAIM
(CLAIM_ID VARCHAR(255) PRIMARY KEY, 
NAME VARCHAR(255),
CLAIM_NUMBER VARCHAR(255), 
PERSON_ID VARCHAR(255),
CHALLENGED_CLAIM_ID VARCHAR(255),
CHALLANGE_EXPIRY_DATE DATE,
DATE_OF_START DATE,
STATUS VARCHAR(255),
VERSION VARCHAR(10),
TYPE VARCHAR(255),
RECORDER_NAME VARCHAR(255),
NOTES VARCHAR(300),
LAND_USE VARCHAR(255),
SURVEY_FORM CLOB,
CLAIM_AREA BIGINT,
BOUNDARY_ID VARCHAR(40),
DELETED BOOLEAN NOT NULL DEFAULT FALSE,
CREATION_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
FOREIGN KEY (LAND_USE) REFERENCES LAND_USE(TYPE),
FOREIGN KEY (CHALLENGED_CLAIM_ID) REFERENCES CLAIM(CLAIM_ID),
FOREIGN KEY (PERSON_ID) REFERENCES PERSON(PERSON_ID),
FOREIGN KEY (TYPE) REFERENCES CLAIM_TYPE(TYPE),
FOREIGN KEY (STATUS) REFERENCES CLAIM_STATUS(STATUS),
FOREIGN KEY (BOUNDARY_ID) REFERENCES BOUNDARY(ID));

CREATE TABLE CARDINAL_DIRECTION
(ID INT auto_increment PRIMARY KEY,
 DIRECTION VARCHAR(255) NOT NULL);
 
CREATE TABLE ADJACENCY
(SOURCE_CLAIM_ID VARCHAR(255) NOT NULL, 
DEST_CLAIM_ID VARCHAR(255) NOT NULL, 
CARDINAL_DIRECTION VARCHAR(255) NOT NULL,
PRIMARY KEY (SOURCE_CLAIM_ID, DEST_CLAIM_ID),
FOREIGN KEY (SOURCE_CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID),
FOREIGN KEY (CARDINAL_DIRECTION)
REFERENCES CARDINAL_DIRECTION(DIRECTION),
FOREIGN KEY (DEST_CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE TABLE SHARE
(ID VARCHAR(255) PRIMARY KEY,
CLAIM_ID VARCHAR(255) NOT NULL,
SHARES DECIMAL(4,0) NOT NULL DEFAULT 1,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE TABLE OWNER
(SHARE_ID VARCHAR(255) NOT NULL,
PERSON_ID VARCHAR(255) NOT NULL,
PRIMARY KEY (SHARE_ID, PERSON_ID),
FOREIGN KEY (SHARE_ID)
REFERENCES SHARE(ID),
FOREIGN KEY (PERSON_ID)
REFERENCES PERSON(PERSON_ID));


CREATE TABLE VERTEX
(VERTEX_ID VARCHAR(255) PRIMARY KEY, 
CLAIM_ID VARCHAR(255) NOT NULL,
SEQUENCE_NUMBER INT NOT NULL,
GPS_LAT DECIMAL(15,10),
GPS_LON DECIMAL(15,10),
MAP_LAT DECIMAL(15,10) NOT NULL,
MAP_LON DECIMAL(15,10) NOT NULL,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE UNIQUE INDEX CLAIM_VERTEX_IDX ON VERTEX(CLAIM_ID,SEQUENCE_NUMBER);

CREATE TABLE HOLE_VERTEX
(HOLE_VERTEX_ID VARCHAR(255) PRIMARY KEY,
CLAIM_ID VARCHAR(255) NOT NULL,
HOLE_NUMBER INT NOT NULL,
SEQUENCE_NUMBER INT NOT NULL,
GPS_LAT DECIMAL(15,10),
GPS_LON DECIMAL(15,10),
MAP_LAT DECIMAL(15,10) NOT NULL,
MAP_LON DECIMAL(15,10) NOT NULL,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE UNIQUE INDEX CLAIM_HOLE_VERTEX_IDX ON HOLE_VERTEX(CLAIM_ID,HOLE_NUMBER,SEQUENCE_NUMBER);

CREATE TABLE PROPERTY_LOCATION
(PROPERTY_LOCATION_ID VARCHAR(255) PRIMARY KEY, 
CLAIM_ID VARCHAR(255) NOT NULL,
DESCRIPTION VARCHAR(255) NOT NULL,
GPS_LAT DECIMAL(15,10),
GPS_LON DECIMAL(15,10),
MAP_LAT DECIMAL(15,10) NOT NULL,
MAP_LON DECIMAL(15,10) NOT NULL,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE TABLE ADDITIONAL_INFO
(ADDITIONAL_INFO_ID VARCHAR(255) PRIMARY KEY,
CLAIM_ID VARCHAR(255) NOT NULL, 
NAME VARCHAR(255) NOT NULL, 
VALUE VARCHAR(255), 
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE UNIQUE INDEX CLAIM_ADDITIONAL_INFO_IDX ON ADDITIONAL_INFO(CLAIM_ID,NAME);

CREATE TABLE ADJACENCIES_NOTES
(NORTH_ADJACENCY VARCHAR(255),
SOUTH_ADJACENCY VARCHAR(255),
WEST_ADJACENCY VARCHAR(255),
EAST_ADJACENCY VARCHAR(255),
CLAIM_ID VARCHAR(255) NOT NULL,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID));

CREATE TABLE ATTACHMENT
(ATTACHMENT_ID VARCHAR(255) PRIMARY KEY, 
STATUS VARCHAR(255),
CLAIM_ID VARCHAR(255) NOT NULL, 
DESCRIPTION VARCHAR(255) NOT NULL, 
FILE_NAME VARCHAR(255) NOT NULL, 
FILE_TYPE VARCHAR(255) NOT NULL, 
MIME_TYPE VARCHAR(255) NOT NULL, 
MD5SUM VARCHAR(255), 
PATH VARCHAR(255) NOT NULL,
SIZE BIGINT,
DOWNLOADED_BYTES BIGINT,
UPLOADED_BYTES BIGINT,
FOREIGN KEY (CLAIM_ID)
REFERENCES CLAIM(CLAIM_ID),
FOREIGN KEY (STATUS)
REFERENCES ATTACHMENT_STATUS(STATUS));

MERGE INTO LOCATION(LOCATION_ID, NAME, LAT, LON) KEY (LOCATION_ID) SELECT '1', 'CURRENT', 0.0, 0.0 FROM DUAL;
MERGE INTO LOCATION(LOCATION_ID, NAME, LAT, LON) KEY (LOCATION_ID) SELECT '2', 'HOME', 0.0, 0.0 FROM DUAL;

INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('NORTH');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('SOUTH');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('EAST');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('WEST');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('NORTHEAST');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('NORTHWEST');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('SOUTHEAST');
INSERT INTO CARDINAL_DIRECTION (DIRECTION) VALUES ('SOUTHWEST');

INSERT INTO CLAIM_STATUS (STATUS) VALUES ('created');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('uploading');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('updating');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('unmoderated');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('moderated');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('challenged');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('reviewed');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('upload_incomplete');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('upload_error');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('update_incomplete');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('update_error');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('withdrawn');
INSERT INTO CLAIM_STATUS (STATUS) VALUES ('issued');

INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('created');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('uploading');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('uploaded');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('deleted');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('upload_incomplete');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('upload_error');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('download_incomplete');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('download_failed');
INSERT INTO ATTACHMENT_STATUS (STATUS) VALUES ('downloading');




 
 

