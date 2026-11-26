import re

#Parses Markdown and returns HTML
def parse_markdown_update(markdown):
    lines=markdown.split('\n')
    result=''
    in_list=False

    for i in lines:
        i = check_header(i)
        i, in_list = check_list(i,in_list)
        i = check_bold(i)
        i = check_italic(i)
        i = check_paragraph(i)
        result += i

    if in_list:
        result += '</ul>'

    return result

# Checking if String is Header
def check_header(s):
    match = re.match(r'(^#+)', s)
    if match:
        cnt = len(match.group(1))
        s = '<h%d>%s</h%d>' % (cnt, s[cnt+1:], cnt)
    return s

# Checking if String is part of a List
def check_list(s,in_list):
    match = re.match(r'\* (.*)', s)
    if match:
        s = '<li>' + match.group(1) + '</li>'
        if not in_list:
            in_list = True
            s = '<ul>' + s
    return s, in_list

# Checking if String is a paragraph
def check_paragraph(s):
    match = re.match('<h|<ul|<li', s)
    if not match:
        s = '<p>' + s + '</p>'
    return s

# Checking if part of the String is Bold
def check_bold(s):
    match = re.match(r'(.*)__(.*)__(.*)', s)
    if match:
        s = match.group(1) + '<strong>' + \
                match.group(2) + '</strong>' + match.group(3)
    return s

# Checking if part of the String is Italic
def check_italic(s):
    match = re.match(r'(.*)_(.*)_(.*)', s)
    if match:
        s = match.group(1) + '<em>' + \
            match.group(2) + '</em>' + match.group(3)
    return s

