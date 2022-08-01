CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(1024) NOT NULL,
    UNIQUE(name)
);

CREATE TABLE quotes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    author_id int,
    quote VARCHAR(1024) NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);
