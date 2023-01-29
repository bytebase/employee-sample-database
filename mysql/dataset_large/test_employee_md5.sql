--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

USE employee;

SELECT 'TESTING INSTALLATION' as 'INFO';

DROP TABLE IF EXISTS expected_value, found_value;
CREATE TABLE expected_value (
    table_name varchar(30) not null primary key,
    recs int not null,
    crc_md5 varchar(100) not null
);


CREATE TABLE found_value LIKE expected_value;

INSERT INTO `expected_value` VALUES 
('employee',    10000, '2b9ee8043563317634407daf42a9ef0b'),
('department',      9, 'd1af5e170d2d1591d776d5638d71fc5f'),
('dept_manager',    24, '953e3c0c8360805645498ada817b66e9'),
('dept_emp',     11051, 'fc43a976d1406705d9707f6fea1df9df'),
('title',       14782, 'ffa808be19d75619f415e2964cbe0320'),
('salary',     94917, '0fcb81f97f6b0eacb01a22a085e6512d');
SELECT table_name, recs AS expected_record, crc_md5 AS expected_crc FROM expected_value;

DROP TABLE IF EXISTS tchecksum;
CREATE TABLE tchecksum (chk char(100));

SET @crc= '';

INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc,
                emp_no,birth_date,first_name,last_name,gender,hire_date)) 
    FROM employee ORDER BY emp_no;
INSERT INTO found_value VALUES ('employee', (SELECT COUNT(*) FROM employee), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, dept_no,dept_name)) 
    FROM department ORDER BY dept_no;
INSERT INTO found_value values ('department', (SELECT COUNT(*) FROM department), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, dept_no,emp_no, from_date,to_date)) 
    FROM dept_manager ORDER BY dept_no,emp_no;
INSERT INTO found_value values ('dept_manager', (SELECT COUNT(*) FROM dept_manager), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, dept_no,emp_no, from_date,to_date)) 
    FROM dept_emp ORDER BY dept_no,emp_no;
INSERT INTO found_value values ('dept_emp', (SELECT COUNT(*) FROM dept_emp), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, emp_no, title, from_date,to_date)) 
    FROM title order by emp_no,title,from_date;
INSERT INTO found_value values ('title', (SELECT COUNT(*) FROM title), @crc);

SET @crc = '';
INSERT INTO tchecksum 
    SELECT @crc := MD5(CONCAT_WS('#',@crc, emp_no, amount, from_date,to_date)) 
    FROM salary order by emp_no,from_date,to_date;
INSERT INTO found_value values ('salary', (SELECT COUNT(*) FROM salary), @crc);

DROP TABLE tchecksum;

SELECT table_name, recs as 'found_records   ', crc_md5 as found_crc from found_value;

SELECT  
    e.table_name, 
    IF(e.recs=f.recs,'OK', 'not ok') AS records_match, 
    IF(e.crc_md5=f.crc_md5,'ok','not ok') AS crc_match 
from 
    expected_value e INNER JOIN found_value f USING (table_name); 


set @crc_fail=(select count(*) from expected_value e inner join found_value f on (e.table_name=f.table_name) where f.crc_md5 != e.crc_md5);
set @count_fail=(select count(*) from expected_value e inner join found_value f on (e.table_name=f.table_name) where f.recs != e.recs);

select timediff(
    now(),
    (select create_time from information_schema.tables where table_schema='employee' and table_name='expected_value')
) as computation_time;

DROP TABLE expected_value,found_value;

select 'CRC' as summary,  if(@crc_fail = 0, "OK", "FAIL" ) as 'result'
union all
select 'count', if(@count_fail = 0, "OK", "FAIL" );


