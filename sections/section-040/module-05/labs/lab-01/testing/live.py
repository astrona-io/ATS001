releases = json.loads(command(['helm', 'list', '-n', 'starfleet', '-o', 'json']).stdout)
fleet = [release for release in releases if release['name'] == 'fleet']
assert fleet, 'Install a release named fleet in starfleet'
assert fleet[0]['status'] == 'deployed', 'The release must be deployed'
assert fleet[0]['chart'] == 'fleet-chart-0.2.0', 'Install the packaged chart at version 0.2.0'
values = json.loads(command(['helm', 'get', 'values', 'fleet', '-n', 'starfleet', '-o', 'json']).stdout)
assert values.get('replicaCount') == 3 and values.get('version') == 'v2', 'Supply replicaCount 3 and version v2'
