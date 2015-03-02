class CommentsController < ApplicationController
	def show
		respond_to do |format|
			format.template
		end
	end

	def new
		respond_to do |format|
			format.template
		end
	end
end
