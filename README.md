# Desafio Técnico - Cubos DevOps
**Repositório base:** [GitHub Cubos DevOps - Desafio Tecnico](https://github.com/cubos-devops/desafio-tecnico)

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

Caso não esteja instado, confira os links extras.

## Rodando a aplicação
1. Clone o projeto do GitHub ou baixe o repositório;
2. Navegue até o diretório raiz do projeto;
3. Execute os comandos para inicializar o ambiente com o Terraform:

```bash
terraform init
terraform plan # opcional, porém recomendado para verificar o plano antes de aplicar
terraform apply # digite 'yes' se estiver tudo correto
```
 
**Obs.:** O `terraform init` só é necessário na primeira vez.

4. (Opcional) Verifique se os containers foram iniciados corretamente: `docker ps`
5. Acesse a página do frontend: [http://localhost:8080/](http://localhost:8080/)

### Configurando as variáveis de ambiente

Antes de executar o `terraform apply`, você pode customizar as configurações do seu ambiente. Para isso, edite o arquivo `terraform.tfvars` na raiz do projeto:

```terraform
db_user = "seu_usuario"
db_password = "sua_senha"
db_name = "seu_banco"
backend_port = 3000
```

## Monitoramento
- **Prometheus:** [http://localhost:9090](http://localhost:9090)
- **Grafana:** [http://localhost:3001](http://localhost:3001)
  - Login: `admin`
  - Senha: `admin`
  - O dashboard deve ser criado manualmente (links na seção de referências).
  
## Parar a aplicação
Caso deseje interromper a aplicação por completo, utilize: `terraform destroy`
- Enter a value: `yes`

## Solução de Problemas
- **Erro ao aplicar o Terraform:** Verifique se você tem as permissões corretas para acessar o Docker e criar recursos.
- **Containers não iniciam:** Verifique os logs dos containers com o comando `docker logs <nome_do_container>` para identificar erros.
- **Aplicação não acessível:** Verifique se os containers estão rodando na rede correta e se as portas estão expostas corretamente.<br>

**Windows** <br>
Para o Windows, pode ser que haja algum erro. Algumas dicas para solucionar problemas:
- Verificar a instalação do Docker e Terraform;
- Verificar as variáveis de ambiente;
- Verificar se o Docker Desktop está rodando.

## Estrutura de Diretórios
```bash
.
├── backend
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── frontend
│   ├── Dockerfile
│   ├── default.conf
│   └── index.html
├── prometheus
│   └── prometheus.yml
├── sql
│   └── script.sql
├── main.tf
├── terraform.tfvars
├── variables.tf
├── docker-compose.yml   # modelo não usado diretamente
└── README.md
```

**Obs.:** O `docker-compose.yml` não foi utilizado diretamente para subir a aplicação, mas serviu de modelo e pode ser usado como alternativa, alterando os parâmetros configurados.


## Referências
- [Terraform Registry - Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [PostgreSQL no DockerHub](https://hub.docker.com/_/postgres)
- [Dockerfile](https://docs.docker.com/reference/dockerfile/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Dashboards Grafana](https://grafana.com/grafana/dashboards/)
- [NGNIX Prometheus Exporter](https://github.com/nginx/nginx-prometheus-exporter)

**Links Extras**
- [Instalação Docker](https://docs.docker.com/engine/install/)
- [Instalação Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
