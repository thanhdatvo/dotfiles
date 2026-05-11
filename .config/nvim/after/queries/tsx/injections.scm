; extends

(
  (call_expression
    function: (identifier) @_name
    arguments: (template_string
      (string_fragment) @injection.content))
  (#eq? @_name "css")
  (#set! injection.language "css")
)
