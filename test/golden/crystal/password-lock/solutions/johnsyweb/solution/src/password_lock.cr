class PasswordLock
  alias Password = Int32 | String | Float64

  def initialize(@password : Password)
  end

  def encrypt
    @password = encrypt_password(@password)
  end

  def unlock?(input : Password) : String?
    encrypt_password(input) == @password ? "Unlocked" : nil
  end

  private def encrypt_password(input : Password) : Password
    case input
    when Int32  then (input / 2i32).round(0)
    when String then input.reverse
    else             input * 4f64
    end
  end
end
