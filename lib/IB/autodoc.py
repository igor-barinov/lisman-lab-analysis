import sys
from pathlib import Path
from enum import Enum
import os

class LineType(Enum):
    CODE = 0,
    COMMENT = 1,
    FUN_DEF = 2,
    CLASS_DEF = 4,
    END = 5

def parse_matlab_fun_def(fn_def):
    # function [outputs] = name(inputs)
    fn_def = ''.join(fn_def.split())

    char_idx = 0
    parsing_outputs = False
    parsing_name = False
    parsing_inputs = False

    fn_name = ''
    fn_inputs = []
    fn_outputs = []

    while char_idx < len(fn_def):
        if parsing_outputs: # after '['
            end_idx = fn_def.find(']')
            fn_outputs += fn_def[char_idx:end_idx].split(',')
            char_idx = end_idx-1
            parsing_outputs = False
        elif parsing_name: # after '='
            end_idx = fn_def.find('(')
            fn_name = fn_def[char_idx:end_idx]
            char_idx = end_idx-1
            parsing_name = False
        elif parsing_inputs: # after '('
            end_idx = fn_def.find(')')
            fn_inputs += fn_def[char_idx:end_idx].split(',')
            char_idx = end_idx-1
            parsing_inputs = False
        else:
            if fn_def[char_idx] == '[':
                parsing_outputs = True
            elif fn_def[char_idx] == '=':
                parsing_name = True
            elif fn_def[char_idx] == '(':
                parsing_inputs = True
        
        char_idx += 1
            

    return (fn_name, fn_inputs, fn_outputs)
            

def parse_matlab_line(line):
    line_data = {
        'type': LineType.CODE,
        'fun_name': '',
        'fun_inputs': [],
        'fun_outputs': []
    }

    comment_idx = line.find('%')
    fn_def_idx = line.find('function')
    class_def_idx = line.find('classdef')
    end_def_idx = line.find('end')

    parsed_indices = list(filter(lambda i: i != -1,  [comment_idx, fn_def_idx, class_def_idx, end_def_idx]))
    if len(parsed_indices) == 0:
        return line_data

    first_idx = min(parsed_indices)
    if first_idx == comment_idx:
        line_data['type'] = LineType.COMMENT
    elif first_idx == fn_def_idx:
        line_data['type'] = LineType.FUN_DEF
        (line_data['fun_name'], line_data['fun_inputs'], line_data['fun_outputs']) = parse_matlab_fun_def(line)
    elif first_idx == class_def_idx:
        line_data['type'] = LineType.CLASS_DEF
    elif first_idx == end_def_idx:
        line_data['type'] = LineType.END

    return line_data


    

def parse_matlab_file(filepath):
    filedata = {
        'object_name': '',
        'lines': [],
        'line_data': [],
        'comments': [],
        'comment_line_nums': [],
        'prev_offset': 0,
        'read_offset': 0
    }

    filedata['object_name'] = Path(filepath).name
    with open(filepath, 'r') as matlab_file:
        is_eof = False
        while not is_eof:
            line = matlab_file.readline()
            if not line:
                is_eof = True
            else:
                filedata['lines'].append(line)
                filedata['line_data'].append(parse_matlab_line(line))

    return filedata

def line_has_definition(line):
    words = line.split()

    keywords = ['if', 'switch', 'for', 'while']
    for kw in keywords:
        if kw in words:
            return True
    
    return False





def next_definition(filedata):
    def_data = {
        'printed': '',
        'lines': [],
        'line_data': [],
        'first_line': 0,
        'last_line': 0
    }

    filedata['prev_offset'] = filedata['read_offset']
    offset = filedata['read_offset']
    if offset >= len(filedata['lines']):
        return ''

    while True:
        if offset == len(filedata['lines']):
            return ''

        line_data = filedata['line_data'][offset]

        if line_data['type'] == LineType.CLASS_DEF or line_data['type'] == LineType.FUN_DEF:
            break

        filedata['read_offset'] += 1
        offset = filedata['read_offset']

    
    end_offset = offset
    start_line_data = filedata['line_data'][offset]
    if start_line_data['type'] == LineType.CLASS_DEF:
        while end_offset < len(filedata['lines']):
            line = filedata['lines'][end_offset]

            if line.find('methods') > -1:
                break

            end_offset += 1

            
    elif start_line_data['type'] == LineType.FUN_DEF:
        n_defs = 1
        while n_defs > 0:
            line = filedata['lines'][end_offset]
            
            line_data = filedata['line_data'][end_offset]

            if line_data['type'] != LineType.COMMENT and line_has_definition(line):
                n_defs += 1
            
            if line_data['type'] == LineType.END:
                n_defs -= 1

            end_offset += 1

    filedata['read_offset'] = end_offset

    def_data['first_line'] = offset
    def_data['last_line'] = end_offset
    def_data['lines'] = filedata['lines'][offset:end_offset]
    def_data['line_data'] = filedata['line_data'][offset:end_offset]
    def_data['printed'] = '\n'.join(def_data['lines'])

    return def_data

def generate_comment(fn_def, fn_title, fn_summary, input_summaries, output_summaries):
    first_line = fn_def['lines'][0]
    first_line_data = fn_def['line_data'][0]
    n_spaces = first_line.find('function')
    n_dashes = 112 - n_spaces

    whitespace = ' '*n_spaces
    comment = whitespace + '%% '
    comment += '-'*n_dashes + '\n'
    comment += whitespace + '% {}\n'.format(fn_title)
    comment += whitespace + '%\n'
    comment += whitespace + '% {}\n'.format(fn_summary)

    fn_inputs = first_line_data['fun_inputs']
    for i in range(len(fn_inputs)):
        var = fn_inputs[i]
        doc = input_summaries[i]
        comment += whitespace + '%\n'
        comment += whitespace + '% (IN) \"{}\": {}\n'.format(var, doc)

    fn_outputs = first_line_data['fun_outputs']
    for i in range(len(fn_outputs)):
        var = fn_outputs[i]
        doc = output_summaries[i]
        comment += whitespace + '%\n'
        comment += whitespace + '% (OUT) \"{}\": {}\n'.format(var, doc)

    comment += whitespace + '%\n'

    return comment

def insert_comment(filedata, comment, line_number):
    filedata['comments'].append(comment)
    filedata['comment_line_nums'].append(line_number)

def write_comments_to_file(filepath, filedata):
    with open(filepath, 'w') as matlab_file:
        lines_written = 0
        for i in range(len(filedata['comments'])):
            comment = filedata['comments'][i]
            comment_line = filedata['comment_line_nums'][i]
            lines_until_comment = comment_line-lines_written
            print('Writing {} lines'.format(lines_until_comment))

            for j in range(lines_until_comment):
                code = filedata['lines'][j+lines_written]
                matlab_file.write(code)
                lines_written += 1

            matlab_file.write(comment)

        for i in range(lines_written, len(filedata['lines'])):
            code = filedata['lines'][i]
            matlab_file.write(code)

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

def main():
    n_args = len(sys.argv)
    if n_args < 2:
        print('Usage: autodoc.py <".m" file>')
        return

    filepath = sys.argv[1]
    filedata = parse_matlab_file(filepath)

    while True:
        next_def = next_definition(filedata)
        if not next_def:
            break
        else:
            cls()
            print(next_def['printed'])
            print()
            first_line_data = next_def['line_data'][0]
            if first_line_data['type'] == LineType.FUN_DEF:
                fn_name = first_line_data['fun_name']
                fn_inputs = first_line_data['fun_inputs']
                fn_outputs = first_line_data['fun_outputs']

                print('*'*50)
                print('COMMENT GENERATOR')
                print('*'*50)
                print()

                title = input('Comment title:\n')
                print()

                summary = input('Summarize function \"{}\":\n'.format(fn_name))
                print()

                input_summaries = []
                for var in fn_inputs:
                    input_summaries.append(input('Describe input \"{}\":\n'.format(var)))
                    print()

                output_summaries = []
                for var in fn_outputs:
                    output_summaries.append(input('Describe output \"{}\":\n'.format(var)))
                    print()

                print('Generated the following documentation:')
                comment = generate_comment(next_def, title, summary, input_summaries, output_summaries)
                print(comment)
                print()

                comment_line = next_def['first_line']+2
                user_input = input('Insert comment at line {} (y/n)? '.format(comment_line))
                if user_input == 'y':
                    insert_comment(filedata, comment, comment_line)
                else:
                    user_input = input('Redo or continue (r/c)? ')
                    if user_input == 'r':
                        filedata['read_offset'] = filedata['prev_offset']
                        continue




        user_input = input('Continue (y/n)? ')
        if user_input == 'n':
            break

    cls()
    print('The following comments will be added:')
    for i in range(len(filedata['comments'])):
        comment = filedata['comments'][i]
        line = filedata['comment_line_nums'][i]

        print('Line {}:\n{}'.format(line, comment))
        print()

    user_input = input('Continue (y/n)?')
    if user_input == 'y':
        write_comments_to_file(filepath, filedata)

if __name__ == "__main__":
    main()