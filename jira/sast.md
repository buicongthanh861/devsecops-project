Devsecops | SAST High DBClient command Injection



Description

Scan Detials: DBClient_SAST_CICD_scan_17a0ca9f

Source file path: src/.../org/t246osslab/easybuggy/core/dao/DBClient.java

Filename: DBClient.java

Vulnerable Code funcition: 



       // create users table


        stmt.executeUpdate("create table users (id varchar(10) primary key, name varchar(30), password varchar(30), " +


                "secret varchar(100), ispublic varchar(5), phone varchar(20), mail varchar(100))");




        // insert private (invisible) user records


        stmt.executeUpdate("insert into users values ('admin','admin','password','" + RandomStringUtils.randomNumeric(10) + "','false', '', '')");
Make sure using a dynamically formatted SQL query is safe here.


        stmt.executeUpdate("insert into users values ('admin02','admin02','pas2w0rd','" + RandomStringUtils.randomNumeric(10) + "','false', '', '')");


        stmt.executeUpdate("insert into users values ('admin03','admin03','pa33word','" + RandomStringUtils.randomNumeric(10) + "','false', '', '')");


        stmt.executeUpdate("insert into users values ('admin04','admin04','pathwood','" + RandomStringUtils.randomNumeric(10) + "','false', '', '')");


        


        // insert public (test) user records
Line number: 75 in DBClient.java

Formatted SQL queries can be difficult to maintain, debug and can increase the risk of SQL injection when concatenating untrusted values into the query. However, this rule doesn’t detect SQL injections (unlike rule {rule:javasecurity:S3649}), the goal is only to highlight complex/formatted queries.  


How can fix: 

OWASP - Top 10 2021 Category A3 - Injection

OWASP - Top 10 2017 Category A1 - Injection

CWE - CWE-89 - Improper Neutralization of Special Elements used in an SQL Command

CWE - CWE-564 - SQL Injection: Hibernate

CWE - CWE-20 - Improper Input Validation

CWE - CWE-943 - Improper Neutralization of Special Elements in Data Query Logic

CERT, IDS00-J. - Prevent SQL injection

Derived from FindSecBugs rules Potential SQL/JPQL Injection (JPA), Potential SQL/JDOQL Injection (JDO), Potential SQL/HQL Injection (Hibernate)

Subtasks

Add subtask
Linked work items

Add linked work item
Confluence content



