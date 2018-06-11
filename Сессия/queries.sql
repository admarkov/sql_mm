--Выбрать всех студентов из одной группы упорядочив по ФИО.
SELECT * FROM Students where groupid = 243 order by name
--Упорядочить сданные кем-либо экзамены по числу сдавших.
SELECT subject, passed_amount from (SELECT exid, COUNT(*) as passed_amount FROM Results where result = 'passed' group by exid) as tt JOIN Exams ON Exams.id = tt.exid
--Каково число студентов, не получивших ни одного зачета?
SELECT COUNT(*) FROM Students where id not in (SELECT stid FROM extResults where result = 'passed' and  extype = 'Зачет' group by stid)
--Найти самую малочисленную группу
SELECT top 1 groupid, COUNT(*) as cnt from Students group by groupid order by cnt
--Найти студента, сдавшего больше всех экзаменов
SELECT top 1 stid, count(*) as cnt FROM extResults where result = 'passed' and extype = 'Экзамен' group by stid order by cnt desc
--Найти всех студентов, сдавших все обязательные экзамены с хотя бы одним несданным зачетом
SELECT Students.id, Students.name, Students.groupid FROM Students JOIN (SELECT stid, COUNT(*) as passed from extResults where extype = 'Экзамен' and result = 'passed' and isrequired = 1 group by stid) as passedtt on passedtt.stid = Students.id JOIN (SELECT groupid, COUNT(*) as total from Exams where type = 'Экзамен' and isrequired = 1 group by groupid) as grouptt on grouptt.groupid = Students.groupid JOIN (SELECT stid, COUNT(*) as passedzach from extResults where extype = 'Зачет' and result = 'passed' group by stid) as passedzachtt on passedzachtt.stid = Students.id JOIN (SELECT groupid, COUNT(*) as totalzach from Exams where type = 'Зачет' group by groupid) as groupzachtt on groupzachtt.groupid = Students.groupid where passed = total and passedzach < totalzach
--Найти группу с самой большой нагрузкой (числом зачетов и экзаменов).
select groupid, count(*) as amount from Exams where isrequired = 1 group by groupid order by amount desc
--Найти, сколько студентов не допущены (т.е., не получили необходимых зачетов) хотя бы к одному обязательному экзамену.
SELECT COUNT(DISTINCT Students.id) FROM Students JOIN Exams on Students.groupid = Exams.groupid where Exams.type = 'Экзамен' and Exams.isrequired = 1 and dbo.isallowed(Students.id, Exams.id) = 0
--Найти самый «сложный» экзамен (с максимальным процентом не сдавших). Полностью необязательные экзамены не рассматривать.
SELECT TOP 1 totaltable.exid as exid, Exams.subject as subject, CAST(badamount as real) / totalamount as ratio FROM (SELECT exid, COUNT(DISTINCT stid) as totalamount from extResults where extype = 'Экзамен' and isrequired = 1 group by exid) as totaltable join (SELECT exid, COUNT(DISTINCT stid) as badamount from extResults where extype = 'Экзамен' and isrequired = 1 and result = 'FAILED' group by exid) as badtable on totaltable.exid = badtable.exid join Exams on totaltable.exid = Exams.id order by ratio desc
--Проверить, есть ли в базе студент, не допущенный ни к одному обязательному для его группы экзамену. Можно считать, что каждая группа обязана сдавать хотя бы один экзамен.
SELECT (SELECT Count(*) from Students) - (SELECT COUNT(DISTINCT Students.id) from Students JOIN Exams on Students.groupid = Exams.groupid where Exams.type = 'Экзамен' and Exams.isrequired = 1 and dbo.isallowed(Students.id, Exams.id) = 1)