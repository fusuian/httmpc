require "date"

class Song < Hash
	def initialize(args)
		if args.size == 1
			Song.parse_file self, *args.first.split(/: /)
		else
			args.each do |s|
				k,v = s.split(/: /)
				k.downcase!
				case k
				when 'file'
					Song.parse_file self, k, v
				when /-modified/
					self[k] = DateTime.parse v
				when 'time'
					self[k] = v.to_f
				when 'pos', 'id'
					self[k] = v.to_i
				else
					self[k] = v
				end
			end
		end
	end


	def self.parse_file(hash,k,v)
		hash[k] = v
		v =~ /\.(\d{4}-\d{2}-\d{2}T\d{2}=\d{2})\./
		onair = $1.sub(/=/, ":")
		hash['onair'] = DateTime.parse onair
		hash['title'] = v.split(/\./)[0]
	end


	def method_missing(method_name)
		method_key = method_name.to_s
		if self.key? method_key
			self[method_key]
		else
			super
		end
	end
	
end