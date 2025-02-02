CREATE IF NOT EXISTS PE2BookTrackingSystem;

USE PE2BookTrackingSystem;

CREATE TABLE IF NOT EXISTS Book(
    title VARCHAR(50),
    isbn13Number CHAR(13),
    author VARCHAR(255),
    numberofPages INT,
    releaseDate DATE,

    CONSTRAINT pk_isbn PRIMARY KEY(isbn13Number)
);

SELECT *
FROM Book;
