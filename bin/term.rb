require "net/telnet"
require "pp"
require "song"

mpdhost = "soundwave.local"
mpdport = 6600

begin
	term = Net::Telnet.new("Host" => mpdhost, "Port" => mpdport, 
		"Prompt"=>/OK/, "Telnetmode" => false, "Binmode" => true)
	#sleep 0.5
rescue Errno::ECONNREFUSED
	$stderr.puts "#{mpdhost}:#{mpdport} mpdホストへの接続失敗"
	exit 1
end


term.waitfor /^OK.*$/
#term.cmd 'ping'
#pp term.cmd 'stats'

songs = []
info = []
term.cmd('playlistinfo').split(/\n/).each do |s|
 	p [s, info.size]
 	if s =~ /^file:/ && info.size > 0
 		pp info
 		songs << Song.new(info)
 		info = []
 	end
 	info << s
end
pp songs
songs.each do |song|
	pp song
end
pp term.cmd 'ping'
