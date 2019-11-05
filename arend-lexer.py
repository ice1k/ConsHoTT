from pygments.lexer import RegexLexer, bygroups, words
from pygments.token import *

class ArendLexer(RegexLexer):
    name = 'Arend'
    aliases = ['arend']
    filenames = ['*.ard']

    tokens = {
        'root': [
            (r'\s+', Text),
            (words(('Nat', 'coe', 'left', 'right', 'zero', 'path', 'suc')), Name.Builtin),
            (r'--[^\n\r]*', Comment),
            (r'(\\data)(\s+)([a-zA-Z0-9_\-\']+)',
              bygroups(Keyword, Text, Name.Class)),
            (r'(\\func)(\s+)([a-zA-Z0-9_\-\']+)',
              bygroups(Keyword, Text, Name.Function)),
            (r'\\[a-zA-Z\-0-9]+', Keyword),
            (r'=>?', Operator),
            (r'[\(\)\{\}]', Operator),
            (r'[:@\|]', Operator),
            (r'[a-zA-Z0-9_\']+', Text),
        ]
    }
#
