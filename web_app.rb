require 'sinatra'
require 'active_record'
require 'json'

ActiveRecord::Base.establish_connection(
:adapter => "mysql2",
:host => 'localhost',
:user=> 'tushar',
:password => "samael321",
:database => "pics_app_db",
)

class Tag < ActiveRecord::Base
end

  	def get_tag_id (tag_name)
                name = tag_name
                name.downcase
		10.times do puts name end
                tag = Tag.where(:t_name => name)
                tag.first.t_id
        end

 	def get_pics_urls  tag_id, offset , limit
                id = tag_id
                #offset = :offset
                #limit = :limit
                res = Pics_url.find_all_by_t_id(id , :offset => offset, :limit => limit)
                pics_array = []
                res.each {|r| hash = {:pic_url => "#{r.pic_url}" , :source => r.s_id } ; pics_array << hash }
                json = {:feed => pics_array}
                json.to_json
         end	
	
		

class Pics_url < ActiveRecord::Base
end

get '/:name/:offset/:limit' do
	#get_tag_id("#{params[:name]}")	
	get_pics_urls get_tag_id("#{params[:name]}") ,params[:offset],params[:limit]
	#Search_Word.get_search_words(Tag.get_tag_id "dogs") 
end

after do
  ActiveRecord::Base.connection.close
end

