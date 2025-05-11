
USE master;
GO
DROP DATABASE IF EXISTS MovieRecommendation;
GO
CREATE DATABASE MovieRecommendation;
GO
USE MovieRecommendation;
GO

-- Таблица узлов: User
CREATE TABLE [User]
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    age INT
) AS NODE;

-- Таблица узлов: Movie
CREATE TABLE Movie
(
    id INT NOT NULL PRIMARY KEY,
    title NVARCHAR(100) NOT NULL,
    release_year INT
) AS NODE;

-- Таблица узлов: Genre
CREATE TABLE Genre
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;

-- Таблица узлов: Actor
CREATE TABLE Actor
(
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;




-- Таблица рёбер: Likes (Пользователь оценивает фильм)
CREATE TABLE Likes
(
    rating INT NOT NULL
) AS EDGE;

-- Таблица рёбер: BelongsToGenre (Фильм относится к жанру)
CREATE TABLE BelongsToGenre AS EDGE;

-- Таблица рёбер: ActedIn (Актёр снимался в фильме)
CREATE TABLE ActedIn AS EDGE;

-- Таблица рёбер: Knows (Пользователь знает другого пользователя)
CREATE TABLE Knows AS EDGE;

-- Добавление ограничений рёбер
ALTER TABLE Likes
ADD CONSTRAINT EC_Likes CONNECTION ([User] TO Movie);

ALTER TABLE BelongsToGenre
ADD CONSTRAINT EC_BelongsToGenre CONNECTION (Movie TO Genre);

ALTER TABLE ActedIn
ADD CONSTRAINT EC_ActedIn CONNECTION (Actor TO Movie);

ALTER TABLE Knows
ADD CONSTRAINT EC_Knows CONNECTION ([User] TO [User]);
GO


-- Заполнение таблицы User
INSERT INTO [User] (id, name, age)
VALUES
    (1, N'Alice', 25),
    (2, N'Bob', 30),
    (3, N'Charlie', 22),
    (4, N'Diana', 28),
    (5, N'Ethan', 35),
    (6, N'Fiona', 27),
    (7, N'George', 29),
    (8, N'Hannah', 24),
    (9, N'Ian', 32),
    (10, N'Julia', 26);

-- Заполнение таблицы Movie
INSERT INTO Movie (id, title, release_year)
VALUES
    (1, N'The Matrix', 1999),
    (2, N'Inception', 2010),
    (3, N'The Shawshank Redemption', 1994),
    (4, N'Pulp Fiction', 1994),
    (5, N'The Dark Knight', 2008),
    (6, N'Forrest Gump', 1994),
    (7, N'Fight Club', 1999),
    (8, N'Snatch', 2000),
    (9, N'Shrek', 2001),
    (10, N'The Big Short', 2015);

-- Заполнение таблицы Genre
INSERT INTO Genre (id, name)
VALUES
    (1, N'Action'),
    (2, N'Sci-Fi'),
    (3, N'Drama'),
    (4, N'Thriller'),
    (5, N'Crime'),
    (6, N'Comedy'),
    (7, N'Romance'),
    (8, N'Superhero'),
    (9, N'Mystery'),
    (10, N'Adventure');

-- Заполнение таблицы Actor
INSERT INTO Actor (id, name)
VALUES
    (1, N'Keanu Reeves'),
    (2, N'Leonardo DiCaprio'),
    (3, N'Morgan Freeman'),
    (4, N'John Travolta'),
    (5, N'Christian Bale'),
    (6, N'Tom Hanks'),
    (7, N'Brad Pitt'),
    (8, N'Mike Myers'),
    (9, N'Jason Statham'),
    (10, N'Ryan Gosling');
GO




-- Заполнение таблицы Likes
INSERT INTO Likes ($from_id, $to_id, rating)
VALUES
    ((SELECT $node_id FROM [User] WHERE id = 1), (SELECT $node_id FROM Movie WHERE id = 1), 8),
    ((SELECT $node_id FROM [User] WHERE id = 1), (SELECT $node_id FROM Movie WHERE id = 2), 9),
    ((SELECT $node_id FROM [User] WHERE id = 2), (SELECT $node_id FROM Movie WHERE id = 3), 10),
    ((SELECT $node_id FROM [User] WHERE id = 2), (SELECT $node_id FROM Movie WHERE id = 4), 7),
    ((SELECT $node_id FROM [User] WHERE id = 3), (SELECT $node_id FROM Movie WHERE id = 5), 9),
    ((SELECT $node_id FROM [User] WHERE id = 4), (SELECT $node_id FROM Movie WHERE id = 6), 8),
    ((SELECT $node_id FROM [User] WHERE id = 5), (SELECT $node_id FROM Movie WHERE id = 7), 10),
    ((SELECT $node_id FROM [User] WHERE id = 6), (SELECT $node_id FROM Movie WHERE id = 8), 9),
    ((SELECT $node_id FROM [User] WHERE id = 7), (SELECT $node_id FROM Movie WHERE id = 9), 8),
    ((SELECT $node_id FROM [User] WHERE id = 8), (SELECT $node_id FROM Movie WHERE id = 10), 9),
    ((SELECT $node_id FROM [User] WHERE id = 2), (SELECT $node_id FROM Movie WHERE id = 1), 8), 
    ((SELECT $node_id FROM [User] WHERE id = 3), (SELECT $node_id FROM Movie WHERE id = 1), 9);


-- Заполнение таблицы BelongsToGenre
INSERT INTO BelongsToGenre ($from_id, $to_id)
VALUES
    ((SELECT $node_id FROM Movie WHERE id = 1), (SELECT $node_id FROM Genre WHERE id = 2)), -- The Matrix ? Sci-Fi
    ((SELECT $node_id FROM Movie WHERE id = 2), (SELECT $node_id FROM Genre WHERE id = 2)), -- Inception ? Sci-Fi
    ((SELECT $node_id FROM Movie WHERE id = 3), (SELECT $node_id FROM Genre WHERE id = 3)), -- The Shawshank Redemption ? Drama
    ((SELECT $node_id FROM Movie WHERE id = 4), (SELECT $node_id FROM Genre WHERE id = 5)), -- Pulp Fiction ? Crime
    ((SELECT $node_id FROM Movie WHERE id = 5), (SELECT $node_id FROM Genre WHERE id = 8)), -- The Dark Knight ? Superhero
    ((SELECT $node_id FROM Movie WHERE id = 6), (SELECT $node_id FROM Genre WHERE id = 7)), -- Forrest Gump ? Romance 
    ((SELECT $node_id FROM Movie WHERE id = 7), (SELECT $node_id FROM Genre WHERE id = 4)), -- Fight Club ? Thriller
    ((SELECT $node_id FROM Movie WHERE id = 8), (SELECT $node_id FROM Genre WHERE id = 5)), -- Snatch ? Crime
    ((SELECT $node_id FROM Movie WHERE id = 9), (SELECT $node_id FROM Genre WHERE id = 6)), -- Shrek ? Adventure
	((SELECT $node_id FROM Movie WHERE id = 9), (SELECT $node_id FROM Genre WHERE id = 6)), -- Shrek ? Comedy
    ((SELECT $node_id FROM Movie WHERE id = 10), (SELECT $node_id FROM Genre WHERE id = 3)); -- The Big Short ? Drama

-- Заполнение таблицы ActedIn
INSERT INTO ActedIn ($from_id, $to_id)
VALUES
    ((SELECT $node_id FROM Actor WHERE id = 1), (SELECT $node_id FROM Movie WHERE id = 1)),
    ((SELECT $node_id FROM Actor WHERE id = 2), (SELECT $node_id FROM Movie WHERE id = 2)),
    ((SELECT $node_id FROM Actor WHERE id = 3), (SELECT $node_id FROM Movie WHERE id = 3)),
    ((SELECT $node_id FROM Actor WHERE id = 4), (SELECT $node_id FROM Movie WHERE id = 4)),
    ((SELECT $node_id FROM Actor WHERE id = 5), (SELECT $node_id FROM Movie WHERE id = 5)),
	((SELECT $node_id FROM Actor WHERE id = 5), (SELECT $node_id FROM Movie WHERE id = 10)),
    ((SELECT $node_id FROM Actor WHERE id = 6), (SELECT $node_id FROM Movie WHERE id = 6)),
    ((SELECT $node_id FROM Actor WHERE id = 7), (SELECT $node_id FROM Movie WHERE id = 7)),
	((SELECT $node_id FROM Actor WHERE id = 7), (SELECT $node_id FROM Movie WHERE id = 8)),
	((SELECT $node_id FROM Actor WHERE id = 7), (SELECT $node_id FROM Movie WHERE id = 10)),
    ((SELECT $node_id FROM Actor WHERE id = 8), (SELECT $node_id FROM Movie WHERE id = 9)),
    ((SELECT $node_id FROM Actor WHERE id = 9), (SELECT $node_id FROM Movie WHERE id = 8)),
    ((SELECT $node_id FROM Actor WHERE id = 10), (SELECT $node_id FROM Movie WHERE id = 10));

-- Заполнение таблицы Knows
INSERT INTO Knows ($from_id, $to_id)
VALUES
    ((SELECT $node_id FROM [User] WHERE id = 1), (SELECT $node_id FROM [User] WHERE id = 2)),
    ((SELECT $node_id FROM [User] WHERE id = 1), (SELECT $node_id FROM [User] WHERE id = 3)),
    ((SELECT $node_id FROM [User] WHERE id = 2), (SELECT $node_id FROM [User] WHERE id = 4)),
    ((SELECT $node_id FROM [User] WHERE id = 3), (SELECT $node_id FROM [User] WHERE id = 5)),
    ((SELECT $node_id FROM [User] WHERE id = 4), (SELECT $node_id FROM [User] WHERE id = 6)),
    ((SELECT $node_id FROM [User] WHERE id = 5), (SELECT $node_id FROM [User] WHERE id = 7)),
    ((SELECT $node_id FROM [User] WHERE id = 6), (SELECT $node_id FROM [User] WHERE id = 8)),
    ((SELECT $node_id FROM [User] WHERE id = 7), (SELECT $node_id FROM [User] WHERE id = 9)),
    ((SELECT $node_id FROM [User] WHERE id = 8), (SELECT $node_id FROM [User] WHERE id = 10)),
    ((SELECT $node_id FROM [User] WHERE id = 9), (SELECT $node_id FROM [User] WHERE id = 1)),
  ((SELECT $node_id FROM [User] WHERE id = 2), (SELECT $node_id FROM [User] WHERE id = 3)), -- Bob ? Charlie
    ((SELECT $node_id FROM [User] WHERE id = 1), (SELECT $node_id FROM [User] WHERE id = 4));
GO



-- Запрос 1: Какие фильмы понравились пользователю Alice?
SELECT m.title, l.rating
FROM [User] u, Likes l, Movie m
WHERE MATCH(u-(l)->m)
AND u.name = N'Alice';

-- Запрос 2: Какие жанры нравятся друзьям Bob?
SELECT DISTINCT g.name
FROM [User] u, Knows k, [User] friend, Likes l, Movie m, BelongsToGenre btg, Genre g
WHERE MATCH(u-(k)->friend-(l)->m-(btg)->g)
AND u.name = N'Bob';

-- Запрос 3: Какие актёры снимались в фильмах, которые нравятся Charlie?
SELECT DISTINCT a.name
FROM [User] u, Likes l, Movie m, ActedIn ai, Actor a
WHERE MATCH(u-(l)->m<-(ai)-a)
AND u.name = N'Charlie';


-- Запрос 4: Какие фильмы в жанре 'Sci-Fi' нравятся пользователям?
SELECT DISTINCT m.title, u.name, l.rating
FROM [User] u, Likes l, Movie m, BelongsToGenre btg, Genre g
WHERE MATCH(u-(l)->m-(btg)->g)
AND g.name = N'Sci-Fi';

-- Запрос 5: Кто из друзей Alice оценил фильмы с актёром Keanu Reeves?
SELECT DISTINCT friend.name
FROM [User] u, Knows k, [User] friend, Likes l, Movie m, ActedIn ai, Actor a
WHERE MATCH(u-(k)->friend-(l)->m<-(ai)-a)
AND u.name = N'Alice'
AND a.name = N'Keanu Reeves';



-- Запрос 1: Найти кратчайший путь знакомства от Alice до всех пользователей (шаблон +)
SELECT u1.name AS start_user, STRING_AGG(u2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS path
FROM [User] AS u1, Knows FOR PATH AS k, [User] FOR PATH AS u2
WHERE MATCH(SHORTEST_PATH(u1(-(k)->u2)+))
    AND u1.name = N'Alice';


-- Запрос 2: Найти кратчайший путь знакомства от Bob до Ethan с максимум 3 шагами (шаблон {1,3})
DECLARE @start_user NVARCHAR(50) = N'Bob';
DECLARE @end_user NVARCHAR(50) = N'Ethan';
WITH T AS (
    SELECT u1.name AS start_user, STRING_AGG(u2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS path, LAST_VALUE(u2.name) WITHIN GROUP (GRAPH PATH) AS last_user
    FROM [User] AS u1, Knows FOR PATH AS k, [User] FOR PATH AS u2
    WHERE MATCH(SHORTEST_PATH(u1(-(k)->u2){1,3}))
        AND u1.name = @start_user
)
SELECT start_user, path
FROM T
WHERE last_user = @end_user;
GO



select @@SERVERNAME