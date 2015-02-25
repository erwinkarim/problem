class SearchController < ApplicationController
	def index
		if params.has_key? :q then
			#look for question
			respond_to do |format|
				format.html
				format.json
			end
		else
			not_found
		end
	end
end
