import sys

def fix_file(filename):
    with open(filename, 'r') as f:
        content = f.read()
    
    # We want to find `#stage-2 {` and replace `justify-content: flex-start; padding-top: 10vh;` 
    # with `justify-content: flex-end; padding-bottom: 5vh;`
    import re
    # Match the block for #stage-2
    pattern = r'(#stage-2\s*\{[^}]*?)justify-content:\s*flex-start;\s*padding-top:\s*10vh;([^}]*\})'
    
    def replacer(match):
        return match.group(1) + 'justify-content: flex-end; padding-bottom: 5vh;' + match.group(2)
        
    new_content = re.sub(pattern, replacer, content)
    
    with open(filename, 'w') as f:
        f.write(new_content)

fix_file('01-family-intro.it.html')
fix_file('01-family-intro.en.html')
