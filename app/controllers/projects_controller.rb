class ProjectsController < ApplicationController
  
  def index
    @current_user=User.find(session[:user_id])
    @projects = @current_user.projects
  end
  
  def show
    @project=Project.find(params[:id])
  end
  
  def new
    @project=Project.new
    #TODO: Check on this view file
    # @categories=Category.all
  end
  
  def create
    @project=Project.new(params[:project])
    
    if @project.save
      u=User.find(session[:user_id])
      u.projects << @project
      redirect_to projects_path
    else
      render "new"
    end
  end
  
  def edit
    @project=Project.find(params[:id])
  end
  
  def update
    @project=Project.find(params[:id])
    
    if @project.update_attributes(params[:project])
      redirect_to project_path(@project.id)
    else
      render "edit"
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    
    redirect_to projects_path
  end
  
end
