# Interrogations avancées

#1 Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettre et le résultat doit s’afficher dans une seul colonne
SELECT CONCAT(rental_date, MONTHNAME(rental_date)) FROM rental WHERE year(rental_date)=2006;

#2 Afficher la colonne qui donne la durée de location des films en jour
SELECT *, datediff(return_date, rental_date) as duree_location FROM rental;

#3 Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un format lisible
SELECT * FROM rental WHERE hour(rental_date) < 1 AND year(rental_date)=2005;

#4 Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent
SELECT rental_date FROM rental WHERE month(rental_date) BETWEEN 4 AND 5 ORDER BY rental_date ASC;

#5 Lister les film dont le nom ne commence pas par le « Le »
SELECT title FROM film WHERE title NOT LIKE "LE%";
SELECT title FROM film WHERE LEFT (title,2) <> 'Le';

#6 Lister les films ayant la mention « PG-13 » ou « NC-17 ». Ajouter une colonne qui affichera « oui » si « NC-17 » et « non » Sinon
SELECT rating, 
	CASE
		WHEN rating='PG-13' THEN 'OUI'
		ELSE 'NON'
	END
AS 'NC-17'
    FROM film 
    WHERE rating ='PG-13' OR rating='NC-17';

#7 Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT)
SELECT name FROM category WHERE name LIKE "A%" OR name like"C%";
SELECT *, name FROM category 
WHERE LEFT (name,1) IN ("A", "C");

#8 Lister les trois premiers caractères des noms des catégorie
SELECT LEFT(name,3) FROM category;

#9 Lister les premiers acteurs en remplaçant dans leur prenom les E par des A
SELECT *, replace(first_name, 'E', 'A') as modified_first_name
FROM actor
LIMIT 100;







# LES JOINTURES

#1 Lister les 10 premiers films ainsi que leur langues
SELECT title, name 
FROM film JOIN language 
ON film.language_id = language.language_id 
LIMIT 10;

#2 Afficher les film dans les quel à joué « JENNIFER DAVIS » sortie en "2006"
SELECT film.title, actor.first_name, actor.last_name, film.release_year 
FROM actor
JOIN film_actor
	ON actor.actor_id = film_actor.actor_id
JOIN film
	ON film.film_id = film_actor.film_id
WHERE (actor.last_name = 'DAVIS'
	AND actor.first_name = 'JENNIFER')
	AND film.release_year = 2006;

#3 Afficher le noms des client ayant emprunté « ALABAMA DEVIL »
SELECT c.last_name, c.first_name, title
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory  AS i ON r.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = f.film_id
WHERE f.title = 'Alabama Devil';

#4 Afficher les films louer par des personne habitant à « Woodridge ».Vérifié s’il y a des films qui n’ont jamais été emprunté
SELECT f.title
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN customer AS c ON r.customer_id = c.customer_id
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ci ON a.city_id = ci.city_id
WHERE city = 'Woodridge'

UNION 

SELECT f.title
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
 LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

#5 Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?
SELECT title,datediff(R.return_date,R.rental_date) 
FROM film AS F
JOIN inventory AS I ON F.film_id = I.film_id
JOIN rental AS R ON I.inventory_id = R.inventory_id
WHERE datediff(R.return_date,R.rental_date) IS NOT NULL
ORDER BY datediff(R.return_date,R.rental_date) 
LIMIT 10;

SELECT f.title,
TIMESTAMPDIFF(HOUR, UNIX_TIMESTAMP(re.rental_date), UNIX_TIMESTAMP(re.return_date)) AS Duree
FROM rental AS re
INNER JOIN inventory AS inv 
ON inv.inventory_ID=re.inventory_id 
INNER JOIN film AS f 
ON f.film_id=inv.film_id 
HAVING Duree IS NOT NULL 
ORDER BY Duree ASC 
LIMIT 10;

#6 Lister les films de la catégorie « Action » ordonnés par ordre alphabétique
select f.title, c.name from film as f
join film_category as fc on fc.film_id = f.film_id
join category as c on fc.category_id = c.category_id
where c.name = 'action'
ORDER BY f.title;

#7 Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?
SELECT film.title, datediff(return_date, rental_date)
FROM film
JOIN inventory
 ON film.film_id = inventory.film_id
JOIN rental
 ON inventory.inventory_id = rental.inventory_id
WHERE datediff(return_date, rental_date) <= 2
ORDER BY film.title;