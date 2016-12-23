class Timetable < ApplicationRecord
    # コマ毎の"hh:mm〜hh:mm"を配列で保存
    serialize :times
end
