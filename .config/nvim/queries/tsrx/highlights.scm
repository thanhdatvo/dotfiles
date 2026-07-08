; ---------- comments ----------
(line_comment) @comment
(block_comment) @comment

; ---------- literals ----------
(string) @string
(template_string) @string
(number) @number
(regex) @string.regex
(true) @boolean
(false) @boolean
(null) @constant.builtin
(undefined) @constant.builtin
(this) @variable.special

; ---------- keywords ----------
[
  "import"
  "from"
  "export"
  "default"
  "as"
  "type"
  "interface"
  "extends"
  "const"
  "let"
  "var"
  "function"
  "async"
  "await"
  "return"
  "typeof"
  "void"
  "delete"
] @keyword

[
  "if"
  "else"
  "for"
  "while"
  "switch"
  "case"
  "of"
  "in"
  "try"
  "catch"
  "finally"
] @keyword.control

; tsrx-defining keywords get a distinctive capture
"component" @keyword.special

; template expression flavour markers
(template_text_expression "text" @keyword.special)
(template_html_expression "html" @keyword.special)

; ---------- declarations ----------
(component_declaration name: (identifier) @function.special)
(function_declaration name: (identifier) @function)
(type_alias_declaration name: (identifier) @type)
(interface_declaration name: (identifier) @type)

; ---------- types ----------
(predefined_type) @type.builtin
(type_alias_declaration (identifier) @type)
(type_parameters (identifier) @type)
(object_type (identifier) @property)

; ---------- parameters / variables ----------
(formal_parameters (identifier) @variable.parameter)
(object_pattern (identifier) @variable.parameter)
(array_pattern (identifier) @variable.parameter)
(lazy_object_pattern (identifier) @variable.parameter)

(variable_declarator name: (identifier) @variable)

; ---------- calls / members ----------
(call_expression
  (primary_expression (identifier) @function.call))

(call_expression
  (member_expression (identifier) @function.method.call .))

(member_expression (identifier) @property .)

; ---------- elements (statement-level) ----------
(opening_element (tag_name) @tag)
(closing_element (tag_name) @tag)
(self_closing_element (tag_name) @tag)
(opening_element (member_name (identifier) @constructor))
(closing_element (member_name (identifier) @constructor))
(self_closing_element (member_name (identifier) @constructor))

; capitalised tag names render as components
((tag_name) @constructor
  (#match? @constructor "^[A-Z]"))

(attribute_name) @attribute

; ---------- TSX islands & fragments ----------
(tsx_opening_element "<tsx" @tag.builtin)
(tsx_closing_element "</tsx" @tag.builtin)
(tsx_opening_element ":" (identifier) @tag.builtin)
(tsx_closing_element ":" (identifier) @tag.builtin)
(fragment "<>" @tag.builtin)
(fragment "</>" @tag.builtin)

; ---------- style block ----------
(style_block "<style" @tag.builtin)
(style_block "</style>" @tag.builtin)

; ---------- tsrx host identifiers ----------
(style_identifier) @variable.special
(server_identifier) @variable.special
(style_member "#style" @variable.special)
(server_member "#server" @variable.special)
(server_block "#server" @variable.special)

; lazy-pattern markers
(lazy_object_pattern "&{" @punctuation.special)
(lazy_object_pattern "}" @punctuation.special)
(lazy_array_pattern "&[" @punctuation.special)
(lazy_array_pattern "]" @punctuation.special)

(lazy_attribute (lazy_object_pattern key: (identifier) @attribute))
(lazy_attribute (lazy_object_pattern (identifier) @attribute))

; ---------- punctuation / operators ----------
[
  "+" "-" "*" "/" "%"
  "=" "==" "===" "!=" "!==" "<" ">" "<=" ">="
  "&&" "||" "??" "!" "~"
  "+=" "-=" "*=" "/=" "%="
  "=>" "..."
  "?"
] @operator

[ "(" ")" "[" "]" "{" "}" "<" ">" ] @punctuation.bracket
[ "," ";" ":" "." ] @punctuation.delimiter

; ---------- identifiers (fallback) ----------
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$"))

((identifier) @constructor
  (#match? @constructor "^[A-Z]"))

(identifier) @variable
