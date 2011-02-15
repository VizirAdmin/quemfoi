module ApplicationHelper

 def link_to_add_participant(name, f)  
    new_participant = Participant.new  
    fields = f.fields_for( :participants, 
                          new_participant, 
                          :child_index => "new_participant") do |builder|  
      render("participant_fields", :pf => builder)  
    end
    p #{fields}  
    link_to_function(name, h("add_fields(this, 'participants', '#{escape_javascript(fields)}')"))  
  end  
  
end
