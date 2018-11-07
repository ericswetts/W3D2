require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
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

    return nil unless user.length > 0
    Users.new(user.first)
  end

  def self.all
    users = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL

    users.map {|user| Users.new(user)}
  end

  def self.find_by_name(fname, lname)
    id = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        id
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    return nil unless id.length > 0
    Users.new(id.first).id
  end

  def authored_questions(question_author_id)
    Questions.find_by_author_id(question_author_id)
  end

  def authored_replies(question_reply_id)
    Replies.find_by_author_id(question_reply_id)
  end

  def followed_questions
    Question_follows.followed_questions_user_id(self.id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
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

    return nil unless question.length > 0
    Questions.new(question.first)
  end

  def followers
    Question_follows.followers_for_question_id(self.id)
  end

  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id=?
      SQL

    return nil unless question.length > 0
    Questions.new(question.first)
  end

  def replies(question_id)
    Replies.find_by_SQR_id(question_id)
  end


  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author(author_id)
    Users.find_by_id(author_id)
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

    return nil unless question_follows.length > 0
    question_follows.map {|question| Question_follows.new(question)}
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

    return nil unless users_following.length > 0
    users_following.map {|user| Question_follows.new(user)}
  end

  def self.followers_for_question_id(question_id)
    all_user_ids = Question_follows.find_by_question_id(question_id)
    all_user_ids.map{|user_id| Users.find_by_id(user_id.user_id)}
  end

  def self.followed_questions_user_id(user_id)
    all_question_ids = Question_follows.find_by_user_id(user_id)
    all_question_ids.map {|question_id| Questions.find_by_id(question_id.question_id)}
  end

  def initialize(options)
    @user_id = options['user_id']
    @question_id = options['question_id']
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

    return nil unless replies.length > 0
    Replies.new(replies.first)
  end

  def author
    Users.find_by_id(self.author_id)
  end

  def parent_reply
    Replies.find_by_id(self.parent_reply_id)
  end

  def question
    Questions.find_by_id(self.subject_question_reference)
  end

  def child_replies
    child_replies = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id=?
      SQL
    return nil unless child_replies.length > 0
    child_replies.map {|reply|Replies.new(reply)}
  end

  def self.find_by_author_id(author_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id=?
      SQL

    return nil unless replies.length > 0
    replies.map {|reply|Replies.new(reply)}
  end

  def self.find_by_SQR_id(subject_question_reference)
    replies = QuestionsDatabase.instance.execute(<<-SQL, subject_question_reference)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_question_reference=?
      SQL

    return nil unless replies.length > 0
    replies.map {|reply|Replies.new(reply)}
  end



  def initialize(options)
    @id = options['id']
    @subject_question_reference = options['subject_question_reference']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
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

    return nil unless num_likes.length > 0
    Question_likes.new(num_likes.first)
  end

  def initialize(options)
    @question_id = options['question_id']
    @liked = options['liked']
  end

end
