import re
import os

with open('errors.txt', 'r', encoding='utf-8') as f:
    lines = f.readlines()

errors = []
for line in lines:
    # error - Methods can't be invoked in constant expressions - lib\features\settings\view\settings_screen.dart:671:45 - const_eval_method_invocation
    if "const_eval_method_invocation" in line:
        match = re.search(r'([a-zA-Z0-9_\.\\\/:]+\.dart):(\d+):(\d+)', line)
        if match:
            filepath = os.path.normpath(os.path.abspath(match.group(1)))
            line_num = int(match.group(2))
            errors.append((filepath, line_num))

# Group by file
files_to_fix = {}
for e in errors:
    if e[0] not in files_to_fix:
        files_to_fix[e[0]] = []
    files_to_fix[e[0]].append(e[1])

for filepath, line_nums in files_to_fix.items():
    if not os.path.exists(filepath):
        continue
    with open(filepath, 'r', encoding='utf-8') as f:
        file_lines = f.readlines()
    
    # Iterate backwards so changing lines doesn't affect offsets (though we are keeping line counts same)
    for line_num in line_nums:
        idx = line_num - 1
        # search upwards for up to 5 lines for 'const '
        for i in range(idx, max(-1, idx - 10), -1):
            if 'const ' in file_lines[i] or 'const\n' in file_lines[i]:
                # Remove just the first 'const ' we see scanning backwards
                # Or safely replace all 'const ' on that line
                file_lines[i] = re.sub(r'\bconst\s+', '', file_lines[i])
                break

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(file_lines)

print(f"Fixed {len(files_to_fix)} files.")
