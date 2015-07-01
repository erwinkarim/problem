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
		@end_result = ImportHelper.import_issue(params[:target],
			params[:'fire-order'].split(',').map{|x| x.to_i},
			params[:'date-format'], current_user, session[:password])
	end
end
