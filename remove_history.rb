require 'rubygems'
require 'sqlite3'

keywords = File.open("keywords.txt").readlines.collect {|k| k.chomp}.reject {|k| k == ""}

for db_name in ["History", "Archived History"]
  f = File.expand_path("~/Library/Application Support/Google/Chrome/Default/#{db_name}")
  db = SQLite3::Database.open(f)
  q = keywords.collect {|k| "url LIKE '%#{k}%' or title LIKE '%#{k}%' "}.join(" or ")
  url_ids = db.execute( "SELECT id FROM urls WHERE #{q}" ).collect {|i| i[0].to_i}
  next if url_ids.empty?
  q = url_ids.collect {|id| "'#{id}'"}.join(", ")
  db.execute(" DELETE FROM urls WHERE id IN (#{q})")
  q = url_ids.collect {|id| "'#{id}'"}.join(", ")
  db.execute(" DELETE FROM visits WHERE url IN (#{q})")
  
end