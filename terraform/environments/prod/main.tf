module "eks" {
  source       = "../../modules/eks"
  region       = "eu-central-1"
  cluster_name = "prod-cluster"
  subnet_ids   = ["subnet-xxxxxx", "subnet-yyyyyy"]
  vpc_id = "vpc-xxxxxx"
}


module "kafka" {
  source    = "../../modules/kafka"
  kubeconfig = var.kubeconfig
}

module "tensorflow_serving" {
  source    = "../../modules/tensorflow-serving"
  model_path = "/path/to/dev/model"
}

module "producer" {
  source          = "../../modules/producer"
  producer_image  = "your-docker-repo/kafka-producer:latest"
}

module "consumer" {
  source          = "../../modules/consumer"
  consumer_image  = "your-docker-repo/kafka-consumer:latest"
}
