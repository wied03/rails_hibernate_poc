module Bsw
  class Event
    attr_accessor :id
    attr_accessor :title
    attr_accessor :date

    def getId
      @id
    end

    def setId(id)
      @id = id
    end

    def getTitle
      @title
    end

    def setTitle(title)
      @title = title
    end

    def getDate
      @date
    end

    def setDate(date)
      @date = date
    end
  end
end
