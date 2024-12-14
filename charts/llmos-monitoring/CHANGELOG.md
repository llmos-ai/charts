# Changelog

This changelog highlights notable changes to this chart compared to the upstream [`kube-prometheus-stack`](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) chart.

- **Upstream `kube-prometheus-stack` version**: 66.1.1

## Changes - v0.1.0 (2024-11-13)

### General

- **Added clusterRoles for Prometheus Operator CRs**: Added `llmos-monitoring-admin`, `llmos-monitoring-edit`, and `llmos-monitoring-view` default `ClusterRoles`. These roles allow admins to assign permissions to users to interact with Prometheus Operator CRs. Enable this by setting `.Values.global.rbac.userRoles.create` (default: `true`). Typically, you'll use a `ClusterRoleBinding` to bind these roles to a Subject, enabling them to set up or view `ServiceMonitors`, `PodMonitors`, `PrometheusRules`, and view `Prometheus` or `Alertmanager` CRs across the cluster. If `.Values.global.rbac.userRoles.aggregateRolesForRBAC` is enabled, these roles will aggregate into the respective default ClusterRoles provided by Kubernetes.
- **Added clusterRoles for managing configuration resources**: Added `llmos-monitoring-config-admin`, `llmos-monitoring-config-edit`, and `llmos-monitoring-config-view` default `Roles`. These roles allow admins to assign permissions to users to edit/view `Secrets` and `ConfigMaps` within the `cattle-monitoring-system` namespace. Enable this by setting `.Values.global.rbac.userRoles.create` (default: `true`). In a typical RBAC setup, you might use a `RoleBinding` to bind these roles to a Subject within the `cattle-monitoring-system` namespace to modify configuration resources such as Alertmanager Config Secrets.
- **Added clusterRoles for managing Grafana dashboards**: Added `llmos-monitoring-dashboard-admin`, `llmos-monitoring-dashboard-edit`, and `llmos-monitoring-dashboard-view` default `Roles`. These roles allow admins to assign permissions to users to edit/view `ConfigMaps` within the `cattle-dashboards` namespace. Enable this by setting `.Values.global.rbac.userRoles.create` (default: `true`) and deploying Grafana as part of this chart. In a typical RBAC setup, use a `RoleBinding` to bind these roles to a Subject within the `cattle-dashboards` namespace to create/modify ConfigMaps containing the JSON used to persist Grafana dashboards.
- **Added default resource limits**: Added default resource limits for `Prometheus Operator`, `Prometheus`, `AlertManager`, `Grafana`, `kube-state-metrics`, and `node-exporter`.
- **Added global k8s provider config**: Added global `global.k8s.provider` config to support provider configs, default to `k3s` for now.
- Disabled the following deployments by default (can be enabled if required):
  - `AlertManager`
  - `kube-controller-manager` metrics exporter (as already aggregated in apiserver if runs in k3s)
  - `kube-scheduler` metrics exporter (as already aggregated in apiserver if runs in k3s)
  - `kube-proxy` metrics exporter (as already aggregated in apiserver if runs in k3s)

### Grafana

- **Added nginx proxy container for Grafana**: Added a default `nginx` proxy container deployed with Grafana, whose configuration is set in the `ConfigMap` located in `./templates/grafana/nginx-config.yaml`. This container enables viewing Grafana's UI through a proxy that has a subpath (e.g., K8s API proxy). The proxy container listens on port `8080` (with the `portName` set to `nginx-http` instead of the default `service`). This will forward requests to the Grafana container, which listens on the default port `3000`.
- **Added namespace for Grafana dashboards**: Added `grafana.sidecar.dashboards.searchNamespace` and `grafana.sidecar.datasources.searchNamespace` to `values.yaml` (default value: `llmos-dashboards`). The specified namespace should contain all ConfigMaps labeled `grafana_dashboard`, which the Grafana Dashboards sidecar will search for updates. This namespace is also created along with the deployment. All default dashboard ConfigMaps have been moved from the deployment namespace to this new namespace.
- **Added default LLMOS dashboard**: Added a default LLMOS dashboard on the Grafana home page.
- **Modified Grafana service values**: Modified the default values for `grafana.service` and exposed them in the default `README.md`.
- **Modified Grafana configuration**: Modified the default configuration to automatically assign users who access Grafana to the Viewer role and enable anonymous access to Grafana dashboards by default. This works well for LLMOS users accessing Grafana via the `kubectl proxy` on the LLMOS Dashboard UI, where users are authenticated by the Kubernetes API Server. However, you should modify this behavior if exposing Grafana in a non-authenticated way (e.g., as a `NodePort` service).
