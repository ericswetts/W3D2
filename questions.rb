require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = TRUE
    self.results_as_hash = TRUE
  end

end

class Users

  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id=?
      SQL

    return NIL unless user.length > 0
    Users.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def create
  end

  def update

  end
end


class Questions

  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id=?
      SQL

    return NIL unless question.length > 0
    Questions.new(question.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def create
  end

  def update

  end
end

class Question_follows

  attr_accessor :user_id, :question_id

  def self.find_by_user_id(user_id)
    question_follows = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id=?
      SQL

    return NIL unless question_follows.length > 0
    Question_follows.new(question_follows.first)
  end

  def self.find_by_question_id(question_id)
    users_following = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id=?
      SQL

    return NIL unless users_following.length > 0
    Question_follows.new(users_following.first)
  end

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def create
  end

  def update

  end
end

class Replies

  attr_accessor :id, :subject_question_reference, :parent_reply_id, :author_id, :body

  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id=?
      SQL

    return NIL unless replies.length > 0
    Replies.new(replies.first)
  end

  def initialize(options)
    @id = options['id']
    @subject_question_reference = options['subject_question_reference']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end

  def create
  end

  def update

  end
end

class Question_likes

  attr_accessor :question_id, :liked

  def self.find_by_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id=?
      SQL

    return NIL unless num_likes.length > 0
    Question_likes.new(num_likes.first)
  end

  def initialize(options)
    @question_id = options['question_id']
    @liked = options['liked']
  end

  def create
  end

  def update

  end
end
