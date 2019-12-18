{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "deployment.envs" }}
env:
  - name: CIRCLE_CI_TOKEN 
    valueFrom:
      secretKeyRef:
        name: {{ template "app.name" . }}
        key: CIRCLE_CI_TOKEN
{{- end -}}
