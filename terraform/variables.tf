variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "my-simple-app"
}

variable "mime_types" {
  type = map(string)
  default = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "svg"  = "image/svg+xml"
    "ico"  = "image/vnd.microsoft.icon"
    "json" = "application/json"
    "txt"  = "text/plain"
    "map"  = "application/json"
    "woff" = "font/woff"
    "woff2" = "font/woff2"
  }
}
