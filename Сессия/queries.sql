--������� ���� ��������� �� ����� ������ ���������� �� ���.
SELECT * FROM Students where groupid = 243 order by name
--����������� ������� ���-���� �������� �� ����� �������.
SELECT subject, passed_amount from (SELECT exid, COUNT(*) as passed_amount FROM Results where result = 'passed' group by exid) as tt JOIN Exams ON Exams.id = tt.exid
--������ ����� ���������, �� ���������� �� ������ ������?
SELECT COUNT(*) FROM Students where id not in (SELECT stid FROM extResults where result = 'passed' and  extype = '�����' group by stid)
--����� ����� ������������� ������
SELECT top 1 groupid, COUNT(*) as cnt from Students group by groupid order by cnt
--����� ��������, �������� ������ ���� ���������
SELECT top 1 stid, count(*) as cnt FROM extResults where result = 'passed' and extype = '�������' group by stid order by cnt desc
--����� ���� ���������, ������� ��� ������������ �������� � ���� �� ����� ��������� �������
SELECT Students.id, Students.name, Students.groupid FROM Students JOIN (SELECT stid, COUNT(*) as passed from extResults where extype = '�������' and result = 'passed' and isrequired = 1 group by stid) as passedtt on passedtt.stid = Students.id JOIN (SELECT groupid, COUNT(*) as total from Exams where type = '�������' and isrequired = 1 group by groupid) as grouptt on grouptt.groupid = Students.groupid JOIN (SELECT stid, COUNT(*) as passedzach from extResults where extype = '�����' and result = 'passed' group by stid) as passedzachtt on passedzachtt.stid = Students.id JOIN (SELECT groupid, COUNT(*) as totalzach from Exams where type = '�����' group by groupid) as groupzachtt on groupzachtt.groupid = Students.groupid where passed = total and passedzach < totalzach
--����� ������ � ����� ������� ��������� (������ ������� � ���������).
select groupid, count(*) as amount from Exams where isrequired = 1 group by groupid order by amount desc
--�����, ������� ��������� �� �������� (�.�., �� �������� ����������� �������) ���� �� � ������ ������������� ��������.
SELECT COUNT(DISTINCT Students.id) FROM Students JOIN Exams on Students.groupid = Exams.groupid where Exams.type = '�������' and Exams.isrequired = 1 and dbo.isallowed(Students.id, Exams.id) = 0
--����� ����� �������� ������� (� ������������ ��������� �� �������). ��������� �������������� �������� �� �������������.
SELECT TOP 1 totaltable.exid as exid, Exams.subject as subject, CAST(badamount as real) / totalamount as ratio FROM (SELECT exid, COUNT(DISTINCT stid) as totalamount from extResults where extype = '�������' and isrequired = 1 group by exid) as totaltable join (SELECT exid, COUNT(DISTINCT stid) as badamount from extResults where extype = '�������' and isrequired = 1 and result = 'FAILED' group by exid) as badtable on totaltable.exid = badtable.exid join Exams on totaltable.exid = Exams.id order by ratio desc
--���������, ���� �� � ���� �������, �� ���������� �� � ������ ������������� ��� ��� ������ ��������. ����� �������, ��� ������ ������ ������� ������� ���� �� ���� �������.
SELECT (SELECT Count(*) from Students) - (SELECT COUNT(DISTINCT Students.id) from Students JOIN Exams on Students.groupid = Exams.groupid where Exams.type = '�������' and Exams.isrequired = 1 and dbo.isallowed(Students.id, Exams.id) = 1)