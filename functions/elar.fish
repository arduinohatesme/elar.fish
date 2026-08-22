function elar --description "ELAR Study Tools"
    set -f plugin_dir (path dirname (path dirname (status filename)))
    set -f data_dir (path resolve "$plugin_dir/data")
    switch "$argv[1]"
        case sentence
            set -l sentence_types simple compound complex compound-complex
            set -l sentence_type_num (random 1 4)
            set -l sentence_type $sentence_types[$sentence_type_num]
            set -l vocab_file_path "$data_dir/vocab/$argv[2].json"

            if test -z "$argv[2]"
                echo "Write a $sentence_type sentence."
                return 0
            end

            set -l word (random choice (jq -r '.[]' $vocab_file_path))

            echo "Write a $sentence_type sentence with the word $word."
        case vocab
            set -l vocab_file_path "$data_dir/vocab/$argv[2].json"
            set -l word (random choice (jq -r '.[]' $vocab_file_path))
            set -l tasks "Find a synonym for" "Find an antonym for" "Define the word"
            set -l task (random choice $tasks)

            echo "$task $word."
        case root
            set -l roots_file_path "$data_dir/roots/$argv[2].json"
            set -l index (random 0 (math (jq -r 'length' $roots_file_path) - 1))
            jq -r ".[$index].root, .[$index].definition, .[$index].is_latin" $roots_file_path \
                | string trim -- \
                | read -l -z root definition is_latin
            set -l root_color_code
            set -l latin_or_greek_letter

            if test (string trim -- $is_latin) = true
                set root_color_code "#ff9977"
                set latin_or_greek_letter L
            else
                set root_color_code "#7799ff"
                set latin_or_greek_letter G
            end

            tput civis
            echo "The root is: $root"
            read -n 1 -P "Press any key to flip " _char
            tput cuu1
            tput el
            tput cuu1
            tput el
            tput cnorm

            set_color $root_color_code
            echo "$root ($latin_or_greek_letter)"
            set_color --reset
            echo
            echo $definition
            echo
            echo Examples
            echo ---
            set -l num_examples (jq -r ".[$index].examples | length" $roots_file_path)

            for i in (seq 0 (math $num_examples - 1))
                jq -r ".[$index].examples.[$i].word, .[$index].examples.[$i].definition" $roots_file_path \
                    | read -l -z example_word example_def
                echo "  - $example_word"
                echo "    $example_def"
            end
    end
end
