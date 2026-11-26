import re


def parse2(markdown):
    lines = markdown.split('\n')
    res = ''
    in_list = False
    in_list_append = False
    for line in lines:
        if re.match('###### (.*)', line) is not None:
            line = '<h6>' + line[7:] + '</h6>'
        elif re.match('## (.*)', line) is not None:
            line = '<h2>' + line[3:] + '</h2>'
        elif re.match('# (.*)', line) is not None:
            line = '<h1>' + line[2:] + '</h1>'
        m = re.match(r'\* (.*)', line)
        # * : is a special char for zero or multi occurence, \* we escape the special char to match * 'star'
        print(f"m is : {m}")
        if m:
            if not in_list:
                in_list = True
                is_bold = False
                is_italic = False
                curr = m.group(1)
                m1 = re.match('(.*)__(.*)__(.*)', curr)
                if m1:
                    curr = m1.group(1) + '<strong>' + \
                        m1.group(2) + '</strong>' + m1.group(3)
                    is_bold = True
                m1 = re.match('(.*)_(.*)_(.*)', curr)
                if m1:
                    curr = m1.group(1) + '<em>' + m1.group(2) + \
                        '</em>' + m1.group(3)
                    is_italic = True
                line = '<ul><li>' + curr + '</li>'
            else:
                is_bold = False
                is_italic = False
                curr = m.group(1)
                m1 = re.match('(.*)__(.*)__(.*)', curr)
                if m1:
                    is_bold = True
                m1 = re.match('(.*)_(.*)_(.*)', curr)
                if m1:
                    is_italic = True
                if is_bold:
                    curr = m1.group(1) + '<strong>' + \
                        m1.group(2) + '</strong>' + m1.group(3)
                if is_italic:
                    curr = m1.group(1) + '<em>' + m1.group(2) + \
                        '</em>' + m1.group(3)
                line = '<li>' + curr + '</li>'
        else:
            if in_list:
                in_list_append = True
                in_list = False

        m = re.match('<h|<ul|<p|<li', line)
        if not m:
            line = '<p>' + line + '</p>'
        m = re.match('(.*)__(.*)__(.*)', line)
        print(f"m is hhhh  {m}")
        if m:
            line = m.group(1) + '<strong>' + m.group(2) + '</strong>' + m.group(3)
        m = re.match('(.*)_(.*)_(.*)', line)
        if m:
            line = m.group(1) + '<em>' + m.group(2) + '</em>' + m.group(3)
        if in_list_append:
            line = '</ul>' + line
            in_list_append = False
        res += line
    if in_list:
        res += '</ul>'
    return res

def match_headings(line):
    if re.match("# (.*)", line):
        line = line.strip("#").strip()  # remove '#' and ' ' from the begining of the sentence
        line = "<h1>" + line + "</h1>"  # append the tags to the new string

    elif re.match("## (.*)", line):
        line = line.strip("#").strip()  # remove '#' and ' ' from the begining of the sentence
        line = "<h2>" + line + "</h2>"  # append the tags to the new string

    elif re.match("###### (.*)", line):
        line = line.strip("#").strip()  # remove '#' and ' ' from the begining of the sentence
        line = "<h6>" + line + "</h6>"  # append the tags to the new string

    return line

def match_list_items(m, in_list, in_list_append, line):

    if m:  # if it match the list item pattern 
        
        if not in_list:  # if it's the first list item
            in_list = True
            is_bold = False
            is_italic = False

            curr = m.group(1)

            m1 = re.match('(.*)__(.*)__(.*)', curr)  # matching the bold pattern
            
            if m1:
                curr , is_bold = match_strong_italic(m1.string, "strong")  # adding strong tag
                
            m1 = re.match('(.*)_(.*)_(.*)', curr)  # matching the italic pattern
            if m1:
                curr, is_italic = match_strong_italic(m1.string, "em")  # adding the em tag
                
            line = '<ul><li>' + curr + '</li>'  # making an unordered list
        else:  # if it's not the first item
            is_bold = False
            is_italic = False
            curr = m.group(1)
            m1 = re.match('(.*)__(.*)__(.*)', curr)  # matching the bold pattern 
            if m1:
                curr, is_bold = match_strong_italic(m1.string, "strong")  # adding the strong tag
            m1 = re.match('(.*)_(.*)_(.*)', curr)  # matching the italic pattern 
            if m1:
                curr, is_italic = match_strong_italic(m1.string, "em")  # adding the em tag
            
            line = '<li>' + curr + '</li>'
    else:  # if it doesnt match the list item
        if in_list:
            in_list_append = True
            in_list = False
    
    return line, in_list, in_list_append

def match_strong_italic(m1, tag):
    m1 = m1.strip().strip("__")
    return f"<{tag}>" + m1 + f"</{tag}>", True


def parse(markdown):
    lines = markdown.split('\n')
    res = ''
    in_list = False
    in_list_append = False
    for line in lines:
        line = match_headings(line)
        m = re.match(r'\* (.*)', line)  # matching * .... for list items
        line, in_list, in_list_append = match_list_items(m, in_list, in_list_append, line)
        # * : is a special char for zero or multi occurence, \* we escape the special char to match * 'star'
        # print(f"m is : {m}")
        

        m = re.match('<h|<ul|<p|<li', line)
        if not m:
            line = '<p>' + line + '</p>'
        m = re.match('(.*)__(.*)__(.*)', line) #matching the strong pattern in the outer scope
        # print(f"m is hhhh  {m}")
        
        if m:
            
            line = m.group(1) + '<strong>' + m.group(2) + '</strong>' + m.group(3)
        m = re.match('(.*)_(.*)_(.*)', line)
        if m:
            line = m.group(1) + '<em>' + m.group(2) + '</em>' + m.group(3)
        if in_list_append:
            line = '</ul>' + line
            in_list_append = False
        res += line
    if in_list:
        res += '</ul>'
    return res


result = parse("# Header!\n* __Bold Item__\n* _Italic Item_")
print(result)

resultat = re.findall(r'\*', "\anis anis le cool")
print(resultat)