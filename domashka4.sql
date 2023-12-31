USE [master]
GO
/****** Object:  Database [Acad00]    Script Date: 07.12.2023 21:13:43 ******/
CREATE DATABASE [Acad00]
GO
USE [Acad00]
GO
/****** Object:  UserDefinedFunction [dbo].[DayOfWeek]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[DayOfWeek] (@day datetime)
returns varchar(15)
as
begin 
	declare @weekday varchar(30)
	if (datename(dw,@day) = 'Суббота')
		set @weekday = 'Сегодня суббота'
	if (datename(dw,@day) = 'Воскресенье')
		set @weekday = 'Воскресенье' 
	else 
		set @weekday = 'Будний день' 
return @weekday
end
GO
/****** Object:  UserDefinedFunction [dbo].[DayOfWeek1]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[DayOfWeek1](@day datetime)
returns varchar(15)
as
begin 
	declare @weekday varchar(30)
	if (datename(dw,@day) = 'суббота')
		set @weekday = 'Сегодня суббота'
	else
	begin
		if (datename(dw,@day) = 'воскресенье')
			set @weekday = 'Воскресенье' 
		else 
			set @weekday = 'Будний день' 
	end
return @weekday
end
GO
/****** Object:  UserDefinedFunction [dbo].[NameFunc1]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NameFunc1] (@a int, @b int)
returns int
as
begin
	declare @res int
	set @res = @a + @b
	return @res
end
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Year] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupsLectures]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupsLectures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[GroupId] [int] NULL,
	[LectureId] [int] NULL,
 CONSTRAINT [PK__GroupsLe__3214EC07ACFFB42E] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lectures]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lectures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LectureRoom] [nvarchar](max) NOT NULL,
	[SubjectId] [int] NOT NULL,
	[TeacherId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Teachers]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Teachers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Salary] [money] NOT NULL,
	[Surname] [nvarchar](max) NOT NULL,
	[Premium] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[tablefunc]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[tablefunc]()
returns table
as
return (with SalaryTeachers
as
(
select id, Name, Surname, case when Salary<20000 then 'Учителя с зп меньше 20000'
			when Salary>=20000 and Salary<50000 then 'Учителя с зп больше 20000 меньше 50000'
			when Salary between 50000 and 100000 then 'Учителя с зп больше 50000 меньше 100000'
			else 'Учителя с зп больше 100000'
			end as column1
from Teachers
),
GroupTeachersSalary
as
(
select g.Name as gName, st.Name as stName, st.Surname, st.column1
from SalaryTeachers st
join Lectures l on l.TeacherId = st.id
join GroupsLectures gl on gl.LectureId = l.Id
join Groups g on g.Id = gl.GroupId
)
select * from GroupTeachersSalary)

GO
/****** Object:  UserDefinedFunction [dbo].[tablefunc1]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[tablefunc1](@a int, @b int)
returns table
as
return(
	select * 
	from Teachers
	where Salary between @a and @b)
GO
/****** Object:  UserDefinedFunction [dbo].[TeacherSalary]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[TeacherSalary](@a int, @b int)
returns table
as
return(
	select * 
	from Teachers
	where Salary between @a and @b)
GO
/****** Object:  Table [dbo].[Curators]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curators](
	[id] [int] NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_Curators] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Financing] [money] NULL,
	[Name] [nvarchar](100) NULL,
	[FacultyId] [int] NULL,
 CONSTRAINT [PK__Departme__3214EC075447E959] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faculties]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Financing] [money] NULL,
 CONSTRAINT [PK__Facultie__3214EC070BCF63AA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupsCurators]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupsCurators](
	[id] [int] NULL,
	[GroupId] [int] NULL,
	[CuratorId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Subjects]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subjects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Curators] ([id], [Name]) VALUES (1, N'cur1')
INSERT [dbo].[Curators] ([id], [Name]) VALUES (2, N'cur2')
INSERT [dbo].[Curators] ([id], [Name]) VALUES (3, N'cur3')
INSERT [dbo].[Curators] ([id], [Name]) VALUES (4, N'cur4')
INSERT [dbo].[Curators] ([id], [Name]) VALUES (5, N'cur5')
GO
SET IDENTITY_INSERT [dbo].[Departments] ON 

INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (1, 40000.0000, N'Software Development', 1)
INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (2, 20000.0000, N'Foreign languages', 2)
INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (3, 16500.0000, N'Heat Engines', 3)
INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (1003, 26000.0000, N'Heat Engines Language', 1)
INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (1008, 50000.0000, N'eqwrfafe', NULL)
INSERT [dbo].[Departments] ([Id], [Financing], [Name], [FacultyId]) VALUES (1009, 50000.0000, N'dep23', NULL)
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[Faculties] ON 

INSERT [dbo].[Faculties] ([Id], [Name], [Financing]) VALUES (1, N'Computer Science', 10000.0000)
INSERT [dbo].[Faculties] ([Id], [Name], [Financing]) VALUES (2, N'Economics and Management', 20000.0000)
INSERT [dbo].[Faculties] ([Id], [Name], [Financing]) VALUES (3, N'Energy and Electronics', 30000.0000)
INSERT [dbo].[Faculties] ([Id], [Name], [Financing]) VALUES (4, N'fucult5', 40000.0000)
SET IDENTITY_INSERT [dbo].[Faculties] OFF
GO
SET IDENTITY_INSERT [dbo].[Groups] ON 

INSERT [dbo].[Groups] ([Id], [Name], [Year], [DepartmentId]) VALUES (1, N'C-22', 1, 1)
INSERT [dbo].[Groups] ([Id], [Name], [Year], [DepartmentId]) VALUES (2, N'B-20', 3, 2)
INSERT [dbo].[Groups] ([Id], [Name], [Year], [DepartmentId]) VALUES (3, N'A-18', 5, 3)
INSERT [dbo].[Groups] ([Id], [Name], [Year], [DepartmentId]) VALUES (4, N'G-19', 4, 1)
INSERT [dbo].[Groups] ([Id], [Name], [Year], [DepartmentId]) VALUES (1002, N'G-12', 5, 1)
SET IDENTITY_INSERT [dbo].[Groups] OFF
GO
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (1, 1, 1)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (2, 1, 4)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (3, 2, 2)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (4, 2, 3)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (5, 3, 5)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (6, 3, 4)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (7, 4, 1)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (8, 4, 2)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (9, 1002, 1)
INSERT [dbo].[GroupsCurators] ([id], [GroupId], [CuratorId]) VALUES (10, 4, 1)
GO
SET IDENTITY_INSERT [dbo].[GroupsLectures] ON 

INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (1, 1, 1, 2)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (2, 1, 2, 2)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (3, 1, NULL, 3)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (4, 1, 4, 3)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (5, 2, 2, 2)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (6, 2, 4, 7)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (7, 3, 1, 5)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (8, 3, 3, NULL)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (9, 3, 3, 6)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (10, 4, 1, 4)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (11, 4, 1, 1)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (12, 4, 3, 3)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (13, 5, 1, 1)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (14, 5, 2, 5)
INSERT [dbo].[GroupsLectures] ([Id], [DayOfWeek], [GroupId], [LectureId]) VALUES (15, 5, 3, 3)
SET IDENTITY_INSERT [dbo].[GroupsLectures] OFF
GO
SET IDENTITY_INSERT [dbo].[Lectures] ON 

INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (1, N'D201', 1, 1)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (2, N'D205', 2, 2)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (3, N'D210', 3, 3)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (4, N'D212', 2, 2)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (5, N'D201', 3, 2)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (6, N'D205', 3, 3)
INSERT [dbo].[Lectures] ([Id], [LectureRoom], [SubjectId], [TeacherId]) VALUES (7, N'D201', 1, 5)
SET IDENTITY_INSERT [dbo].[Lectures] OFF
GO
SET IDENTITY_INSERT [dbo].[Subjects] ON 

INSERT [dbo].[Subjects] ([Id], [Name]) VALUES (1, N'Database Theory')
INSERT [dbo].[Subjects] ([Id], [Name]) VALUES (2, N'Maths')
INSERT [dbo].[Subjects] ([Id], [Name]) VALUES (3, N'Physics')
SET IDENTITY_INSERT [dbo].[Subjects] OFF
GO
SET IDENTITY_INSERT [dbo].[Teachers] ON 

INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (1, N'Jack', 26000.0000, N'Petrov', 5000.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (2, N'Jack', 450000.0000, N'Underhill', 10000.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (3, N'Dave ', 16000.0000, N'McQueen', 12000.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (5, N'Ben', 800000.0000, N'Jonson', 7000.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (6, N'teach1', 16000.0000, N'asdfasdf', 12341.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (7, N'teach2', 26000.0000, N'aaqqwe', 112.0000)
INSERT [dbo].[Teachers] ([Id], [Name], [Salary], [Surname], [Premium]) VALUES (9, N'teach2', 700000.0000, N'aaqqwe', 112.0000)
SET IDENTITY_INSERT [dbo].[Teachers] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Departme__737584F64AB297D4]    Script Date: 07.12.2023 21:13:44 ******/
ALTER TABLE [dbo].[Departments] ADD  CONSTRAINT [UQ__Departme__737584F64AB297D4] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Facultie__737584F65A32880B]    Script Date: 07.12.2023 21:13:44 ******/
ALTER TABLE [dbo].[Faculties] ADD  CONSTRAINT [UQ__Facultie__737584F65A32880B] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Groups__737584F6CAAC50AE]    Script Date: 07.12.2023 21:13:44 ******/
ALTER TABLE [dbo].[Groups] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Subjects__737584F6911CC3FD]    Script Date: 07.12.2023 21:13:44 ******/
ALTER TABLE [dbo].[Subjects] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Departments] ADD  CONSTRAINT [DF__Departmen__Finan__398D8EEE]  DEFAULT ((0.0)) FOR [Financing]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [FK__Departmen__Facul__52593CB8] FOREIGN KEY([FacultyId])
REFERENCES [dbo].[Faculties] ([Id])
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [FK__Departmen__Facul__52593CB8]
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK__Groups__Departme__534D60F1] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Departments] ([Id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK__Groups__Departme__534D60F1]
GO
ALTER TABLE [dbo].[GroupsCurators]  WITH CHECK ADD  CONSTRAINT [FK_GroupsCurators_Curators] FOREIGN KEY([CuratorId])
REFERENCES [dbo].[Curators] ([id])
GO
ALTER TABLE [dbo].[GroupsCurators] CHECK CONSTRAINT [FK_GroupsCurators_Curators]
GO
ALTER TABLE [dbo].[GroupsCurators]  WITH CHECK ADD  CONSTRAINT [FK_GroupsCurators_Groups] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([Id])
GO
ALTER TABLE [dbo].[GroupsCurators] CHECK CONSTRAINT [FK_GroupsCurators_Groups]
GO
ALTER TABLE [dbo].[GroupsLectures]  WITH CHECK ADD  CONSTRAINT [FK__GroupsLec__Group__5441852A] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Groups] ([Id])
GO
ALTER TABLE [dbo].[GroupsLectures] CHECK CONSTRAINT [FK__GroupsLec__Group__5441852A]
GO
ALTER TABLE [dbo].[GroupsLectures]  WITH CHECK ADD  CONSTRAINT [FK__GroupsLec__Lectu__5535A963] FOREIGN KEY([LectureId])
REFERENCES [dbo].[Lectures] ([Id])
GO
ALTER TABLE [dbo].[GroupsLectures] CHECK CONSTRAINT [FK__GroupsLec__Lectu__5535A963]
GO
ALTER TABLE [dbo].[Lectures]  WITH CHECK ADD FOREIGN KEY([SubjectId])
REFERENCES [dbo].[Subjects] ([Id])
GO
ALTER TABLE [dbo].[Lectures]  WITH CHECK ADD FOREIGN KEY([TeacherId])
REFERENCES [dbo].[Teachers] ([Id])
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [CK__Departmen__Finan__38996AB5] CHECK  (([Financing]>=(0.0)))
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [CK__Departmen__Finan__38996AB5]
GO
ALTER TABLE [dbo].[Departments]  WITH CHECK ADD  CONSTRAINT [CK__Department__Name__3A81B327] CHECK  (([Name]<>N''))
GO
ALTER TABLE [dbo].[Departments] CHECK CONSTRAINT [CK__Department__Name__3A81B327]
GO
ALTER TABLE [dbo].[Faculties]  WITH CHECK ADD  CONSTRAINT [CK__Faculties__Name__3E52440B] CHECK  (([Name]<>N''))
GO
ALTER TABLE [dbo].[Faculties] CHECK CONSTRAINT [CK__Faculties__Name__3E52440B]
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD CHECK  (([Name]<>N''))
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD CHECK  (([Year]>=(1) AND [Year]<=(5)))
GO
ALTER TABLE [dbo].[GroupsLectures]  WITH CHECK ADD  CONSTRAINT [CK__GroupsLec__DayOf__45F365D3] CHECK  (([DayOfWeek]>=(1) AND [DayOfWeek]<=(7)))
GO
ALTER TABLE [dbo].[GroupsLectures] CHECK CONSTRAINT [CK__GroupsLec__DayOf__45F365D3]
GO
ALTER TABLE [dbo].[Lectures]  WITH CHECK ADD CHECK  (([LectureRoom]<>N''))
GO
ALTER TABLE [dbo].[Subjects]  WITH CHECK ADD CHECK  (([Name]<>N''))
GO
ALTER TABLE [dbo].[Teachers]  WITH CHECK ADD CHECK  (([Name]<>N''))
GO
ALTER TABLE [dbo].[Teachers]  WITH CHECK ADD CHECK  (([Salary]>(0.0)))
GO
ALTER TABLE [dbo].[Teachers]  WITH CHECK ADD CHECK  (([Surname]<>N''))
GO
/****** Object:  StoredProcedure [dbo].[sp_nameProc]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_nameProc]
as
with SalaryTeachers
as
(
select id, Name, Surname, case when Salary<20000 then 'Учителя с зп меньше 20000'
			when Salary>=20000 and Salary<50000 then 'Учителя с зп больше 20000 меньше 50000'
			when Salary between 50000 and 100000 then 'Учителя с зп больше 50000 меньше 100000'
			else 'Учителя с зп больше 100000'
			end as column1
from Teachers
),
GroupTeachersSalary
as
(
select g.Name as gName, st.Name as stName, st.Surname, st.column1
from SalaryTeachers st
join Lectures l on l.TeacherId = st.id
join GroupsLectures gl on gl.LectureId = l.Id
join Groups g on g.Id = gl.GroupId
)
select * from GroupTeachersSalary
GO
/****** Object:  StoredProcedure [dbo].[sp_nameProc2]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_nameProc2]
@Name varchar(100) output,
@Surname varchar(100) output
as 
select @Name = t.Name, @Surname = t.Surname
from Teachers t
where t.Salary>100000
GO
/****** Object:  StoredProcedure [dbo].[sp_nameProc3]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_nameProc3]
@Salary int,
@Name varchar(100) output,
@Surname varchar(100) output
as 
select @Name = t.Name, @Surname = t.Surname
from Teachers t
where t.Salary>@Salary
GO
/****** Object:  StoredProcedure [dbo].[sp_summ2]    Script Date: 07.12.2023 21:13:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_summ2]
@a int,
@b int 
as
declare @res int
set @res = @a + @b
return @res
GO
USE [master]
GO
ALTER DATABASE [Acad00] SET  READ_WRITE 
GO
