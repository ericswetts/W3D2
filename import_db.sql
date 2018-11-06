PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_reference INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY (subject_question_reference) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  question_id INTEGER NOT NULL,
  liked INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Eric', 'Swetts'),
  ('Peter', 'Zeng'),
  ('Wanda', 'Sikes');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('sqlite3', 'What was wrong with the first two sqlites?', 1),
  ('recursion', 'When should we use recursion instead of iteration?',2),
  ('Chess', 'How do I get the cursor to move pieces about?', 3);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1,1),
  (2,2),
  (3,3),
  (1,2),
  (1,3),
  (2,1),
  (2,3),
  (3,1),
  (3,2);

INSERT INTO
  replies(subject_question_reference, parent_reply_id, author_id, body)
VALUES
  (1, NULL, 2, 'THEY WERE NOT LIGHT ENOUGH.'),
  (2, NULL, 1, 'When you can figure out how to recurse through a problem.'),
  (1, 1, 3, 'Good answer. hahaha');

INSERT INTO
  question_likes(question_id,liked)
VALUES
  (1, 1),
  (1, 1),
  (2, 0);
