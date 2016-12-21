CREATE TABLE comments (
  id INTEGER PRIMARY KEY,
  body VARCHAR(255) NOT NULL,
  post_id INTEGER,

  FOREIGN KEY(post_id) REFERENCES post(id)
);

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  user_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES user(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL
);

INSERT INTO
  users (id, username)
VALUES
  (1, "wesrobinson12"), (2, "ivyloren");

INSERT INTO
  posts (id, title, user_id)
VALUES
  (1, "How to become a programmer in 10 easy steps!", 1),
  (2, "Life of an App Academy Student", 1),
  (3, "Pizza heals everything", 2),
  (4, "Cuddling with puppies 101", 2);

INSERT INTO
  comments (id, body, post_id)
VALUES
  (1, "u r a terrible coder", 1),
  (2, "Wow, your life is awful!", 2),
  (3, "bless up", 3),
  (4, "I am one with the universe", 3),
  (5, "took this course in college, learned a lot", 4);
