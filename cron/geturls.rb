require 'open-uri'
require 'json'

module Geturls			# The methods defined here will be called to get urls from different API's
				# to dump those urls into the app_db
FL_MR = 500
SM_MR = 100
FI_MR = 100
IN_MR = 20
	
	def Geturls.fromFlickr (search_word, limit) 		#limit tells how many urls  
				                    		#are to be searched	
		pages = limit/FL_MR + 1		
		counter = 0
		picUrlString = ""
		pages.times do |page|
			page = page + 1 
			json = JSON.parse(open("http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=510f1250100da2839e65772ce28fce10&tags=#{search_word}&format=json&nojsoncallback=1&page=#{page}&per_page=500&content_type=1&safe_search=1").read)
			pics = json["photos"]["photo"]
			pics.each do |pic|
				if counter >= limit then break end
				counter += 1
				secret = pic["secret"]
				server = pic["server"] 
				id = pic["id"]
				url = "http://farm9.staticflickr.com/#{server}/#{id}_#{secret}_b.jpg"
				picUrlString = picUrlString + url + "|" + "flickr" + ","
			end
		if counter >= limit then break end
		end
		return picUrlString
	end
	
	def Geturls.fromFive (search_word, limit) 		#limit tells how many urls  
                                                    		#are to be searched 
                pages = limit/FI_MR + 1
                counter = 0
		picUrlString = ""
                pages.times do |page|
                        page = page + 1
                        json = JSON.parse(open("https://api.500px.com/v1/photos/search?tag=#{search_word}&consumer_key=0qZ6Mzm0cVzOh2jbS2d1NuKtE3eYXcNhSL9OgPsA&page=#{page}&rpp=100").read)
                        pics = json["photos"]
                        pics.each do |pic|
                                if counter >= limit then break end
                                counter += 1
                                url = pic["image_url"]
                                picUrlString = picUrlString + url + "|" + "500px" + ","
                        end
                if counter >= limit then break end
                end
		return picUrlString
	end			
	
	def Geturls.fromInstagram (search_word, limit)		 #limit tells how many urls  
                                                       		 #are to be searched 
                pages = limit/IN_MR + 1
                counter = 0
		picUrlString = ""
                pages.times do |page|
                        page = page + 1
                        json = JSON.parse(open("https://api.instagram.com/v1/tags/#{search_word}/media/recent?access_token=294775657.bd2837c.296a258a3b62498d81ed550768157c64&page=#{page}").read)
                        pics = json["data"]
                        pics.each do |pic|
                                if counter >= limit then break end
				counter += 1                               
				url = pic["images"]["low_resolution"]["url"]
                                picUrlString = picUrlString + url + "|" + "instagram" + ","
                        end
                	if counter >= limit then break end
			sleep 1
                end
		return picUrlString
	end
	
	def Geturls.fromSmugmug (search_word, limit) 		#limit tells how many urls  
                                                     		#are to be searched 
                offset = 0
                counter = 0
		picUrlString = ""
                while counter < limit
                        json = JSON.parse(open("http://www.smugmug.com/services/api/json/1.4.0/?Query=#{search_word}&Size=100&SortBy=relevance&method=rpc.search.images&Start=#{offset}").read)
                        pics = json["Akamai"]
                        pics.each do |pic|
                                if counter >= limit then break end
				counter += 1                               
				url = pic.gsub("PreFetchURL=","")
                                picUrlString = picUrlString + url + "|" + "smugmug" + ","
                        end
			offset +=counter
                end
		return picUrlString
	end
end
	
