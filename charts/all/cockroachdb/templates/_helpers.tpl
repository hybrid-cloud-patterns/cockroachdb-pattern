{{/*
Expand the name of the chart.
*/}}
{{- define "cockroachdb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cockroachdb.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cockroachdb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cockroachdb.labels" -}}
helm.sh/chart: {{ include "cockroachdb.chart" . }}
{{ include "cockroachdb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cockroachdb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cockroachdb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cockroachdb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cockroachdb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
generate the join list
*/}}
{{- define "cockroachdb.joinList" -}}
{{- $val := "" }}
{{- $clusters := .Values.clusters }}
{{- $nodeCount := .Values.replicas | int}}
{{- range $i, $e := until $nodeCount}}
{{- range $clusters }}
{{- $cluster := . }}
{{- $seg := printf "cockroachdb-%d.%s.cockroachdb.cockroachdb.svc.clusterset.local" $i $cluster }}
{{- $val = printf "%s,%s"  $val $seg}}
{{- end}}
{{- end}}
{{-  $val | trimPrefix "," }}
{{- end }}

