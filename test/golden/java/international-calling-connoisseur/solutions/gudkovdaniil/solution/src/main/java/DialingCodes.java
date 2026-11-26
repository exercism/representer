import java.util.Map;
import java.util.HashMap;
public class DialingCodes {
    private Map<Integer, String> dialingCodeMap = new HashMap<>();
    public Map<Integer, String> getCodes() {
        return dialingCodeMap;  
    }
    public void setDialingCode(Integer code, String country) {
        dialingCodeMap.put(code, country);
    }
    public String getCountry(Integer code) {
        return dialingCodeMap.get(code);
    }
    public void addNewDialingCode(Integer code, String country) {
        if (!dialingCodeMap.containsKey(code) && !dialingCodeMap.containsValue(country)) {
            dialingCodeMap.put(code, country);
        } 
    }
    public Integer findDialingCode(String country) {
        for (Map.Entry<Integer, String> entry : dialingCodeMap.entrySet()) {
            if (entry.getValue().equals(country)) {     
                return entry.getKey(); // Возвращаем ключ, если найдено совпадение
            }
        }
        return null; // Возвращаем null, если код не найден
    }
    public void updateCountryDialingCode(Integer code, String country) {
        Integer currentCode = findDialingCode(country);
        if (currentCode != null) { // Исправлено: убран пробел
            dialingCodeMap.remove(currentCode);
            dialingCodeMap.put(code, country); // Исправлено: заменено newCode на code
        }
    }
}
