class IssueExtraInfosController < ApplicationController
	# GET    /issue_extra_infos/new
	def new
		@random_id = SecureRandom.hex(8)
		@extra_info = IssueExtraInfo.new(:extra_info_detail_id => IssueExtraInfoDetail.first.id)

		respond_to do |format|
			format.template { render :template => 'issue_extra_infos/form.template', 
				:locals => { :random_id => @random_id, :extra_info => @extra_info } 
			}
		end
	end
end
