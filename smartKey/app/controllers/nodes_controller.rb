require 'jpush'

#class NodesController < ApplicationController
class NodesController < BaseController
    #before_action :find_user, :only => :unbind
    @@ret_dic = {:msg => nil, :status => nil, :time => nil} 
    #every http request have a class NodesController object!!!
    def initialize
        @result = Hash.new
    end

    def set_ret(rets)
        keys = rets.keys
        keys.each do |key|
            if @@ret_dic.has_key? key
                @result[key] = rets[key]
            else
                Rails.logger.debug("GDD_DEBUG-->input key = #{key} error")
            end     
        end 
    end

    def get_ret
        @result.to_json
    end
    
    #render :text => "node=#{node_params[:node_mac]} bind user=#{@user[:phone_num]} success!"              
    def bind
        find_user
        Rails.logger.debug("GDD_DEBUG-->bind: #{params.inspect}")
        
        @node = Node.find_by(node_mac: node_params[:node_mac])
        if !@node
            @node =Node.create(node_params)
        end

        @ship = NodeUsership.find_by(:node => @node, :user => @user)
        if !@ship
            NodeUsership.create(:node => @node, :user => @user)
            @result[:status] = "1"
        else            
            @result[:status]  = "0"
            @result[:message] = "已绑定"
        end
        render :json => @result.to_json
    end

    #render :text => "node=#{node_params[:node_mac]} and user=#{@user[:phone_num]} bind unexit!"              
    def unbind
        find_user
        Rails.logger.debug("GDD_DEBUG-->bind: #{params.inspect}")        
       
        #c = Category.where( :name => "Ruby" ).first_or_create 
        @node = Node.find_by(node_mac: node_params[:node_mac])
        if !@node
            @node =Node.create(node_params)
        end

        @ship = NodeUsership.find_by(:node => @node, :user => @user)
        if @ship
            @ship.destroy
            @result[:status] = "1"
        else
            @result[:status]  = "0"
            @result[:message] = "绑定不存在"
        end
        render :json => @result.to_json
    end

    def index
        @nodes = Node.all
        render :json => @nodes.to_json
        #respond_to do |format|
	    #format.html # index.html.erb
            #format.json
        #end
    end

    def keyon
        Rails.logger.debug("GDD_DEBUG-->keyon: #{params.inspect}")
        @node = Node.find_by(:node_mac => params[:mac])
        if @node
            Rails.logger.debug("GDD_DEBUG-->keyon: #{@node.inspect}")
            @node[:updated_on] = Time.now.to_i
            @node[:uptime] = params[:uptime].to_i
            @node.save
            jpush_send(@node[:node_mac])
            set_ret({:msg => "ok", :time=> 10})
        else 
            set_ret({:msg => "error", :time=> 600})
        end
        render :text => get_ret
    end

    def get_push_id(mac) 
        push_array = Array.new
        @node = Node.find_by(:node_mac => mac)
        if @node
            @node.users.each do |user|
                 user.clients.each do |client|
                    push_array << client[:push_id]
                 end                
            end
        end
        push_array
    end

    def keyevent 
        Rails.logger.debug("GDD_DEBUG-->keyevent: #{params.inspect}")
        push_ids = Array.new
        push_ids = get_push_id(params[:mac])

        if /short/ =~ params[:event]
            msg = "short"    
        elsif /long/ =~ params[:event]
            msg = "long"    
        end

        push_ids.each do |id|
            Rails.logger.debug("GDD_DEBUG-->keyevent: send #{id} #{msg} msg!")                                
        end
        set_ret({:msg => "ok"})
        render :text => get_ret
    end

    protected
    def jpush_send(mac)
        master_secret = '83e0d2dd709ec75210883be3'
        app_key = '73bc9ce25ddd9118a105f1a6'
        client = JPush::JPushClient.new(app_key, master_secret)
        #send broadcast
        payload1 = JPush::PushPayload.build(
                platform: JPush::Platform.all,
                #audience: JPush::Audience.build(registration_id: ["07085582b47", "07085582b49"]),
                audience: JPush::Audience.all,
                notification: JPush::Notification.build(
                    alert: "#{mac} alert meassage by broadcast"
                )
            )
        result = client.sendPush(payload1)
        Rails.logger.debug("Got result  " +  result.toJSON)
    end


    def find_user
        @user = User.find_by(phone_num: params[:phone_num])        
        if !@user
            render :text => "this user is unexist!"
            return
        end
    end

    def node_params
        params.require(:node).permit(:node_mac)
    end

end
