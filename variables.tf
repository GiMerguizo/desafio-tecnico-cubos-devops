# Variáveis default para o banco de dados PostgreSQL e backend
## Alterar os valores no arquivo terraform.tfvars conforme necessário

variable "db_user" {
    type        = string
    description = "Usuário do banco de dados PostgreSQL"
    default     = "user"
}

variable "db_password" {
    type        = string
    description = "Senha do banco de dados PostgreSQL"
    default     = "password"
    sensitive = true
}

variable "db_name" {
    type        = string
    description = "Nome do banco de dados PostgreSQL"
    default     = "mydb"
}

variable "db_host" {
    type        = string
    description = "Host do banco de dados PostgreSQL"
    default     = "host"
}

variable "db_port" {
    type        = string
    description = "Porta do banco de dados PostgreSQL"
    default     = "5432"
}

variable "backend_port" {
    type        = string
    description = "Porta do backend"
    default     = "3000"
}