class IssueStatus < ActiveRecord::Base
	#belongs_to :old_issue, :class_name => 'IssueTracker'
	has_many :issue_trackers, :foreign_key => 'old_status'
	has_many :issue_trackers, :foreign_key => 'new_status'
	validates :name, :uniqueness => true
end
