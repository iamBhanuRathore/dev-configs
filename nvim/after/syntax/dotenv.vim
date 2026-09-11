" dotenv has no runtime syntax file of its own; reuse dosini's so keys,
" values, numbers and comments each get their own color.
" (Deliberately not ft=sh: that would run shfmt/shellcheck on save and
" mangle .env files.)
if exists('b:current_syntax')
  finish
endif
runtime! syntax/dosini.vim
