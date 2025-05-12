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
	position NVARCHAR(60) NOT NULL -- должность сотрудника в компании
) AS EDGE;
GO

CREATE TABLE Develop
(
	budget DECIMAL(19,4) -- бюджет на разработку игры
) AS EDGE;
GO

CREATE TABLE Play AS EDGE;
GO

ALTER TABLE WorkIn ADD CONSTRAINT EC_WorkIn CONNECTION (GameDeveloper TO GameStudio);
ALTER TABLE Develop ADD CONSTRAINT EC_Develop CONNECTION (GameStudio TO Game);
ALTER TABLE Play ADD CONSTRAINT EC_Play CONNECTION (GameDeveloper TO Game);
GO

INSERT INTO GameDeveloper (id, name)
VALUES (1, N'Станислав'),
	   (2, N'Екатерина'),
	   (3, N'Олег'),
	   (4, N'Ольга'),
	   (5, N'Егор'),
	   (6, N'София'),
	   (7, N'Владимир'),
	   (8, N'Мария'),
	   (9, N'Александр'),
	   (10, N'Наталья')
GO

INSERT INTO GameStudio (id, name, address)
VALUES (1, N'Gamers Life', N'г.Минск, ул.Интернациональная, д.12'),
	   (2, N'Lesta games', N'г.Минск, ул.Бородинская, д.34'),
	   (3, N'WarGaming', N'г.Минск, ул.Высокая, д.5'),
	   (4, N'Press Fire Games', N'г.Минск, ул.Петруся Бровки, д.17'),
	   (5, N'OpenMyGame', N'г.Гомель, ул.Гагарина, д.20'),
	   (6, N'id Software', N'г.Брест, ул.Ленина, д.8'),
	   (7, N'Yacht Club', N'г.Могилев, ул.Переулочная, д.31'),
	   (8, N'Mike Klubnika inc.', N'г.Минск, ул.Железнодорожников, д.1'),
	   (9, N'404Games', N'г.Полоцк, ул.Восточная, д.13'),
	   (10, N'Respawn', N'г.Жодино, ул.Речная, д.72')
GO

INSERT INTO Game (id, name, genre, price)
VALUES (1, N'World Of Taks', N'историческая', 3.99),
	   (2, N'Control Strike', N'шутер', NULL),
	   (3, N'Katana First', N'платформер', 14.99),
	   (4, N'Metro: Exondus', N'сюжетная', 30.0),
	   (5, N'WordPlay', N'головоломка', NULL),
	   (6, N'Cyberprank', N'симулятор', 34.49),
	   (7, N'Asseto Corsta', N'гонки', 12.49),
	   (8, N'Biosok', N'сюжетная', 33.99),
	   (9, N'Firewatcher', N'сюжетная', 25.99),
	   (10, N'Anex Legends', N'шутер', 59.99),
	   (11, N'Hello Knight', N'метроидвания', 6.99)
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


-- Запрос №1 
-- В какие игры играет Егор?
SELECT Game.name
FROM GameDeveloper 
	, Play
	, Game
WHERE MATCH(GameDeveloper-(Play)->Game) AND GameDeveloper.name = N'Егор';
GO

-- Запрос №2
-- Какие игры разработала студия, в которой работает Мария?
SELECT Game.name
FROM GameDeveloper
	, WorkIn
	, GameStudio
	, Develop
	, Game
WHERE MATCH(GameDeveloper-(WorkIn)->GameStudio-(Develop)->Game) AND GameDeveloper.name = N'Мария'

-- Запрос №3
-- Кто занимает в своей студии позицию программиста?
SELECT GD.name
FROM GameDeveloper AS GD
	, WorkIn
	, GameStudio AS GS
WHERE MATCH(GD-(WorkIn)->GS) AND WorkIn.position = 'Programmer'

-- Запрос №4
-- Какие позиции занимают люди, играющие в World Of Taks?
SELECT W.position, GameDeveloper.name
FROM GameDeveloper
	, Play
	, Game
	, GameStudio AS GS
	, WorkIn AS W
WHERE MATCH(GameDeveloper-(W)->GS AND GameDeveloper-(Play)->Game) AND Game.name = 'World Of Taks'

-- Запрос №5
-- Кто играет в игры студии, в которой они работают?
SELECT GD.name AS person, GS.name AS gameStudio, WorkIn.position AS position
FROM GameDeveloper AS GD
	, Game AS G
	, Play
	, WorkIn
	, GameStudio AS GS
	, Develop
WHERE MATCH(GD-(Play)->G AND GD-(WorkIn)->GS-(Develop)->G)



-- В какие игры играет Екатерина, обойдя свои игры не более чем на 2 шага?
SELECT GD.name
	  , STRING_AGG(Game.name, '->') WITHIN GROUP (GRAPH PATH) AS GamePath
FROM GameDeveloper AS GD
	, Play FOR PATH
	, Game FOR PATH
WHERE MATCH(SHORTEST_PATH(GD(-(Play)->Game){1,2})) AND GD.name = N'Екатерина';


-- Все игры в которые играет Станислав
SELECT GD.name
	  , STRING_AGG(Game.name, '->') WITHIN GROUP (GRAPH PATH) AS GamePath
FROM  GameDeveloper AS GD
	, Play FOR PATH 
	, Game FOR PATH
WHERE MATCH(SHORTEST_PATH(GD(-(Play)->Game)+)) AND GD.name = N'Станислав';