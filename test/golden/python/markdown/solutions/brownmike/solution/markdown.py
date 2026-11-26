import re

import typing


def parse(markdown):
    return Markdown(markdown).html()


class Markdown:
    def __init__(self, markdown: str):
        self._markdown: str = markdown
        self._markdown_lines: typing.List[MarkdownLine] = [MarkdownLine('')]

    def html(self) -> str:
        self._parse()
        return ''.join([line.html() for line in self._markdown_lines])

    def _parse(self):
        for line in self._markdown.split('\n'):
            line = MarkdownLine(line)
            self._handle_list_tags(line)
            self._markdown_lines.append(line)

        self._handle_list_close()

    def _handle_list_tags(self, line):
        self._handle_list_open(line)
        if not line.is_list_item:
            self._handle_list_close()

    def _handle_list_close(self):
        if self._previous_line.is_list_item:
            self._markdown_lines.append(MarkdownLine('</ul>'))

    def _handle_list_open(self, line):
        if line.is_list_item and not self._previous_line.is_list_item:
            self._markdown_lines.append(MarkdownLine('<ul>'))

    @property
    def _previous_line(self):
        return self._markdown_lines[-1]


class MarkdownLine:
    def __init__(self, line: str):
        self._original_line = line
        self._line = line

    @property
    def is_list_item(self):
        return self._original_line.startswith('* ')

    def html(self) -> str:
        self._parse()
        return self._line

    def _parse(self):
        self._parse_block_element()
        self._parse_inline_elements()

    def _parse_block_element(self):
        self._parse_header()
        self._parse_list_item()
        self._parse_paragraph()

    def _parse_inline_elements(self):
        self._bold()
        self._emphasis()

    def _bold(self):
        bold_match = re.match(r'(.*)__(.*)__(.*)', self._line)
        if bold_match:
            self._line = f'{bold_match.group(1)}<strong>{bold_match.group(2)}</strong>{bold_match.group(3)}'
            self._bold()

    def _emphasis(self):
        italic_match = re.match(r'(.*)_(.*)_(.*)', self._line)
        if italic_match:
            self._line = f'{italic_match.group(1)}<em>{italic_match.group(2)}</em>{italic_match.group(3)}'
            self._emphasis()

    def _parse_header(self):
        header_match = re.match(r'(?P<hashes>#{1,6}) .+', self._line)
        if header_match:
            header_size = len(header_match.group('hashes'))
            self._line = f'<h{header_size}>' + ' '.join(self._line.split()[1:]) + f'</h{header_size}>'

    def _parse_list_item(self):
        if self.is_list_item:
            self._line = '<li>' + self._line[2:] + '</li>'

    def _parse_paragraph(self):
        line_is_marked_up = re.match('<h|<ul|</ul|<p|<li', self._line)
        if self._line and not line_is_marked_up:
            self._line = '<p>' + self._line + '</p>'
