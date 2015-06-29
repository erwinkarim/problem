class ImportController < ApplicationController
	include ImportHelper

	def index
	end

	#  POST   /issues/import
	# Parameters: {"utf8"=>"✓", "authenticity_token"=>"....",
	# 	"import-file-field"=>
	# 		#<ActionDispatch::Http::UploadedFile:0x00000007ed46d8
	# 			@tempfile=#<Tempfile:/tmp/RackMultipart20150619-2621-kzkh85.csv>,
	# 			@original_filename="April_2015_CCC.csv", @content_type="application/vnd.ms-excel",
	# 			@headers="Content-Disposition: form-data; name=\"import-file-field\";
	# 			filename=\"April_2015_CCC.csv\"\r\nContent-Type: application/vnd.ms-excel\r\n">}
	def drop_file
		#save locally
		uploader =  AvatarUploader.new
		uploader.store!( params[:'import-file-field'])

		Rails.logger.info uploader.inspect

		respond_to do |format|
			format.html {
				file_name = uploader.file.file.split("/").last
				render :json => { :files => [ {
					:name => file_name, :size => uploader.file.size,
					:view_path => [AvatarUploader.store_dir, file_name].join('/')  } ] }
			}
		end
	end

	# import_preview_issues
	#
	# params
	# 	target = the file that we wish to open
	#
	def preview
		test_file = "#{Rails.root}/public/uploads/April_2015_CCC.csv"

		if params.has_key? :target then
			uploader = AvatarUploader.new
			uploader.retrieve_from_store!(params[:target])
			@file = File.open(uploader.file.file)
		else
			@file = nil
		end

		respond_to do |format|
			format.template
		end
	end

	#  POST   /issues/import/process_file
	#  Started POST "/issues/import/process_file" for 192.168.234.1 at 2015-06-25 10:24:43 +0800
	#  Processing by ImportController#process_file as HTML
	#    Parameters: {"utf8"=>"✓", "authenticity_token"=>"....", "target"=>"April_2015_CCC.csv",
	#    "fire-order"=>"1,3,4,5", "date-format => "2"}
	#  Expected Fire Order
	# 	1. Open Date - Date issue was opened
	# 	2. Assigned Date - Date issue was assigned (assignee will be the person who import)
	# 	3. Closed Date - Date issue was Closed
	# 	4. Affected User ( email of name of the user)
	# 	5. Description - description of the issue
	def process_file
		#convert the fire-order into array of numbers
		fireOrder = params[:'fire-order'].split(',').map{ |x| x.to_i }
		date_format = ImportHelper.supported_date_formats[params[:'date-format'].to_i]

		#process the file
		uploader = AvatarUploader.new
		uploader.retrieve_from_store!( params[:target] )

		require 'csv'
		imported_issues = Array.new
		current_line_number = 0

		File.foreach(uploader.file.file) do |line|
			# process the csv, be wary of dups
			if current_line_number != 0 then
				imported_issues << Array.new
				current_line = CSV.parse(line).first
				fireOrder.each do |element|
					imported_issues.last << current_line[element]
				end
			end
			current_line_number += 1
		end

		#now, let's do some fake date creation
		processed_issues = Array.new

		imported_issues.each do |this_issue|
			#assigne user
			user = User.find_by_mail( this_issue[3], "#{current_user.username}@#{current_user.domain}", session[:password])
			if user.nil? then
				user = current_user
			end

			#check for dups
			dup_issue = Issue.where(:description => this_issue[4], :user_id => user.id).first

			if dup_issue.nil? then
				#issue is fresh
				push_issue = Issue.new(:created_at => Date.strptime(this_issue[0], date_format),
					:description => this_issue[4], :user_id => current_user.id
				)
				if user != current_user then
					push_issue.assign_attributes({:affected_user_id => user.id})
				end

				#save the issue
				push_issue.save!

				#after the issue has been save, build the IssueTracker objects
				# for open
				push_issue.issue_trackers.new({:created_at => Date.strptime(this_issue[0], date_format),
					:new_status_id => IssueStatus.find_by_name('Open').id,
					:user_id => current_user.id, :comment => 'Imported Data'}).save!

				# for assigne
				push_issue.issue_trackers.new({:created_at => Date.strptime(this_issue[1], date_format),
					:new_status_id => IssueStatus.find_by_name('Assigned').id,
					:user_id => current_user.id, :comment => 'Imported Data'}).save!
				push_issue.update_attribute(:assignee_id, current_user.id)

				# for close
				if !this_issue[3].empty? then
					push_issue.issue_trackers.new({:created_at => Date.strptime(this_issue[2], date_format),
						:new_status_id => IssueStatus.find_by_name('Closed').id,
						:user_id => current_user.id, :comment => 'Imported Data'}).save!
				end

				processed_issues << [push_issue, push_issue.valid?]
			else
				#check if the issue has been closed, otherwise. it's just dupe
				processed_issues << ["skiped because of dups", false]
			end
		end

		@end_result = processed_issues

	end
end
