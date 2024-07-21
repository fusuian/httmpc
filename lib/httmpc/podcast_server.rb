require 'sinatra'
require 'sinatra/json'
require 'fileutils'

# エピソードのリストを生成
def load_podcasts
  exts = %w(mp3 m4a opus ts)
  episodes = Dir.glob(File.join($music_dir, "*.{#{exts * ','}}")).map do |file|
    if File.file?(file)
      title, date, extension = File.basename(file).split('.')
      date.sub!(/=/, ':')
      audio_url = File.join $music_dir, file
      { title: title, date: date, audio_url: file }
    end
  end
  episodes
end

# ポッドキャストエピソードのリストを返すエンドポイント
get '/podcasts' do
  podcasts = load_podcasts
  json podcasts
end

# 静的ファイルを提供するための設定
set :public_folder, $music_dir
