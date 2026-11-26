class Badge {
    public String print(Integer id, String name, String department) {
        String output;

        if(department==null){
            if (id == null){
                output = String.format("%s - OWNER", name);
            }
            else{
                output = String.format("[%d] - %s - OWNER", id, name);
            }
        }
        else if(id == null){
            output = String.format("%s - %s", name, department.toUpperCase());
        }
        else{
            output = String.format("[%d] - %s - %s", id, name, department.toUpperCase());
        }
        
        return output;
        
        //throw new UnsupportedOperationException("Please implement the Badge.print() method");
    }
}
