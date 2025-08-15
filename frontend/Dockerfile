# Imagem Nginx
FROM nginx:1.27

# Copia o arquivo de configuração do Nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Copia o conteúdo da aplicação para o diretório padrão do Nginx
COPY . /usr/share/nginx/html