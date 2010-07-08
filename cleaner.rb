require 'rubygems'
require 'vpim'
require 'highline/import' 
require 'pp'

def debug_print(s)
   puts s if true
end         

@input_file = '/Users/hbeaver/Documents/address_book_export/vCards_All.vcf'     

@choices = {:missing_phone => 'Missing Phone', :missing_email => 'Missing Email', :missing_phone_and_email => 'Missing Phone and Email'}
# delete if no phone                => :delete_if_no_phone
# delete if no email                => :delete_if_no_email
# delete if no phone and no email   => :delete_if_no_phone_and_email
@user_choice = choose do |menu|
  menu.prompt = "Please type of vCard cleansing?  "
  @choices.each_value do |choice|
    menu.choice(choice)     
  end    
end                                              
debug_print @user_choice = @choices.invert[@user_choice]

# @file_string = File.open('/Users/hbeaver/Documents/address_book_export/vCards_All.vcf', 'r').readlines.to_s  
#puts vcard_string

@vcards_array = Vpim::Vcard.decode(File.open(@input_file))
@to_delete_indexes = []          

#clean
@vcards_array.each_with_index do |card,index|   
     
  case @user_choice
  when :missing_phone
   debug_print  card.telephones.size < 1 ? "No telephones" : "#{card.telephones.size} phones present"
   @to_delete_indexes << index if card.telephones.size < 1
   #puts card.telephones.empty? ? "telephones empty" : "telephones present"
  when :missing_email
   debug_print  card.emails.size < 1 ? "No emails" : "#{card.emails.size} emails present"   
   @to_delete_indexes << index if card.emails.size < 1 
  when :missing_phone_and_email
   debug_print  card.telephones.size < 1 ? "No telephones" : "#{card.telephones.size} phones present"  
   debug_print  card.emails.size < 1 ? "No emails" : "#{card.emails.size} emails present"
   @to_delete_indexes << index if card.telephones.size < 1 && card.emails.size
  end   
end 

# pp @to_delete_indexes  
@continue = ask("You are about to delete #{@to_delete_indexes.size} contacts. Type 'yes' to continue.")
exit if @continue.downcase != 'yes' 

#do the cleanup
@to_delete_indexes.each{|idx| @vcards_array.delete_at(idx) } 
@output_file = "#{@input_file[0..@input_file.rindex('.')-1]}_#{Time.now.to_i}.vcf" 
debug_print @output_file   
File.open(@output_file,'w') {|f| f << @vcards_array.to_s }


          



      



