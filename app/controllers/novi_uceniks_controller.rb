class NoviUceniksController < ApplicationController
	  skip_before_filter  :verify_authenticity_token

  def new
  end

  def create
  	@ucenik = NoviUcenik.new({:name => params[:name], :mjesto => params[:mjesto], :jezik => params[:jezik], :parents_name => params[:parents_name], :tel => params[:tel], :email => params[:email], :comment => params[:comment], :created_at => Time.now})

  	@ucenik.save
  end

  private
  	def user_params
  		params.require(:novi_ucenik).permit(:name, :mjesto, :jezik, :parents_name, :tel, :email, :comment, :created_at)
  	end
end
