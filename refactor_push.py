import os, re
modified_files = 0

for root, dirs, files in os.walk('d:/Flutter/freelance/exotic/lib'):
    for file in files:
        if file.endswith('.dart') and file != 'routes.dart':
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            orig_content = content
            
            # General replacement fallback
            # We replace Navigator.push(context, MaterialPageRoute(builder: (context) => SomeWidget(params)))
            # -> context.push('/dynamicRoute', extra: () => SomeWidget(params))
            
            def replacer_push(m):
                widget_code = m.group(1).strip()
                if widget_code == 'pathToNavigate':
                    return 'context.push(pathToNavigate)'
                return f"context.push('/dynamicRoute', extra: () => {widget_code})"

            def replacer_replace(m):
                widget_code = m.group(1).strip()
                return f"context.go('/dynamicRoute', extra: () => {widget_code})"

            # Important: handle multiline matching
            content = re.sub(r'Navigator\.push\([^,]+,\s*MaterialPageRoute\(\s*builder:\s*\([^)]*\)\s*=>\s*(.+?)\s*\)\s*,?\s*\)', replacer_push, content, flags=re.DOTALL)
            content = re.sub(r'Navigator\.pushReplacement\([^,]+,\s*MaterialPageRoute\(\s*builder:\s*\([^)]*\)\s*=>\s*(.+?)\s*\)\s*,?\s*\)', replacer_replace, content, flags=re.DOTALL)

            if content != orig_content:
                if "import 'package:go_router/go_router.dart';" not in content:
                    content = "import 'package:go_router/go_router.dart';\n" + content
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                modified_files += 1

print('Modified', modified_files, 'files via automated Router migration')