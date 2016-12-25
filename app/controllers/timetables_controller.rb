class TimetablesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :admin_user,     only: [:new, :create]
  before_action :set_timetable, only: [:confirm]
  
  def new
    @timetable = Timetable.new
    @times = Array.new
    @period_hash = create_timetable_period  # 期間のセレクトボックス選択肢
    @koma_array = (1..24).to_a              # コマ数のセレクトボックス選択肢
    @times = create_koma_times              # 各コマ毎の時間の初期値
  end
  
  def create
    @timetable = Timetable.new(timetable_params)
    flash[:danger] = "#{(l Date.today, format: :short)}"
    if @timetable.save
      timetable_confirm_and_template_process
    else
      render :new
    end
  end
  
  def confirm
  end
  
  private
  
  def timetable_params
    params.require(:timetable).permit(:from_date, :to_date, :max_koma, :times)
  end
  
  def create_timetable_period
    period_hash = Hash.new
    (Date.today - 2.weeks).upto(Date.today + 1.month) do |date|
      period_hash.store((l date, format: :short), date)
    end
    return period_hash
  end
  
  # タイムテーブルの各コマ毎の時間を作成
  def create_koma_times
    koma_times = <<~"EOS"
      8:50~10:20
      10:20~12:30
      12:30~14:30
      14:30~16:10
      16:10~18:00
      18:00~20:00
      20:00~22:00
    EOS
    return koma_times
  end
  
  def set_timetable
    @timetable = Timetable.find(params[:id])
  end
  
  # タイムテーブルの作成前確認とテンプレート保存の処理（newとeditで同じ処理のためまとめる）
  def timetable_confirm_and_template_process
    if params[:commit_value] == "confirm"                           # 「確認」が実行された場合
      redirect_to confirm_user_timetable_path(current_user, @timetable)
    elsif params[:commit_value] == "template"                       # 「現在の内容を保存」が実行された場合

      redirect_to new_user_timetable_path(current_user)
    else          
      flash[:danger] = "不正な操作です"
      redirect_to root_path
    end
  end
end
