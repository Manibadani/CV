provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mandanasbucket3"
}
  
resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket.my_bucket]
}
   
resource "aws_s3_bucket_public_access_block" "block_acl_false" {
  bucket = aws_s3_bucket.my_bucket.id
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource":
"arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/Telia.pdf"
    }
  ]
}
POLICY
  depends_on = [aws_s3_bucket_ownership_controls.owner]
}


