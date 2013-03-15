require 'mysql2'

class MysqlAccess
	
	attr_accessor :connection
		
	def initialize ( host, user, password, database)
		
		raise "Please specify the host" if host.nil?
		raise "Please specify the user" if user.nil?
		raise "Please specify the password" if password.nil?
		raise "Please specify the database" if database.nil?
		
		@connection = Mysql2::Client.new(:host=>"#{host}",:user=>"#{user}",:password=>"#{password}",:database=>"#{database}")
	end

	def insert_into ( table, columns, values )		#columns and values are csv's and values must be specified strings or not using ''
								#return the response from the database
		raise "Please specify the table name" if table.nil?
		raise "Please specify the columns" if columns.nil?
		raise "Please specify the host" if values.nil?
		#puts columns
		#puts values
		#columns  = columns.split(",")
		#values   = values.split(",")
		
		#raise "values insufficient for columns" if (!columns.length==values.length) ?
		
		return self.connection.query("insert into #{table} (#{columns}) values (#{values})") 		
	end
	
	def select_all (table)					#select all values from table passed
		
		raise "Please specify the table name" if table.nil?
		
		return self.connection.query("select * from #{table}")
	end
	
end

		
		
	
