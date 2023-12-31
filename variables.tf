#say that we need a uuid tag for out main.tf 
#Andrew is not a fan of writing vars by hand, so having ChatGPT do this
variable "user_uuid" {
  type        = string
}

variable "bucket_name"{
  type        = string
}

variable "index_html_filepath" {
  type        = string 
}

variable "error_html_filepath" {
  type        = string
}

variable "content_version" {
  type        = number
}

variable "assets_path" {
  type        = string
}