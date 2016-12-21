# ログ出力先ファイルを指定
set :output, 'log/crontab.log'

# 実行環境を指定
set :environment, :production
 
# 毎日am4:00に実行
every 1.day, at: '4:00 am' do
  runner 'MailingList.delete_old_mails' # １年以上前のメールを過去のメール一覧から削除
end

# 毎週日曜am4:00に実行
every :sunday, at: '4:00 am' do
  runner 'User.delete_non_activated_users' # 1時間以上アカウントを有効化していないユーザを削除
end


