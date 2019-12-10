3) SELECT cd.id, cd.series_id, cd.name, cd.price
FROM firms INNER JOIN (series INNER JOIN cd ON series.id = cd.series_id) ON firms.id = series.firm_id
ORDER BY firms.name, cd.name;

4) SELECT DISTINCT firms.name
FROM firms INNER JOIN (series INNER JOIN cd ON series.id = cd.series_id) ON firms.id = series.firm_id;

5) SELECT performers.id, performers.name
FROM performers INNER JOIN albums ON performers.id = albums.performer_id
WHERE albums.name = 'Фигаро'
ORDER BY performers.name;

6) SELECT DISTINCT performers.id, performers.name
FROM performers INNER JOIN albums ON performers.id = albums.performer_id
WHERE albums.name = any 
(Select albums.name from albums 
where albums.name in ('Фигаро', 'Риголетто', 'Альфио', 'Скар-пиа', 'Дон Жуан'));

7) SELECT *
FROM tracks
WHERE tracks.name like '*amore*'
and tracks.name like '*core*'
and tracks.duration > '00:05:00'; - ХЗ, ВЕРНО ЛИ

8) SELECT albums.name, tracks.id, tracks.name
FROM cd, albums INNER JOIN tracks ON albums.id = tracks.album_id;

9) SELECT first.performer_id, second.performer_id
FROM albums AS [first], albums AS [second]
WHERE first.id = second.id and first.performer_id > second.performer_id;

11)SELECT cd.name, count(track_id)
FROM cd INNER JOIN tracks_on_cd ON cd.id = tracks_on_cd.cd_id
GROUP BY cd.name;

12)
SELECT main_perf.name FROM
          performers main_perf,
          (SELECT performers.id as id, COUNT(*) AS cd_num FROM
                        (SELECT DISTINCT toc.cd_id AS CDID, performers.id FROM
                        ((performers INNER JOIN albums ON albums.performer_id = performers.id)
                        INNER JOIN tracks ON tracks.album_id = albums.id)
                        INNER JOIN tracks_on_cd AS toc ON toc.track_id = tracks.id)
          GROUP BY performers.id)
WHERE main_perf.id = id AND cd_num >= ALL (
                  SELECT COUNT(*) AS cd_num FROM
                        (SELECT DISTINCT toc.cd_id AS CDID, performers.id FROM
                        ((performers INNER JOIN albums ON albums.performer_id = performers.id)
                        INNER JOIN tracks ON tracks.album_id = albums.id)
                        INNER JOIN tracks_on_cd AS toc ON toc.track_id = tracks.id)
                  GROUP BY performers.id
)

13)
SELECT avg(price) as avg_price
FROM cd
WHERE id IN (
              SELECT cd_id FROM tracks_on_cd toc1
              GROUP BY toc1.cd_id HAVING count(*) >= ALL (
                            SELECT count(*) FROM tracks_on_cd toc2
                            GROUP BY toc2.cd_id
               )
);

14)
SELECT artists.name, role, COUNT(*) as times 
FROM roles INNER JOIN artists ON artists.id = roles.artist_id
WHERE artist_id IN (
              SELECT r.artist_id FROM roles r
              GROUP BY r.artist_id, r.role HAVING COUNT(*) <= ALL (
                          SELECT COUNT(*) FROM roles r1
                          WHERE r1.role = r.role
              )
)
GROUP BY artists.name, role

15) INSERT INTO albums
VALUES ('12', '14', 'something');

16) DELETE *
FROM albums
WHERE albums.id = 12;

