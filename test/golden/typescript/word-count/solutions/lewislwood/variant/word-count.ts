export function count(title: string):Map<string, number> {
  const punc = /["".:;\\@!"%?\n,#&@$%^&]/g;
  const wMap =  new Map<string, number>();
  const list = title.toLowerCase().replace(punc, " ").replace(/\s/g, " ").trim().split(" ");
  const mapIt = (sw:string):void => {
    if (! sw) return;
    let w = sw.replace(/^'/, "").replace(/'$/,"").replace(/[\s]/g,"");
    if (! w) return;

if (!wMap.has(w))wMap.set(w,1)
else {
  const v = wMap.get(w)! - 1 ;
  wMap.set(w,v)
}
  }; // mapIt
  list.forEach((w) => mapIt(w));
  return wMap;
}

