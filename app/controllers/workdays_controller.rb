class WorkdaysController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
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
    @workday = Workday.find_by_id(params[:id])
    return render plain: 'Not Found :-(', status: :not_found if @workday.blank?
  end

  private

  def workday_params
    params.require(:workday).permit(:job_title, :industry, :description)
  end
end
