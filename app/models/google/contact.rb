class Contact

  cattr_accessor :service

  class << self

    @@service = nil
    
    def find_all
      @@service.get_all_contacts
    end

  end

end
