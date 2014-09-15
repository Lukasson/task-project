class TasksController < ApplicationController
  
  def index
    @tasks=Task.all
  end
  
  def show
    @task=Task.find(params[:id])
  end
  
  def new
    @task=Task.new
  end
  
  def create
    @task=Task.new(params[:task])
    
    if @task.save
      redirect_to tasks_path
    else
      render "new"
    end
  end
  
  def edit
    @task=Task.find(params[:id])
  end
  
  def update
    @task=Task.find(params[:id])
    
    if @task.update_attributes(params[:task])
      redirect_to task_path(@task.id)
    else
      render "edit"
    end
  end
  
  def destroy
    session[:user_id]=nil     # or reset_session to clear entire session
    redirect_to tasks_path
  end
  
end
