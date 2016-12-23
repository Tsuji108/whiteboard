class TimetablesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :admin_user,     only: [:new, :create]
  
  def new
    @timetable = Timetable.new
    @times = Array.new
    @period_array = create_timetable_period # 期間のセレクトボックス選択肢
    @koma_array = (1..24).to_a              # コマ数のセレクトボックス選択肢
    @times = create_koma_times              # 各コマ毎の時間の初期値
  end
  
  def create
  end
  
  private
  
  # タイムテーブルの期間を選択するセレクトボックスの選択幅を作成
  def create_timetable_period
    period_array = Array.new
    (Date.today - 2.weeks).upto(Date.today + 1.month) do |date|
      period_array.push(l date, format: :short)
    end
    return period_array
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
end
