class Zone
    attr_accessor :value

    @@playerOneSymbol = "[\u25CB]" #white circle
    @@playerTwoSymbol = "[\u25CF]" #black circle
    @@emptySymbol = "[ ]"

    def initialize(value = 0)
        @value = value
    end

    def valueSymbol
        if @value == 0
            return @@emptySymbol.encode('utf-8')
        elsif @value == 1
            return @@playerOneSymbol.encode('utf-8')
        elsif @value == 2
            return @@playerTwoSymbol.encode('utf-8')
        end
    end
end