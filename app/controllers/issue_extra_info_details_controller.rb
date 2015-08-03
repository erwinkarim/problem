class IssueExtraInfoDetailsController < ApplicationController
	before_action :admins_only, :only => [:index]
	def index
		@extra_info_details = IssueExtraInfoDetail.all

		respond_to do |format|
			format.html { render :tempalte => 'issue_extra_info_details/form.template',
				:locals => { :'@extra_info_details' => @extra_info_details } }
		end
	end

	def new
		@extra_info_detail = IssueExtraInfoDetail.new
	end

	def update
		# delete extra info details that is not in the list
		IssueExtraInfoDetail.all.each do |extra_info|
				if params[:extra_infos].select{ |x| x[0] == extra_info.id.to_s}.empty? then
					Rails.logger.info "#{ extra_info.id} not in list. will be destoryed"
					extra_info.destroy
				end
		end

		# scan for new extra info details
		params[:extra_infos].each do |extra_info|
			info_detail = IssueExtraInfoDetail.find_by_id(extra_info[0])
			if info_detail.nil? then
				info_detail = IssueExtraInfoDetail.new
			end
			info_detail.assign_attributes(extra_info[1].permit(:name, :description, :use_field) )
			info_detail.save!
			#Rails.logger.info extra_info.inspect
		end

		respond_to do |format|
			format.html { redirect_to issue_extra_info_details_path }
		end
	end

	private

	def issue_extra_info_details_params
		params.require(:extra_infos).permit(:name, :description)
	end
end
