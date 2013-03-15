path = File.dirname(File.expand_path(__FILE__))
require path+'/mysqlaccess.rb'
require path+'/geturls'
class DbUpdater
	attr_accessor :dbaccessor , :tags, :search_words, :date
	
	def initialize 
		@dbaccessor = MysqlAccess.new("localhost","tushar","samael321","pics_app_db")
		@date = DateTime.now.to_s.split("T").first
	end

	def getTags
		puts "getTags"
		@tags = self.dbaccessor.select_all("tags")
		@search_words = self.dbaccessor.select_all("search_words")
	end
	
#	def getEyeemUrls(search_word,limit)
#		x = dbaccessor.connection.query("select * from search_words where search_word = '#{search_word}';")
#		offset = x.first["eyeem_offset"]
#		puts offset
#		total = x.first["eyeem_total"]
#		response = ""
#		if total > limit+offset
#			res = dbaccessor.connection.query("select * from eyeem_pics where search_word = '#{search_word}' limit #{limit} offset #{offset};")	
#			res.each do |r|
#				response += r["url"]+","
#			end
#			dbaccessor.connection.query("update search_words set eyeem_offset = #{offset + limit} where search_word = '#{search_word}';")
#		else
#			limit -= total-offset
#			res = dbaccessor.connection.query("select * from eyeem_pics where search_word = '#{search_word}' limit #{total-offset} offset #{offset};")
#			res.each do |r|
#				response += r["url"]+","
#			end
#			if limit > 0
#				res = dbaccessor.connection.query("select * from eyeem_pics where search_word = '#{search_word}' limit #{limit} offset 0;")
#				res.each do |r|
#				response += r["url"]+","
#				end	
#			end
#			dbaccessor.connection.query("update search_words set eyeem_offset = #{limit} where search_word = '#{search_word}';")
#		end
#	end
	
	def getUrls(t_id , type)
		puts "getUrls"
		search_words = self.search_words.select {|s| s["t_id"]==t_id}
		divider = search_words.length
		puts search_words
		puts type
		case type
#			when 3
#				urls = ["","","","",""]
#				search_words.each do |search_word|
#					urls[0]+= Geturls.fromFlickr(search_word["search_word"],1500/divider)
#					urls[1]+= Geturls.fromInstagram(search_word["search_word"],1500/divider)
#					urls[2]+= Geturls.fromSmugmug(search_word["search_word"],500/divider)
#					urls[3]+= Geturls.fromFive(search_word["search_word"],500/divider)
#					urls[4]+= getEyeemUrls(search_word["search_word"],500/divider)
#				end
#				urls.each_with_index do |url,i| 
#					urls[i] = url.split(",") 
#					urls[i] = urls[i].shuffle!
#					urls[i] = [urls[i].slice(0,300),urls[i].slice(300,urls[i].length)]
#				end
#				urls.each do |url| urls1 << url[0] ; urls2 << url[1] end
#				urls1 = urls1.flatten.shuffle!
#				urls2 = urls2.flatten.shuffle!
#				response = [urls1,urls2]
#				response = response.flatten
#				return response	
	
			 when 2
				urls = ""
			 	search_words.each do |search_word|
                                       	urls+= Geturls.fromInstagram(search_word["search_word"],5000/divider)
                                end
                                response = urls.split(",").shuffle!
                                return response
                           
			 when 1
			 	urls = ["","","","",""]
				urls1,urls2 = [],[]
			  	search_words.each do |search_word|
			 	       	urls[0]+= Geturls.fromFlickr(search_word["search_word"],1625/divider)
			 	       	urls[1]+= Geturls.fromInstagram(search_word["search_word"],1625/divider)
			 	        urls[2]+= Geturls.fromSmugmug(search_word["search_word"],625/divider)
			 	        urls[3]+= Geturls.fromFive(search_word["search_word"],625/divider)
			 	end
			 	urls.each_with_index do |url,i|
			 	        urls[i] = url.split(",")
			 	        urls[i] = urls[i].shuffle!
			 	        urls[i] = [urls[i].slice(0,400),urls[i].slice(400,urls[i].length)]
				end
				urls.each do |url| urls1 << url[0] ; urls2 << url[1] end
                                urls1 = urls1.flatten.shuffle!
                                urls2 = urls2.flatten.shuffle!
                                response = [urls1,urls2]
                                response = response.flatten
                                return response
		end
	end
	
	def update_Db 
		puts "update_Db"
		self.getTags
		self.tags.each do |tag|
			db_feed = getUrls(tag["t_id"],tag["search_type"])
			db_feed.each do |url_string|
				url,source = url_string.split("|")
				self.db_accessor.insert_into("pics_urls","t_id, s_name, pic_url, added_on","#{t_id},'#{source}','#{url}',#{self.date}")
			end
		end
	end
end	
