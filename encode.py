import html
import urllib.parse
import base64

# Define encoding functions
def encode_html(text):
    """Encode text to HTML entities."""
    return html.escape(text)

def encode_url(text):
    """Encode text to URL encoding."""
    return urllib.parse.quote(text)

def encode_base64(text):
    """Encode text to Base64."""
    return base64.b64encode(text.encode('utf-8')).decode('utf-8')

def encode_hex(text):
    """Encode text to hex encoding."""
    return ''.join(f"%{ord(char):02X}" for char in text)

def encode_js_escape(text):
    """Encode text using JavaScript escape sequences."""
    return ''.join(f"\\x{ord(char):02x}" for char in text)

# Map function names to functions
function_list = {
    'html': encode_html,
    'url': encode_url,
    'base64': encode_base64,
    'hex': encode_hex,
    'js': encode_js_escape,
}

def main():
    print("Available encoding types:", ", ".join(function_list.keys()))
    while True:
        text = input("\n> ")

        encoding_type = input("Enter encoding type: ").lower()
        encoder = function_list.get(encoding_type)

        if encoder:
            result = encoder(text)
            print(f"Encoded ({encoding_type}): {result}")
        else:
            print("Invalid encoding type.")

if __name__ == "__main__":
    main()
