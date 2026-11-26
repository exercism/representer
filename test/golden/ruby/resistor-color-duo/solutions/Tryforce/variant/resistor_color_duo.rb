class ResistorColorDuo
    COLORS = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']

    def self.value(colorList)
        result = COLORS.index(colorList[0]).to_s - COLORS.index(colorList[1]).to_s
        result.to_i
    end
end