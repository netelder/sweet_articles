class Legacy < ActiveRecord::Base
  establish_connection "old_database"
  
end
