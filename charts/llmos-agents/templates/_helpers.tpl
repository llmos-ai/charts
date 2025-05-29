{{/*
Expand the name of the chart.
*/}}
{{- define "llmos-agents.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "llmos-agents.fullname" -}}
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

{{- define "llmos-agents.langflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}-langflow
{{- end }}

{{- define "llmos-agents.langflow.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}-langflow
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}-langflow
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name "langflow" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "llmos-agents.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "llmos-agents.labels" -}}
helm.sh/chart: {{ include "llmos-agents.chart" . }}
{{ include "llmos-agents.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "llmos-agents.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llmos-agents.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
LangFlow Common labels
*/}}
{{- define "llmos-agents.langflow.labels" -}}
helm.sh/chart: {{ include "llmos-agents.chart" . }}
{{ include "llmos-agents.langflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: langflow
{{- end }}

{{/*
LangFlow Selector labels
*/}}
{{- define "llmos-agents.langflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "llmos-agents.langflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: langflow
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "llmos-agents.langflow.serviceAccountName" -}}
{{- if .Values.langflow.serviceAccount.create }}
{{- default (include "llmos-agents.fullname" .) .Values.langflow.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.langflow.serviceAccount.name }}
{{- end }}
{{- end }}
