require "date"

class Song < Hash
	def initialize(args)
		args.each do |s|
			k,v = s.split(/: /)
			k.downcase!
			case k
			when 'file'
				Song.parse_file self, k, v
			when /-modified/
				self[k] = DateTime.parse v
				self['onair'] = self[k] unless self.has_key? 'onair'
			when 'time'
				self[k] = v.to_f
			when 'pos', 'id'
				self[k] = v.to_i
			else
				self[k] = v
			end
		end
	end


	def playtime
		if self.has_key? 'time'
			(Time.parse("1/1") + time).strftime("%H:%M")
		else
			"?"
		end
	end

	def self.parse_file(hash,k,v)
		v.force_encoding('utf-8')
		hash[k] = v
		v =~ /\.(\d{4}-\d{2}-\d{2}(T\d{2}=\d{2})?)\./
		if $1
			onair = $1.sub(/=/, ":")
			hash['onair'] = DateTime.parse onair
			hash['title'] = v.split(/\./)[0]
		else
			hash['title'] = v
		end
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