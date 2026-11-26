#include "pig_latin.h"
#include <vector>
#include <boost/algorithm/string.hpp> /// For split()

namespace pig_latin {

    // この関数が呼び出される
    string translate(string str) {
        string output;
 
        // v is the vector to store the substrings after
        // splitting of the original string
        // s is original string
        // is_any_of(" ") returns true or false if space(" ") is
        // present in the string or not
        vector<string> v;
        // 引数であるstrを" "で分割し、vに格納する
        boost::split(v, str, boost::is_any_of(" "));
        // vの要素数だけループする
        for (auto t = v.begin(); t != v.end(); t++) {
            // 初回以外は空白を出力
            if (output.size() > 0) {
                output += ' ';
            }
            size_t offset = 0;
            if (t->size() >= 3) {
                // 3文字以上ある。規定の文字列と比較する
                if ((t->compare(0, 3, "squ") == 0) ||
                    (t->compare(0, 3, "sch") == 0) ||
                    (t->compare(0, 3, "thr") == 0)) {
                    offset = 3;    // 進める
                } else if (t->compare(0, 3, "rhy") == 0) {
                    offset = 2;    // 進める
                }
            }
            if (offset == 0) {
                // 未処理の場合ここに来る。2文字チェックする
                if ((t->compare(0, 2, "ch") == 0) ||
                    (t->compare(0, 2, "th") == 0) ||
                    (t->compare(0, 2, "qu") == 0)) {
                    offset = 2;    // 進める
                }
            }
            if (offset == 0) {
                // 未処理の場合ここに来る。1文字チェックする
                switch (t->front()) {
                    case 'a':
                    case 'e':
                    case 'i':
                    case 'o':
                    case 'u':
                        break;
                    default:
                        offset = 1;
                        break;
                }
            }
            if (offset == 1) {
                if ((t->compare(0, 2, "xr") == 0) ||
                    (t->compare(0, 2, "yt") == 0)) {
                    offset = 0;
                }
            }
            if (offset == 0) {
                output += *t;
            } else {
                output += t->substr(offset);
                output += t->substr(0, offset);
            }
            output += "ay";
        }
        return output;
    }

}  // namespace pig_latin



