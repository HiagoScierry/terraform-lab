exports.handler = async (event) => {
  // O objeto 'event' contém informações sobre a requisição (se vier do API Gateway, por exemplo)
  console.log("Evento recebido:", JSON.stringify(event, null, 2));

  const nome = event.queryStringParameters?.nome || 'Mundo';

  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      mensagem: `Olá, ${nome}! Sua função Lambda Node.js executou com sucesso.`,
      timestamp: new Date().toISOString(),
    }),
  };

  return response;
};