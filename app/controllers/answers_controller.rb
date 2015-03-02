class AnswersController < ApplicationController
	def index
	end

	def show
	end

	def new
		respond_to do |format|
			format.template
		end
	end
end
