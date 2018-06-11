ALTER PROCEDURE nextGrade(@old int, @new int)
	AS BEGIN
		DECLARE cur cursor for select id as stid from Students where groupid = @old
		DECLARE @stid int
		open cur
		fetch cur into @stid
		WHILE (@@FETCH_STATUS = 0) BEGIN
			declare cur2 cursor for select id as exid from Exams where isrequired = 1 and groupid = @old
			declare @exid int, @good int
			SET @good = 1
			open cur2
			fetch cur2 into @exid
			WHILE (@@FETCH_STATUS = 0) BEGIN
				if (dbo.ispassed(@stid, @exid) = 0)
					SET @good = 0
				fetch cur2 into @exid
			END
			close cur2
			deallocate cur2
			if (@good = 1)
				UPDATE Students SET groupid = @new where id = @old
			fetch cur into @stid
		END
		close cur
		deallocate cur

	END