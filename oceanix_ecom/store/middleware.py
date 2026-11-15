import re
from django.utils.deprecation import MiddlewareMixin

class HTMLMinifyMiddleware(MiddlewareMixin):
    def process_response(self, request, response):
        # Only minify HTML responses
        if (
            response.has_header('Content-Type') and 
            'text/html' in response['Content-Type']
        ):
            try:
                # Get the response content
                content = response.content.decode('utf-8')
                
                # Minify the HTML content safely
                minified_content = self.minify_html(content)
                
                # Update the response content
                response.content = minified_content.encode('utf-8')
                
                # Update Content-Length header if present
                if response.has_header('Content-Length'):
                    response['Content-Length'] = str(len(response.content))
            except Exception as e:
                # If decoding or minification fails, fall back to the original response
                pass
                
        return response

    def minify_html(self, html_content):
        # Regex to match blocks that should not have their formatting minified:
        # <pre>...</pre>, <textarea>...</textarea>, <script>...</script>, <style>...</style>
        pattern = re.compile(
            r'(<(pre|textarea|script|style)\b[^>]*>.*?</\2>)',
            re.IGNORECASE | re.DOTALL
        )
        
        # Split HTML content by the matching blocks
        parts = pattern.split(html_content)
        
        minified_parts = []
        i = 0
        while i < len(parts):
            # 1. Minify standard HTML segments
            html_part = parts[i]
            if html_part:
                # Remove standard HTML comments (excluding IE conditionals)
                html_part = re.sub(r'<!--(?!\s*\[if)[^\]]*?-->', '', html_part, flags=re.DOTALL)
                # Replace consecutive whitespace/newlines with a single space
                html_part = re.sub(r'\s+', ' ', html_part)
                # Remove spaces around tag boundaries
                html_part = re.sub(r'>\s+<', '><', html_part)
                minified_parts.append(html_part)
            
            # 2. Keep script/style/pre/textarea blocks intact
            if i + 1 < len(parts):
                minified_parts.append(parts[i + 1])
                
            i += 3
            
        return "".join(minified_parts).strip()
