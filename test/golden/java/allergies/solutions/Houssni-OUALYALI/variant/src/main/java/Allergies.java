import java.util.ArrayList;
import java.util.List;

class Allergies {
    private String binary;

    Allergies(int degree){
        binary = Integer.toBinaryString(degree);
    }

    public boolean isAllergicTo(Allergen allergen){
        List<Allergen> allergens = this.getList();
        if(allergens.contains(allergen)){
            return true;
        }
        return false;
    }

    public List<Allergen> getList(){
        List<Allergen> allergens = new ArrayList<>();
        String strBinary = "";
        for(int i=binary.length()-1; i>=0; --i)
            strBinary += binary.charAt(i);

        for(int i=0; i<=strBinary.length(); ++i){
            if(strBinary.charAt(i)=='1' && i < 8){
                allergens.add(Allergen.values()[i]);
            }else if(i >= 8){
                break;
            }
        }
        return allergens;
    }
}
