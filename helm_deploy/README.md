
### Example test deploy command

```
helm --namespace dps-toolkit upgrade dps-monitor ./dps-monitor/ --install --values=values-prod.yaml --values=secrets-example.yaml --dry-run --debug
```

Test template output:

```
helm template ./dps-monitor/ --values=values-prod.yaml --values=secrets-example.yaml
```

### Rolling back a release
Find the revision number for the deployment you want to roll back:
```
helm --namespace dps-toolkit history dps-monitor
```
(note, each revision has a appVersion which has the app version used by circleci)

Rollback
```
helm --namespace dps-toolkit rollback dps-monitor [INSERT REVISION NUMBER HERE] --wait
```

### Setup Lets Encrypt cert

Ensure the certificate definition exists in the cloud-platform-environments repo under the relevant namespaces folder

e.g.
```
cloud-platform-environments/namespaces/live-1.cloud-platform.service.justice.gov.uk/[INSERT NAMESPACE NAME]/05-certificate.yaml
```
