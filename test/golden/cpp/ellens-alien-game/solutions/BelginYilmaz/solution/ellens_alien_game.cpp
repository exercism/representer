namespace targets {
// TODO: Insert the code for the alien class here
    class Alien{

        private:
        int health{3};

        public:
        int x_coordinate; 
        int y_coordinate;
        Alien(int x, int y){
            x_coordinate=x;
            y_coordinate=y;        
            }
        int get_health(){
            return health;
        }
        int hit(){
            health-=1;
            if(health<=0){
                health=0;
            }
        return true;      
        }
        bool is_alive(){

            if(health==0){
                return false;
            }
            return true;
        }
        int teleport(int x_new, int y_new){
            x_coordinate = x_new;
            y_coordinate = y_new;

            return true;
        }
        bool collision_detection(Alien b){
            
            if(x_coordinate==b.x_coordinate || y_coordinate==b.y_coordinate ){
                return true;
            }
            else
                return false;
        }
        
    };

}  // namespace targets