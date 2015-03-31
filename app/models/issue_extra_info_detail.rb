# Description of the extra issue
# Each IssueExtraInfo will link into this class which will give more detail information about the stuff
class IssueExtraInfoDetail < ActiveRecord::Base
	has_one :issue_extra_info

	enum :use_field => [ :string, :integer ]
end
