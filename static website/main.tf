# create s3 bucket

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket

}


resource "aws_s3_bucket_ownership_controls" "webstie_control" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.webstie_control,
    aws_s3_bucket_public_access_block.website_access,
  ]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}


resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "erro" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}


resource "aws_s3_object" "index_css" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "styles.css"
  source = "styles.css"
  acl = "public-read"

}
resource "aws_s3_object" "error_css" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "error-styles.css"
  source = "error-styles.css"
  acl = "public-read"

}

resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.website_bucket.id
    index_document {
      suffix = "index.html"
    }
    error_document {
      key="error.html"
    }
  depends_on = [  aws_s3_bucket_acl.acl ]
}