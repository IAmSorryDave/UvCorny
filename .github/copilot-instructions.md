<Goals>
- Implement all features. 
- Pass all unit tests.
- Update documentation.
</Goals>

<StepsToFollow>
- Implement features defined by the tests in the ```tests``` folder.
- If there are no tests defined, skip to the last step in this section.
- Read the contents of the directory ```.build_logs``` to idenifiy what tests are failing.
- Make changes only inside ```src/**/**``` directories.
- Alert the user once all tests are passing.
- Document how to use the artifact by writing detailed instructions to the README.md.jinja template in the project root. DO NOT overwrite formatting. 
</StepsToFollow>

<BuildInstructions>
- Each feature should be a subdirectory of the ```src/**``` folder that maps 1-to-1 to a subdirectory in the tests folder.
- Do NOT edit the __init__.py and _loader.py scripts.
- Use a reasonable, professional amount of emoji. DO NOT overwrite formatting.
</BuildInstructions>