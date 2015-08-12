class Profesor < ActiveRecord::Base
	has_paper_trail
	
	has_one :user
	has_many :groups
	has_many :events
	has_many :single_events
	has_many :messages
	#validates_attachment_content_type :document, :content_type => ['application/pdf', 'application/msword', 'text/plain']
end
