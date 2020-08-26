class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :rates, dependent: :destroy
  validates :title, :body, presence: true


  validates :creator_ip, format: { with: /\A([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}\z/,
                                   message: "is empty or in the wrong format" }

  after_create :after_create

  def self.top(num = 100)
    sql = <<-SQL
          SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(t))) 
          FROM (SELECT title, body, average_rating, rates_count 
                FROM posts WHERE (average_rating > 0) 
                ORDER BY average_rating DESC, rates_count DESC LIMIT $1) AS t
    SQL
    ActiveRecord::Base.connection.select_value(sql, 'Posts', [[nil, num]])
  end

  def self.random
    sql = <<-SQL
      SELECT id 
      FROM posts 
      ORDER BY RANDOM() LIMIT 1
    SQL
    ActiveRecord::Base.connection.select_value(sql, 'Posts')
  end

  private
  def after_create
    UserAddress.create(ip: creator_ip,
                       user_id: user_id)
  end

end