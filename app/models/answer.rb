class Answer < ActiveRecord::Base
  belongs_to :user
	has_many :comments, :as => :parent
end
