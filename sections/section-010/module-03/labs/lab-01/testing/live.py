slices=json.loads(kubectl('-n','starfleet','get','endpointslices','-l','kubernetes.io/service-name=probe','-o','json'))
ready=[endpoint for item in slices['items'] for endpoint in item.get('endpoints',[]) if endpoint.get('conditions',{}).get('ready') is True]
assert len(ready)==4, 'All four canary and stable backends must be ready'
assert all(endpoint.get('targetRef',{}).get('kind')=='Pod' for endpoint in ready), 'Use actual Pod backends'
