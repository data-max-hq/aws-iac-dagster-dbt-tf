resource "kubernetes_namespace" "dagster" {
  metadata {
    name = "dagster-dbt"
  }
}

resource "kubernetes_deployment" "dagster" {
  metadata {
    name      = "dagster-deployment"
    namespace = kubernetes_namespace.dagster.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "DagsterApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "DagsterApp"
        }
      }
      spec {
        container {
          #          image = "aldosula/dagster-dbt:eks"
          image = "${data.aws_ecr_repository.image.repository_url}:latest"
          name  = "dagster"
          port {
            container_port = 3000
          }
          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = data.aws_secretsmanager_secret_version.aws-access-key-id.secret_string
          }
          env {
            name  = "AWS_SECRET_ACCESS_KEY"
            value = data.aws_secretsmanager_secret_version.aws-secret-access-key.secret_string
          }
          env {
            name  = "API_KEY"
            value = data.aws_secretsmanager_secret_version.api-key.secret_string
          }

        }


      }
    }
  }
  depends_on = [aws_ecr_repository.weather-data-on-dagster,aws_secretsmanager_secret.api-key, aws_secretsmanager_secret.aws-access-key-id, aws_secretsmanager_secret.aws-secret-access-key]
}
resource "kubernetes_service" "dagster" {
  metadata {
    name      = "dagster"
    namespace = kubernetes_namespace.dagster.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.dagster.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 3000
      target_port = 3000
    }
  }
}

