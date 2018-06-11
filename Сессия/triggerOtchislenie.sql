ALTER TRIGGER deleteExam on Exams INSTEAD OF DELETE AS
	BEGIN
		declare @id int
		declare cur cursor for select id from deleted
		open cur
		fetch cur into @id
		WHILE (@@FETCH_STATUS = 0) 
			BEGIN
				delete from Dependencies where exid = @id or depends_of = @id
				delete from Exams where id = @id
				fetch cur into @id
			END
		close cur
		deallocate cur
	END


/*ALTER TRIGGER otchislenie on Students AFTER DELETE AS
	BEGIN
		declare @stid int, @group int, @groupSize int
		SELECT @stid = id from deleted
		SELECT @group = groupid from deleted
		SELECT @groupSize = COUNT(*) from Students where groupid = @group
		print(@groupSize)
		if (@groupSize = 0)
			delete from Exams where groupid = @group
	END*/