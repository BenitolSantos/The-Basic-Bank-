class TransactionsController < ApplicationController
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/transactions' do
    redirect_if_not_logged_in
    @transactions = current_user.transactions
    erb :'/transactions/index'
  end

  get '/transactions/new' do
    redirect_if_not_logged_in
    erb :'/transactions/new'
  end


  get '/transactions/:id' do
    redirect_if_not_logged_in
    @transaction = Transaction.find_by_id(params[:id])
    erb :'/transactions/show'
  end


  post '/transactions' do
    redirect_if_not_logged_in
    @transaction = Transaction.new(amount: params["transaction"]["amount"], user_id: current_user.id)
    #ActiveRecord::SubclassNotFound: Invalid single-table inheritance type: deposit is not a subclass of Transaction
    if params["deposit"] == "on"
      @transaction.update(version: "deposit")
      current_user.balance += params["transaction"]["amount"].to_i
      current_user.transactions << @transaction
      current_user.save
    elsif params["withdrawl"] == "on"
      @transaction.update(version: "withdrawl")
      current_user.balance -= params["transaction"]["amount"].to_i
      current_user.transactions << @transaction
      current_user.save
    else
    end
      redirect to "/transactions"
  end


  get '/transactions/:id/edit' do
    redirect_if_not_logged_in
    @transaction = Transaction.find_by(id: params[:id])
    #this resets the balance to before the previous edit
    binding.pry
    if @transaction.version == "deposit"
      @transaction.update(version: "deposit")
      current_user.balance -= @transaction.amount.to_i
      current_user.transactions.delete(@transaction)
      current_user.save
    elsif @transaction.version == "withdrawl"
      @transaction.update(version: "withdrawl")
      current_user.balance += @transaction.amount.to_i
      current_user.transactions.delete(@transaction)
      current_user.save
    else
    end
    binding.pry
    erb :"/transactions/edit"
  end

  patch '/transactions/:id' do
    binding.pry
    redirect_if_not_logged_in
  end

  delete '/transactions/:id' do
    redirect_if_not_logged_in
  end



end
