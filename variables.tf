variable "db_user" {
    type        = string
    description = "Usuário do banco de dados PostgreSQL"
    default     = "myuser"
}

variable "db_password" {
    type        = string
    description = "Senha do banco de dados PostgreSQL"
    default     = "mypass"
    sensitive = true
}

variable "db_name" {
    type        = string
    description = "Nome do banco de dados PostgreSQL"
    default     = "mydb"
}

variable "backend_port" {
    type        = string
    description = "Porta do backend"
    default     = "3000"
}