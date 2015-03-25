class IssueTracker < ActiveRecord::Base
  belongs_to :issue
  belongs_to :old_status, :class_name => 'IssueStatus'
  belongs_to :new_status, :class_name => 'IssueStatus'
  belongs_to :user

	validates :comment, :presence => true
end
