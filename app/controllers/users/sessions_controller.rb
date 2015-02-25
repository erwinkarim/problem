class Users::SessionsController < Devise::SessionsController
before_filter :configure_sign_in_params
#, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  #def create
	#	logger.info "attempt to auth"
  #	super
  #end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

	def user_params
		params.require(:user).permit( :username, :password, :password_confirmation, :email, :domain)
	end 

  protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
		devise_parameter_sanitizer.for(:sign_in).push(:username, :domain)
  end
end
