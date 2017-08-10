#!/usr/bin/env ruby
require "sinatra"
require "sinatra/reloader"
require "net/telnet"

require "./lib/song"

$mpdhost = "soundwave.local"
$mpdport = 6600


get '/' do
	redirect '/listall'
end



def fetch_songs(cmd)
	songs = []
	info = []
	res = @term.cmd(cmd)
	@term.close
	res.split(/\n/).each do |s|
	 	if s =~ /^file:/ && info.size > 0
	 		songs << Song.new(info)
	 		info = []
	 	end
	 	info << s
	end
	songs << Song.new(info) if info.size > 0
	songs
end



get '/playlist' do
	begin
		@title = "PlayList"
		@term = Net::Telnet.new("Host" => $mpdhost, "Port" => $mpdport, 
			"Prompt"=>/OK/, "Telnetmode" => false, "Binmode" => true)
		@term.waitfor /^OK.*$/
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
		@term = Net::Telnet.new("Host" => $mpdhost, "Port" => $mpdport, 
			"Prompt"=>/OK/, "Telnetmode" => false, "Binmode" => true)
		@term.waitfor /^OK.*$/

		@songs = fetch_songs 'listallinfo'
		# @songs = @songs.sort_by {|s| s.onair }.reverse
		
		erb :listall, layout: :template
		# pp songs

	rescue Errno::ECONNREFUSED
		"#{$mpdhost}:#{$mpdport} mpdホストへの接続失敗"
	end
end



