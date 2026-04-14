import os, re
modified_files = 0
for root, dirs, files in os.walk('d:/Flutter/freelance/exotic/lib'):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            orig_content = content
            content = re.sub(r'Navigator\.pop\([^)]+\)', 'context.pop()', content)
            content = re.sub(r'Navigator\.of\([^)]+\)\.pop\([^)]*\)', 'context.pop()', content)
            
            if content != orig_content:
                if 'import \'package:go_router/go_router.dart\';' not in content:
                    content = 'import \'package:go_router/go_router.dart\';\n' + content
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                modified_files += 1

print('Modified', modified_files, 'files for Navigator.pop() -> context.pop()')