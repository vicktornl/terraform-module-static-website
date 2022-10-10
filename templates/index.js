const handler = async (event) => {
  const { request } = event.Records[0].cf;
  const uri = request.uri;
  const newUri = uri.replace(/\/$/, '\/index.html');

  request.uri = newUri;

  return request
};

module.exports.handler = handler;
