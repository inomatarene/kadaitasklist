class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
    @tasks = Task.all.page(params[:page])
    if logged_in?
    @task = current_user.tasks.build  # form_with 
    @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'tasks/index'
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Task は正常に削除されました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status, :user)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
