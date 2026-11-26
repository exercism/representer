#!/usr/bin/env gawk -f

BEGIN { ind = 1 }

/[0-9]+/           { scores[ind++] = $0 }
/list/             { for(i=1; i<=ind; i++){
                        print scores[i]
                   }}
/latest/           { print scores[ind-1] }
/personalBest/     { n = asort(scores, sorted);
                     print sorted[n] }
/personalTopThree/ { n = asort(scores, sorted)
                     for(i=n; i>n-3; i--){
                        print sorted[i]
                   }}