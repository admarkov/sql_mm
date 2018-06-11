
create table Results (
	stid integer references Students(id),
	exid integer references Exams(id),
	result varchar(20) not null,
	attempt integer not null default 1,
	check (result in ('passed', 'failed'))
);

create table  Dependencies (
	exid integer references Exams(id),
	depends_of integer references Exams(id),
	isrequired tinyint not null default 0
);