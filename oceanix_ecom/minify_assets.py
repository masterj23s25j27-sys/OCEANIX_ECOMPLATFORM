import os
import re
import sys

def minify_css_fallback(css_content):
    # Remove CSS comments
    css_content = re.sub(r'/\*.*?\*/', '', css_content, flags=re.DOTALL)
    # Remove extra spaces/newlines
    css_content = re.sub(r'\s+', ' ', css_content)
    # Remove spaces around selectors and punctuation
    css_content = re.sub(r'\s*([\{\}:;,])\s*', r'\1', css_content)
    # Strip leading/trailing space
    return css_content.strip()

def minify_js_fallback(js_content):
    # Remove single line comments (but not URL protocols)
    # We replace '// ...' with nothing if it's not preceded by 'http:' or 'https:' or ':'
    js_content = re.sub(r'(?<!:|https|http)//.*', '', js_content)
    # Remove multi-line comments
    js_content = re.sub(r'/\*.*?\*/', '', js_content, flags=re.DOTALL)
    # Normalize whitespaces
    js_content = re.sub(r'\s+', ' ', js_content)
    # Remove whitespace around common punctuation
    js_content = re.sub(r'\s*([\{\}\(\)=:;,<>!\+\-\*\/])\s*', r'\1', js_content)
    return js_content.strip()

def minify_file(src_path, dest_path, file_type):
    print(f"Minifying {src_path} -> {dest_path}...")
    try:
        with open(src_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {src_path}: {e}")
        return False

    minified = ""
    if file_type == 'css':
        try:
            import rcssmin
            minified = rcssmin.cssmin(content)
            print("  (Using rcssmin)")
        except ImportError:
            print("  (Using fallback CSS minifier)")
            minified = minify_css_fallback(content)
    elif file_type == 'js':
        try:
            import rjsmin
            minified = rjsmin.jsmin(content)
            print("  (Using rjsmin)")
        except ImportError:
            print("  (Using fallback JS minifier)")
            minified = minify_js_fallback(content)

    try:
        with open(dest_path, 'w', encoding='utf-8') as f:
            f.write(minified)
        print("  Successfully minified.")
        return True
    except Exception as e:
        print(f"Error writing to {dest_path}: {e}")
        return False

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    static_css_dir = os.path.join(base_dir, 'store', 'static', 'css')
    static_js_dir = os.path.join(base_dir, 'store', 'static', 'js')

    # CSS files to minify
    css_files = [
        ('style.css', 'style.min.css'),
        ('admin.css', 'admin.min.css'),
        ('about.css', 'about.min.css')
    ]

    # JS files to minify
    js_files = [
        ('main.js', 'main.min.js')
    ]

    success = True
    for src, dest in css_files:
        src_path = os.path.join(static_css_dir, src)
        dest_path = os.path.join(static_css_dir, dest)
        if os.path.exists(src_path):
            if not minify_file(src_path, dest_path, 'css'):
                success = False
        else:
            print(f"Warning: Source CSS file {src_path} not found.")

    for src, dest in js_files:
        src_path = os.path.join(static_js_dir, src)
        dest_path = os.path.join(static_js_dir, dest)
        if os.path.exists(src_path):
            if not minify_file(src_path, dest_path, 'js'):
                success = False
        else:
            print(f"Warning: Source JS file {src_path} not found.")

    if success:
        print("Minification complete for all static assets!")
        sys.exit(0)
    else:
        print("Minification encountered errors.")
        sys.exit(1)

if __name__ == '__main__':
    main()
