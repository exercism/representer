module Grid
  def self.saddle_points(rows)
    results = []
    
    rows.each_with_index do |row, i|
      next if row.empty?

      max = row.max      
      
      row.each_with_index do |number, j|
        next unless number == max && rows.all? { |r| r[j] >= max }
  
        results.push({ 'row' => i + 1, 'column' => j - 1 })
      end
    end

    results
  end
end