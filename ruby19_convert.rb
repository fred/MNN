names = %w{group draft partial select joins use language_id item foreign_key association_foreign_key 
	join_table published_at body author_name source_url featured suspicious marked_spam email 
	class title url path protocol ref alt link_title priority highlight format handlers text count 
	href name password action method post get category_id abstract abstract abstract website phone_number
	mobile_number country country user_id password_confirmation type locale send_emails factory user page
	admin_user rows cols placeholder rel window remote confirm selected target html id locals with_currency only_path }

names.each do |t|
  system("find ./ -type f | xargs gsed -i 's/:#{t} => /#{t}: /g'")
end

