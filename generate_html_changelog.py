#!/usr/bin/env python3

import sys, re, jinja2

if len(sys.argv) < 2:
    print('You must provide source file name')
    exit()

SOURCE_FILE_NAME = sys.argv[1]
COMMIT_TAG = "ID"
ISSUE_BASE_URL = "https://teamwork.q.agency/app/tasks/"
DESTINATION_FILE_NAME = "release_notes.html"

build_numbers = []
dates = []
release_notes = []
release_note_item = []
counter = 0
with open(SOURCE_FILE_NAME, 'r', encoding='UTF-8') as file:
    while line := file.readline().rstrip():
        if line.startswith('####'):
            release_notes.append(release_note_item.copy())
            release_note_item.clear()
            counter = 0
        else:
            if counter == 0:
                build_numbers.append(line)
            elif counter == 1:
                dates.append(line)
            else:
                match = re.match('^(' + COMMIT_TAG + '[-_\s]*)([0-9].*?)[\s+:](.*)', line, re.IGNORECASE)
                issue_name = None
                issue_url = None
                release_text = line
                if match:
                    issue_prefix = match.group(1)
                    issue_id = match.group(2)
                    release_text = match.group(3).strip()

                    issue_name = issue_prefix + issue_id
                    issue_url = ISSUE_BASE_URL + issue_id
                release_note_item.append((issue_name, issue_url, release_text))
            counter += 1

environment = jinja2.Environment(loader=jinja2.FileSystemLoader('templates/'))
template = environment.get_template('release_notes_template.txt')
context = {
    'build_numbers': build_numbers,
    'dates': dates,
    'release_notes': release_notes
}
with open(DESTINATION_FILE_NAME, mode='w', encoding='UTF-8') as file:
    file.write(template.render(context))
