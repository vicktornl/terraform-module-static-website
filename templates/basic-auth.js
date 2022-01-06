const handler = async (event) => {
  const { request } = event.Records[0].cf;
  const headers = request.headers;

  const base64Credentials = Buffer.from(`${username}:${password}`).toString(
    "base64"
  );
  const authString = "Basic " + base64Credentials;

  if (
    typeof headers.authorization == "undefined" ||
    headers.authorization[0].value !== authString
  ) {
    return {
      body: "Unauthorized",
      headers: {
        "www-authenticate": [{ key: "WWW-Authenticate", value: "Basic" }],
      },
      status: "401",
      statusDescription: "Unauthorized",
    };
  }

  return request;
};

module.exports.handler = handler;
