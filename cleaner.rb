require 'rubygems'
require 'vpim'
require 'highline/import' 
require 'pp'

def debug_print(s)
   puts s if false
end         


@input_file = ARGV[0] #'/Users/user/Documents/address_book_export/vCards_All.vcf'     

if ARGV.size < 1
  puts "Please supply vCard argument."
  puts "Example: ruby #{$0} /path/to/your.vcf"
  exit
end

#MENU
@choices = {:missing_phone => 'Missing Phone', :missing_email => 'Missing Email', :missing_phone_and_email => 'Missing Phone and Email'}
# delete if no phone                => :delete_if_no_phone
# delete if no email                => :delete_if_no_email
# delete if no phone and no email   => :delete_if_no_phone_and_email
@user_choice = choose do |menu|
  menu.prompt = "Please choose type of vCard cleansing?"
  @choices.each_value do |choice|
    menu.choice(choice)     
  end    
end                                              
debug_print @user_choice = @choices.invert[@user_choice]

@vcards_array = Vpim::Vcard.decode(File.open(@input_file)) 
@original_size = @vcards_array.size        
@continue = ask("You are about to delete contacts. Type 'yes' to continue.")
exit if @continue.downcase != 'yes'
     
case @user_choice
when :missing_phone
 @vcards_array.delete_if {|card| 
   debug_print  card.telephones.size < 1 ? "No telephones" : "#{card.telephones.size} phones present"
   card.telephones.size < 1
   }

when :missing_email
 @vcards_array.delete_if {|card| 
   debug_print  card.emails.size < 1 ? "No emails" : "#{card.emails.size} emails present"
   card.emails.size < 1
   }                         
   
when :missing_phone_and_email
 @vcards_array.delete_if {|card| 
   debug_print  card.telephones.size < 1 ? "No telephones" : "#{card.telephones.size} phones present"  
   debug_print  card.emails.size < 1 ? "No emails" : "#{card.emails.size} emails present"
   card.telephones.size < 1 && card.emails.size}
end   

puts "vcards_array size: #{@original_size} | cleaned_vcards size: #{@vcards_array.size}"
#write the cleaned file 
@output_file = "#{@input_file[0..@input_file.rindex('.')-1]}_#{Time.now.to_i}.vcf" 
debug_print @output_file
File.open(@output_file,'w') {|f| f << @vcards_array.to_s }


          



      



