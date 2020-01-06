class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end
  
  def show
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが登録されました。'
      redirect_to root_path
    else
      @tasks = current_user.microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] =　'タスクの登録に失敗しました。'
      render 'tasks'
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  #strong parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
