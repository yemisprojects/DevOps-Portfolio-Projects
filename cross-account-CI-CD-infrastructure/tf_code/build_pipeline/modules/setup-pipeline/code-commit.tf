resource "aws_codecommit_repository" "this" {
  repository_name = var.repo_name
  description     = var.repo_description
  tags            = var.repo_tags
}