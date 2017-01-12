# ログ出力先ファイルを指定
set :output, 'log/crontab.log'

# 実行環境を指定
set :environment, :production
 
# 毎日am4:00に実行
every 1.day, at: '4:00 am' do
  runner 'MailingList.delete_old_mails'               # 3年以上前のメールを過去のメール一覧から削除
  runner 'MailingList.delete_non_send_mails'          # 1時間以上送信していないメールを削除
  runner 'Timetable.delete_old_timetables'            # 3年以上前のタイムテーブルを過去のタイムテーブル一覧から削除
  runner 'Timetable.delete_non_published_timetables'  # 1時間以上公開していないタイムテーブルを削除
end

# 毎週日曜am4:00に実行
every :sunday, at: '4:00 am' do
  runner 'User.delete_non_activated_users' # 1時間以上アカウントを有効化していないユーザを削除
end


