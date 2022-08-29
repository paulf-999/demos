CREATE TABLE animals (
    id MEDIUMINT NOT NULL AUTO_INCREMENT,
    animal_name CHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO animals (animal_name) VALUES
('dog'), ('cat'), ('penguin'),
('lax'), ('whale'), ('ostrich');
