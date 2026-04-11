
from tomllib import load
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

def sync_metadata():
    """Sync metadata between pyproject.toml and README.md."""
    
    with open("pyproject.toml", "rb") as f:
        config = load(f)
    
    project = config.get("project", {})
    tool_meta = config.get("tool", {}).get("project-metadata", {})
    
    context = {
        "title": tool_meta.get("title", project.get("name")),
        "description": project.get("description"),
        "version": project.get("version"),
        "license": project.get("license"),
    }
    
    # Render and write README.md
    env = Environment(loader=FileSystemLoader("."))
    template = env.get_template("README.md.jinja")
    readme_content = template.render(context)
    Path("README.md").write_text(readme_content)

if __name__ == "__main__":
    sync_metadata()
