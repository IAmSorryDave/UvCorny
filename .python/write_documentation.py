
from pathlib import Path
from jinja2 import Environment, FileSystemLoader
from tomllib import load
from subprocess import run

def write_documentation():
    """Generate documentation from pyproject.toml and jinja2 template."""
    
    with open("pyproject.toml", "rb") as f:
        config = load(f)
    
    project = config.get("project", {})
    tool_meta = config.get("tool", {}).get("project-metadata", {})
    
    context = {
        "title": tool_meta.get("title", project.get("name")),
        "description": project.get("description"),
        "version": project.get("version"),
        "python_version": project.get("requires-python"),
        "license": project.get("license"),
    }

    readme_filename = "README.md"
    template_filename = "README.md.jinja"
    
    # Render and write README.md
    env = Environment(loader=FileSystemLoader("."))
    template = env.get_template(template_filename)
    readme_content = template.render(context)

    with open(readme_filename, 'w') as f:
        f.write(readme_content)


if __name__ == "__main__":
    write_documentation()

