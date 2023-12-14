--1. Вывести все возможные пары строк преподавателей и групп.
SELECT t.Name, g.Name
FROM Teachers t
CROSS JOIN Groups g

--2. Вывести названия факультетов, фонд финансирования кафедр которых превышает фонд финансирования факультета.
SELECT f.Name, d.Name, f.Financing, d.Financing
FROM Departments d
JOIN Faculties f ON d.FacultyId = f.Id
WHERE d.Financing > f.Financing

--3. Вывести фамилии кураторов групп и названия групп, которые они курируют.
SELECT c.Surname, g.Name
FROM  GroupsCurators gc
JOIN Curators c ON gc.CuratorId = c.Id
JOIN Groups g ON gc.GroupId = g.Id

--4. Вывести имена и фамилии преподавателей, которые читают лекции у группы “P107”.
SELECT * FROM Lectures
 
SELECT t.Name, t.Surname 
FROM Teachers t 
JOIN GroupsLectures gl ON t.Id = gl.Id
JOIN Lectures l ON gl.LectureId = l.Id 
JOIN Groups g ON gl.GroupId = g.Id 
WHERE g.Name = 'P107'


--5. Вывести Фамилии преподавателей и названия факультетов на которых они читают лекции.
SELECT * FROM Teachers 

SELECT t.Surname, f.Name
FROM Teachers t 
JOIN Lectures l ON l.TeacherId = t.Id
JOIN Faculties f ON l.SubjectId = f.Id

--6. Вывести названия кафедр и названия групп, которые к ним относятся.
SELECT d.Name, g.Name
FROM Departments d
JOIN Groups g ON d.Id = g.DepartmentId

--7. Вывести названия дисциплин, которые читает преподаватель “Samantha Adams”.
SELECT s.Name
FROM Subjects s
JOIN Lectures l ON s.Id = l.SubjectId
JOIN Teachers t ON l.TeacherId = t.Id
WHERE t.Name = 'Samantha' AND t.Surname = 'Adams'

--8. Вывести Названия кафедр, на которых читается дисциплина “Database Theory”
SELECT d.Name
FROM Departments d
INNER JOIN Lectures l ON d.Id = l.Id
INNER JOIN Subjects s ON l.SubjectId = s.Id
WHERE s.Name = 'Database Theory'


--9. Вывести названия групп, которые относятся к факультету “Computer Science”.
SELECT g.Name
FROM Groups g
INNER JOIN Departments d ON g.DepartmentId = d.Id
INNER JOIN Faculties f ON d.FacultyId = f.Id
WHERE f.Name = 'Computer Science'

--10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.
SELECT g.Name, f.Name
FROM Groups g
INNER JOIN Departments d ON g.DepartmentId = d.Id
INNER JOIN Faculties f ON d.FacultyId = f.Id
WHERE g.Year=5

--11. Вывести полные имена преподавателей и лекции, которые они читают (названия дисциплины групп), причем отобрать только те лекции, которые читаются в аудитории “B103”.
SELECT t.Name + t.Surname AS 'Имя преподавателя', s.Name + g.Name AS 'Лекция'
FROM Lectures l
INNER JOIN Groups g ON g.Id = l.TeacherId
INNER JOIN Departments d ON d.Id = g.DepartmentId
INNER JOIN Subjects s ON s.Id = l.SubjectId
INNER JOIN Teachers t ON t.Id = l.TeacherId
WHERE l.LectureRoom = 'B103'


--База данных Академия(Academy)
﻿﻿create database Academy

use Academy 

--1. Кураторы (Curators)
--■ Идентификатор (Id). Уникальный идентификатор куратора.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Имя (Name). Имя куратора.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--■ Фамилия (Surname). Фамилия куратора.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
create table Curators
(
	Id int not null primary key identity(1,1),
	Name nvarchar(max) not null check(Name <> ''),
	Surname nvarchar(max) not null check(Surname <> '')
)

--2. Кафедры (Departments)
--■ Идентификатор (Id). Уникальный идентификатор кафедры.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Финансирование (Financing). Фонд финансирования кафедры.
--▷ тип данных money
--▷ Не может содержать null-значения.
--▷ Не может быть меньше 0.
--▷ Значение по умолчанию 0
--■ Название (Name). Название кафедры.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
--■ Идентификатор факультета (FacultyId). Факультет, в состав которого входит кафедра.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Departments
(
	Id int not null primary key identity(1,1),
	Financing money not null check(Financing>=0) default 0,
	Name nvarchar(100) not null check(Name <> '') unique, 
	FacultyId int not null FOREIGN KEY REFERENCES Faculties(Id)
)

--3. Факультеты (Faculties)
--■ Идентификатор (Id). Уникальный идентификатор факультета.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Финансирование (Financing). Фонд финансирования факультета.
--▷ тип данных money
--▷ Не может содержать null-значения.
--▷ Не может быть меньше 0.
--▷ Значение по умолчанию 0
--■ Название (Name). Название факультета.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
create table Faculties
(
	Id int not null primary key identity(1,1),
	Financing money not null check(Financing>=0) default 0,
	Name nvarchar(100) not null check(Name <> '') unique
)

--4. Группы (Groups)
--■ Идентификатор (Id). Уникальный идентификатор группы.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Название (Name). Название группы.
--▷ тип данных nvarchar(10)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
--■ Курс (Year). Курс (год) на котором обучается группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Должно быть в диапазоне от 1 до 5.
--■ Идентификатор кафедры (DepartmentId). Кафедра, в состав которой входит группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Groups
(
	Id int not null primary key identity(1,1),
	Name nvarchar(10) not null check(Name <> '') unique,
	Year int not null check(Year>=1 and Year<=5),
	DepartmentId int not null FOREIGN KEY REFERENCES Departments(Id)
)

--5. Группы и кураторы (GroupsCurators)
--■ Идентификатор (Id). Уникальный идентификатор группы и куратора.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Идентификатор куратора (CuratorId). Куратор.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
--■ Идентификатор группы (GroupId). Группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table GroupsCurators
(
	Id int not null primary key identity(1,1),
	CuratorId int not null FOREIGN KEY REFERENCES Curators(Id),
	GroupId int not null FOREIGN KEY REFERENCES Groups(Id)
)

--6. Группы и лекции (GroupsLectures)
--■ Идентификатор (Id). Уникальный идентификатор группы и лекции.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Идентификатор группы (GroupId). Группа.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
--■ Идентификатор лекции (LectureId). Лекция.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table GroupsLectures
(
	Id int not null primary key identity(1,1),
	GroupId int not null FOREIGN KEY REFERENCES Groups(Id), 
	LectureId int not null FOREIGN KEY REFERENCES Lectures(Id), 
)

--7. Лекции (Lectures)
--■ Идентификатор (Id). Уникальный идентификатор лекции.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Аудитория (LectureRoom). Аудитория в которой читается лекция.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--■ Идентификатор дисциплины (SubjectId). Дисциплина, по которой читается лекция.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
--■ Идентификатор преподавателя (TeacherId). Преподаватель, который читает лекцию.
--▷ тип данных int
--▷ Не может содержать null-значения.
--▷ Внешний ключ.
create table Lectures
(
	Id int not null primary key identity(1,1),
	LectureRoom nvarchar(max) not null check(LectureRoom <> ''),
	SubjectId int not null FOREIGN KEY REFERENCES Subjects(Id),
	TeacherId int not null FOREIGN KEY REFERENCES Teachers(Id)
)

--8. Дисциплины (Subjects)
--■ Идентификатор (Id). Уникальный идентификатор дисциплины.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Название (Name). Название дисциплины.
--▷ тип данных nvarchar(100)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--▷ Должно быть уникальным.
create table Subjects
(
	Id int not null primary key identity(1,1),
	Name nvarchar(100) not null check(Name <> '') unique
)

--9. Преподаватели (Teachers)
--■ Идентификатор (Id). Уникальный идентификатор преподавателя.
--▷ тип данных int
--▷ Авто приращение.
--▷ Не может содержать null-значения.
--▷ Первичный ключ.
--■ Имя (Name). Имя преподавателя.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
--■ Ставка (Salary). Ставка преподавателя.
--▷ тип данных money
--▷ Не может содержать null-значения.
--▷ Не может быть меньше либо равно 0.
--■ Фамилия (Surname). Фамилия преподавателя.
--▷ тип данных nvarchar(max)
--▷ Не может содержать null-значения.
--▷ Не может быть пустым.
create table Teachers
(
	Id int not null primary key identity(1,1),
	Name nvarchar(max) not null check(Name <> ''),
	Salary money not null check(Salary>=0),
	Surname nvarchar(max) not null check(Surname <> '')
)
