class WelcomeController < ApplicationController
  @@g_index_request_count=0

  def index
        @page=params[:page]
        @per_page=params[:per_page]
        @next_page=@page.to_i+1
        @@g_index_request_count += 1
        @request_count = @@g_index_request_count
  end

  def say
        @page=params[:page]
        @per_page=params[:per_page]
        @next_page=@page.to_i+1 
        @request_count = @@g_index_request_count
  end

end
