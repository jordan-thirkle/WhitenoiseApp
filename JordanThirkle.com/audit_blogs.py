import os
import re

BLOG_DIR = "src/data/blog/"

categories = ['AI', 'Web Development', 'Systems', 'Design', 'Productivity']

print("Auditing blog posts...")

for filename in os.listdir(BLOG_DIR):
    if not filename.endswith(".mdx"): continue

    filepath = os.path.join(BLOG_DIR, filename)
    with open(filepath, 'r') as f:
        content = f.read()

    parts = content.split('---')
    if len(parts) < 3:
        print(f"[{filename}] Invalid frontmatter format")
        continue

    frontmatter_str = parts[1]

    # Parse simple keys manually
    data = {}
    for line in frontmatter_str.strip().split('\n'):
        if ':' in line:
            key, val = line.split(':', 1)
            data[key.strip()] = val.strip().strip('"').strip("'")

    # Check title
    title = data.get('title', '')
    if len(title) > 60:
        print(f"[{filename}] Title exceeds 60 characters: {len(title)} chars")

    # Check description
    desc = data.get('description', '')
    if len(desc) > 160:
        print(f"[{filename}] Description exceeds 160 characters: {len(desc)} chars")

    # Check category
    cat = data.get('category')
    if cat not in categories:
        print(f"[{filename}] Invalid category: '{cat}'. Must be one of {categories}")

    # Check image
    image = data.get('image', '')
    if not image.startswith('/og/'):
        print(f"[{filename}] Image should use dynamic OG endpoint (e.g. /og/[slug].png). Current: {image}")

    # Check TLDR
    if "**TL;DR:**" not in parts[2]:
        print(f"[{filename}] Missing '**TL;DR:**' section")

print("Audit complete.")
