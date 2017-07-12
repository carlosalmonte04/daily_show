require 'byebug'
require 'CSV'
require 'pry'
require 'sqlite3'
require 'active_support/inflector'

# binding.pry
DB = {:conn => SQLite3::Database.new('./daily_show.db')}



# DB[:conn].execute(sql)

csv = CSV.read('../daily_show_guests_true.csv')
headers = csv[0]

year = headers[0]
occupation = headers[1]
show = headers[2]
group = headers[3]
guest_list = headers[4]

csv_content = csv[1..csv.length - 1]

csv_content.each do |attributes|
		


	# check if year exists before persist
	year_found = DB[:conn].execute("SELECT * FROM years WHERE year = #{attributes[0]};")

	# if no year found persist to database
	if year_found.empty?
		DB[:conn].execute("INSERT INTO years (year) VALUES (#{attributes[0]});")
	end

	show_found = DB[:conn].execute("SELECT * FROM shows WHERE showdate = '#{attributes[2]}';")

	if show_found.empty?
		year_id = DB[:conn].execute("SELECT id FROM years WHERE year = #{attributes[0]}").flatten.first
		DB[:conn].execute("INSERT INTO shows (showdate, year) VALUES ('#{attributes[2]}', '#{year_id}');")
	end

	group_found = DB[:conn].execute("SELECT * FROM groups WHERE name = '#{attributes[3]}';")

	if group_found.empty?
		DB[:conn].execute("INSERT INTO groups (name) VALUES ('#{attributes[3]}');")
	end

	occupation_found = DB[:conn].execute("SELECT * FROM occupations WHERE name = '#{attributes[1]}';")

	if occupation_found.empty?
		group_id = DB[:conn].execute("SELECT id FROM groups WHERE name = '#{attributes[3]}'").flatten.first
		DB[:conn].execute("INSERT INTO occupations (name, group_id) VALUES ('#{attributes[1]}', #{group_id});")
	end

	if attributes[4].chars.include?("'")
		attributes[4].gsub!("'", " ")
	end 

	split_array = [" and ", "&", ","]

	attributes[4].split.each_with_index do |word, ind|
		if split_array.include?(word)
			word.gsub!(split_array[split_array.index(word)], ",")
		end
	end

	attributes[4].split(", ").each do |guest|

		guest_found = DB[:conn].execute("SELECT * FROM guests WHERE name = '#{guest}';")
			if guest_found.empty?
				occupation_id = DB[:conn].execute("SELECT id FROM occupations WHERE name = '#{guest}';")
				DB[:conn].execute("INSERT INTO guests (name, occupation) VALUES ('#{guest}', '#{attributes[1]}');")
		# binding.pry
			end
	end
end

csv_content.each do |attributes|
	# debuggerexitsdfasdfasdf
	guest_id = DB[:conn].execute("SELECT id FROM guests WHERE name = '#{attributes[4]}'").flatten.first
	show_id = DB[:conn].execute("SELECT id FROM shows WHERE showdate = '#{attributes[2]}'").flatten.first
	next if guest_id.nil? || show_id.nil?

	DB[:conn].execute("INSERT INTO show_guests (show_id, guest_id) VALUES (#{show_id}, #{guest_id})")
	

end



























