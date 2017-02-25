#run in rails
User.where.not(:phone_number => nil).all.each do |user|
  puts user.phone_number
  phone_number = user.phone_number.gsub(/\D/, '')
# end
  if phone_number.length <= 10
    phone_number = "+1" + phone_number
  elsif phone_number[0] != "+"
    phone_number = "+" + phone_number
  end
  puts phone_number
  user.phone_number = phone_number
  user.save!
end
