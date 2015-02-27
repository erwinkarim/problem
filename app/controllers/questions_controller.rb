class QuestionsController < ApplicationController
	def index
		respond_to do |format|
			format.html
			format.template{
				# return the latest 10 questions
				$recent_questions = Question.all.limit(10).order(:created_at => :desc)
			}
		end
	end

	# /questions/:id
	def show

		respond_to do |format|
			format.html
			format.template{
				@question = Question.find_by_id(params[:id]) or not_found

			}
		end
	end

	# POST   /questions(.:format)
	# parameters : 
	# 	user_id:	the person who ask the question (required)
	# 	question: the question (required, sanitized at client to have some valuesit)
	# 	comments: the comments to the question (optional)
	def create

		question = User.find(params[:userid]).questions.new(:statement => params[:question])
		question.save!

		if params[:comment] != "" then
			comment = question.comments.new(:statement => params[:comment], :user_id => params[:userid].to_i)
			comment.save!
		end

		respond_to do |format|
			format.html { render nothing: true, status: :ok }
		end
	end
end
