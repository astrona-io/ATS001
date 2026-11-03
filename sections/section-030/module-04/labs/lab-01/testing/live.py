deployment = get('deployment', 'probe')
assert deployment['spec']['replicas'] == 2, 'Keep two replicas'
volumes = {volume['name']: volume for volume in deployment['spec']['template']['spec'].get('volumes', [])}
assert 'settings' in volumes and 'app' in volumes, 'The Deployment needs the app and settings volumes'
settings_name = volumes['settings'].get('configMap', {}).get('name', '')
assert settings_name.startswith('probe-settings-') and settings_name != 'probe-settings', 'The settings volume must use the generated, hashed ConfigMap name'
mounts = {mount['name']: mount['mountPath'] for mount in deployment['spec']['template']['spec']['containers'][0].get('volumeMounts', [])}
assert mounts.get('settings') == '/settings', 'Mount the settings volume at /settings'
settings = get('configmap', settings_name)
assert settings['data'].get('greeting') == 'hello-fleet', 'The generated ConfigMap must hold greeting=hello-fleet'
plain = command(['kubectl', '-n', 'starfleet', 'get', 'configmap', 'probe-settings'], success=False)
assert plain.returncode != 0, 'Do not create a ConfigMap with the plain name probe-settings'
