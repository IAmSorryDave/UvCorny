<Goals>
- Implement all features. 
- Pass all unit tests.
- Update documentation.
</Goals>

<StepsToFollow>
- Implement features defined by the tests in the ```tests``` folder.
- Read ```.build_logs``` to idenifiy what tests are failing.
- Make changes only inside ```src/**``` directories.
- Alert the user once all tests are passing.
- Once all tests are passing, document how to use the artifact by writing detailed instructions to the jinja2 template. 
</StepsToFollow>

<BuildInstructions>
- Each feature should be a subdirectory of the ```src/**``` folder that maps 1-to-1 to a subdirectory in the tests folder.
- Do NOT edit the __init__.py and _loader.py scripts.
- Use a reasonable, professional amount of emoji. DO NOT overwrite formatting.
</BuildInstructions>