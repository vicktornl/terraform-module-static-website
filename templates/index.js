/**
 * Implementing Default Directory Indexes in Amazon S3-backed Amazon CloudFront Origins Using Lambda@Edge
 * 
 * @see https://aws.amazon.com/blogs/compute/implementing-default-directory-indexes-in-amazon-s3-backed-amazon-cloudfront-origins-using-lambdaedge/
 */
const handler = async (event) => {
  const { request } = event.Records[0].cf;

  if (`${rewrite_uri}`.startsWith('http')) {
    request.uri = `${rewrite_uri}`;
  } else {
    const uri = request.uri;
    const newUri = uri.replace(/\/$/, '\/index.html');

    request.uri = newUri;  
  }

  return request
};

module.exports.handler = handler;