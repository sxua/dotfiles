class Pry
  def self.ar
    if defined? ActiveRecord
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      return "ActiveRecord logger changed"
    else
      return "There's no ActiveRecord found"
    end
  end
end

if Kernel.const_defined?("Rails") then
  require File.join(Rails.root,"config","environment")
  require 'rails/console/app'
  require 'rails/console/helpers'
  Pry::RailsCommands.instance_methods.each do |name|
    Pry::Commands.command name.to_s do
      Class.new.extend(Pry::RailsCommands).send(name)
    end
  end
end