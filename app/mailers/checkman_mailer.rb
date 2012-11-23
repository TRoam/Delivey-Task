class CheckmanMailer < ActionMailer::Base
  default from: "liulangdewoniu@gmail.com"
  
  def checkman_error_email(person)
    @person = person
    @checkman = @person.checkmen.find_all_by_status("open")
    @url = "http://10.59.154.73/people/#{@person.id}/detail" 
    mail(:to => @person.email,:subject=>"just for a test")   
  end	
end
