-- SQL queries used

-- Create database and tables in pgAdmin from CSV file (split in two per project instructions)
CREATE DATABASE web_page_phishing;

CREATE TABLE web_page_fishing (
    id SERIAL PRIMARY KEY,
    url_length INTEGER,
    n_redirection INTEGER,
    phishing INTEGER
);

COPY web_page_fishing (url_length, n_redirection, phishing)
FROM 'C:\\temp\\web-page-phishing-table1.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE phishing_dataset (
	phishing_id SERIAL PRIMARY KEY,
	n_dots INTEGER,
	n_hyphens INTEGER,
	n_underline INTEGER,
	n_slash INTEGER,
	n_questionmark INTEGER,
	n_equal INTEGER,
	n_at INTEGER,
	n_and INTEGER,
	n_exclamation INTEGER,
	n_space INTEGER,
	n_tilde INTEGER,
	n_comma INTEGER,
	n_plus INTEGER,
	n_asterisk INTEGER,
	n_hashtag INTEGER,
	n_dollar INTEGER,
	n_percent INTEGER
);

COPY phishing_dataset (n_dots, n_hyphens, n_underline, n_slash, n_questionmark, n_equal, n_at, n_and, n_exclamation, n_space, n_tilde, n_comma, n_plus, n_asterisk, n_hashtag, n_dollar, n_percent)
FROM 'C:\\temp\\web-page-phishing-table2.csv'
DELIMITER ','
CSV HEADER;

-- Exploratory data analysis
SELECT MIN(url_length), MAX(url_length), AVG(url_length) FROM web_page_fishing;
-- Result: 4, 4165, 39.1

SELECT COUNT(*) FROM web_page_fishing AS COUNT
WHERE phishing = 1 
-- Result: 36362

SELECT COUNT(*) FROM web_page_fishing AS COUNT
WHERE phishing = 1 AND url_length >= 100;
-- Result: 5555

SELECT COUNT(*) FROM web_page_fishing AS COUNT
WHERE phishing = 0 AND url_length >= 100;
-- Result: 472

SELECT COUNT(*) FROM web_page_fishing AS count
WHERE phishing = 1 AND n_redirection = 1;
-- 7858

SELECT COUNT(*) FROM web_page_fishing AS count
WHERE phishing = 0 AND n_redirection = 1;
-- 19798

--Create combined view to cull data
CREATE VIEW combined_phishing AS
SELECT *
FROM web_page_fishing
INNER JOIN phishing_dataset
ON web_page_fishing.id = phishing_dataset.phishing_id;

--count the number of occurrences of special characters in both the phishing and non-phishing records
SELECT 
    SUM(CASE WHEN n_dots = 1 THEN 1 ELSE 0 END) AS count_n_dots,
    SUM(CASE WHEN n_hyphens = 1 THEN 1 ELSE 0 END) AS count_n_hyphens,
    SUM(CASE WHEN n_underline = 1 THEN 1 ELSE 0 END) AS count_n_underline,
    SUM(CASE WHEN n_slash = 1 THEN 1 ELSE 0 END) AS count_n_slash,
    SUM(CASE WHEN n_questionmark = 1 THEN 1 ELSE 0 END) AS count_n_questionmark,
    SUM(CASE WHEN n_equal = 1 THEN 1 ELSE 0 END) AS count_n_equal,
    SUM(CASE WHEN n_at = 1 THEN 1 ELSE 0 END) AS count_n_at,
    SUM(CASE WHEN n_and = 1 THEN 1 ELSE 0 END) AS count_n_and,
    SUM(CASE WHEN n_exclamation = 1 THEN 1 ELSE 0 END) AS count_n_exclamation,
    SUM(CASE WHEN n_space = 1 THEN 1 ELSE 0 END) AS count_n_space,
    SUM(CASE WHEN n_tilde = 1 THEN 1 ELSE 0 END) AS count_n_tilde,
    SUM(CASE WHEN n_comma = 1 THEN 1 ELSE 0 END) AS count_n_comma,
    SUM(CASE WHEN n_plus = 1 THEN 1 ELSE 0 END) AS count_n_plus,
    SUM(CASE WHEN n_asterisk = 1 THEN 1 ELSE 0 END) AS count_n_asterisk,
    SUM(CASE WHEN n_hashtag = 1 THEN 1 ELSE 0 END) AS count_n_hashtag,
    SUM(CASE WHEN n_dollar = 1 THEN 1 ELSE 0 END) AS count_n_dollar,
    SUM(CASE WHEN n_percent = 1 THEN 1 ELSE 0 END) AS count_n_percent
FROM combined_phishing
WHERE phishing = 1;

--count combinations of characters (alter as needed for the different chars):
SELECT 
    (SELECT COUNT(*) 
     FROM combined_phishing 
      WHERE phishing = 1 AND n_questionmark = 1 AND n_hyphens = 1) AS num_phishing,
	  
(SELECT COUNT(*) 
     FROM combined_phishing 
      WHERE phishing = 0 AND n_questionmark = 1 AND n_hyphens = 1) AS num_non_phishing;


