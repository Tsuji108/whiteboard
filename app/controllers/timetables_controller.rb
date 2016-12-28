class TimetablesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :prohibit_direct_access, only: [:edit, :applay_saved_timetable, :destroy_saved_timetable, :confirm]
  before_action :admin_user,     only: [:new, :create, :confirm]
  before_action :set_timetable, only: [:show, :edit, :update, :destroy_saved_timetable, :confirm]
  before_action :set_saved_timetables, only: [:new, :create, :edit, :update, :applay_saved_timetable, :destroy_saved_timetable]
  
  def show
  end
  
  def new
    @timetable = current_user.timetables.build()
    @period_hash = create_timetable_period  # 期間のセレクトボックス選択肢
    @koma_array = (1..24).to_a              # コマ数のセレクトボックス選択肢
    @default_koma = set_default_koma(@timetable)          # コマ数のセレクトボックスの初期値
    @times = set_koma_times(@timetable)              # 各コマ毎の時間の初期値
  end
  
  def create
    @timetable = current_user.timetables.build(timetable_params)
    if @timetable.save
      timetable_confirm_and_template_process
    else
      render :new
    end
  end

  def edit
    @period_hash = create_timetable_period       # 期間のセレクトボックス選択肢
    @koma_array = (1..24).to_a                   # コマ数のセレクトボックス選択肢
    @default_koma = set_default_koma(@timetable)          # コマ数のセレクトボックスの値
    @times = set_koma_times(@timetable)                   # 各コマ毎の時間の値
  end
  
  def update
    if @timetable.update_attributes(timetable_params)
      timetable_confirm_and_template_process
    else
      render :edit
    end
  end
  
  def applay_saved_timetable
    @timetable = Timetable.find(params[:id]).dup # PATCHリクエストを送信しないようにdupでオブジェクトをコピーして新たに作成
    @period_hash = create_timetable_period       # 期間のセレクトボックス選択肢
    @koma_array = (1..24).to_a                   # コマ数のセレクトボックス選択肢
    @default_koma = set_default_koma(@timetable)          # コマ数のセレクトボックスの値
    @times = set_koma_times(@timetable)                   # 各コマ毎の時間の値
    flash.now[:info] = "選択したテンプレートを適用しました<br>#{@timetable.times.inspect}"
    render :new
  end
  
  def destroy_saved_timetable
    @timetable.destroy
    flash[:danger] = "選択したテンプレートを削除しました"
    redirect_to new_user_timetable_path(current_user)
  end
  
  def confirm
    @timetable_col = "<th></th>"  # タイムテーブル左上の空セル
    @space_cell = ""              # 空のセル
    @timetable.from_date.upto(@timetable.to_date) do |date|
      @timetable_col += "<th class='center'>#{(l date, format: :short)}</th>"
      @space_cell += "<td></td>"
    end
  end
  
  private
  
  # ストロングパラメータの設定
  def timetable_params
    params.require(:timetable).permit(:from_date, :to_date, :max_koma, :times)
  end
  
  # タイムテーブルを作成する期間のセレクトボックス選択肢
  def create_timetable_period
    period_hash = Hash.new
    (Date.today - 2.weeks).upto(Date.today + 1.month) do |date|
      period_hash.store((l date, format: :short), date)
    end
    return period_hash
  end
  
  # コマ数のセレクトボックスのデフォルト値
  def set_default_koma(timetable)
    default_koma = 7 unless default_koma = timetable.max_koma # timetable.max_komaがnilの場合
    return default_koma
  end
  
  # タイムテーブルの各コマ毎の時間を作成
  def set_koma_times(timetable)
    unless koma_times = timetable.times # timetable.timesがnilの場合
      koma_times = <<~'EOS'
        8:50~10:20
        10:20~12:30
        12:30~14:30
        14:30~16:10
        16:10~18:00
        18:00~20:00
        20:00~22:00
      EOS
    end
    return koma_times
  end
  
  def set_timetable
    @timetable = Timetable.find(params[:id])
  end
  
  # カレントユーザが保存中のタイムテーブルを取得
  def set_saved_timetables
    @saved_timetables = current_user.timetables.where(saved: true).order(created_at: :desc) if user_saved_timetable?
  end
  
  # タイムテーブルの作成前確認とテンプレート保存の処理（newとeditで同じ処理のためまとめる）
  def timetable_confirm_and_template_process
    if params[:commit_value] == "confirm"                           # 「確認」が実行された場合
      redirect_to confirm_user_timetable_path(current_user, @timetable)
    elsif params[:commit_value] == "template"                       # 「現在の内容を保存」が実行された場合
      if current_user.timetables.where(saved: true).count < 5       # タイムテーブル保存数が５件より少なければ
        @timetable.update_attribute(:saved, true)
        flash[:info] = "作成中のタイムテーブルをテンプレートとして保存しました<br>
                        次回以降いつでも呼び出して使用できます"
      else
        flash[:danger] = "保存可能なタイムテーブルは5件までです"
      end
      redirect_to new_user_timetable_path(current_user)
    else          
      flash[:danger] = "不正な操作です"
      redirect_to root_path
    end
  end
end
