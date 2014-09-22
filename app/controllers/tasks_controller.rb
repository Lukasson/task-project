class TasksController < ApplicationController
   
  def index
    @tasks=Task.where({:user_id => session[:user_id]})
  end
  
  def show
    @comment = Comment.new
    @users = User.all
    @categories = Category.all
    @task = Task.find_by_url(params[:id])
    @assignee = User.find(@task.user_id)
  end
  
  def new
    if params.include?(:project_id)
      @project = Project.find(params[:project_id])
      @p_id = @project.id
    else
      @p_id = nil
    end
    
    @user=User.find(session[:user_id])
    @task=Task.new
    @categories=Category.all
    @category=Category.new
  end
  
  def create
    @task = Task.new(params[:task])
    @comment = Comment.new(params[:comment])
    
    if @task.save
      feed = Feed.new({atype: "task", user_id: session[:user_id], key: 'feeds/task/create', task_id: @task.id})
      feed.save
      
      if @task.project_id == nil
        redirect_to tasks_path
      else
        redirect_to project_path(@task.project_id)
      end
    else
      render "new"
    end
  end
  
  def edit
    @user = User.find(session[:user_id])
    @categories = Category.all
    @task = Task.find_by_url(params[:id])
  end
  
  def update
    @task = Task.find_by_url(params[:id])
    
    if @task.update_attributes(params[:task])
      feed = Feed.new({atype: "task", user_id: session[:user_id], key: 'feeds/task/update', task_id: @task.id})
      feed.save
      redirect_to task_path(@task.url)
    else
      render "edit"
    end
  end
  
  def assign
    @task = Task.find_by_id(params[:task][:task_id])
    @user = User.find(session[:user_id])
    
    user_id = params[:task][:user_id].to_i
    
    if @task.update_attributes(:user_id => user_id)
      Pony.options = {
        :to => @task.user.email,
        :body => 'You have been assigned to a task.',
        :via => :smtp,
        :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => ENV[:MAIL_ACCOUNT],
          :password             => ENV[:MAIL_PASSWORD],
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        }
      }

      Pony.mail(:from => 'taskmate.ocs@gmail.com')
      
      redirect_to task_path(@task.url), :notice => "You have notified #{@task.user.name} of their new task."
    else
      render "edit", :alert => "Oh, no, something went wrong!"
    end
  end
  
  def destroy
    @task = Task.find_by_url(params[:id])
    feed = Feed.new({atype: "task", user_id: session[:user_id], key: 'feeds/task/destroy'})
    feed.save
    @task.destroy
    
    redirect_to tasks_path
  end
  
  def sort
    params[:task].each_with_index do |id, index|
      Task.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
end
