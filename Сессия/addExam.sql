ALTER PROCEDURE addExam(@exName nvarchar(100), @semName nvarchar(100), @group int)
	AS
		BEGIN
			declare @semcnt int
			SELECT @semcnt = COUNT(*) from Exams where groupid = @group and subject = @semName
			if (@semcnt = 0)
				INSERT INTO Exams(subject, isrequired, type, groupid) VALUES (@semName, 0, '�����', @group)
			declare @semid int, @exid int
			SELECT @semid = id from Exams where type = '�����' and groupid = @group and subject = @semName
			INSERT INTO Exams(subject, isrequired, type, groupid) VALUES (@exName, 1, '�������', @group)
			select @exid = id from Exams where type = '�������' and groupid = @group and subject = @exName
			INSERT INTO Dependencies (exid, depends_of, isrequired) VALUES (@exid, @semid, 1)
		END