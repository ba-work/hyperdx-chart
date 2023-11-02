{{- define "repository" -}}
ghcr.io/hyperdxio/hyperdx
{{- end -}}

{{- define "name" -}}
{{- print .Release.Name "-" .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

# app
{{- define "app.name" -}}
{{ include "name" . }}-app
{{- end }}

{{- define "app.ports" -}}
app: 8080
{{- end }}

{{- define "app.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.app.image.repository -}}
    {{ $repository = .Values.app.image.repository }}
  {{- end -}}

  {{- if .Values.app.image.tag -}}
    "{{ $repository }}:{{ .Values.app.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-app"
  {{- end -}}

{{- end }}

# miner
{{- define "miner.name" -}}
{{ include "name" . }}-miner
{{- end }}

{{- define "miner.ports" -}}
miner: 5123
{{- end }}

{{- define "miner.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.miner.image.repository -}}
    {{ $repository = .Values.miner.image.repository }}
  {{- end -}}

  {{- if .Values.miner.image.tag -}}
    "{{ $repository }}:{{ .Values.miner.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-miner"
  {{- end -}}

{{- end }}


# hostmetrics
{{- define "hostmetrics.name" -}}
{{ include "name" . }}-hostmetrics
{{- end }}

{{- define "hostmetrics.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.hostmetrics.image.repository -}}
    {{ $repository = .Values.hostmetrics.image.repository }}
  {{- end -}}

  {{- if .Values.hostmetrics.image.tag -}}
    "{{ $repository }}:{{ .Values.hostmetrics.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-hostmetrics"
  {{- end -}}

{{- end }}

# ingestor
{{- define "ingestor.name" -}}
{{ include "name" . }}-ingestor
{{- end }}

{{- define "ingestor.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.ingestor.image.repository -}}
    {{ $repository = .Values.ingestor.image.repository }}
  {{- end -}}

  {{- if .Values.ingestor.image.tag -}}
    "{{ $repository }}:{{ .Values.ingestor.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-ingestor"
  {{- end -}}

{{- end }}

{{- define "ingestor.ports" -}}
http: 8002
healthcheck: 8686
{{- end }}

# aggregator
{{- define "aggregator.name" -}}
{{ include "name" . }}-aggregator
{{- end }}

{{- define "aggregator.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.aggregator.image.repository -}}
    {{ $repository = .Values.aggregator.image.repository }}
  {{- end -}}

  {{- if .Values.aggregator.image.tag -}}
    "{{ $repository }}:{{ .Values.aggregator.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-api"
  {{- end -}}

{{- end }}

{{- define "aggregator.ports" -}}
aggregator: 8080
{{- end }}

{{- define "aggregator.secret.name" -}}
  {{- if .Values.aggregator.clickhouseAuth.secretName -}}
    {{ .Values.aggregator.clickhouseAuth.secretName }}
    {{- else -}}
    {{ include "aggregator.name" . }}-clickhouse-auth
  {{- end -}}
{{- end }}

{{- define "aggregator.clickhouse.username" -}}
  {{ if .Values.aggregator.clickhouseAuth.createSecret -}}
    {{ .Values.aggregator.clickhouseAuth.username }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "aggregator.secret.name" .)).data.CLICKHOUSE_USERNAME | b64dec }}
  {{ end -}}
{{- end }}

{{- define "aggregator.clickhouse.password" -}}
  {{ if .Values.aggregator.clickhouseAuth.createSecret -}}
    {{ .Values.aggregator.clickhouseAuth.password }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "aggregator.secret.name" .)).data.CLICKHOUSE_PASSWORD | b64dec }}
  {{ end -}}
{{- end }}

# api
{{- define "api.name" -}}
{{ include "name" . }}-api
{{- end }}

{{- define "api.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.api.image.repository -}}
    {{ $repository = .Values.api.image.repository }}
  {{- end -}}

  {{- if .Values.api.image.tag -}}
    "{{ $repository }}:{{ .Values.api.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-api"
  {{- end -}}

{{- end }}

{{- define "api.ports" -}}
api: 8000
{{- end }}

{{- define "api.secret.name" -}}
  {{- if .Values.api.clickhouseAuth.secretName -}}
    {{ .Values.api.clickhouseAuth.secretName }}
    {{- else -}}
    {{ include "api.name" . }}-clickhouse-auth
  {{- end -}}
{{- end }}

{{- define "api.clickhouse.username" -}}
  {{ if .Values.api.clickhouseAuth.createSecret -}}
    {{ .Values.api.clickhouseAuth.username }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "api.secret.name" .)).data.CLICKHOUSE_USERNAME | b64dec }}
  {{ end -}}
{{- end }}

{{- define "api.clickhouse.password" -}}
  {{ if .Values.api.clickhouseAuth.createSecret -}}
    {{ .Values.api.clickhouseAuth.password }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "api.secret.name" .)).data.CLICKHOUSE_PASSWORD | b64dec }}
  {{ end -}}
{{- end }}

# task-check-alerts
{{- define "taskCheckAlerts.name" -}}
{{ include "name" . }}-task-check-alerts
{{- end }}

{{- define "taskCheckAlerts.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.taskCheckAlerts.image.repository -}}
    {{ $repository = .Values.taskCheckAlerts.image.repository }}
  {{- end -}}

  {{- if .Values.taskCheckAlerts.image.tag -}}
    "{{ $repository }}:{{ .Values.taskCheckAlerts.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-api"
  {{- end -}}

{{- end }}

{{- define "taskCheckAlerts.secret.name" -}}
  {{- if .Values.taskCheckAlerts.clickhouseAuth.secretName -}}
    {{ .Values.taskCheckAlerts.clickhouseAuth.secretName }}
    {{- else -}}
    {{ include "taskCheckAlerts.name" . }}-clickhouse-auth
  {{- end -}}
{{- end }}

{{- define "taskCheckAlerts.clickhouse.username" -}}
  {{ if .Values.taskCheckAlerts.clickhouseAuth.createSecret -}}
    {{ .Values.taskCheckAlerts.clickhouseAuth.username }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "taskCheckAlerts.secret.name" .)).data.CLICKHOUSE_USERNAME | b64dec }}
  {{ end -}}
{{- end }}

{{- define "taskCheckAlerts.clickhouse.password" -}}
  {{ if .Values.taskCheckAlerts.clickhouseAuth.createSecret -}}
    {{ .Values.taskCheckAlerts.clickhouseAuth.password }}
  {{- else -}}
    {{ (lookup "v1" "Secret" (.Release.Namespace) (include "taskCheckAlerts.secret.name" .)).data.CLICKHOUSE_PASSWORD | b64dec }}
  {{ end -}}
{{- end }}

# otel-collector
{{- define "otelCollector.name" -}}
{{ include "name" . }}-otel-collector
{{- end }}

{{- define "otelCollector.image" -}}
  {{ $repository := (include "repository" .) }}

  {{- if .Values.otelCollector.image.repository -}}
    {{ $repository = .Values.otelCollector.image.repository }}
  {{- end -}}

  {{- if .Values.otelCollector.image.tag -}}
    "{{ $repository }}:{{ .Values.otelCollector.image.tag }}"
  {{- else -}}
    "{{ $repository }}:{{ .Chart.AppVersion }}-otel-collector"
  {{- end -}}

{{- end }}

{{- define "otelCollector.ports" -}}
healthcheck: 13133
pprof: 1888
fluentd: 24225
grpc: 4317
http: 4318
zpages: 55679
metrics: 8888
zipkin: 9411
{{- end }}

# clickhouse
{{- define "clickhouse.name" -}}
{{ include "name" . }}-clickhouse
{{- end }}

{{- define "clickhouse.configmap.name" -}}
  {{- if .Values.clickhouse.usersXML.configMapName -}}
    {{ .Values.clickhouse.usersXML.configMapName }}
  {{- else -}}
    {{ include "clickhouse.name" . }}-config
  {{- end -}}
{{- end }}

{{- define "clickhouse.secret.name" -}}
  {{- if .Values.clickhouse.usersXML.secretName -}}
    {{ .Values.clickhouse.usersXML.secretName }}
  {{- else -}}
    {{ include "clickhouse.name" . }}-users
  {{- end -}}
{{- end }}

{{- define "clickhouse.ports" -}}
http: 8123
native: 9000
{{- end }}

# mongo
{{- define "mongo.name" -}}
{{ include "name" . }}-mongo
{{- end }}

{{- define "mongo.ports" -}}
mongo: 27017
{{- end }}

# redis
{{- define "redis.name" -}}
{{ include "name" . }}-redis
{{- end }}

{{- define "redis.ports" -}}
redis: 6379
{{- end }}

# urls
{{- define "server.url" -}}
http://{{ include "api.name" . }}:{{ (fromYaml (include "api.ports" .)).api }}
{{- end }}

{{- define "aggregator.api.url" -}}
http://{{ include "aggregator.name" . }}:{{ (fromYaml (include "aggregator.ports" .)).aggregator }}
{{- end }}

{{- define "ingestor.api.url" -}}
http://{{ include "ingestor.name" . }}:{{ (fromYaml (include "ingestor.ports" .)).http }}
{{- end }}

{{- define "miner.api.url" -}}
http://{{ include "miner.name" . }}:{{ (fromYaml (include "miner.ports" .)).miner }}
{{- end }}

{{- define "otel.exporter.otlp.endpoint" -}}
http://{{ include "otelCollector.name" . }}:{{ (fromYaml (include "otelCollector.ports" .)).http }}
{{- end }}

{{- define "clickhouse.host" -}}
http://{{ include "clickhouse.name" . }}:{{ (fromYaml (include "clickhouse.ports" .)).http }}
{{- end }}

{{- define "mongo.uri" -}}
mongodb://{{ include "mongo.name" . }}:{{ (fromYaml (include "mongo.ports" .)).mongo }}/hyperdx
{{- end }}

{{- define "redis.url" -}}
redis://{{ include "redis.name" . }}:{{ (fromYaml (include "redis.ports" .)).redis }}
{{- end }}

{{- define "frontend.url" -}}
  {{ $scheme := "http" }}
  {{- if .Values.ingress.tls -}}
    {{ $scheme = "https" }}
  {{- end -}}
{{ $scheme }}://{{ default (print "localhost:" (fromYaml (include "app.ports" .)).app ) .Values.ingress.hostname }}
{{- end }}
