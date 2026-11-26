class PhoneNumber
    VALID_PHONE_NUMBER = /^([2-9]\d\d){2}\d{4}$/
    def self.clean(phone_number)
        clean_number = phone_number.gsub(/\D/, "").sub(/^1/, "")
        clean_number[VALID_PHONE_NUMBER]
    end
end