### PROBES VALUES ###
{{- define "probes.values" }}
initialDelaySeconds: {{ .initialDelaySeconds | default "0" }}
timeoutSeconds:      {{ .timeoutSeconds | default "1" }}
periodSeconds:       {{ .periodSeconds | default "10" }}
successThreshold:    {{ .successThreshold | default "1" }}
failureThreshold:    {{ .failureThreshold | default "3" }}
{{- end }}

### LIVENESSPROBE ###
{{ define "livenessProbe"}}
{{- if .Values.deployment.livenessProbe }}
{{- with .Values.deployment.livenessProbe }}
livenessProbe:
  {{- if .httpGet }}
  httpGet:
    path: {{ .httpGet.path }}
    port: {{ .httpGet.port }}
    {{- if .httpGet.httpHeaders }}
    httpHeaders:
    {{- range $headers := .httpGet.httpHeaders }}
    - name: {{ $headers.name }}
      value: {{ $headers.value }}
    {{- end }}
    {{- end }}
  {{- end }}
  {{- if .exec }}
  exec:
    command:
    {{- range $value := .exec.command }}
    - {{ $value }}
    {{- end }}
  {{- end }}
  {{- include "probes.values" . | trim | nindent 2 }}
{{- end }}
{{- end }}  
{{- end }}

### READINESSPROBE ###
{{ define "readinessProbe"}}
{{- if .Values.deployment.readinessProbe }}
{{- with .Values.deployment.readinessProbe }}
readinessProbe:
  {{- if .httpGet }}
  httpGet:
    path: {{ .httpGet.path }}
    port: {{ .httpGet.port }}
    {{- if .httpGet.httpHeaders }}
    httpHeaders:
    {{- range $headers := .httpGet.httpHeaders }}
    - name: {{ $headers.name }}
      value: {{ $headers.value }}
    {{- end }}
    {{- end }}
  {{- end }}
  {{- if .exec }}
  exec:
    command:
    {{- range $value := .exec.command }}
    - {{ $value }}
    {{- end }}
  {{- end }}
  {{- include "probes.values" . | trim | nindent 2 }}
{{- end }}
{{- end }}  
{{- end }}