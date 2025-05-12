USE master;
GO

IF EXISTS (SELECT 1 FROM sys.sysdatabases WHERE name='GamingInterests')
    BEGIN
        ALTER DATABASE [GamingInterests] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE [GamingInterests];
    END
GO

CREATE DATABASE GamingInterests;
GO

USE GamingInterests;
GO

CREATE TABLE GameDeveloper
(
	id INT NOT NULL PRIMARY KEY,
	name NVARCHAR(50) NOT NULL
) AS NODE;
GO

CREATE TABLE GameStudio
(
	id INT NOT NULL PRIMARY KEY,
	name NVARCHAR(30) NOT NULL,
	address NVARCHAR(70) NOT NULL
) AS NODE;
GO

CREATE TABLE Game
(
	id INT NOT NULL PRIMARY KEY,
	name NVARCHAR(50) NOT NULL,
	genre NVARCHAR(20) NOT NULL,
	price DECIMAL(19,4) NULL
) AS NODE;
GO

CREATE TABLE WorkIn 
(
	position NVARCHAR(60) NOT NULL -- ��������� ���������� � ��������
) AS EDGE;
GO

CREATE TABLE Develop
(
	budget DECIMAL(19,4) -- ������ �� ���������� ����
) AS EDGE;
GO

CREATE TABLE Play AS EDGE;
GO

ALTER TABLE WorkIn ADD CONSTRAINT EC_WorkIn CONNECTION (GameDeveloper TO GameStudio);
ALTER TABLE Develop ADD CONSTRAINT EC_Develop CONNECTION (GameStudio TO Game);
ALTER TABLE Play ADD CONSTRAINT EC_Play CONNECTION (GameDeveloper TO Game);
GO

INSERT INTO GameDeveloper (id, name)
VALUES (1, N'���������'),
	   (2, N'���������'),
	   (3, N'����'),
	   (4, N'�����'),
	   (5, N'����'),
	   (6, N'�����'),
	   (7, N'��������'),
	   (8, N'�����'),
	   (9, N'���������'),
	   (10, N'�������')
GO

INSERT INTO GameStudio (id, name, address)
VALUES (1, N'Gamers Life', N'�.�����, ��.�����������������, �.12'),
	   (2, N'Lesta games', N'�.�����, ��.�����������, �.34'),
	   (3, N'WarGaming', N'�.�����, ��.�������, �.5'),
	   (4, N'Press Fire Games', N'�.�����, ��.������� ������, �.17'),
	   (5, N'OpenMyGame', N'�.������, ��.��������, �.20'),
	   (6, N'id Software', N'�.�����, ��.������, �.8'),
	   (7, N'Yacht Club', N'�.�������, ��.�����������, �.31'),
	   (8, N'Mike Klubnika inc.', N'�.�����, ��.�����������������, �.1'),
	   (9, N'404Games', N'�.������, ��.���������, �.13'),
	   (10, N'Respawn', N'�.������, ��.������, �.72')
GO

INSERT INTO Game (id, name, genre, price)
VALUES (1, N'World Of Taks', N'������������', 3.99),
	   (2, N'Control Strike', N'�����', NULL),
	   (3, N'Katana First', N'����������', 14.99),
	   (4, N'Metro: Exondus', N'��������', 30.0),
	   (5, N'WordPlay', N'�����������', NULL),
	   (6, N'Cyberprank', N'���������', 34.49),
	   (7, N'Asseto Corsta', N'�����', 12.49),
	   (8, N'Biosok', N'��������', 33.99),
	   (9, N'Firewatcher', N'��������', 25.99),
	   (10, N'Anex Legends', N'�����', 59.99),
	   (11, N'Hello Knight', N'������������', 6.99)
GO

INSERT INTO WorkIn ($from_id, $to_id, position)
VALUES ((SELECT $node_id FROM GameDeveloper WHERE id = 1), (SELECT $node_id FROM GameStudio WHERE id = 3) , N'UX Designer'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 2), (SELECT $node_id FROM GameStudio WHERE id = 7) , N'Programmer'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 3), (SELECT $node_id FROM GameStudio WHERE id = 2) , N'Promoter'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 3), (SELECT $node_id FROM GameStudio WHERE id = 10) , N'Trainee'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 4), (SELECT $node_id FROM GameStudio WHERE id = 10) , N'UI Designer'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM GameStudio WHERE id = 8) , N'Programmer'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 5), (SELECT $node_id FROM GameStudio WHERE id = 4) , N'UX Designer'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 10), (SELECT $node_id FROM GameStudio WHERE id = 9) , N'Art Director'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 9), (SELECT $node_id FROM GameStudio WHERE id = 5) , N'Trainee'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 6), (SELECT $node_id FROM GameStudio WHERE id = 6) , N'Promoter'),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 7), (SELECT $node_id FROM GameStudio WHERE id = 1) , N'UX Designer')
GO 

INSERT INTO Develop ($from_id, $to_id, budget)
VALUES ((SELECT $node_id FROM GameStudio WHERE id = 3), (SELECT $node_id FROM Game WHERE id = 1) , 1000000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 4), (SELECT $node_id FROM Game WHERE id = 5) , 780000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 5), (SELECT $node_id FROM Game WHERE id = 7) , 540000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 3) , 125000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 11) , 78500),
	   ((SELECT $node_id FROM GameStudio WHERE id = 1), (SELECT $node_id FROM Game WHERE id = 8) , 889000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 9), (SELECT $node_id FROM Game WHERE id = 2) , 2000000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 10), (SELECT $node_id FROM Game WHERE id = 10) , 670000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 2), (SELECT $node_id FROM Game WHERE id = 6) , 3000000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 7), (SELECT $node_id FROM Game WHERE id = 4) , 550000),
	   ((SELECT $node_id FROM GameStudio WHERE id = 6), (SELECT $node_id FROM Game WHERE id = 9) , 79000)
GO

INSERT INTO Play ($from_id, $to_id)
VALUES ((SELECT $node_id FROM GameDeveloper WHERE id = 1), (SELECT $node_id FROM Game WHERE id = 1)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 1), (SELECT $node_id FROM Game WHERE id = 6)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 2), (SELECT $node_id FROM Game WHERE id = 2)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 2), (SELECT $node_id FROM Game WHERE id = 3)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 2), (SELECT $node_id FROM Game WHERE id = 9)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 2), (SELECT $node_id FROM Game WHERE id = 10)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 3), (SELECT $node_id FROM Game WHERE id = 1)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 3), (SELECT $node_id FROM Game WHERE id = 11)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 4), (SELECT $node_id FROM Game WHERE id = 7)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 5), (SELECT $node_id FROM Game WHERE id = 6)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 5), (SELECT $node_id FROM Game WHERE id = 8)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 5), (SELECT $node_id FROM Game WHERE id = 10)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 6), (SELECT $node_id FROM Game WHERE id = 5)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 6), (SELECT $node_id FROM Game WHERE id = 7)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 6), (SELECT $node_id FROM Game WHERE id = 11)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 7), (SELECT $node_id FROM Game WHERE id = 1)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 7), (SELECT $node_id FROM Game WHERE id = 5)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 7), (SELECT $node_id FROM Game WHERE id = 8)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 2)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 4)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 5)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 8)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 8), (SELECT $node_id FROM Game WHERE id = 9)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 9), (SELECT $node_id FROM Game WHERE id = 2)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 9), (SELECT $node_id FROM Game WHERE id = 4)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 9), (SELECT $node_id FROM Game WHERE id = 5)),
	   ((SELECT $node_id FROM GameDeveloper WHERE id = 10), (SELECT $node_id FROM Game WHERE id = 11))
GO


-- ������ �1 
-- � ����� ���� ������ ����?
SELECT Game.name
FROM GameDeveloper 
	, Play
	, Game
WHERE MATCH(GameDeveloper-(Play)->Game) AND GameDeveloper.name = N'����';
GO

-- ������ �2
-- ����� ���� ����������� ������, � ������� �������� �����?
SELECT Game.name
FROM GameDeveloper
	, WorkIn
	, GameStudio
	, Develop
	, Game
WHERE MATCH(GameDeveloper-(WorkIn)->GameStudio-(Develop)->Game) AND GameDeveloper.name = N'�����'

-- ������ �3
-- ��� �������� � ����� ������ ������� ������������?
SELECT GD.name
FROM GameDeveloper AS GD
	, WorkIn
	, GameStudio AS GS
WHERE MATCH(GD-(WorkIn)->GS) AND WorkIn.position = 'Programmer'

-- ������ �4
-- ����� ������� �������� ����, �������� � World Of Taks?
SELECT W.position, GameDeveloper.name
FROM GameDeveloper
	, Play
	, Game
	, GameStudio AS GS
	, WorkIn AS W
WHERE MATCH(GameDeveloper-(W)->GS AND GameDeveloper-(Play)->Game) AND Game.name = 'World Of Taks'

-- ������ �5
-- ��� ������ � ���� ������, � ������� ��� ��������?
SELECT GD.name AS person, GS.name AS gameStudio, WorkIn.position AS position
FROM GameDeveloper AS GD
	, Game AS G
	, Play
	, WorkIn
	, GameStudio AS GS
	, Develop
WHERE MATCH(GD-(Play)->G AND GD-(WorkIn)->GS-(Develop)->G)



-- � ����� ���� ������ ���������, ������ ���� ���� �� ����� ��� �� 2 ����?
SELECT GD.name
	  , STRING_AGG(Game.name, '->') WITHIN GROUP (GRAPH PATH) AS GamePath
FROM GameDeveloper AS GD
	, Play FOR PATH
	, Game FOR PATH
WHERE MATCH(SHORTEST_PATH(GD(-(Play)->Game){1,2})) AND GD.name = N'���������';


-- ��� ���� � ������� ������ ���������
SELECT GD.name
	  , STRING_AGG(Game.name, '->') WITHIN GROUP (GRAPH PATH) AS GamePath
FROM  GameDeveloper AS GD
	, Play FOR PATH 
	, Game FOR PATH
WHERE MATCH(SHORTEST_PATH(GD(-(Play)->Game)+)) AND GD.name = N'���������';