import http from 'http';
import PG from 'pg';
import prometheus from 'prom-client'; // Importando o cliente Prometheus para coletar as métricas

const port = Number(process.env.port);
const user = process.env.user;
const pass = process.env.pass;
const host = process.env.host;
const db_port = process.env.db_port;
const db_name = process.env.db_name;

// Config do contador de requisições
const requestCounter = new prometheus.Counter({
  name: 'app_requests_total',
  help: 'Número total de requisições para a aplicação',
});

// Conexão do Banco de Dados
const client = new PG.Client(
  `postgres://${user}:${pass}@${host}:${db_port}/${db_name}`
);

let successfulConnection = false;

http.createServer(async (req, res) => {
  console.log(`Request: ${req.url}`);

  // Contador de requisições
  requestCounter.inc();

  // Endpoint para métricas do Prometheus
  if (req.url === '/metrics') {
    res.setHeader('Content-Type', prometheus.register.contentType);
    res.end(await prometheus.register.metrics());
    return;
  }

  if (req.url === "/api") {
    client.connect()
      .then(() => { successfulConnection = true })
      .catch(err => console.error('Database not connected -', err.stack));

    res.setHeader("Content-Type", "application/json");
    res.writeHead(200);

    let result;

    try {
      result = (await client.query("SELECT * FROM users")).rows[0];
    } catch (error) {
      console.error(error)
    }

    const data = {
      database: successfulConnection,
      userAdmin: result?.role === "admin"
    }

    res.end(JSON.stringify(data));
  } else {
    res.writeHead(503);
    res.end("Internal Server Error");
  }

}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});