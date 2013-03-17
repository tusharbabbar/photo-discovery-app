x = File.dirname(File.expand_path('__FILE__'))
require x+'/dbupdater.rb'
	
dbupdater = DbUpdater.new
dbupdater.update_Db

