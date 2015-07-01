require 'csv'
module ImportHelper
  def self.supported_date_formats
    return ["%d/%m/%Y", "%m/%d/%Y", "%Y-%m-%d"]
  end

  # load the file into Issue model
  # arguments
  # =>  file_name = target file name
  # =>  fire_order = from the CVS, the order of index which data will be captured
  # =>  date_format = date format index from  supported_date_formats
  # => current_user, current_user variable
  # => session_password, session[:password] variable
  #
  # returns: an array of issue objects
  def self.import_issue file_name, fire_order, selected_date_format, current_user, session_password
		#convert the fire-order into array of numbers
		#fireOrder = params[:'fire-order'].split(',').map{ |x| x.to_i }
    fireOrder = fire_order
		date_format = ImportHelper.supported_date_formats[selected_date_format.to_i]

		#process the file
		uploader = AvatarUploader.new
		uploader.retrieve_from_store!(file_name)

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
			user = User.find_by_mail( this_issue[3], "#{current_user.username}@#{current_user.domain}", session_password)
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
				push_issue.issue_trackers.new({:created_at => Date.strptime(this_issue[1], date_format) + 1.minute,
					:new_status_id => IssueStatus.find_by_name('Assigned').id,
					:user_id => current_user.id, :comment => 'Imported Data'}).save!
				push_issue.update_attribute(:assignee_id, current_user.id)

				# for close
				if !this_issue[3].empty? then
					push_issue.issue_trackers.new({:created_at => Date.strptime(this_issue[2], date_format) + 2.minute,
						:new_status_id => IssueStatus.find_by_name('Closed').id,
						:user_id => current_user.id, :comment => 'Imported Data'}).save!
				end

				processed_issues << [push_issue, push_issue.valid?]
			else
				#check if the issue has been closed, otherwise. it's just dupe
				processed_issues << ["skiped because of dups", false]
			end
		end

    return processed_issues
  end
end
