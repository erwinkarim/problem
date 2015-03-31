# contains extra infomation that an issue have (ie; wells count, # of seismic, etc...)
#
# an issue can have 0 or more ExtraInfo
class IssueExtraInfo < ActiveRecord::Base
  #belongs_to :extra_info_detail
	belongs_to :extra_info_detail, :class_name => 'IssueExtraInfoDetail'
  belongs_to :issue
end
