class TransactionsController < ApplicationController
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/transactions' do
    redirect_if_not_logged_in
    @transactions = Transaction.all
    erb :'/transactions/index'
  end

  get '/transactions/new' do
    redirect_if_not_logged_in
    erb :'/transactions/new'
  end


  get '/transactions/:id' do
    redirect_if_not_logged_in
  end


  post '/transactions' do
    redirect_if_not_logged_in
    @transaction = Transaction.new(ammount: params["transaction"]["amount"], user_id: current_user.id)
    #ActiveRecord::SubclassNotFound: Invalid single-table inheritance type: deposit is not a subclass of Transaction
    @transaction.update(type: params["transaction"]["type"])
    @transaction.save
    binding.pry
    if @transaction.type.downcase == "deposit"
      binding.pry
      current_user.update(current_user.ammount + params["transaction"]["amount"])
    elsif @transaction.type.downcase == "withdrawl"
      current_user.update(current_user.ammount - params["transaction"]["amount"])
    else
      redirect to "/transactions/new"
    end
  end


  get '/transactions/:id/edit' do
    redirect_if_not_logged_in
  end

  patch '/tweets/:id' do
    redirect_if_not_logged_in
  end

  delete '/tweets/:id' do
    redirect_if_not_logged_in
  end






end
