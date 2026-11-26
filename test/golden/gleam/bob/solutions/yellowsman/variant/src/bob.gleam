// 相手からのメッセージに対するボブの返事を返す

// 質問には"Sure."と返す。質問は最後が疑問符(？)で終わる
// 怒鳴られたら"Whoa, chill out!"と返す。怒鳴り声はすべてが大文字
// 怒鳴って質問されたら"Calm down, I know what I'm doing!"と返す。
// 沈黙には"Fine. Be that way!"と返す。沈黙は空文字か、空白文字の組み合わせ。
// それ以外には"Whatever." と返す。

// Resultが必要な処理が続くならresult.tryでチェインしたら良い？
// 判定に必要な関数を複数定義して、caseで判定する

import gleam/string

pub fn hey(remark: String) -> String {
  let remark = string.trim(remark)
  case
    string.ends_with(remark, "?"),
    // 大文字にした時と小文字にした時で変化が無い = 文字が含まれていない、という判定
    string.uppercase(remark) == remark && string.lowercase(remark) == remark,
    string.is_empty(remark)
  {
    True, True, _ -> "Calm down, I know what I'm doing!"
    True, _, _ -> "Sure."
    _, True, _ -> "Whoa, chill out!"
    _, _, True -> "Fine. Be that way!"
    _, _, _ -> "Whatever."
  }
}