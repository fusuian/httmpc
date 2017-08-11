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




