class Group < ActiveRecord::Base
	has_paper_trail :ignore => [:updated_at]
	
	has_many :uceniks, through: :group_uceniks
	has_many :group_uceniks
	has_many :events
	has_many :payments

	belongs_to :profesor
end
