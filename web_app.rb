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

class Pics_url < ActiveRecord::Base
end

class Category < ActiveRecord::Base
end

  	def get_tag_id (tag_name)
                tag = Tag.where(:t_name => tag_name)
                tag.first.t_id
        end

 	def get_pics_urls(tag_name,tag_id,offset,limit)
                res = Pics_url.find_all_by_t_id(tag_id , :offset => offset, :limit => limit)
                pics_array = [] 
		res.each {|r| hash = {:pic_url => "#{r.pic_url}" , :source => r.s_id } ; pics_array << hash }
                response= {:tag =>  tag_name,:pics => pics_array}
                return response         
	end	
		#isf res.first == nil then code = 204 
		#else code = 200 
		#end
			

	def get_json_by_tag (tag,offset,limit)
		name = tag
		name.downcase
		id = get_tag_id(name)
		feed = get_pics_urls(name,id,offset,limit)
		json = {:feed => feed}
		json.to_json
	end
		
	def get_json_by_category (category,offset,limit)
		name = category
		category.downcase
		category = Category.where(:c_name => category)
		id = category.first.c_id
		tags = Tag.where(:category => id)
		feed = []		
		tags.each do |tag|
			id = get_tag_id(tag.t_name)
			feed << get_pics_urls(tag.t_name,id,offset,limit)
		end
		json = {:feed => feed}
		json.to_json
	end


get '/:name/:offset/:limit' do
	get_json_by_tag(params[:name],params[:offset],params[:limit])
end

get '/all/:name/:offset/:limit' do 
	get_json_by_category(params[:name],params[:offset],params[:limit])
end

after do
  ActiveRecord::Base.connection.close
end
