deployment = get('deployment', 'probe')
template = deployment['spec']['template']
assert template['metadata']['labels'].get('tier') == 'production', 'Add the Pod template label tier=production'
assert deployment['spec']['selector']['matchLabels'] == {'app': 'probe', 'release': 'probe'}, 'Do not change the selector'
container = template['spec']['containers'][0]
assert {item['name']: item.get('value') for item in container.get('env', [])}.get('VERSION') == 'v2', 'Set VERSION to v2'
volumes = {volume['name']: volume for volume in template['spec'].get('volumes', [])}
settings_name = volumes.get('settings', {}).get('configMap', {}).get('name', '')
assert settings_name.startswith('probe-settings-'), 'The settings volume must use the generated, hashed ConfigMap name'
assert 'app' in volumes, 'Keep the app volume'
mounts = {mount['name']: mount['mountPath'] for mount in container.get('volumeMounts', [])}
assert mounts.get('settings') == '/settings' and mounts.get('app') == '/app', 'Mount settings at /settings and keep /app'
assert get('configmap', settings_name)['data'].get('greeting') == 'hello-production', 'The generated ConfigMap must hold the production greeting'
