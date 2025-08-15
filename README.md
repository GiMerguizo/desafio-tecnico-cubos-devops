# Desafio Técnico - Cubos DevOps

## Desafio
Crie um ambiente seguro utilizando infraestrutura como código onde
existam redes internas apenas acessíveis por certas aplicações e redes
externas para contato com o usuário. Esse ambiente deve ser replicável e
subir corretamente através de comandos de inicialização expostos no
README criado por você, todas as dependências para sua execução
também devem ser explicitadas, os usuários terão acesso a uma página
HTML que se conectará a um backend, este que por sua vez deverá ter
acesso a um banco de dados.

## Pré-requisitos
_Windows e Linux_

- [Docker](https://www.docker.com/get-started/)
  ```
  docker --version
  ```
- [Terraform](https://developer.hashicorp.com/terraform)
    ```
    terraform --version
    ```

## Rodando a aplicação
1. Clone o projeto do GitHub ou baixe o repositório;
2. Navegue até o diretório raiz do projeto;
3. Execute os comandos para inicializar o ambiente com o Terraform:

```
terraform init
terraform plan // opcional, porém recomendado para verificar o plano antes de aplicar
terraform apply
```
- Enter a value: `yes`
  
Obs.: O `terraform init` só é necessário na primeira vez.
4. (Opcional) Verifique se os containers foram iniciados corretamente: `docker ps`
5. Acesse a página do frontend através do localhost: http://localhost:8080/

### Windows
Para o windows, pode ser que haja algum erro, tratativas que podem ajudar:
- Verificar a instalação do Docker e Terraform;
- Verificar as variáveis de ambiente;
- Verificar se o Docker Desktop está rodando.

## Parar a aplicação
Caso deseje interromper a aplicação por completo, utilize: `terraform destroy`
- Enter a value: `yes`


## Referências
- [GitHub Cubos DevOps - Desafio Tecnico](https://github.com/cubos-devops/desafio-tecnico)
- [Terraform Registry - Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [DockerHub - Imagem Postgres](https://hub.docker.com/_/postgres)

### Links Extras
- [Install Docker](https://docs.docker.com/engine/install/)
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**Windows**
- [Install Chocolatey](https://chocolatey.org/install)