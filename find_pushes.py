import os, re
results = []
for root, dirs, files in os.walk('d:/Flutter/freelance/exotic/lib'):
    for file in files:
        if file.endswith('.dart') and file != 'routes.dart':
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            matches = re.finditer(r'Navigator\.pushReplacement\(.*?=>\s*([^)]+\))', content, re.DOTALL)
            for m in matches:
                results.append(f"{file} pushReplacement -> {m.group(1).strip()}")
            matches = re.finditer(r'Navigator\.push\(.*?=>\s*(.*?)\)\s*,?\s*\)', content, re.DOTALL)
            for m in matches:
                results.append(f"{file} push -> {m.group(1).strip()}")
for r in results:
    print(r.replace('\n', ' '))