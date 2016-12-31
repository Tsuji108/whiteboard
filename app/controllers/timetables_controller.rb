class TimetablesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :prohibit_direct_access, only: [:applay_saved_timetable, :destroy_saved_timetable, :confirm]
  before_action :admin_user,     only: [:new, :create, :edit, :update, :applay_saved_timetable, :destroy_saved_timetable, :confirm]
  before_action :set_timetable, only: [:show, :edit, :update, :destroy_saved_timetable, :confirm, :publish_timetable]
  before_action :set_saved_timetables, only: [:new, :create, :edit, :update, :applay_saved_timetable, :destroy_saved_timetable]
  
  def show
    @timetable_date = "<th></th>"  # タイムテーブル左上の空セルを最初に登録
    @space_cell = ""               # 空のセル
    @timetable.from_date.upto(@timetable.to_date) do |date|
      @timetable_date += "<th class='center'>#{(l date, format: :short)}</th>"
      @space_cell += "<td></td>"
    end
  end
  
  def new
    @timetable = current_user.timetables.build()
    @period_hash = create_timetable_period                  # 期間のセレクトボックス選択肢
    @default_from_date = set_default_from_date(@timetable)  # from_dateの初期値を設定
    @default_to_date = set_default_to_date(@timetable)      # to_dateの初期値を設定
    @times = set_koma_times(@timetable)                     # 各コマ毎の時間の値
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
    @period_hash = create_timetable_period                  # 期間のセレクトボックス選択肢
    @default_from_date = set_default_from_date(@timetable)  # from_dateの初期値を設定
    @default_to_date = set_default_to_date(@timetable)      # to_dateの初期値を設定
    @times = set_koma_times(@timetable)                     # 各コマ毎の時間の値
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
    @period_hash = create_timetable_period                  # 期間のセレクトボックス選択肢
    @default_from_date = set_default_from_date(@timetable)  # from_dateの初期値を設定
    @default_to_date = set_default_to_date(@timetable)      # to_dateの初期値を設定
    @times = set_koma_times(@timetable)                     # 各コマ毎の時間の値
    flash.now[:info] = "選択したテンプレートを適用しました"
    render :new
  end
  
  def destroy_saved_timetable
    @timetable.destroy
    flash[:danger] = "選択したテンプレートを削除しました"
    redirect_back(fallback_location: root_path)
  end
  
  def confirm
    @timetable_date = "<th></th>"  # タイムテーブル左上の空セルを最初に登録
    @space_cell = ""               # 空のセル
    @timetable.from_date.upto(@timetable.to_date) do |date|
      @timetable_date += "<th class='center'>#{(l date, format: :short)}</th>"
      @space_cell += "<td></td>"
    end
  end
  
  def publish_timetable
    @timetable.update_attribute(:published, true)
    flash[:info] = "タイムテーブルを作成しました"
    redirect_to user_timetable_path(current_user, @timetable)
  end
  
  private
  
  # ストロングパラメータの設定
  def timetable_params
    params.require(:timetable).permit(:from_date, :to_date, :times)
  end
  
  # タイムテーブルを作成する期間のセレクトボックス選択肢
  def create_timetable_period
    period_hash = Hash.new
    (Date.today - 2.weeks).upto(Date.today + 1.month) do |date|
      period_hash.store((l date, format: :short), date)
    end
    return period_hash
  end
  
  # from_dateの初期値を設定
  def set_default_from_date(timetable)
    if timetable.from_date.nil? || self.action_name == 'applay_saved_timetable' # timetable.from_dateがnilまたはapplay_saved_timetableアクションから呼び出された場合
      default_from_date = Date.today
    else
      default_from_date = timetable.from_date
    end
    return default_from_date
  end
  
  # to_dateの初期値を設定
  def set_default_to_date(timetable)
    if timetable.to_date.nil?                           # timetable.to_dateがnilの場合
      if Timetable.where(published: true).last.nil?       # 公開済みのタイムテーブルが存在しない場合
        default_to_date = Date.today + 6                  # 今日から６日後を指定
      else                                                # 公開済みのタイムテーブルが存在する場合
        default_to_date = Date.today + (Timetable.where(published: true).last.to_date - Timetable.where(published: true).last.from_date)
      end
    elsif self.action_name == 'applay_saved_timetable'  # applay_saved_timetableアクションから呼び出された場合
      default_to_date = Date.today + (timetable.to_date - timetable.from_date)  # 今日からテンプレートで保存された日数後を指定
    else
      default_to_date = timetable.to_date
    end
    return default_to_date
  end
  
  # タイムテーブルの各コマ毎の時間を作成
  def set_koma_times(timetable)
    unless koma_times = timetable.times             # timetable.timesが存在しない場合(newページの場合)
      if Timetable.where(published: true).last.nil? # 公開済みのタイムテーブルが存在しない場合
        koma_times = <<~'EOS'
          8:50~10:20
          10:20~12:30
          12:30~14:30
          14:30~16:10
          16:10~18:00
          18:00~20:00
          20:00~22:00
        EOS
      else                                          # 公開済みのタイムテーブルが存在する場合
        koma_times = Timetable.where(published: true).last.times
      end
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
    # エラー処理
    message = ""
    message += "期間が不正です<br>" if @timetable.from_date > @timetable.to_date            # to_dateがfrom_dateよりも過去のとき
    message += "各コマの時間を記入してください" if @timetable.times.chomp("").blank?        # 各コマの時間が空白のとき
    message += "各コマの時間は500字以内で記入してください" if 500 < @timetable.times.length # 各コマの時間は500字以上のとき
    unless message.blank?
      flash[:danger] = message
      redirect_back(fallback_location: root_path)
      return
    end
    
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
      #redirect_to edit_user_timetable_path(current_user, @timetable)
      redirect_to new_user_timetable_path(current_user)
    else          
      flash[:danger] = "不正な操作です"
      redirect_to root_path
    end
  end
end
