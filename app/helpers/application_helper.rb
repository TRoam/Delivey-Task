module ApplicationHelper
  def link_to_add_fields(name, f, type)
  new_object = f.object.send "build_#{type}"
  id = "new_#{type}"
  fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
    render(type.to_s + "_fields", f: builder)
   end
  link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
 

  def button_to_remove_fields(name, f)
    content_tag :button, name, class: 'remove_fields'
  end
  
  def button_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: "new_#{type}") do |builder|
      render(type.to_s + "_fields", f: builder)
    end
    content_tag :button, name, :class => 'add_fields', 'data-field-type' => type, 'data-content' => "#{fields}"
  end

  def button_to_nest_fields(name, type)
    content_tag :button, name, :class => 'nest_fields', 'data-field-type' => type
  end
end
