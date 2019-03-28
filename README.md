PATTERNS ON TEXT
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin provides a toolbox of commands to delete, substitute, or
de-duplicate text based on a passed regular expression (or the last used
search pattern), something which would otherwise require multiple steps, a
complex sub-replace-expression or a macro. One way or the other, all
commands here are extensions of the :substitute command. Use them whenever
the general built-in doesn't suffice.

### SOURCE

- [:DeleteExcept](http://stackoverflow.com/questions/6249172/vim-delete-anything-other-than-pattern)
- [:SubstituteInSearch inspiration](http://stackoverflow.com/questions/13763880/in-vim-how-can-i-search-and-replace-every-other-match)
- [:DeleteDuplicateLinesOf inspiration](http://stackoverflow.com/questions/14236226/hanging-only-to-the-first-instance-of-the-line-and-deleting-all-further-copies)
- [:DeleteDuplicateLinesIgnoring inspiration](http://stackoverflow.com/questions/1896793/remove-duplicate-line-in-vim)
- [:DeleteAllDuplicateLinesIgnoring inspiration](http://stackoverflow.com/questions/22193596/in-vim-how-to-remove-all-lines-that-are-duplicate-somewhere)
- [:SubstituteNotInSearch inspiration](http://stackoverflow.com/questions/26569959/ignore-keywords-in-quotes-in-vim-regex-substitute)
- [:DeleteUniqueLinesIgnoring inspiration](http://stackoverflow.com/questions/26981192/how-do-i-remove-non-duplicate-lines-in-vim)
- [:SubstituteChoices inspiration](http://vi.stackexchange.com/questions/9700/mutliple-choice-substitute)

### SEE ALSO

- The ExtractMatches.vim plugin ([vimscript #4795](http://www.vim.org/scripts/script.php?script_id=4795)) provides commands to yank
  matches into a register, optionally only unique matches without duplicates.
- The EditSimilar.vim plugin ([vimscript #2544](http://www.vim.org/scripts/script.php?script_id=2544)) uses the same
  {wildcard}={string} replacement pairs of :SubstituteWildcard, but for
  editing a similar file, e.g. via :EditSubstitute.
- The ingo#syntaxitem#IsOnSyntax() function provided by ingo-library.vim can
  be used with :SubstituteIf as a predicate that checks for the syntax of
  the current match. For example, a predicate that detects comments can be
  defined as:
 <!-- -->

    function! Comment()
        return ingo#syntaxitem#IsOnSyntax(getpos('.'), '^Comment$')
    endfunction

### RELATED WORKS

- The :SubstituteSelected command can be emulated with built-ins via
 <!-- -->

    :call feedkeys('yyyq') | %s/{pattern}/{string}/gc

  (Source: http://stackoverflow.com/a/25840884/813602)
- substitute\_unless\_string.vim
  (https://github.com/LucHermitte/lh-misc/blob/master/plugin/substitute_unless_string.vim)
  implements a :SubstituteIf with a fixed predicate (that checks the current
  syntax).

USAGE
------------------------------------------------------------------------------

    :[range]SubstituteExcept/{pattern}/{string}/[flags] [count]
                            Replace text in the current line / [range] that does
                            not match {pattern} / the last used search pattern
                            with {string}; "g" is implicit. Empty lines (without
                            any whitespace) are kept empty.
                            In {string}, & refers to the text that does not match,
                            whereas \1 etc. refer to the previous match of a
                            sub-expression in {pattern}.
    :[range]SubstituteExcept [flags] [count]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement string, and last used
                            :s_flags; "g" is implicit.

    :[range]DeleteExcept [{pattern}]
    :[range]DeleteExcept /{pattern}/[flags]
                            Delete all text in the current line / [range] except
                            for the text matching {pattern} / the last used search
                            pattern. For [flags], see :s_flags; "g" is implicit.

    :[range]SubstituteSelected/{pattern}/{string}/[flags] {answers}
                            Replace matches of {pattern} in the current line /
                            [range] with {string}, determining whether a
                            particular match should be replaced on the sequence of
                            "y" or "n" (a count can be prefixed, e.g. "3y4n2y") or
                            numeric positions "2,5", or ranges "3-5" in {answers}.
                            If no numeric positions follow, the last "y" / "n"
                            sequence repeats for further matches. For example with
                            "ynn", the first match is replaced, the second and
                            third are not, the fourth is again replaced, ...
                            Handles & and \0, \1 .. \9 in {string}, also \=
                            sub-replace-expression and \r, \n, \t, \b.
    :[range]SubstituteSelected [flags] [answers]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement string, last used
                            :s_flags, and last used answers.

    :[range]SubstituteSubsequent/{pattern}/{string}/[flags]
                            Replace all matches of {pattern} on or after the
                            current cursor position (and in all entire following
                            lines) in [range] with {string}.
                            For a "blockwise to end" replacement that is
                            restricted to positions on and after the current
                            column in all lines, pass the special flag [b].
    :[range]SubstituteSubsequent/{pattern}/{string}/[flags] {answers}
                            Replace all matches of {pattern} on or after the
                            current cursor position in [range] with {string},
                            determining whether a particular match should be
                            replaced on the sequence of "y" or "n" (a count can be
                            prefixed, e.g. "3y4n2y") or numeric positions "2,5",
                            or ranges "3-5" in {answers}, as with
                            :SubstituteSelected.
    :[range]SubstituteSubsequent [flags] [answers]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement string, last used
                            :s_flags, and last used answers.

    :[range]SubstituteInSearch/{pattern}/{string}/[flags] [count]
                            Within the current search pattern matches, replace all
                            matches of {pattern} with {string}. Shortcut for
                            :%s//\=substitute(submatch(0), "foo", "bar", "g")/gc
                            ~ is replaced with the {string} of the previous
                            :Substitute[Not]InSearch.
                            Handles \= sub-replace-expression in {string}, which
                            can't be used recursively in the above built-in
                            :%s//\=...
                            [flags] and [count] apply to the outer matching of the
                            last search pattern. The [e] from :s_flags also
                            suppresses the error message when {pattern} never
                            matches.
                            To replace only the first occurrence of {pattern},
                            pass the special flag [f].
                            For a case-insensitive substitution, prepend '\c' to
                            {pattern}.
                            Does not modify the last search pattern quote/.
    :[range]SubstituteInSearch/{search}/{pattern}/{string}/[flags] [count]
                            Like above, but additionally specifies the {search}
                            pattern instead of using quote/ (which again isn't
                            modified).
    :[range]SubstituteInSearch [flags] [count]
                            Repeat last :SubstituteInSearch with same search
                            {pattern} and substitute {string}, but without the
                            same flags or given {search} pattern.

    :[range]SubstituteNotInSearch/{pattern}/{string}/[flags] [count]
                            Outside the current search pattern matches, replace
                            all matches of {pattern} with {string}. Combination of
                            :SubstituteExcept and :SubstituteInSearch.
                            ~ is replaced with the {string} of the previous
                            :Substitute[Not]InSearch.
                            [flags] and [count] apply to the outer matching of the
                            last search pattern. The [e] from :s_flags also
                            suppresses the error message when {pattern} never
                            matches.
                            To replace only the first occurrence of {pattern},
                            pass the special flag [f].
                            For a case-insensitive substitution, prepend '\c' to
                            {pattern}.
                            Does not modify the last search pattern quote/.
    :[range]SubstituteNotInSearch/{search}/{pattern}/{string}/[flags] [count]
                            Like above, but additionally specifies the {search}
                            pattern instead of using quote/ (which again isn't
                            modified).
    :[range]SubstituteNotInSearch [flags] [count]
                            Repeat last :SubstituteNotInSearch with same search
                            {pattern} and substitute {string}, but without the
                            same flags or given {search} pattern.

    :[range]SubstituteIf/{pattern}/{string}/[flags] {predicate}
    :[range]SubstituteUnless/{pattern}/{string}/[flags] {predicate}
                            Replace matches of {pattern} in the current line /
                            [range] with {string} if the expression {predicate}
                            returns a true (:SubstituteIf) / false
                            (:SubstituteUnless) value.

                            Inside {predicate}, you can reference a context object
                            via v:val. It provides the following information:
                                matchCount: number of current match of {pattern}
                                replacementCount: number of actual replacements
                                                  done so far, i.e. where
                                                  {predicate} was true
                            It also contains pre-initialized variables for use by
                            {predicate}. These get cleared by each :SubstituteIf
                            / :SubstituteUnless invocation:
                                n: number / flag (0 / false)
                                m: number / flag (1 / true)
                                l: empty List []
                                d: empty Dictionary {}
                                s: empty String ""
    :[range]SubstituteIf [flags] [predicate]
    :[range]SubstituteUnless [flags] [predicate]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement string, last used
                            :s_flags, and last used predicate.

    :[range]SubstituteChoices /{pattern}/{string1}/{string2}/[.../] [flags] [count]
                            Replace a match of {pattern} with one of {string1},
                            {string2}, ..., with each replacement queried from the
                            user.
    :[range]SubstituteChoices [flags] [count]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement choices, last used
                            :s_flags and count.

    :[range]SubstituteMultiple /{pattern}/{string}/ [...] [flags] [count]
                            Change any of the {pattern} given to the corresponding
                            {string}. As this is done in a single :substitute,
                            this can have different (better) semantics than
                            sequential :s/new/old/ | s/older/newer/ commands. For
                            example, you can swap texts with this.
                            Note: You cannot use capturing groups /\( here!
                            Handles & and \= sub-replace-expression in {string}.
    :[range]SubstituteMultiple [flags] [count]
                            Repeat the last substitution with the last used search
                            patterns, last used replacement strings, last used
                            :s_flags and count.

    :[range]SubstituteWildcard {wildcard}={string} [...] [flags] [count]
                            Change (first in the line, with "g" flag all) matches
                            of wildcard to {string}. Modeled after the Korn
                            shell's "cd {old} {new}" command.
                            Handles & and \= sub-replace-expression in {string}.
                            Whitespace in the substitution pairs must be escaped;
                            for a literal backslash search / replace, use \\:
                                C:\\=my\ drive
    :[range]SubstituteWildcard [flags] [count]
                            Repeat the last substitution with the last used search
                            pattern, last used wildcard replacements, last used
                            :s_flags and count.

    :[range]SubstituteMultipleExpr /{pattern-expr}/{replacement-expr}/ [flags] [count]
                            Evaluate {pattern-expr}, either as a List of patterns,
                            or else as String, which is then split into lines of
                            patterns. Change any of these patterns to the
                            corresponding (i.e. with the same index, using the
                            last available if there are fewer replacements
                            available) List element of {replacement-expr}.
                            Note: You cannot use capturing groups /\( here!
                            Each replacement handles & and \=.
    :[range]SubstituteMultipleExpr [flags] [count]
                            Repeat the last substitution with the last used search
                            and replacement expressions, last used :s_flags and
                            count.

    :[range]SubstituteTransactional /{pattern}/{string}/
                                    [flags][t/{test-expr}/][u/{update-predicate}/]
                            First record every match of {pattern} without changing
                            anything.
                            The optional {test-expr} is invoked at each match
                            (v:val contains a context Dict Substitute-v:val that
                            can be used to store additional information. It also
                            has the matchCount information (but not
                            replacementCount)). You can skip that match by
                            throwing "skip".
                            The optional {update-predicate} is invoked once at the
                            end (and passed that context object as v:val again,
                            now also with matchNum information); it has to return
                            1 or 0; in the latter case, no replacements are done
                            (the transaction is aborted). In case of 1 (commit),
                            all recorded positions (in reverse order from last to
                            first) are replaced with {string}, which handles & and
                            also \=; with the latter sub-replace-expression, the
                            cursor is positioned on the match, and can use the
                            context via v:val, which contains the following
                            additional information:
                                matchNum:   total number of matches
                                matchCount: number of current match of {pattern};
                                            decreases from matchNum to 1
                                matchText:  matched text (as you cannot use
                                            submatch(0) any longer
                                startPos:   [line, col] of the start of the match
                                endPos:     [line, col] of the end of the match
    :[range]SubstituteTransactional [flags][t/{test-expr}/][u/{update-predicate}/]
                            Repeat the last substitution with the last used search
                            pattern, last used replacement, last used :s_flags
                            and {test-expr} / {update-predicate} (unless
                            specified).

    :[range]SubstituteTransactionalExpr /{pattern-expr}/{replacement-expr}/
                                    [flags][t/{test-expr}/][u/{update-predicate}/]
                            Evaluate {pattern-expr}, either as a List of patterns,
                            or else as String, which is then split into lines of
                            patterns. First record (the optional {test-expr}, and
                            a later sub-replace-expression have an additional
                            patternIndex that shows which pattern matched) and
                            then at the end change any of these patterns given to
                            the corresponding (i.e. with the same index, using the
                            last available if there are fewer replacements
                            available) List element of {replacement-expr}, like
                            :SubstituteTransactional.
                            Note: You cannot use capturing groups /\( here!
    :[range]SubstituteTransactionalExpr [flags][t/{test-expr}/][u/{update-predicate}/]
                            Repeat the last substitution with the last used search
                            and replacement expressions, last used :s_flags and
                            {test-expr} / {update-predicate} (unless specified).

    :[range]SubstituteTransactionalExprEach /{pattern-expr}/{replacement-expr}/
                                    [flags][t/{test-expr}/][u/{update-predicate}/]
                            Evaluate {pattern-expr}, either as a List of patterns,
                            or else as String, which is then split into lines of
                            patterns. First record (the optional {test-expr}, and
                            a later sub-replace-expression have an additional
                            patternIndex that shows which pattern matched) and
                            then at the end change any of these patterns given to
                            the corresponding (i.e. with the same index, using the
                            last available if there are fewer replacements
                            available) List element of {replacement-expr}, like
                            :SubstituteTransactional.
                            In contrast to :SubstituteTransactionalExpr, each
                            pattern is searched separately, not as alternative
                            regexp branches (where the first branch matches, and
                            other potential matches are eclipsed). As the
                            replacements are only done at the very end, this means
                            that _any_ pattern match is recorded and later
                            replaced, not just the first alternative! (And you can
                            use capturing groups here.)
    :[range]SubstituteTransactionalExprEach [flags][t/{test-expr}/][u/{update-predicate}/]
                            Repeat the last substitution with the last used search
                            and replacement expressions, last used :s_flags and
                            {test-expr} / {update-predicate} (unless specified).

    :[range]SubstituteExecute/{pattern}/[flags] {expr}
                            Replace matches of {pattern} in the current line /
                            [range] with whatever {expr} |:return|s.
                            This is like :sub-replace-expression, but you can
                            use commands like :let, and have to explicitly
                            :return the replacement value.
                            Inside {expr}, you can reference a context object, as
                            with :SubstituteIf. Cp. Substitute-v:val
    :[range]SubstituteExecute [flags] [expr]
                            Repeat the last substitution with the last used search
                            pattern, last used :s_flags, and last used
                            expression.

    :[range]SubstituteTranslate[!] /{pattern}/\={expr}/[flags]
                            Put each unique match of {pattern} through {expr} ...
                            Inside {expr}, you can reference a context object, as
                            with :SubstituteIf. Cp. Substitute-v:val; here,
                            the information is:
                                matchCount: number of non-memoized match of
                                            {pattern}
                                replacementCount: number of actual replacements
                                                  (memoized and new) done so far
    :[range]SubstituteTranslate[!] /{pattern}/{func}/[flags]
                            Invoke {func} (a context object, as with
                            :SubstituteIf, cp. Substitute-v:val is the only
                            argument; the match can be inspected via submatch())
                            for each unique match ...
    :[range]SubstituteTranslate[!] /{pattern}/{item1}/{item2}[/...]/[flags]
                            Replace each unique match of {pattern} with the
                            {item1}, ... (from left to right; if these are new
                            {itemA} or there are additional appended {item3},
                            those are added to the original ones, unless ! is
                            given) ...
                            ... and memoize the association, so that further
                            identical matches will automatically use the same
                            value (without invoking {expr} / {func} / popping
                            {item1}). This persists across invocations (so you can
                            apply the same translation on multiple ranges /
                            buffers); use ! to clear any stored associations and
                            reset the context object.
                            By returning a List, {expr} / {func} can indicate the
                            the current match should be skipped (this decision
                            isn't memoized), just like if there are no {item1}
                            available any longer.
    :[range]SubstituteTranslate[!] [flags] [count]
                            Repeat the last substitution with the last used search
                            pattern, last used {expr} / {func} / {item1}..., last
                            used :s_flags and count.
    :[line]PutTranslations [{template-expr}]
                            Put all translations from :SubstituteTranslate after
                            [line] (default current line), according to
                            {template-expr}, which can refer to each original
                            match as v:val.match, the associated replacement as
                            v:val.replacement, and the (original) number of
                            translation (which also determines the output order)
                            as v:val.count. The default template associates the
                            replacement with the original match:
                                repl1: match1
                                repl2: match2
    :YankTranslations [x] [{template-expr}]
                            Yank all translations from :SubstituteTranslate
                            [into register x], according to {template-expr} (see
                            above). The default template creates :substitute
                            commands that undo the translation:
                                :'[,']substitute/repl1/match1/g

    :[range]PrintDuplicateLinesOf[!] [{pattern}]
    :[range]PrintDuplicateLinesOf[!] /{pattern}/
                            Print all occurrences of lines matching (with [!]: not
                            matching) {pattern} (or the current line, if omitted).
                            All matching lines are added to the jumplist, so you
                            can use CTRL-O to revisit the locations.

    :[range]DeleteDuplicateLinesOf[!] [{pattern}]
    :[range]DeleteDuplicateLinesOf[!] /{pattern}/
                            Delete all subsequent occurrences of lines matching
                            (with [!]: not matching) {pattern} (or the current
                            line, if omitted).

    :[range]PrintDuplicateLinesIgnoring[!] [{pattern}]
    :[range]PrintDuplicateLinesIgnoring[!] /{pattern}/
                            Print all occurrences of a line whose text (ignoring
                            any text matched (with [!]: not matched) by {pattern})
                            appears multiple times. To ignore empty lines, use a
                            {pattern} of ^$ (strict) or ^\s*$ (lenient).
                            All matching lines are added to the jumplist, so you
                            can use CTRL-O to revisit the locations.

    :[range]DeleteDuplicateLinesIgnoring[!] [{pattern}]
    :[range]DeleteDuplicateLinesIgnoring[!] /{pattern}/
                            Delete all subsequent occurrences of a line (ignoring
                            any text matched (with [!]: not matched) by
                            {pattern}).

    :[range]DeleteAllDuplicateLinesIgnoring[!] [{pattern}]
    :[range]DeleteAllDuplicateLinesIgnoring[!] /{pattern}/
                            Delete all (including the very first) occurrences of a
                            duplicate line (ignoring any text matched (with [!]:
                            not matched) by {pattern}).

    :[range]PrintUniqueLinesOf[!] [/]{pattern}[/]
                            Print all unique occurrences of lines matching (with
                            [!]: not matching) {pattern}. All matching lines are
                            added to the jumplist, so you can use CTRL-O to
                            revisit the locations.

    :[range]DeleteUniqueLinesOf[!] [/]{pattern}[/]
                            Delete all unique occurrences of lines matching (with
                            [!]: not matching) {pattern}. Only duplicate lines are
                            kept.

    :[range]PrintUniqueLinesIgnoring[!] [{pattern}]
    :[range]PrintUniqueLinesIgnoring[!] /{pattern}/
                            Print all lines whose text (ignoring any text matched
                            (with [!]: not matched) by {pattern}) appears only
                            once in the buffer / [range].
                            All matching lines are added to the jumplist, so you
                            can use CTRL-O to revisit the locations.

    :[range]DeleteUniqueLinesIgnoring[!] [{pattern}]
    :[range]DeleteUniqueLinesIgnoring[!] /{pattern}/
                            Delete all unique occurrences of a line (ignoring
                            any text matched (with [!]: not matched) by
                            {pattern}). Only duplicate lines are kept.

                            For the following commands, the [!] suppresses the
                            error when there are no duplicates.

    :[range]PrintUniques[!] [{pattern}]
    :[range]PrintUniques[!] /{pattern}/
                            Print all matches of {pattern} (if omitted: the last
                            search pattern) that appear only once in the current
                            line / [range].
                            To print all unique matches of {pattern} within a
                            single line, processing a [range] or the entire
                            buffer, use:
                            :global/^/PrintUniques! [{pattern}]
                            :global/^/PrintUniques! /{pattern}/
                            The [!] suppresses the error when there are no
                            uniques in a particular line.

    :[range]DeleteUniques[!] [{pattern}]
    :[range]DeleteUniques[!] /{pattern}/
                            Delete all unique matches of {pattern} (or the last
                            search pattern, if omitted). Only duplicate matches
                            are kept.

    :[range]PrintDuplicates[!] [{pattern}]
    :[range]PrintDuplicates[!] /{pattern}/
                            Print all matches of {pattern} (if omitted: the last
                            search pattern) that appear multiple times in the
                            current line / [range].
                            To print all duplicate matches of {pattern} within a
                            single line, processing a [range] or the entire
                            buffer, use:
                            :global/^/PrintDuplicates! [{pattern}]
                            :global/^/PrintDuplicates! /{pattern}/
                            The [!] suppresses the error when there are no
                            duplicates in a particular line.

    :[range]DeleteDuplicates[!] [{pattern}]
    :[range]DeleteDuplicates[!] /{pattern}/
                            Delete all subsequent matches of {pattern} (or the
                            last search pattern, if omitted) except the first.
                            To delete all non-unique matches, use
                            :DeleteAllDuplicates instead.

    :[range]DeleteAllDuplicates[!] [{pattern}]
    :[range]DeleteAllDuplicates[!] /{pattern}/
                            Delete all non-unique matches of {pattern} (or the last
                            search pattern, if omitted). To keep the first match,
                            use :DeleteDuplicates instead.

    :[range]DeleteRanges[!] {range} [range] [...] [x]
    :[range]YankRanges[!] {range} [range] [...] [x]
                            Within the entire buffer / passed [range], delete /
                            yank all lines that fall within {range} (with [!]: do
                            not fall within) into register [x] (or the unnamed
                            register). When multiple [range]s are given, each line
                            is yanked only once (in ascending order).

    :[range]PrintRanges[!] {range} [range] [...]
                            Within the entire buffer / passed [range], print all
                            lines that fall within {range} (with [!]: do not fall
                            within).
                            Each start of a block is added to the jumplist, so
                            you can use CTRL-O to revisit the locations.

    :[range]RangeDo[!] {range} [range] [...] {command}
                            Within the entire buffer / passed [range], execute the
                            Ex command {cmd} on each line that falls within
                            {range} (with [!]: does not fall within). When
                            multiple [range]s are given, each line is processed
                            only once (in ascending order).
                            Note: {command} must be separated by whitespace from
                            the preceding ranges!
                            Works like
                                :global/apples/,/peaches/ {cmd}
                            but:
                            - processes each line only once when the ranges are
                              overlapping
                            - supports multiple ranges (which are joined) and
                              inversion with [!]

    :[range]Renumber [N][/{pattern}/[{fmt}/]][flags][[*]offset]
                            Search for decimal numbers / {pattern} with [flags],
                            and replace each (according to :s_flags with
                            1, 2, ... / [N], [N] + [offset], ...
                            (or [N] * [offset])
                            formatted as {fmt} (cp. printf()).
    :[range]Renumber &      Continue renumbering with the last used number, same
                            {pattern}, {fmt}, [flags] and [offset]. Useful with
                            :global to cover only certain lines. Use
                            :0Renumber ... to prime the required values, e.g.:
                                :0Renumber 100 g 10 | global/^#/.Renumber &

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-PatternsOnText
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim PatternsOnText*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.035 or
  higher.

KNOWN PROBLEMS
------------------------------------------------------------------------------

- The # pattern separator cannot be used with :SubstituteSelected,
  :SubstituteInSearch, and :SubstituteNotInSearch.
- The : pattern separator cannot be used with :SubstituteChoices,
  :SubstituteIf, :SubstituteExecute, and :Renumber.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-PatternsOnText/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 2.11    28-Mar-2019
- Extract PatternsOnText#Translate#Translate() API function to allow easier
  creation of custom translation commands without having to reassemble (and
  then re-parse) the entire command arguments.
- Add :PutTranslations and :YankTranslations companion commands of
  :SubstituteTranslate.
- ENH: Also support \\= sub-replace-expression for :SubstituteMultiple and
  :SubstituteWildcard.
- ENH: Add :SubstituteMultipleExpr variant of :SubstituteMultiple.
- ENH: Add :SubstituteTransactional[Expr[Each]] commands.

##### 2.10    19-Oct-2018
- Add :Renumber command.
- Add :DeleteAllDuplicates command, a variant of :DeleteDuplicates and inverse
  of :DeleteUniques.
- Minor: Do proper escaping of pattern separators when adding to the search
  history.
- CHG: Allow inversion of :...LinesOf and :...LinesIgnoring {pattern} via !
  (instead of suppressing error message with !) Affects
  :PrintDuplicateLinesOf, :DeleteDuplicateLinesOf,
  :PrintDuplicateLinesIgnoring, :DeleteDuplicateLinesIgnoring,
  :DeleteAllDuplicateLinesIgnoring, :PrintUniqueLinesOf, :DeleteUniqueLinesOf,
  :PrintUniqueLinesIgnoring, :DeleteUniqueLinesIgnoring
- :SubstituteChoices: FIX: Forgot to update current line number; current line
  is re-printed on each occurrence.
- :SubstituteChoices: Only rely on 'cursorline' highlighting if the line isn't
  actually folded.
- :SubstituteChoices: ENH: Include count of match replacements in current line
  in query.
- :SubstituteChoices: Correctly handle multi-digit entry, leading zeros with
  /c flag.
- FIX: Many :Substitute... commands did not yet check for read-only or
  unmodifiable buffer and instead printed an ugly multi-line error.
- :SubstituteChoices: Also offer "no" and "last as ..." choices if the :s\_c
  flag is given, to offer feature parity with built-in :substitute.
- Add :SubstituteTranslate command.
- CHG: Escaping of whitespace and backslashes in :SubstituteMultiple is not
  necessary any longer (but now the full /{pattern}/{string}/ needs to be
  given; you cannot omit e.g. the trailing /). This parsing better matches the
  user expectation. :SubstituteWildcard still requires escaping, though.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.035!__

##### 2.01    15-Aug-2017
- Add :SubstituteUnless variant of :SubstituteIf.
- Move PatternsOnText#DefaultReplacementOnPredicate(),
  PatternsOnText#ReplaceSpecial(), and PatternsOnText#DefaultReplacer() to
  ingo-library.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.032!__

##### 2.00    30-Sep-2016
- Add :SubstituteChoices command.
- Add :SubstituteIf command.
- Add :SubstituteExecute command.
- ENH: Support recall of previous pairs / substitutions in :SubstituteWildcard
  / :SubstituteMultiple.
- FIX: Minor: With :SubstituteSelected, Cursor jumps to first line if no
  substitution at all ("nnnnn"). Initialize l:lastNum to current line.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.027!__

##### 1.51    23-Dec-2014
- Don't set the buffer 'modified' for :PrintDuplicates and :PrintUniques.
- Improve reporting of readonly buffers for :SubstituteExcept, :DeleteExcept,
  :SubstituteSelected, and :SubstituteSubsequent.
- FIX: Misplaced :continue in s:Collect() safety check; must :return out of
  factored out function.

##### 1.50    19-Nov-2014
- ENH: Add :PrintUniqueLinesOf, :DeleteUniqueLinesOf,
  :PrintUniqueLinesIgnoring, :DeleteUniqueLinesIgnoring, :PrintUniques,
  :DeleteUniques commands that are the opposite of the corresponding
  :...Duplicate... commands.

##### 1.40    28-Oct-2014
- FIX: :SubstituteSubsequent can give "E488: Trailing characters". Previous
  search pattern must be properly escaped in case the separators are
  different.
- Add :SubstituteNotInSearch, a combination of :SubstituteExcept and
  :SubstituteInSearch.

##### 1.36    26-Oct-2014
- BUG: :.DeleteRange et al. don't work correctly on a closed fold; need to use
  ingo#range#NetStart().
- BUG: :.DeleteDuplicateLines... et al. don't work correctly on a closed fold;
  need to use ingo#range#NetStart().
- BUG: :SubstituteSubsequent doesn't work correctly on a closed fold; need to
  use ingo#range#NetStart().
- Make the deletions work with closed folds (i.e. only delete the duplicate
  lines / lines in range itself, not the entire folds) by temporarily
  disabling folding.
- Correctly report :PrintDuplicates on folded lines.
- Refactoring: Use ingo#cmdargs#pattern#ParseUnescaped().
- Factor out ingo#range#lines#Get() into ingo-library.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.022!__

##### 1.35    25-Apr-2014
- ENH: Allow to pass multiple ranges to the :\*Ranges commands.
- FIX: The \*Ranges commands only handled /{pattern}/,... ranges, not line
  numbers or marks. Only use :global for patterns; for everything else,
  there's only a single range, so we can just prepend it to :call directly.
- Don't clobber the search history with the :\*Ranges commands (through using
  :global).
- Add :RangeDo command.
- ENH: Also support passing the search pattern inline with
  :SubstituteInSearch/{search}/{pattern}/{string}/[flags] instead of using the
  last search pattern.

##### 1.30    13-Mar-2014
- Add :DeleteAllDuplicateLinesIgnoring command.
- CHG: The :[Print|Delete]DuplicateLines[ Of|Ignoring] commands do not
  automatically ignore empty lines any more. Use a {pattern} like ^$ to ignore
  them explicitly.
- FIX: Wrong use of ingo#escape#Unescape().
- ENH: Enable use of \\= sub-replace-expression in :SubstituteInSearch through
  emulation, as the command implementation itself uses \\=, Vim doesn't allow
  recursive use inside it. This has been inspired by
  http://stackoverflow.com/questions/21588649/increment-numbers-between-delimiters-in-vim
- Add :DeleteRanges, :YankRanges, :PrintRanges commands.
- Handle \\r, \\n, \\t, \\b in {string}, too.

__You need to update to
  ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.017!__

##### 1.20    18-Feb-2014
- ENH: Add :SubstituteWildcard {wildcard}={string} and
  :SubstituteMultiple /{pattern}/{string}/ commands.

__You need to update to
  ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.016!__

##### 1.12    21-Nov-2013
- FIX: Use of \\v and \\V magicness atoms in the pattern for :DeleteExcept and
  :SubstituteExcept cause errors like "E54: Unmatched (" and "E486: Pattern
  not found". Revert to the default 'magic' mode after each pattern insertion
  to the workhorse regular expression.
- FIX: Abort :DeleteExcept / :SubstituteExcept commands when the pattern
  contains the set start / end match patterns \\zs / \\ze, as these interfere
  with the internal implemenation.
- Minor: Make substitute() and matchlist() robust against 'ignorecase'.

##### 1.11    13-Jun-2013
- FIX: Remove -bar from all commands to correctly handle patterns like
  foo\\|bar without escaping as foo\\\\|bar.
- :SubstituteSelected now positions the cursor on the line where the last
  selected replacement happened, to behave like :substitute.

##### 1.10    06-Jun-2013
- ENH: :SubstituteSelected handles count before "y" and "n" answers, numeric
  positions "2,5", and ranges "3-5".
- Also recall previous answers in a bare :SubstituteSelected command.
- The commands that take a {pattern}, i.e. :SubstituteExcept, :DeleteExcept,
  :SubstituteSelected now consistently set that as the last search pattern.
- Refactoring: Move functions from ingo/cmdargs.vim to
  ingo/cmdargs/pattern.vim and ingo/cmdargs/substitute.vim.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.007!__

##### 1.01    30-May-2013
- Implement abort on error for :SubstituteExcept, :DeleteExcept,
:SubstituteSelected, and :SubstituteInSearch, too.

##### 1.00    29-May-2013
- First published version.

##### 0.01    12-Sep-2011
- Started development as part of my custom ingocommands.

------------------------------------------------------------------------------
Copyright: (C) 2011-2019 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
