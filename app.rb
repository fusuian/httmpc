#!/usr/bin/env ruby
require "sinatra"
require "sinatra/reloader"
require "net/telnet"
require "time"
require "pp"

require "./lib/song"

$mpdhost = "soundwave.local"
$mpdport = 6600


get '/' do
	redirect '/listall'
end



def fetch_songs(cmd)
	songs = []
	info = []
	res = term.cmd(cmd)
	infos = res.split(/\n/)
	infos.pop
	infos.each do |s|
	 	if s =~ /^file:/ && info.size > 0
	 		songs << Song.new(info)
	 		info = []
	 	end
	 	info << s
	end
	songs << Song.new(info) if info.size > 0
	songs
end

@term = nil

def term
	pp ['term', @term && @term.sock.closed?]
	if @term == nil || @term.sock.closed?
		@term = Net::Telnet.new("Host" => $mpdhost, "Port" => $mpdport, 
				"Prompt"=>/OK/, "Telnetmode" => false, "Binmode" => true)
		@term.waitfor /^OK.*$/
	end
	@term
end

post '/add/:file' do |file|
	content_type :json
	res = term.cmd("add #{file}")
	{action: 'add', file: file, responce: res}.to_json
end


delete '/delete/:id' do |id|
	content_type :json
	res = term.cmd("deleteid #{id}")
	{action: 'delete', id: id, responce: res}.to_json
end


post '/play/:id' do |id|
	content_type :json
	res = term.cmd("playlistid #{id}")
	{action: 'play', id: id, responce: res}.to_json
end

post '/play' do
	content_type :text
	term.cmd("play")
end


post '/pause' do 
	content_type :text
	term.cmd("pause")
end


post '/next' do
	content_type :text
	term.cmd("next")
end

post '/previous' do
	content_type :text
	term.cmd("previous")
end


post '/seekcur/:sec' do |sec|
	content_type :text
	res = term.cmd("seekcur #{sec}")
	"#{res}: seekcur #{sec}"
end


get '/playlist' do
	begin
		@title = "PlayList"
		@songs = fetch_songs 'playlistinfo'
		erb :playlist, layout: :template
		# pp songs

	rescue Errno::ECONNREFUSED
		"#{$mpdhost}:#{$mpdport} mpdホストへの接続失敗"
	end
end


get '/listall' do
	begin
		@title = "List"
		@songs = fetch_songs 'listallinfo'
		# @songs = @songs.sort_by {|s| s.onair }.reverse
		
		erb :listall, layout: :template
		# pp songs

	rescue Errno::ECONNREFUSED
		"#{$mpdhost}:#{$mpdport} mpdホストへの接続失敗"
	end
end


def stat2hash(res)
	stats = res.split(/\n/)
	stats.pop
	hash = {}
	stats.each do |s|
		k,v = s.split(/: /)
		hash[k] = v
	end
	hash
end

get '/playing' do 
	begin
		res = term.cmd('status')
		status = stat2hash(res)
		
		playing = {}
		playing['state'] = status['state']

		if playing['state'] == 'stop'
			playing['title'] = 'stopping'
			playing['elapsed'] = '--:--'
			playing['time'] = '--:--'
		
		else
			playing['elapsed'] = status['elapsed'].to_f
			songs = fetch_songs('currentsong')
			# pp ['songs: ', songs]
			song = songs[0]
			playing['title'] = song.title
			playing['time'] = song.time.to_i
		end
		
		playing.to_json

	rescue Errno::ECONNRESET, Errno::EPIPE
		return {}.to_json
	end

end

