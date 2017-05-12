class WorkdaysController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @workdays = Workday.all
  end

  def new
    @workday = Workday.new
  end

  def create
    @workday = current_user.workdays.create(workday_params)

    if @workday.valid?
      redirect_to workdays_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    return render_status(:not_found) if current_workday.blank?
  end

  def edit
    return render_status(:not_found) if current_workday.blank?
    return render_status(:forbidden) if current_workday.user != current_user
  end

  def update
    return render_status(:not_found) if current_workday.blank?
    return render_status(:forbidden) if current_workday.user != current_user

    current_workday.update_attributes(workday_params)

    if current_workday.valid?
      redirect_to workdays_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return render_status(:not_found) if current_workday.blank?
    return render_status(:forbidden) if current_workday.user != current_user

    current_workday.destroy
    redirect_to root_path
  end

  private

  def workday_params
    params.require(:workday).permit(:job_title, :industry, :description)
  end

  helper_method :current_workday
  def current_workday
    @workday ||= Workday.find_by_id(params[:id])
  end
end
