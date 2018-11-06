cat import_db.sql | sqlite3 questions.db
pry
load "questions.rb"
Replies.find_by_author_id(2)

bill = Users.new({'fname' => 'Bill', 'lname' => 'Nye'})

  ({'title' => 'Chess', 'body' => 'How do I get the cursor to move pieces about again?', 'author_id' => 3})
