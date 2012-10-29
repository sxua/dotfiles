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