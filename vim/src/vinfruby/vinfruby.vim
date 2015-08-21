" Simple wrapper around IRB
"
" VInfRuby allows to start an IRB-session in an external shell window
" and lets you execute your ruby-script from within VIM in that IRB-session
"
" <Leader>rt            opens a new 'xterm' with an irb-session
" <Leader>rf            evaluates the current file 
" <Leader>rl            evaluates the current line
" <Leader>rd            evaluates the 'def'-block the cursor is in
" <Leader>rc            evaluates the 'class'-block the cursor is in
"
" In visual-mode
" <Leader>r             evaluates the currently highlighted code
"
" To install VInfRuby, put this file and the file 'vinfruby.rb' in the
" directory ~/.vim/plugin
"
" VInfRuby requires VIM to be built with the Ruby-extension.

ruby <<EOF
require 'drb'

module VInfRuby
    def self.reconnect
        @@irb_server = DRbObject.new(nil, 'druby://localhost:33668')
    end

    def self.evaluate(line, line_no)
        first_try = true
        begin
            @@irb_server.evaluate(line, line_no)
        rescue
            if first_try
                first_try = false
                reconnect
                retry
            else
                raise
            end
        end
    end

    def self.evaluate_current_block(block_name)
        lines = VIM::Editor.lines
        srow, scol, erow, ecol = VInfRuby.find_block(lines,
            VIM::Editor.cursor.row-1, VIM::Editor.cursor.col, block_name)
        unless ecol.nil?
            txt = [lines[srow][scol..-1]] + 
                lines[(srow+1)..(erow-1)] + 
                [lines[erow][0...ecol]]
            txt = txt.join("\n")
            VInfRuby.evaluate(txt, srow + 1)
        end
    end

    def self.find_block(lines, row, col, block_name)
        start_row, start_col = find_start_of_block(lines, row, block_name)
        return false unless start_row

        end_row, end_col = find_end_of_block(lines, start_row, start_col)
        return false unless end_row

        return [start_row, start_col, end_row, end_col]
    end

    def self.find_start_of_block(lines, start_row, block_name)
        re = Regexp.new("\\b(?:#{block_name})\\b(?!.*\\b(?:#{block_name})\\b)")
        start_row.downto(0) do |i|
            m = re.match(lines[i])
            return [i, m.begin(0)] if m
        end
        return false
    end

    def self.find_end_of_block(lines, start_row, start_col)
        level = 0
        c = start_col
        for i in start_row...lines.size
            begin
                l = lines[i][c..-1]
                if m = /(^|;)\s*(while|until|loop|for|ensure|begin|rescue|def|class)\b/.match(l)
                    level += 1
                    c += m.begin(2) + m[2].size
                elsif m = /\bdo\b(\s*\|[^\|]*\|)?/.match(l)
                    level += 1
                    c += m.begin(0) + 2
                elsif m = /\bend\b/.match(l)
                    level -= 1
                    c += m.begin(0) + 3
                end

                if level == 0
                    return [i, c]
                end
            end until m.nil?
            c = 0
        end

        return false
    end
end

module VIM
    module Editor
        class Position
            attr_reader :row, :col

            def self.from_vim(row_cmd, col_cmd)
                self.new(VIM.evaluate(row_cmd), VIM.evaluate(col_cmd))
            end

            def initialize(row, col)
                @row = row.to_i
                @col = col.to_i
            end
        end

        module Reg
            def self.[](regname)
                VIM.evaluate("@#{regname.to_s}")
            end

            def self.[]=(regname, value)
                VIM.evaluate("let @#{regname.to_s} = #{value}")
            end

            def self.method_missing(name, *args)
                name=name.to_s
                if name[-1] == ?=
                    self.[]=(*args)
                else
                    self.[](*args)
                end
            end
        end

        def self.cursor
            Position.from_vim('line(".")', 'col(".")')
        end

        def self.num_lines
            VIM::Buffer.current.count
        end

        def self.line(n = nil)
            n.nil? ? VIM::Buffer.current.line : VIM::Buffer.current[n]
        end

        def self.lines(s = 1, e = -1)
            e = num_lines + e + 1 if e < 0
            (s..e).map {|i| line(i)}
        end

        def self.mark(name)
            Position.from_vim(%Q{line("'#{name}")}, %Q{col("'#{name}")})
        end

        def self.selection_begin
            return mark("<")
        end

        def self.selection_end
            return mark(">")
        end

        def self.selection_text
            return Reg["*"]
        end
    end
end
EOF

function! s:openterm()
    ruby <<EOF
    Kernel.fork { system("xterm -e 'irb -r ~/.vim/plugin/vinfruby.rb'") }
EOF
endfunction

function! s:evalline()
    ruby <<EOF
    VInfRuby.evaluate(VIM::Editor.line, VIM::Editor.cursor.row)
EOF
endfunction

function! s:evalvisual()
    ruby <<EOF
    VInfRuby.evaluate(VIM::Editor.selection_text, 
                      VIM::Editor.selection_begin.row)
EOF
endfunction

function! s:evalfile()
    ruby <<EOF
    VInfRuby.evaluate(VIM::Editor.lines.join("\n"), 1)
EOF
    return ""
endfunction

function! s:evaldef()
    ruby <<EOF
    VInfRuby.evaluate_current_block("def")
EOF
endfunction

function! s:evalclass()
    ruby <<EOF
    VInfRuby.evaluate_current_block("class")
EOF
endfunction

nnoremap <silent> <Plug>Ropenterm :<C-U> call <SID>openterm()<CR>
nnoremap <silent> <Plug>Revalfile :<C-U> call <SID>evalfile()<CR>
nnoremap <silent> <Plug>Revalline :<C-U> call <SID>evalline()<CR>
nnoremap <silent> <Plug>Revaldef :<C-U> call <SID>evaldef()<CR>
nnoremap <silent> <Plug>Revalclass :<C-U> call <SID>evalclass()<CR>
vnoremap <silent> <Plug>Revalvisual :<C-U> call <SID>evalvisual()<CR>

nmap   <Leader>rt   <Plug>Ropenterm
nmap   <Leader>rf   <Plug>Revalfile 
nmap   <Leader>rl   <Plug>Revalline 
nmap   <Leader>rd   <Plug>Revaldef 
nmap   <Leader>rc   <Plug>Revalclass 
vmap   <Leader>r    <Plug>Revalvisual

