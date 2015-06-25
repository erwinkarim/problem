class ImportController < ApplicationController
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
	#    Parameters: {"utf8"=>"✓", "authenticity_token"=>"....", "target"=>"April_2015_CCC.csv", "fire-order"=>"1,3,4,5"}
	def process_file
		#convert the fire-order into array of numbers
		fireOrder = params[:'fire-order'].split(',').map{ |x| x.to_i }

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

		@end_result = imported_issues
		
	end
end
