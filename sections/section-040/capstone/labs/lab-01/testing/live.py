release = json.loads(command(['helm', 'status', 'crew', '-n', 'starfleet', '-o', 'json']).stdout)
assert release['info']['status'] == 'deployed', 'Keep a deployed release named crew'
assert release['version'] == 4, 'The release must be at revision 4: install, upgrade, rollback, upgrade'
history = json.loads(command(['helm', 'history', 'crew', '-n', 'starfleet', '-o', 'json']).stdout)
assert any(entry['description'].startswith('Rollback to 1') for entry in history), 'The history must show a rollback to revision 1'
values = json.loads(command(['helm', 'get', 'values', 'crew', '-n', 'starfleet', '-o', 'json']).stdout)
assert values.get('replicaCount') == 2 and values.get('version') == 'v1.1', 'Supply replicaCount 2 and version v1.1 from a values file'
scratch = command(['helm', 'status', 'scratch', '-n', 'outpost'], success=False)
assert scratch.returncode != 0, 'Uninstall the scratch release in outpost'
