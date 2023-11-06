USE sakila;

SHOW TABLES;

#step1
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer AS c
JOIN 
    rental AS r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id;


#step2
CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM 
    customer_rental_summary AS crs
JOIN 
    payment AS p ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id;


#step3
WITH customer_summary AS (
SELECT 
    crs.name,
    crs.email,
    crs.rental_count,
    cps.total_paid,
    (cps.total_paid / crs.rental_count) AS average_payment_per_rental
FROM 
    customer_rental_summary AS crs
JOIN 
    customer_payment_summary AS cps ON crs.customer_id = cps.customer_id
)
SELECT 
    name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM 
    customer_summary;
