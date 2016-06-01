#class UsersController < ApplicationController
class UsersController < BaseController
  around_action BenchmarkFilter 
  #before_action BenchmarkFilter  
  #before_action {|controller| controller.logger.debug "before_action------------#{controller.request.remote_ip}"}
  #prepend_before_action {|controller| controller.logger.debug "before_action--#{controller.controller_name}-#{controller.action_name}"}
  
  def initialize
        @result = Hash.new
  end
 
  def index
    @users = User.all
    render :json => @users.to_json
    #respond_to do |format|
	#format.html # index.html.erb
        #format.json
    #end
  end

  def show
	@user = User.find_by(id: params[:id])
	Rails.logger.debug("GDD_DEBUG---->user: #{@user.inspect}")
	if @user
		render :json => @user.to_json
	else
        ret = {} 
		ret["status"] = 0
		render :json => ret.to_json 
		#return api_error(status: 401)
	end
  end

  #https://ihower.tw/rails4/activerecord-lifecycle.html
  def create
      @user = User.find_by(:phone_num => user_params[:phone_num])
      if @user
         @result["status"]  = "0"
         @result["message"] = "已注册"
      else
        @user = User.create(user_params)
        if !@user.errors.empty?
           @result["status"]  = "0"
           @result["message"] = @user.errors.full_messages
           Rails.logger.debug("GDD_DEBUG---->create: #{@user.errors.full_messages}")
        else
            @result["status"]  = "1"
        end
      end
	  render :json => @result.to_json 
  end

    #curl -i -X POST -v  http://openwrtdl.com:3000/users/update/1  -H "Content-Type: application/json" -d '{"phone_num":"13564177739","password":"123457"}' 
    def update
        Rails.logger.debug("GDD_DEBUG---->update: #{user_params.inspect}")
        @user = User.find_by(id: params[:id])
        if @user && @user.update(user_params)
            render :json => @user.to_json
        else
            render :text => "user unexist or update user fail!"
        end
    end

    # curl -X POST -v http://www.openwrtdl.com:3000/users/edit -H "Content-Type: application/json"
    # -d '{"phone_num":"13564177739","password":"123457", "new_password":"123456"}'
    def edit
        Rails.logger.debug("GDD_DEBUG---->login: #{params.inspect}") 
        @user = User.find_by(user_params)
        if @user
            @user[:password] = params[:new_password]
            @user.save
            @result[:status] = "1"
        else             
            @result[:status]   = "0"
            @result["message"] = "原账号验证失败"
        end
        render :json => @result.to_json
    end

  #def destroy
  def delete
    @user = User.find_by(id: params[:id])
    Rails.logger.debug("GDD_DEBUG---->user: #{@user.inspect}")
    if @user
        #@user.clients.destroy_all #destroy all the clients of user
        @user.destroy
        render :text => "delete user success"
    else
        render :text => "delete user fail(unexist)"
    end
  end

  # curl -i -X POST -v  http://openwrtdl.com:3000/users/login -H "Content-Type: application/json"
  # -d '{"phone_num":"13564177739","password":"112233","push_id":"03085582b47"}'
  # user = User.find_by(:phone_num => "13564177740", :password =>"123457")
  def login
    Rails.logger.debug("GDD_DEBUG---->login: #{params.inspect}") 
    Rails.logger.debug("GDD_DEBUG---->login: #{user_params.inspect}") 
    @user = User.find_by(user_params)
    if @user
        @client = Client.find_by_push_id(params[:push_id]) #make the push_is is Unique and only have a user
        if !@client
            @client = Client.create(:push_id => params[:push_id])
        end
        @user.clients << @client
        @result["status"]  = "1" 
    else    
        @result["status"]  = "0" 
        @result["message"] = "登入失败"
    end
    render :json => @result.to_json 
  end

  # curl -i -X POST -v  http://openwrtdl.com:3000/users/logout -H "Content-Type: application/json"
  # -d '{"phone_num":"13564177739","password":"112233","push_id":"03085582b47"}'
  def logout
    Rails.logger.debug("GDD_DEBUG---->logout: #{params.inspect}") 
    @user = User.find_by(user_params) 
    if @user
        @user.clients.each do |app|
            if app[:push_id] == params[:push_id]
               app.destroy
            end
        end 
        @result["status"]  = "1"
    else
        @result["status"]  = "0"
        @result["message"] = "登出账号和密码验证失败"
    end 
    render :json => @result.to_json 
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:phone_num, :password)
    end
end
