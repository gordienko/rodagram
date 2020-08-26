class UserAddress < ApplicationRecord
  belongs_to :user
  validates :ip, presence: true, uniqueness: { scope: :user_id }

  def self.statictics
    sql = <<-SQL
           SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(t)))
           FROM (SELECT host(ip) AS ipaddr, ARRAY_AGG(login) AS authors
                 FROM user_addresses 
                 INNER JOIN users ON users.id = user_id 
                 GROUP BY ip HAVING COUNT(user_id) > 1 ORDER BY COUNT(user_id) DESC) AS t
    SQL
    ActiveRecord::Base.connection.select_value(sql, 'UserAddresses')
  end

end