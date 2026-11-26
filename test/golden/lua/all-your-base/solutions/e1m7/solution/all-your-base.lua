
local function to_decimal(digits, base)                                      -- конвертировать в 10 (число, база), например (123, 5)
    local decimal = 0                                                        -- decimal = ответ (пока 0)
    for i, digit in ipairs(digits) do                                        -- выбрать индекс и число из таблицы чисел (1,2,3)
        assert(digit >= 0, 'negative digits are not allowed' )               -- проверка: цифра >= 0, иначе ошибка
        assert(digit < base, 'digit out of range')                           -- проверка: цифра < базы, иначе ошибка
        decimal = decimal + digit * (base ^ (#digits - i))                   -- ответ = ответ + число(1)*(базу(5)^(3-1))
    end
    return math.floor(decimal)                                               -- вернуть ответ
end

local function from_decimal(decimal, base)                                   -- конвертировать из 10 в новое (10-ное число, база), например (123, 2)
    local digits = {}                                                        -- digits = ответ (пока 0)
    while decimal > 0 do                                                     -- пока число > 0
        table.insert(digits, 1, (decimal % base))                            -- 1) добавить в таблицу digits на 1-ое место 123 % 2 = 1
        decimal = decimal // base                                            -- 2) 123 = 123 // 2 = 60
    end
    return #digits > 0 and digits or {0}                                     -- вернуть digits, если там больше 0 чисел или вернуть {0}
end

return {
    convert = function(from_digits, from_base)                               -- переменная convert = функция, которая получает from_digits, from_base
        return {                                                             -- вернуть из функции...
            to = function(to_base)                                           -- переменная to = функция, которая получает to_base
                assert(from_base > 1, 'invalid input base')                  -- проверка: from_base > 1
                assert(to_base > 1, 'invalid output base')                   -- проверка: to_base > 1
                local decimal = to_decimal(from_digits, from_base)           -- decimal = переводим число в 10-ое
                return from_decimal(decimal, to_base)                        -- возвращаем его перевод в to_base-шное
            end
        }    
    end
}
















    