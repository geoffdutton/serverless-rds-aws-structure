const https = require('https')
const dns = require('dns')
const { Client } = require('pg')

module.exports.hello = async (event, context) => {
  const dnsResponse = await new Promise((resolve, reject) => {
    const hostname = 'serverless.com'
    dns.lookup('serverless.com', (err, address, family) => {
      if (err) {
        reject(err)
      } else {
        resolve({ hostname, address, family })
      }
    })
  })

  console.log({ dnsResponse })

  const responseHeaders = await new Promise((resolve, reject) => {
    console.log('env:', process.env)
    console.log('context:', context)
    console.log('Testing outbound internet connection')
    const req = https.request(
      'https://jsonplaceholder.typicode.com/todos/1',
      { method: 'HEAD' },
      (res) => {
        console.log('Success!', res.headers)
        resolve(res.headers)
      }
    )
    req
      .on('timeout', () => {
        console.log('Timeout!!')
        req.abort()
      })
      .on('error', (err) => {
        console.log('Failed!')
        reject(err)
      })
      .end()
  })

  console.log({ responseHeaders })

  // When client.end() is called, we need to create a new client
  // each invocation
  const client = new Client()
  await client.connect()
  const res = await client.query('SELECT $1::text as message', [
    'DB connection success!'
  ])
  const dbResponse = res.rows[0].message
  await client.end()

  return {
    message: 'Very much success!!',
    dbResponse,
    dnsResponse,
    responseHeader: responseHeaders['content-type'],
    event
  }
}
