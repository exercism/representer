#include "secret_handshake.h"

namespace secret_handshake {

        vector<string> commands(int num){
            array<string, 4> actions = {"wink", "double blink", "close your eyes", "jump"};
            vector<int> to_do;
            vector<string> to_return;
            int resto;
            bool reverse = false;
            if (num > 15)
                reverse = true;
            while (num != 0){
                resto = num % 2;
                cout << resto << endl;
                to_do.push_back(resto);

                cout << to_do[0] << endl;
                num = num / 2;
            }

            if(reverse == true){
                for(size_t i = to_do.size()-1; i > 0; i--){
                     if (to_do[i - 1] == 1)
                        to_return.push_back(actions[i + 1]);
                }
            }else{
                for(size_t i = 0; i < to_do.size(); i++){
                    if (to_do[i] == 1){
                        to_return.push_back(actions[i]);
                        }
                }
            }
                
            return to_return;
        }
}  // namespace secret_handshake
