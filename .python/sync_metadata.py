#!/usr/bin/env python3
import tomllib
import re
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

def extract_from_readme(readme_path="README.md"):
    """Extract metadata from README.md using regex patterns."""
    content = Path(readme_path).read_text()
    
    # Extract title from first heading
    title_match = re.search(r"^# (.+)$", content, re.MULTILINE)
    
    return {
        "title": title_match.group(1) if title_match else None,
    }

def sync_metadata():
    """Sync metadata between pyproject.toml and README.md."""
    
    with open("pyproject.toml", "rb") as f:
        config = tomllib.load(f)
    
    # Check which file was modified more recently
    readme_mtime = Path("README.md").stat().st_mtime if Path("README.md").exists() else 0
    toml_mtime = Path("pyproject.toml").stat().st_mtime
    
    project = config.get("project", {})
    tool_meta = config.get("tool", {}).get("project-metadata", {})
    
    context = {
        "title": tool_meta.get("title", project.get("name", "Project")),
        "description": project.get("description", ""),
        "version": project.get("version", "0.1.0"),
        "name": project.get("name", "my-project"),
    }
    
    # Render and write README.md
    env = Environment(loader=FileSystemLoader("."))
    template = env.get_template("README.md.jinja")
    readme_content = template.render(context)
    Path("README.md").write_text(readme_content)

if __name__ == "__main__":
    sync_metadata()
