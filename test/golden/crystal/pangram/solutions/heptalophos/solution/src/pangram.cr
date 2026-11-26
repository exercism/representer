module Pangram
    extend self

    def pangram?(phrase : String)
        ('a'..'z').to_a.each do |c|
            return false if !c.in?(phrase.downcase)
            c < 'z' ? next : return true
        end
    end
end
