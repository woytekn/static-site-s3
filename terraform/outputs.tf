output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.app_cdn.domain_name
  description = "The domain name of the CloudFront distribution"
}
