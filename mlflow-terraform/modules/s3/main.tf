resource "aws_s3_bucket" "mlflow_bucket" {
  bucket = var.s3_bucket
  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true

}

resource "aws_s3_bucket_ownership_controls" "mlflow_bucket_owner" {
  bucket = aws_s3_bucket.mlflow_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "mlflow_bucket_acl" {
  depends_on = [ aws_s3_bucket_ownership_controls.mlflow_bucket_owner ]
  bucket = aws_s3_bucket.mlflow_bucket.id
  acl = "private"
  
}

output "mlflow-bucket-arn" {
  value = aws_s3_bucket.mlflow_bucket.arn
}