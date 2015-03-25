class IssueTracker < ActiveRecord::Base
  belongs_to :issue
  belongs_to :old_status, :class_name => 'IssueStatus'
  belongs_to :new_status, :class_name => 'IssueStatus'
  belongs_to :user

	validates :comment, :presence => true

	#checks the current new_status and give the options for the next step base on workflow
	#
	# The work flow
	# Open -> Acknowledged -> Assigned ->
	# 	User Uncontactable
	# 		hang here until resolved
	# 	Escalate To Vendor
	# 		hang here until resolved
	#
	# 	Resolved
	# 		Closed
	# 			-> auto close after 2 weeks on the issue being resolved
	# 		Reopened
	# 			-> next option is assigned	
	#
	# 	Between Open and Closed, these status can be added at any time
	# 	Edit Description
	# 	Add Comment
	def next_step_options
		current_status = self.new_status.name
		if (current_status == 'Open') then
			return IssueStatus.where(:name => ['Acknowledged'])
		elsif (current_status == 'Acknowledged') then
			return IssueStatus.where(:name => ['Assigned'])
		elsif (current_status == 'Assigned') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='User Uncontactable') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='Escalate To Vendor') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='Resolved') then
			return IssueStatus.where(:name => ['Closed', 'Reopen'])
		elsif (current_status =='Reopen') then
			return IssueStatus.where(:name => ['Assigned'])
		else
			return nil
		end
	end

	def next_step_options_for_select
		options = self.next_step_options
		if options == nil then
			return nil
		else
			return options.collect{ |x| [x.name, x.id] }
		end
	end
end
