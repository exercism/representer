module ETL
    extend self

    def transform(legacy : Hash(String, Array(String))) : Hash(String, Int32)
        legacy.reduce({} of String => Int32) do |shiny_new, (score, letters)|
            letters.each do |l|
                shiny_new[l.downcase] = score.to_i
            end
            shiny_new
        end
    end
end
