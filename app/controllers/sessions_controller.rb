class SessionsController < ApplicationController

  def new; end

  def create
    user = User.find_by username: (params[:username])
    if user && user.authenticate(params[:password])
      #determine if 2factor authentication is on
      if user.two_factor_auth?
        # restrict access to pin_path via session parameters
        session[:two_factor] = true
        # gen a pin, send pin to twilio, sms to user's phone
        user.generate_pin!
        user.send_pin_to_twilio
        # show pin form
        redirect_to pin_path
      else
        login_user!(user)
      end
    else
      flash[:error] = "There was an error in your username and password combination. Please retry."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  def pin
    access_denied if session[:two_factor].nil?
    #renders pin template automatically if it's not a request
    if request.post?
      user = User.find_by pin: params[:pin]
      #success condition
      if user
        session[:two_factor] = nil
        user.remove_pin!
        #remove the pin
        #log user in
        login_user!(user)
      else
        flash[:error] = "Sorry, something is wrong with your pin number."
      end
    end
  end

  private
    def login_user!(user)
      session[:user_id] = user.id
      flash[:notice] = "Hi, #{user.username}. You have been logged in."
      redirect_to root_path
    end
end
