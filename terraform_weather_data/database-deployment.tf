resource "kubernetes_config_map" "postgres_config" {
  metadata {
    name      = "postgres-config"
    namespace = kubernetes_namespace.dagster.metadata.0.name
    labels = {
      app = "postgres"
    }
  }
  data = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
}

resource "kubernetes_storage_class" "manual" {
  metadata {
    name = "manual"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
}

resource "kubernetes_persistent_volume" "postgres_pv_volume" {
  metadata {
    name = "postgres-pv-volume"
    labels = {
      app = "postgres"
    }
  }
  spec {
    storage_class_name = kubernetes_storage_class.manual.metadata.0.name
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]

    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
  depends_on = [kubernetes_storage_class.manual]
}

resource "kubernetes_persistent_volume_claim" "postgres_pv_claim" {
  metadata {
    name      = "postgres-pv-claim"
    namespace = kubernetes_namespace.dagster.metadata.0.name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.manual.metadata.0.name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.postgres_pv_volume.metadata.0.name
  }

  depends_on = [kubernetes_storage_class.manual, kubernetes_persistent_volume.postgres_pv_volume]
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.dagster.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          image             = "postgres"
          name              = "postgres"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5432
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.postgres_config.metadata.0.name
            }
          }
          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgredb"
          }
        }
        volume {
          name = "postgredb"
          persistent_volume_claim {
            claim_name = "postgres-pv-claim"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_persistent_volume_claim.postgres_pv_claim]
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.dagster.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.postgres.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 5432
      target_port = 5432
    }
  }
  depends_on = [kubernetes_deployment.postgres]
}


